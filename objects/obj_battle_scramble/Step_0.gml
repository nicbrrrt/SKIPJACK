// ====================================================
// 0. KEYBOARD TYPING SUPPORT
// ====================================================
if (battle_state == "player_input") 
{
    // Check if any key was pressed
    if (keyboard_check_pressed(vk_anykey)) 
    {
        // Get the letter typed and force it to UPPERCASE (to match your buttons)
        var _key = string_upper(keyboard_lastchar);
        
        // Check valid letters (A-Z)
        // (ord("A") is 65, ord("Z") is 90)
        if (ord(_key) >= 65 && ord(_key) <= 90) 
        {
            // Find a button that matches this letter
            // We use 'break' so we only click ONE button (e.g. if there are two 'P's)
            var _found = false;
            
            with (obj_battle_button) 
            {
                if (my_char == _key && !_found) 
                {
                    // SIMULATE A CLICK ON THIS BUTTON!
                    // This runs the code inside the button as if you used the mouse.
                    event_perform(ev_mouse, ev_left_press);
                    _found = true; 
                }
            }
        }
    }
}

// Shake
if (shake_magnitude > 0) {
    camera_set_view_pos(view_camera[0], irandom_range(-shake_magnitude, shake_magnitude), irandom_range(-shake_magnitude, shake_magnitude));
    shake_magnitude -= 1;
} else {
    camera_set_view_pos(view_camera[0], 0, 0);
}

// --- PLAYER ATTACK ---
if (battle_state == "player_attack") 
{
    timer++;
    // Lunge
    if (timer < 15) player_x_offset = lerp(player_x_offset, -200, 0.2); 
    
    // Impact
    if (timer == 15) {
        player_sprite = spr_jack_hit; image_index = 0;
        audio_play_sound(snd_attack_impact, 10, false); 
        shake_magnitude = 8;
        enemy_flash_timer = 10; 
        audio_play_sound(snd_hurt, 10, false); 
        current_hp_enemy -= 35;
        // Spawn Damage Number
        instance_create_depth(display_get_gui_width()*0.2, display_get_gui_height()*0.4 - 50, -16000, obj_damage_text).damage_amount = "-35";
    }
    // Return
    if (timer > 45) {
        player_sprite = spr_jack_battle; 
        player_x_offset = lerp(player_x_offset, 0, 0.1); 
    }
    // End Turn
    if (timer > 80) { 
        if (current_hp_enemy <= 0) { battle_state = "win"; timer = 0; } 
        else { battle_state = "enemy_turn"; timer = 0; }
    }
}

// --- ENEMY TURN ---
else if (battle_state == "enemy_turn")
{
    timer++;
    // Lunge
    if (timer < 30) enemy_x_offset = lerp(enemy_x_offset, 200, 0.1);
    
    // Impact
    if (timer == 30) {
        enemy_sprite = spr_virus_attack; image_index = 0;
        audio_play_sound(snd_hurt, 10, false);
        player_sprite = spr_jack_hurt;
        player_flash_timer = 10;
        shake_magnitude = 5;
        current_hp_player -= 15;
        // Spawn Damage Number
        var _txt = instance_create_depth(display_get_gui_width()*0.8, display_get_gui_height()*0.6 - 50, -16000, obj_damage_text);
        _txt.damage_amount = "-15"; _txt.color = c_red;
    }
    // Return
    if (timer > 60) {
        enemy_sprite = spr_virus_idle;
        player_sprite = spr_jack_battle;
        enemy_x_offset = lerp(enemy_x_offset, 0, 0.1);
    }
    // End Turn
    if (timer > 100) {
        if (current_hp_player <= 0) { battle_state = "lose"; timer = 0; } 
        else { load_next_puzzle(); }
    }
}

// --- WIN/LOSE ---
else if (battle_state == "win") {
    timer++;
    if (timer == 1) { audio_play_sound(snd_die_monster, 10, false); enemy_sprite = spr_enemy_death; image_index = 0; }
    if (timer > 120) { instance_activate_object(obj_jack); instance_destroy(); room_goto(rm_level_1); }
}
else if (battle_state == "lose") {
    timer++;
    if (timer == 1) audio_play_sound(snd_die, 10, false);
    if (timer > 120) game_restart();
}