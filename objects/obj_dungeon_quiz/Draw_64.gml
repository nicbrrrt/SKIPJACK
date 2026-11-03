/// @description obj_dungeon_quiz — Draw GUI Event
/// Renders the standalone Cybersecurity Question UI overlay (640x360 GUI).

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _sx = (shake_timer > 0) ? irandom_range(-4, 4) : 0;
var _sy = (shake_timer > 0) ? irandom_range(-4, 4) : 0;

var _cx = (_gui_w * 0.5) + _sx;
var _cy = (_gui_h * 0.5) + _sy;

// Dim background backdrop
draw_set_alpha(0.75);
draw_set_color(c_black);
draw_rectangle(0, 0, _gui_w, _gui_h, false);

// Main quiz panel
var _pw = 500;
var _ph = 230;
var _x1 = _cx - (_pw * 0.5);
var _y1 = _cy - (_ph * 0.5);
var _x2 = _cx + (_pw * 0.5);
var _y2 = _cy + (_ph * 0.5);

draw_set_alpha(0.95);
draw_set_color(make_color_rgb(16, 22, 34));
draw_rectangle(_x1, _y1, _x2, _y2, false);

// Gold security border
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(255, 195, 35));
draw_rectangle(_x1, _y1, _x2, _y2, true);
draw_rectangle(_x1 + 3, _y1 + 3, _x2 - 3, _y2 - 3, true);

draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Header
draw_set_color(make_color_rgb(255, 210, 55));
draw_text_transformed(_cx, _y1 + 24, "CYBERSECURITY LOCK — KEY VAULT", 1.15, 1.15, 0);

// Question / Hint
draw_set_color(c_white);
draw_text(_cx, _y1 + 52, "CLUE: " + current_hint);

// Scrambled letter tiles row
var _len      = array_length(letter_chars);
var _tile_sz  = 28;
var _tile_gap = 8;
var _total_w  = (_len * _tile_sz) + ((_len - 1) * _tile_gap);
var _start_x  = _cx - (_total_w * 0.5) + (_tile_sz * 0.5);
var _tiles_y  = _y1 + 98;

for (var _i = 0; _i < _len; _i++) {
    var _tx   = _start_x + _i * (_tile_sz + _tile_gap);
    var _used = letter_used[_i];

    draw_set_color(_used ? make_color_rgb(30, 35, 45) : make_color_rgb(55, 42, 14));
    draw_rectangle(_tx - 14, _tiles_y - 14, _tx + 14, _tiles_y + 14, false);

    draw_set_color(_used ? c_dkgray : make_color_rgb(255, 195, 35));
    draw_rectangle(_tx - 14, _tiles_y - 14, _tx + 14, _tiles_y + 14, true);

    draw_set_color(_used ? c_dkgray : c_white);
    draw_text(_tx, _tiles_y, letter_chars[_i]);
}

// Player Answer Slots row
var _ans_y = _y1 + 148;
for (var _i = 0; _i < _len; _i++) {
    var _tx = _start_x + _i * (_tile_sz + _tile_gap);
    var _has_ch = (_i < string_length(player_guess));
    var _ch = _has_ch ? string_char_at(player_guess, _i + 1) : "_";

    draw_set_color(make_color_rgb(10, 14, 22));
    draw_rectangle(_tx - 14, _ans_y - 14, _tx + 14, _ans_y + 14, false);

    draw_set_color(_has_ch ? c_aqua : c_gray);
    draw_rectangle(_tx - 14, _ans_y - 14, _tx + 14, _ans_y + 14, true);

    draw_set_color(_has_ch ? c_lime : c_gray);
    draw_text(_tx, _ans_y, _ch);
}

// Status message or instructions
if (status_msg != "") {
    draw_set_color(status_col);
    draw_text(_cx, _y1 + 184, status_msg);
} else {
    draw_set_color(c_ltgray);
    draw_text(_cx, _y1 + 184, "Unscramble the cybersecurity term above!");
}

draw_set_color(make_color_rgb(160, 175, 195));
draw_text_transformed(_cx, _y1 + 208, "TYPE [A-Z]   |   [BACKSPACE] Erase   |   [ESC] Cancel", 0.85, 0.85, 0);

// Reset draw state
draw_set_font(fnt_default);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);
