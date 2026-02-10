// ====================================================
// ORBIT LOGIC
// ====================================================
if (battle_state == "player_input" && instance_exists(obj_battle_button)) {
    var _center_x = (640 * 0.25) + enemy_x_offset; 
    var _center_y = base_y_level + orbit_y_nudge; 
    var _radius = 70; 
    var _speed = current_time * 0.05; 
    
    with (obj_battle_button) {
        if (visible) {
            if (!variable_instance_exists(id, "orbit_angle_offset")) orbit_angle_offset = 0;
            var _my_angle = _speed + orbit_angle_offset;
            x = _center_x + lengthdir_x(_radius, _my_angle);
            y = _center_y + lengthdir_y(_radius, _my_angle);
        }
    }
}

// ====================================================
// 1. INPUT STATE (Typing & Backspace)
// ====================================================
if (battle_state == "player_input") 
{
    // --- BACKSPACE LOGIC ---
    if (keyboard_check_pressed(vk_backspace)) {
        var _len = string_length(player_guess);
        if (_len > 0) {
            var _last_char = string_char_at(player_guess, _len);
            player_guess = string_delete(player_guess, _len, 1);
            audio_play_sound(snd_button_click, 10, false);
            with (obj_battle_button) {
                if (my_char == _last_char && visible == false) {
                    visible = true; 
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
                if (visible == true && my_char == _typed_char) {
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
    camera_set_view_pos(view_camera[0], irandom_range(-shake_magnitude, shake_magnitude), irandom_range(-shake_magnitude, shake_magnitude));
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
        enemy_sprite = spr_virus_attack; 
        image_index = 0;
        audio_play_sound(snd_hurt, 10, false);
        player_sprite = spr_jack_hurt;
        player_flash_timer = 10;
        shake_magnitude = 5;
        current_hp_player -= 15;
        var _txt = instance_create_depth(display_get_gui_width()*0.8, display_get_gui_height()*0.6 - 50, -16000, obj_damage_text);
        _txt.damage_amount = "-15"; 
        _txt.color = c_red;
    }
    if (timer > 60) {
        enemy_sprite = spr_virus_idle;
        player_sprite = spr_jack_battle;
        enemy_x_offset = lerp(enemy_x_offset, 0, 0.1);
    }
    if (timer > 100) {
        if (current_hp_player <= 0) { battle_state = "lose"; timer = 0; } 
        else { load_next_puzzle(); }
    }
}

// ====================================================
// 5. BOSS DEFEAT & WIN STATES
// ====================================================

// --- A. THE DRAMATIC DYING SEQUENCE ---
else if (battle_state == "win") {
    timer++;
    
    // On the very first frame of victory:
    if (timer == 1) {
        audio_stop_sound(snd_battle_music);
        // audio_play_sound(snd_boss_explosion, 10, false); 
    }

    // --- VISUAL FX DURING DEATH ---
    // 1. Heavy Shake
    shake_magnitude = 15; 

    // 2. Glitch "Data Leak" (Using your obj_damage_text)
    if (timer % 10 == 0) {
        var _gui_w = 640; 
        var _gui_h = 360;
        // Spawn glitchy text over the enemy's position
        var _glitch = instance_create_depth((_gui_w * 0.25) + enemy_x_offset + irandom_range(-30, 30), base_y_level + irandom_range(-50, 50), -16000, obj_damage_text);
        _glitch.damage_amount = choose("NULL", "000", "ERR", "VOID");
        _glitch.color = c_red;
    }

    // 3. THE TRANSITION
    // After 2.5 seconds (150 frames) of exploding, finally leave
    if (timer > 150) {
        // RESET GREG'S FLAGS
        global.last_battle_id = "none";
        global.battle_result = "win";
        global.is_jrpg = false;
        global.greg_defeated = true; // Mark him as dead in the world!

        instance_activate_object(obj_jack);
        instance_destroy();
        room_goto(rm_level_1);
    }
}