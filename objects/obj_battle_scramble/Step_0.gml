// ====================================================
// ORBIT LOGIC
// ====================================================
if (battle_state == "player_input" && instance_exists(obj_battle_button)) {
    
    // 1. Calculate Center Point
    var _center_x = (640 * 0.25) + enemy_x_offset; 
    
    // 2. APPLY THE NUDGE
    // We take the base level and add the manual offset.
    // If the circle looks too high, make orbit_y_nudge a positive number (like 20).
    // If the circle looks too low, make orbit_y_nudge a negative number (like -20).
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

// ... The rest of your Step Event (Typing Logic) follows here ...

// --- STEP EVENT OF obj_battle_scramble ---

// ====================================================
// 1. INPUT STATE (Typing & Backspace)
// ====================================================
if (battle_state == "player_input") 
{
    // --- A. BACKSPACE LOGIC ---
    if (keyboard_check_pressed(vk_backspace)) {
        var _len = string_length(player_guess);
        
        if (_len > 0) {
            var _last_char = string_char_at(player_guess, _len);
            player_guess = string_delete(player_guess, _len, 1);
            audio_play_sound(snd_button_click, 10, false);
            
            // Bring the button back to life!
            with (obj_battle_button) {
                if (my_char == _last_char && visible == false) {
                    visible = true; 
                    break; 
                }
            }
        }
    }

    // --- B. TYPING LOGIC (A-Z) ---
    for (var k = 65; k <= 90; k++) {
        if (keyboard_check_pressed(k)) {
            var _typed_char = chr(k); 
            
            // Find a VISIBLE button that matches
            var _found_btn = noone;
            with (obj_battle_button) {
                if (visible == true && my_char == _typed_char) {
                    _found_btn = id;
                    break; 
                }
            }
            
            // Simulate click
            if (_found_btn != noone) {
                with (_found_btn) {
                    event_perform(ev_mouse, ev_left_press);
                }
            }
        }
    }
}

// ====================================================
// 2. SHAKE LOGIC (Runs in all states)
// ====================================================
if (shake_magnitude > 0) {
    camera_set_view_pos(view_camera[0], irandom_range(-shake_magnitude, shake_magnitude), irandom_range(-shake_magnitude, shake_magnitude));
    shake_magnitude -= 1;
} else {
    // Force camera back to center (Assuming 640x360 room setup)
    var _centered_x = (room_width - 640) / 2;
    var _centered_y = (room_height - 360) / 2;
    camera_set_view_pos(view_camera[0], _centered_x, _centered_y);
}

// ====================================================
// 3. PLAYER ATTACK STATE (The Animation)
// ====================================================
if (battle_state == "player_attack") 
{
    timer++;
    
    // Lunge Forward
    if (timer < 15) player_x_offset = lerp(player_x_offset, -200, 0.2); 
    
    // Impact Frame
    if (timer == 15) {
        player_sprite = spr_jack_hit; 
        image_index = 0;
        audio_play_sound(snd_attack_impact, 10, false); 
        shake_magnitude = 8;
        enemy_flash_timer = 10; 
        audio_play_sound(snd_hurt, 10, false); 
        
        // Deal Damage
        current_hp_enemy -= 35;
        
        // Spawn Damage Number
        instance_create_depth(display_get_gui_width()*0.2, display_get_gui_height()*0.4 - 50, -16000, obj_damage_text).damage_amount = "-35";
    }
    
    // Return to Position
    if (timer > 45) {
        player_sprite = spr_jack_battle; 
        player_x_offset = lerp(player_x_offset, 0, 0.1); 
    }
    
    // End Turn -> Check Win or Enemy Turn
    if (timer > 80) { 
        if (current_hp_enemy <= 0) { 
            battle_state = "win"; 
            timer = 0; 
        } 
        else { 
            battle_state = "enemy_turn"; 
            timer = 0; 
        }
    }
}

// ====================================================
// 4. ENEMY TURN STATE
// ====================================================
else if (battle_state == "enemy_turn")
{
    timer++;
    
    // Lunge
    if (timer < 30) enemy_x_offset = lerp(enemy_x_offset, 200, 0.1);
    
    // Impact
    if (timer == 30) {
        enemy_sprite = spr_virus_attack; 
        image_index = 0;
        audio_play_sound(snd_hurt, 10, false);
        player_sprite = spr_jack_hurt;
        player_flash_timer = 10;
        shake_magnitude = 5;
        
        current_hp_player -= 15;
        
        // Spawn Damage Number
        var _txt = instance_create_depth(display_get_gui_width()*0.8, display_get_gui_height()*0.6 - 50, -16000, obj_damage_text);
        _txt.damage_amount = "-15"; 
        _txt.color = c_red;
    }
    
    // Return
    if (timer > 60) {
        enemy_sprite = spr_virus_idle;
        player_sprite = spr_jack_battle;
        enemy_x_offset = lerp(enemy_x_offset, 0, 0.1);
    }
    
    // End Turn -> Check Lose or Next Puzzle
    if (timer > 100) {
        if (current_hp_player <= 0) { 
            battle_state = "lose"; 
            timer = 0; 
        } 
        else { 
            // Load the next scramble puzzle!
            load_next_puzzle(); 
        }
    }
}

// ====================================================
// 5. WIN / LOSE STATES
// ====================================================
else if (battle_state == "win") {
    timer++;
    if (timer == 1) { 
        audio_play_sound(snd_die_monster, 10, false); 
        // Ensure this sprite exists, otherwise use spr_virus_idle
        if (sprite_exists(spr_enemy_death)) enemy_sprite = spr_enemy_death; 
        image_index = 0; 
    }
    if (timer > 120) { 
        instance_activate_object(obj_jack); 
        instance_destroy(); 
        // MAKE SURE THIS IS THE CORRECT ROOM NAME TO RETURN TO
        room_goto(rm_level_1); 
    }
}
else if (battle_state == "lose") {
    timer++;
    if (timer == 1) audio_play_sound(snd_die, 10, false);
    if (timer > 120) game_restart();
}
// ... existing state logic ...

else if (battle_state == "win") {
    timer++;
    if (timer == 1) { 
        audio_stop_sound(snd_battle_music); // <--- STOP THE LOOP
        audio_play_sound(snd_die_monster, 10, false); 
        if (sprite_exists(spr_enemy_death)) enemy_sprite = spr_enemy_death; 
        image_index = 0; 
    }
    if (timer > 120) { 
        instance_activate_object(obj_jack); 
        instance_destroy(); 
        room_goto(rm_level_1); 
    }
}
else if (battle_state == "lose") {
    timer++;
    if (timer == 1) {
        audio_stop_sound(snd_battle_music); // <--- STOP THE LOOP
        audio_play_sound(snd_die, 10, false);
    }
    if (timer > 120) game_restart();
}