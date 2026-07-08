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

// --- 1. ENEMY (Left) ---
var _enemy_scale_x = enemy_draw_xscale;
var _enemy_scale_y = enemy_draw_yscale;
var _enemy_x = (_w * enemy_x_pct) + enemy_x_offset;
var _enemy_y = scr_battle_sprite_feet_y(enemy_sprite, _enemy_scale_y, base_y_level);
var _enemy_sub = image_index;
var _ec = scr_battle_sprite_chest_xy(enemy_sprite, _enemy_scale_y, _enemy_x, _enemy_y);
var _orbit_cx = _ec[0];
var _orbit_cy = _ec[1];
var _orbit_r  = 70;

// Orbit countdown ring (visible during active quiz input / block parry)
if ((battle_state == "player_input" || battle_state == "block_attack")
    && (!scramble_tutorial || tutorial_phase >= 5)) {
    var _pct = clamp(orbit_countdown / orbit_countdown_max, 0, 1);
    draw_set_color(c_black);
    draw_set_alpha(0.35);
    draw_circle(_orbit_cx, _orbit_cy, _orbit_r, true);
    draw_set_alpha(1);
    draw_set_color(c_orange);
    var _start = -90;
    var _sweep = 360 * _pct;
    if (_sweep > 1) {
        draw_primitive_begin(pr_linestrip);
        for (var _a = 0; _a <= _sweep; _a += 4) {
            var _ang = _start + _a;
            draw_vertex(_orbit_cx + lengthdir_x(_orbit_r, _ang), _orbit_cy + lengthdir_y(_orbit_r, _ang));
        }
        draw_primitive_end();
    }
    // Shrinking ring pulse as timer runs low
    if (_pct < 0.2) {
        draw_set_alpha(0.25 + (1 - _pct / 0.2) * 0.35);
        draw_set_color(c_red);
        draw_circle(_orbit_cx, _orbit_cy, _orbit_r + 4, true);
        draw_set_alpha(1);
    }
}

// Visual Logic for the Death Sequence
var _alpha = 1;
var _color = c_white;

if (battle_state == "win") {
    _color = c_red;
    _alpha = (timer % 2 == 0) ? 0.8 : 0.2; 
    if (timer > 130) {
        gpu_set_fog(true, c_white, 0, 0);
        _alpha = 1;
    }
}

if (enemy_flash_timer > 0) {
    enemy_flash_timer--;
    gpu_set_fog(true, c_red, 0, 0);
}

draw_sprite_ext(enemy_sprite, _enemy_sub, _enemy_x, _enemy_y, _enemy_scale_x, _enemy_scale_y, 0, _color, _alpha);
gpu_set_fog(false, c_white, 0, 0);

var _enemy_head_y = _enemy_y - 90;
if (battle_state != "win") {
    draw_healthbar(_enemy_x - 40, _enemy_head_y, _enemy_x + 40, _enemy_head_y + 10, (current_hp_enemy/max_hp_enemy)*100, c_black, c_red, c_green, 0, true, true);
}

// --- 2. PLAYER (Right) ---
var _player_x = (_w * 0.75) + player_x_offset;
var _player_y = scr_battle_sprite_feet_y(player_sprite, player_draw_yscale, base_y_level);

if (player_flash_timer > 0) { player_flash_timer--; gpu_set_fog(true, c_red, 0, 0); }
var _player_sub = (variable_instance_exists(id, "player_idle_subimg")
                   && battle_state != "player_attack" && battle_state != "enemy_turn")
                  ? player_idle_subimg : image_index;
draw_sprite_ext(player_sprite, _player_sub, _player_x, _player_y, player_draw_xscale, player_draw_yscale, 0, c_white, 1);
gpu_set_fog(false, c_white, 0, 0);

var _player_head_y = _player_y - 90;
draw_healthbar(_player_x - 40, _player_head_y, _player_x + 40, _player_head_y + 10, (current_hp_player/max_hp_player)*100, c_black, c_red, c_green, 0, true, true);

// --- TUTORIAL SKIP HINT ---
if (scramble_tutorial && tutorial_phase < 7 && !instance_exists(obj_textevent)) {
    if (variable_instance_exists(id, "fnt_dialogue")) draw_set_font(fnt_dialogue); else draw_set_font(-1);
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_set_alpha(0.55);
    draw_rectangle(_w - 168, 4, _w - 4, 22, false);
    draw_set_alpha(1);
    draw_set_color(c_ltgray);
    draw_text(_w - 8, 6, "[TAB] Skip showcase");
    draw_set_halign(fa_left);
}

// --- TUTORIAL SKIP HINT (during dialogue) ---
if (scramble_tutorial && instance_exists(obj_textevent)) {
    if (variable_instance_exists(id, "fnt_dialogue")) draw_set_font(fnt_dialogue); else draw_set_font(-1);
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_set_alpha(0.55);
    draw_rectangle(_w - 200, 4, _w - 4, 22, false);
    draw_set_alpha(1);
    draw_set_color(c_ltgray);
    draw_text(_w - 8, 6, "[TAB/X] Skip dialogue");
    draw_set_halign(fa_left);
}

// Skip to finish when already on practice round
if (scramble_tutorial && tutorial_phase >= 7 && battle_state == "player_input") {
    if (variable_instance_exists(id, "fnt_dialogue")) draw_set_font(fnt_dialogue); else draw_set_font(-1);
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_set_alpha(0.55);
    draw_rectangle(_w - 168, 4, _w - 4, 22, false);
    draw_set_alpha(1);
    draw_set_color(c_ltgray);
    draw_text(_w - 8, 6, "[TAB] Finish");
    draw_set_halign(fa_left);
}

// --- TUTORIAL MESSAGE BANNER ---
if (scramble_tutorial && tutorial_msg != "" && !instance_exists(obj_textevent)) {
    if (variable_instance_exists(id, "fnt_dialogue")) draw_set_font(fnt_dialogue); else draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    var _tw = string_width(tutorial_msg);
    var _th = string_height(tutorial_msg);
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(_w / 2 - _tw / 2 - 10, 28, _w / 2 + _tw / 2 + 10, 28 + _th + 8, false);
    draw_set_alpha(1);
    draw_set_color(c_aqua);
    draw_text(_w / 2, 32, tutorial_msg);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

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

// --- TUTORIAL AUTO-DEMO UI (orbiting letters during scripted examples) ---
if (battle_state == "tutorial" && instance_exists(obj_battle_button)) {
    with (obj_battle_button) {
        if (visible) event_perform(ev_draw, 0);
    }
    if (variable_instance_exists(id, "fnt_dialogue")) draw_set_font(fnt_dialogue); else draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    var _scale = 1.1;
    var _hint_label = "HINT:  " + current_hint;
    draw_set_color(c_black);
    draw_set_alpha(0.55);
    draw_rectangle(_w * 0.5 - 200, _h - 70, _w * 0.5 + 200, _h - 8, false);
    draw_set_alpha(1);
    draw_set_color(c_yellow);
    draw_text_transformed(_w * 0.5, _h - 62, _hint_label, _scale, _scale, 0);
    var _g = "";
    var _tl = string_length(target_word);
    for (var t = 0; t < _tl; t++) {
        if (t < string_length(player_guess)) _g += string_char_at(player_guess, t+1) + " ";
        else _g += "_ ";
    }
    draw_set_color(c_white);
    draw_text_transformed(_w * 0.5, _h - 38, _g, _scale, _scale, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// --- 3. UI (Bottom) ---
if (battle_state == "player_input" || battle_state == "block_attack") {
    
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

    var _len = string_length(target_word);

    // Measure hint — shrink scale if it would overflow the 640 px screen
    var _hint_label  = "HINT:  " + current_hint;
    var _max_hint_px = 580.0;
    var _hint_raw_w  = string_width(_hint_label);
    var _hint_scale  = (_hint_raw_w * _scale > _max_hint_px)
                       ? (_max_hint_px / _hint_raw_w)
                       : _scale;
    var _hint_w  = _hint_raw_w  * _hint_scale;
    var _guess_raw = "";
    for (var i = 0; i < _len; i++) {
        if (i < string_length(player_guess)) _guess_raw += string_char_at(player_guess, i+1) + " ";
        else if (variable_instance_exists(id, "hint_slots") && array_length(hint_slots) > i && hint_slots[i])
            _guess_raw += string_char_at(target_word, i+1) + " ";
        else _guess_raw += "_ ";
    }
    var _guess_w = string_width(_guess_raw) * _scale;
    var _line_h  = string_height("Ag") * _scale;

    // Suspense line width
    var _suspense = "HURRY UP! BEFORE THE ENEMY ATTACKS YOU";
    var _susp_w = string_width(_suspense) * 0.85;

    var _box_half = max(_hint_w, _guess_w, _susp_w) * 0.5 + _pad;
    var _box_h    = _line_h * 0.9 + _spacing + _line_h + _spacing + _line_h + _pad * 2;
    var _box_y1   = _h - _box_h - 6;
    var _box_y2   = _h - 6;

    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(_w * 0.5 - _box_half, _box_y1,
                   _w * 0.5 + _box_half, _box_y2, false);
    draw_set_alpha(1);

    // Suspense row — orange pulse
    var _pulse = 0.85 + sin(current_time / 120) * 0.15;
    draw_set_color(make_color_rgb(255, 100, 40));
    draw_text_transformed(_w * 0.5, _box_y1 + _pad, _suspense, 0.85 * _pulse, 0.85 * _pulse, 0);

    // Hint row — yellow
    draw_set_color(c_yellow);
    draw_text_transformed(_w * 0.5, _box_y1 + _pad + _spacing, _hint_label, _hint_scale, _hint_scale, 0);

    // Answer row — typed white, revealed hints lime, blanks dim
    var _guess_y = _box_y1 + _pad + _spacing + _spacing;
    var _char_w = string_width("A ") * _scale;
    var _total_guess_w = _char_w * _len;
    var _gx = _w * 0.5 - _total_guess_w * 0.5 + _char_w * 0.5;
    for (var j = 0; j < _len; j++) {
        var _ch = "_";
        var _col = make_color_rgb(120, 120, 120);
        if (j < string_length(player_guess)) {
            _ch = string_char_at(player_guess, j+1);
            _col = c_white;
        } else if (variable_instance_exists(id, "hint_slots") && array_length(hint_slots) > j && hint_slots[j]) {
            _ch = string_char_at(target_word, j+1);
            _col = c_lime;
        }
        draw_set_color(_col);
        draw_text_transformed(_gx + j * _char_w, _guess_y, _ch, _scale, _scale, 0);
    }

    // Block parry prompt
    if (battle_state == "block_attack" && instance_exists(obj_battle_block)) {
        var _blk = instance_find(obj_battle_block, 0);
        var _parry_txt = "PARRY! Press [" + _blk.block_char + "] before it hits!";
        draw_set_color(c_red);
        draw_text_transformed(_w * 0.5, _box_y1 - 26, _parry_txt, 1.15, 1.15, 0);
        if (block_slowmo_timer > 0) {
            draw_set_color(c_aqua);
            draw_text_transformed(_w * 0.5, _box_y1 - 48, "SLOW MOTION — block it now!", 0.95, 0.95, 0);
        }
    }

    // Countdown seconds near ring
    if (!scramble_tutorial || tutorial_phase >= 5) {
        var _secs = ceil(orbit_countdown / room_speed);
        draw_set_halign(fa_center);
        draw_set_color(_secs <= 3 ? c_red : c_orange);
        draw_text(_orbit_cx, _orbit_cy - _orbit_r - 14, string(_secs) + "s");
        draw_set_halign(fa_left);
    }
}

// Slow-motion vignette during block attacks
if (block_slowmo_timer > 0) {
    draw_set_color(c_black);
    draw_set_alpha(0.25);
    draw_rectangle(0, 0, _w, _h, false);
    draw_set_alpha(1);
}

// Reset
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
