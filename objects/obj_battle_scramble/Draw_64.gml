// SINCE WE FORCED GUI TO 640x360, WE USE THOSE NUMBERS
var _w = 640;
var _h = 360;

// =========================================================
// TWEAK THESE NUMBERS TO ALIGN THEM!
// 0.0 = Top of screen, 1.0 = Bottom of screen
// =========================================================
var _enemy_height_mod  = 0.65; 
var _player_height_mod = 0.65;
// =========================================================

// SINCE WE FORCED GUI TO 640x360, WE USE THOSE NUMBERS
var _w = 640;
var _h = 360;

// --- 1. ENEMY (Left) ---
var _enemy_x = (_w * 0.25) + enemy_x_offset; 
// Use the variable we made in Create Event
var _enemy_y = base_y_level; 

if (enemy_flash_timer > 0) { enemy_flash_timer--; gpu_set_fog(true, c_red, 0, 0); }
draw_sprite_ext(enemy_sprite, -1, _enemy_x, _enemy_y, 3.5, 3.5, 0, c_white, 1);
gpu_set_fog(false, c_white, 0, 0);

// Healthbar
draw_healthbar(_enemy_x - 40, _enemy_y - 90, _enemy_x + 40, _enemy_y - 80, (current_hp_enemy/max_hp_enemy)*100, c_black, c_red, c_green, 0, true, true);

// --- 2. PLAYER (Right) ---
var _player_x = (_w * 0.75) + player_x_offset;
// Match the base level
var _player_y = base_y_level; 

if (player_flash_timer > 0) { player_flash_timer--; gpu_set_fog(true, c_red, 0, 0); }
draw_sprite_ext(player_sprite, -1, _player_x, _player_y, -3.5, 3.5, 0, c_white, 1);
gpu_set_fog(false, c_white, 0, 0);

// Healthbar
draw_healthbar(_player_x - 40, _player_y - 90, _player_x + 40, _player_y - 80, (current_hp_player/max_hp_player)*100, c_black, c_red, c_green, 0, true, true);

// --- 3. UI (Bottom) ---
if (battle_state == "player_input") {
    
    // FORCE DRAW BUTTONS
    if (instance_exists(obj_battle_button)) {
        with (obj_battle_button) {
            if (visible) event_perform(ev_draw, 0);
        }
    }

    // SMALLER UI BOX
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_roundrect(140, 300, 500, 355, false); 
    draw_set_alpha(1);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    if (variable_instance_exists(id, "fnt_dialogue")) draw_set_font(fnt_dialogue); else draw_set_font(-1);
    
    // Hint
    draw_set_color(c_yellow);
    draw_text_transformed(_w/2, 315, "HINT: " + current_hint, 0.8, 0.8, 0);
    
    // Guess String
    var _str = "";
    var _len = string_length(target_word);
    for(var i=0; i<_len; i++) {
        if (i < string_length(player_guess)) _str += string_char_at(player_guess, i+1) + " ";
        else _str += "_ "; 
    }
    
    draw_set_color(c_white);
    draw_text_transformed(_w/2, 340, _str, 1.2, 1.2, 0);
}

// Reset
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);