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

// --- TOOLTIP (all word-scramble fights) ---
if (variable_instance_exists(id, "show_tooltips") && show_tooltips && battle_state == "player_input") {
    var _tips = ["Tip: Press Backspace to erase a letter",
                 "Tip: Only the letters of the answer can be typed in",
                 "Tip: You should have reviewed the terms",
                 "Tip: You deal no damage if your answer is wrong"];
    if (variable_instance_exists(id, "fnt_dialogue")) draw_set_font(fnt_dialogue); else draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    var _tip_str = _tips[tooltip_index];
    var _tw = string_width(_tip_str);
    var _th = string_height(_tip_str);
    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(_w / 2 - _tw / 2 - 8, 4, _w / 2 + _tw / 2 + 8, 4 + _th + 6, false);
    draw_set_alpha(1.0);
    draw_set_color(c_yellow);
    draw_text(_w / 2, 8, _tip_str);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// --- 1. ENEMY (Left) ---
var _enemy_x = (_w * 0.25) + enemy_x_offset; 
var _enemy_y = base_y_level; 

// Visual Logic for the Death Sequence
var _alpha = 1;
var _color = c_white;

if (battle_state == "win") {
    // Red tint and rapid flickering
    _color = c_red;
    _alpha = (timer % 2 == 0) ? 0.8 : 0.2; 
    
    // Add a final "White Flash" at the very end
    if (timer > 130) {
        gpu_set_fog(true, c_white, 0, 0);
        _alpha = 1;
    }
}

// Flash when hit (your existing logic)
if (enemy_flash_timer > 0) {
    enemy_flash_timer--;
    gpu_set_fog(true, c_red, 0, 0);
}

draw_sprite_ext(enemy_sprite, -1, _enemy_x, _enemy_y, 3.5, 3.5, 0, _color, _alpha);
gpu_set_fog(false, c_white, 0, 0);

// Only draw healthbar if he's still alive
if (battle_state != "win") {
    draw_healthbar(_enemy_x - 40, _enemy_y - 90, _enemy_x + 40, _enemy_y - 80, (current_hp_enemy/max_hp_enemy)*100, c_black, c_red, c_green, 0, true, true);
}

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

    if (variable_instance_exists(id, "fnt_dialogue")) draw_set_font(fnt_dialogue); else draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    var _scale   = 1.2;
    var _spacing = 18;
    var _pad     = 4;

    // Build guess string
    var _str = "";
    var _len = string_length(target_word);
    for (var i = 0; i < _len; i++) {
        if (i < string_length(player_guess)) _str += string_char_at(player_guess, i+1) + " ";
        else _str += "_ ";
    }

    // Measure hint — shrink scale if it would overflow the 640 px screen
    var _hint_label  = "HINT:  " + current_hint;
    var _max_hint_px = 580.0;                                  // max px across screen
    var _hint_raw_w  = string_width(_hint_label);              // measured at scale 1.0
    var _hint_scale  = (_hint_raw_w * _scale > _max_hint_px)
                       ? (_max_hint_px / _hint_raw_w)
                       : _scale;
    var _hint_w  = _hint_raw_w  * _hint_scale;
    var _guess_w = string_width(_str) * _scale;                // blanks never overflow
    var _line_h  = string_height("Ag") * _scale;

    // Dynamic background — sized to whichever line is wider
    var _box_half = max(_hint_w, _guess_w) * 0.5 + _pad;
    var _box_h    = _line_h + _spacing + _line_h + _pad * 2;
    var _box_y1   = _h - _box_h - 6;
    var _box_y2   = _h - 6;

    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(_w * 0.5 - _box_half, _box_y1,
                   _w * 0.5 + _box_half, _box_y2, false);
    draw_set_alpha(1);

    // Hint row — yellow, auto-scaled to stay on screen
    draw_set_color(c_yellow);
    draw_text_transformed(_w * 0.5, _box_y1 + _pad, _hint_label, _hint_scale, _hint_scale, 0);

    // Answer blanks — white, full scale
    draw_set_color(c_white);
    draw_text_transformed(_w * 0.5, _box_y1 + _pad + _spacing, _str, _scale, _scale, 0);
}

// Reset
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);