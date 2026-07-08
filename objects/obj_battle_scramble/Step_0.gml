if (variable_global_exists("is_paused") && global.is_paused) exit;

if (variable_global_exists("DEBUG_MODE") && global.DEBUG_MODE && keyboard_check_pressed(vk_f3)) {
    show_debug_message("[DEBUG] F3 pressed — skipping JRPG combat as WIN (battle_id: " + string(global.last_battle_id) + ")");
    current_hp_enemy = 0;
    battle_state     = "win";
    timer            = 0;
    exit;
}

// DEBUG: F4 forces JRPG combat loss
if (variable_global_exists("DEBUG_MODE") && global.DEBUG_MODE && keyboard_check_pressed(vk_f4)) {
    show_debug_message("[DEBUG] F4 pressed — forcing JRPG combat LOSS (battle_id: " + string(global.last_battle_id) + ")");
    current_hp_player = 0;
    battle_state      = "lose";
    timer             = 0;
    exit;
}

// DEBUG: F5 instant victory (JRPG word scramble — any NPC)
if (variable_global_exists("DEBUG_MODE") && global.DEBUG_MODE && keyboard_check_pressed(vk_f5)) {
    show_debug_message("[DEBUG] F5 pressed — instant JRPG win (battle_id: " + string(global.last_battle_id) + ")");
    current_hp_enemy = 0;
    battle_state     = "win";
    timer            = 0;
    exit;
}

// ====================================================
// TUTORIAL SIMULATION (scramble_tutorial)
// ====================================================
if (scramble_tutorial) {
    // TAB / X — speedrun skip (dialogue, demos, parry lesson → practice or finish)
    if (keyboard_check_pressed(vk_tab) || keyboard_check_pressed(ord("X"))) {
        tutorial_skip_showcase();
        exit;
    }

    // Pause all battle logic while dialogue is on screen
    if (instance_exists(obj_textevent)) exit;

    if (tutorial_dialogue_pending && !instance_exists(obj_textevent)) {
        tutorial_dialogue_pending = false;
        tutorial_dialogue_finished();
    }

    if (battle_state == "tutorial") {
        tutorial_timer++;

        // --- AUTO-TYPE DEMOS (slower pacing) ---
        if (tutorial_sub == "auto_type") {
            if (tutorial_timer mod tutorial_auto_interval == 0 && tutorial_auto_idx < string_length(target_word)) {
                var _ch = string_char_at(target_word, tutorial_auto_idx + 1);
                with (obj_battle_button) {
                    if (!revealed && my_char == _ch) {
                        revealed = true;
                        obj_battle_scramble.player_guess += my_char;
                        obj_battle_scramble.tutorial_auto_idx++;
                        audio_play_sound(snd_button_click, 10, false);
                        break;
                    }
                }
            }
            if (tutorial_auto_idx >= string_length(target_word)) {
                battle_state = "player_attack";
                timer = 0;
                tutorial_sub = "";
                with (obj_battle_button) instance_destroy();
            }
        }
        exit;
    }
}

// Block attack slow-motion timer
if (block_slowmo_timer > 0) block_slowmo_timer--;

// --- IDLE ANIMATION (directional, no spinning) ---
if (battle_state == "player_input" || battle_state == "setup"
 || battle_state == "block_attack" || battle_state == "tutorial"
 || battle_state == "player_attack"
 || (battle_state == "enemy_turn" && timer > 60)) {
    if (sprite_exists(enemy_sprite)) {
        var _er = scr_dir_idle_anim(enemy_sprite, enemy_idle_facing, enemy_idle_acc, 0.15);
        image_index = _er[0];
        enemy_idle_acc = _er[1];
    }
    if (sprite_exists(player_sprite) && player_sprite != spr_jack_hit && player_sprite != spr_jack_hurt) {
        var _pr = scr_dir_idle_anim(player_sprite, player_idle_facing, player_idle_acc, 0.15);
        // player drawn via player_sprite in Draw_64 — store on instance for draw
        player_idle_subimg = _pr[0];
        player_idle_acc = _pr[1];
    }
}

// ====================================================
// ORBIT LOGIC
// ====================================================
if ((battle_state == "player_input" || battle_state == "block_attack" || battle_state == "tutorial") && instance_exists(obj_battle_button)) {
    var _ex = (640 * enemy_x_pct) + enemy_x_offset;
    var _ey = scr_battle_sprite_feet_y(enemy_sprite, enemy_draw_yscale, base_y_level);
    var _ec = scr_battle_sprite_chest_xy(enemy_sprite, enemy_draw_yscale, _ex, _ey);
    var _center_x = _ec[0];
    var _center_y = _ec[1];
    var _radius = 70; 
    var _speed = current_time * 0.05; 
    
    with (obj_battle_button) {
        if (!variable_instance_exists(id, "orbit_angle_offset")) orbit_angle_offset = 0;
        var _my_angle = _speed + orbit_angle_offset;
        x = _center_x + lengthdir_x(_radius, _my_angle);
        y = _center_y + lengthdir_y(_radius, _my_angle);
    }
}

// ====================================================
// 1. INPUT STATE (Typing & Backspace)
// ====================================================
if (battle_state == "player_input") 
{
    // --- ORBIT COUNTDOWN: every 10s, enemy throws a block ---
    if (!scramble_tutorial || tutorial_phase >= 5) {
        orbit_countdown--;
        if (orbit_countdown <= 0) {
            if (scramble_tutorial && tutorial_phase == 5) {
                launch_block_attack("E", true);
            } else {
                launch_block_attack();
            }
        }
    }

    // --- BACKSPACE LOGIC ---
    if (keyboard_check_pressed(vk_backspace)) {
        var _len = string_length(player_guess);
        if (_len > 0) {
            var _last_char = string_char_at(player_guess, _len);
            player_guess = string_delete(player_guess, _len, 1);
            audio_play_sound(snd_button_click, 10, false);
            with (obj_battle_button) {
                if (my_char == _last_char && revealed) {
                    revealed = false;
                    break;
                }
            }
        }
    }

    // --- TYPING LOGIC (A-Z) ---
    for (var k = 65; k <= 90; k++) {
        if (keyboard_check_pressed(k)) {
            var _typed_char = chr(k); 
            var _found_btn = noone;
            with (obj_battle_button) {
                if (!revealed && my_char == _typed_char) {
                    _found_btn = id;
                    break;
                }
            }
            if (_found_btn != noone) {
                with (_found_btn) event_perform(ev_mouse, ev_left_press);
            }
        }
    }
}

// ====================================================
// 2. SHAKE LOGIC
// ====================================================
if (shake_magnitude > 0) {
    var _cx = (room_width - 640) / 2;
    var _cy = (room_height - 360) / 2;
    camera_set_view_pos(view_camera[0], _cx + irandom_range(-shake_magnitude, shake_magnitude), _cy + irandom_range(-shake_magnitude, shake_magnitude));
    shake_magnitude -= 1;
} else {
    var _centered_x = (room_width - 640) / 2;
    var _centered_y = (room_height - 360) / 2;
    camera_set_view_pos(view_camera[0], _centered_x, _centered_y);
}

// ====================================================
// 3. PLAYER ATTACK STATE
// ====================================================
if (battle_state == "player_attack") 
{
    timer++;
    if (timer < 15) player_x_offset = lerp(player_x_offset, -200, 0.2); 
    if (timer == 15) {
        player_sprite = spr_jack_hit; 
        image_index = 0;
        audio_play_sound(snd_attack_impact, 10, false);
        shake_magnitude = 8;
        enemy_flash_timer = 10;
        audio_play_sound(snd_hurt, 10, false);
        current_hp_enemy -= 35;
        instance_create_depth(display_get_gui_width()*0.2, display_get_gui_height()*0.4 - 50, -16000, obj_damage_text).damage_amount = "-35";
    }
    if (timer > 45) {
        player_sprite = spr_jack_battle; 
        player_x_offset = lerp(player_x_offset, 0, 0.1); 
    }
    if (timer > 80) { 
        if (current_hp_enemy <= 0) { battle_state = "win"; timer = 0; } 
        else if (scramble_tutorial && tutorial_phase == 1) {
            battle_state = "tutorial";
            tutorial_phase = 2;
            tutorial_start_dialogue([
                "Nice! A correct answer damages the enemy.",
                "Here's another example — press E to continue."
            ]);
        }
        else if (scramble_tutorial && tutorial_phase == 3) {
            battle_state = "tutorial";
            tutorial_phase = 4;
            tutorial_start_dialogue([
                "Key rules before you try it yourself:",
                "Always read the CODEX or find hints to answer quickly.",
                "The enemy attacks when the timer runs out — you have 10 seconds!",
                "When a block flies at you, press the letter SHOWN on that block to parry.",
                "Press E when you're ready to practice blocking!"
            ]);
        }
        else if (scramble_tutorial && tutorial_phase < 7) {
            battle_state = "tutorial";
            tutorial_timer = 0;
        }
        else { battle_state = "enemy_turn"; timer = 0; }
    }
}

// ====================================================
// 4. ENEMY TURN STATE
// ====================================================
else if (battle_state == "enemy_turn")
{
    timer++;
    if (timer < 30) enemy_x_offset = lerp(enemy_x_offset, 200, 0.1);
    if (timer == 30) {
        enemy_sprite = enemy_attack_sprite;
        image_index = scr_dir_idle_start(enemy_attack_sprite, enemy_idle_facing);
        audio_play_sound(snd_hurt, 10, false);
        player_sprite = spr_jack_hurt;
        player_flash_timer = 10;
        shake_magnitude = 5;
        current_hp_player -= 15;
        reveal_random_hint_letter();
        var _txt = instance_create_depth(display_get_gui_width()*0.8, display_get_gui_height()*0.6 - 50, -16000, obj_damage_text);
        _txt.damage_amount = "-15"; 
        _txt.color = c_red;
    }
    if (timer > 60) {
        enemy_sprite = global.battle_enemy_sprite;
        enemy_idle_acc = 0;
        image_index = scr_dir_idle_start(enemy_sprite, enemy_idle_facing);
        player_sprite = spr_jack_battle;
        player_idle_acc = 0;
        enemy_x_offset = lerp(enemy_x_offset, 0, 0.1);
    }
    if (timer > 100) {
        if (current_hp_player <= 0) { battle_state = "lose"; timer = 0; }
        else {
            if (show_tooltips) tooltip_index = (tooltip_index + 1) mod 4;
            load_next_puzzle();
        }
    }
}

// ====================================================
// 5. BOSS DEFEAT & WIN STATES
// ====================================================

// --- A. THE DRAMATIC DYING SEQUENCE ---
else if (battle_state == "win") {
    timer++;
    
    // On the very first frame of the death animation:
    if (timer == 1) {
        audio_stop_sound(snd_battle_music);
        audio_stop_sound(snd_quiz_battle_boss_music);
        quiz_lose_snd = audio_play_sound(snd_enemy_lose_quiz, 10, false);
        // audio_play_sound(snd_boss_explosion, 10, false);
    }

    // Begin fading the lose jingle 30 frames before the room transition (timer > 150)
    if (timer == 120) {
        audio_sound_gain(quiz_lose_snd, 0, 500); // fade to silence over ~500 ms
    }

    // --- VISUAL FX DURING DEATH ---
    // 1. Heavy Shake
    shake_magnitude = 15; 

    // 2. Glitch "Data Leak" (Using your obj_damage_text)
    if (timer % 10 == 0) {
        var _gui_w = 640; 
        var _gui_h = 360;
        // Spawn glitchy text over the enemy's position
        var _glitch = instance_create_depth((_gui_w * enemy_x_pct) + enemy_x_offset + irandom_range(-30, 30), base_y_level + irandom_range(-50, 50), -16000, obj_damage_text);
        _glitch.damage_amount = choose("NULL", "000", "ERR", "VOID");
        _glitch.color = c_red;
    }

    // 3. THE TRANSITION
    // After 2.5 seconds (150 frames) of exploding, finally leave
	var _win_delay = (global.last_battle_id == "scramble_tutorial") ? 90 : 150;
	if (timer > _win_delay) {
    if (global.last_battle_id == "scramble_tutorial") {
        global.scramble_tutorial_done = true;
        global.battle_result = "win";
        global.last_battle_id = "scramble_tutorial_done";
        global.is_jrpg = false;
        audio_stop_sound(quiz_lose_snd);
        instance_activate_all();
        room_goto(global.return_room);
        instance_destroy();
        exit;
    }
    // 1. Tell the NPCs they lost
    if (global.last_battle_id == "clipper_review") global.clipper_defeated = true;
    if (global.last_battle_id == "lea_review")     global.lea_defeated     = true;
    if (global.last_battle_id == "david_quiz")     global.david_defeated   = true;
    if (global.last_battle_id == "greg_boss")      global.greg_defeated    = true;

    // 2. Standard handshake
    global.last_battle_id = global.last_battle_id + "_defeated";
    global.battle_result = "win";
    global.is_jrpg = false;

    audio_stop_sound(quiz_lose_snd); // hard-stop before room change (safety net)
    instance_activate_all();
    room_goto(global.return_room);
    instance_destroy();
	}
}

// ====================================================
// 6. PLAYER DEFEAT STATE
// ====================================================
else if (battle_state == "lose") {
    timer++;

    if (timer == 1) {
        audio_stop_sound(snd_battle_music);
        audio_stop_sound(snd_quiz_battle_boss_music);
        player_sprite = spr_jack_hurt;
    }

    // Red glitch text over the player position
    if (timer % 12 == 0 && timer < 100) {
        var _glitch = instance_create_depth(display_get_gui_width() * 0.75 + irandom_range(-20, 20), base_y_level + irandom_range(-40, 40), -16000, obj_damage_text);
        _glitch.damage_amount = choose("KO", "ERR", "DEAD", "0HP");
        _glitch.color = c_red;
    }

    // After ~2 seconds, return to level with lose result
    if (timer > 120) {
        if (global.last_battle_id == "scramble_tutorial") {
            global.battle_result = "none";
            global.last_battle_id = "scramble_tutorial";
            global.is_jrpg = true;
            instance_activate_all();
            room_goto(rm_battle_scramble);
            instance_destroy();
            exit;
        }
        // Mark attempted flag before clearing ID (lose clears ID to "none")
        if (global.last_battle_id == "david_quiz") global.david_quiz_attempted = true;

        global.battle_result = "lose";
        global.last_battle_id = "none"; // Clear so game_controller doesn't auto-re-trigger
        global.is_jrpg = false;

        instance_activate_all();
        room_goto(global.return_room);
        instance_destroy();
    }
}