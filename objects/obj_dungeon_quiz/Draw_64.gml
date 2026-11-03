/// @description obj_dungeon_quiz — Draw GUI Event
/// Renders the Cybersecurity Incident Case Quiz UI overlay (640x360 GUI).

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _sx = (shake_timer > 0) ? irandom_range(-4, 4) : 0;
var _sy = (shake_timer > 0) ? irandom_range(-4, 4) : 0;

var _cx = (_gui_w * 0.5) + _sx;
var _cy = (_gui_h * 0.5) + _sy;

// Dim background backdrop
draw_set_alpha(0.80);
draw_set_color(c_black);
draw_rectangle(0, 0, _gui_w, _gui_h, false);

// Main quiz panel
var _pw = 556;
var _ph = 278;
var _x1 = _cx - (_pw * 0.5);
var _y1 = _cy - (_ph * 0.5);
var _x2 = _cx + (_pw * 0.5);
var _y2 = _cy + (_ph * 0.5);

draw_set_alpha(0.96);
draw_set_color(make_color_rgb(14, 20, 32));
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
draw_text_transformed(_cx, _y1 + 20, "KEY VAULT SECURITY VERIFICATION", 1.1, 1.1, 0);

// Floor Incident Case Scenario Box
draw_set_alpha(0.85);
draw_set_color(make_color_rgb(22, 32, 48));
draw_rectangle(_x1 + 16, _y1 + 36, _x2 - 16, _y1 + 82, false);
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(65, 130, 175));
draw_rectangle(_x1 + 16, _y1 + 36, _x2 - 16, _y1 + 82, true);

draw_set_color(c_white);
draw_text_ext_transformed(_cx, _y1 + 59, current_scenario, 16, (_pw - 48) / 0.88, 0.88, 0.88, 0);

// Field Clues / Investigation Status Banner
var _clues_cur = variable_global_exists("clues_found")  ? global.clues_found  : 0;
var _clues_req = variable_global_exists("clues_needed") ? global.clues_needed : 2;

if (_clues_cur <= 0) {
    draw_set_color(make_color_rgb(255, 170, 65));
    draw_text_transformed(_cx, _y1 + 98, "FIELD CLUES: 0/2 — Talk to coworkers or inspect PCs [E] to unlock hints & letter bank!", 0.82, 0.82, 0);
} else if (_clues_cur == 1) {
    draw_set_color(c_aqua);
    draw_text_transformed(_cx, _y1 + 98, "CLUE 1/2 UNLOCKED: " + current_hint, 0.85, 0.85, 0);
} else {
    var _first_two = string_copy(target_word, 1, 2);
    draw_set_color(c_lime);
    draw_text_transformed(_cx, _y1 + 98, "FULL FIELD NOTES (2/2): " + current_hint + " (Starts with '" + _first_two + "...')", 0.82, 0.82, 0);
}

// Scrambled letter tiles row (masked with '?' if player hasn't gathered any clues yet!)
var _len      = array_length(letter_chars);
var _tile_sz  = 28;
var _tile_gap = 8;
var _total_w  = (_len * _tile_sz) + ((_len - 1) * _tile_gap);
var _start_x  = _cx - (_total_w * 0.5) + (_tile_sz * 0.5);
var _tiles_y  = _y1 + 134;

for (var _i = 0; _i < _len; _i++) {
    var _tx   = _start_x + _i * (_tile_sz + _tile_gap);
    var _used = letter_used[_i];

    draw_set_color(_used ? make_color_rgb(30, 35, 45) : make_color_rgb(55, 42, 14));
    draw_rectangle(_tx - 14, _tiles_y - 14, _tx + 14, _tiles_y + 14, false);

    draw_set_color(_used ? c_dkgray : make_color_rgb(255, 195, 35));
    draw_rectangle(_tx - 14, _tiles_y - 14, _tx + 14, _tiles_y + 14, true);

    draw_set_color(_used ? c_dkgray : ((_clues_cur > 0) ? c_white : make_color_rgb(255, 175, 60)));
    draw_text(_tx, _tiles_y, (_clues_cur > 0) ? letter_chars[_i] : "?");
}

// Player Answer Slots row
var _ans_y = _y1 + 180;
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

// Status message or Lesson Takeaway upon solving
if (success_timer > 0) {
    draw_set_color(c_lime);
    draw_text(_cx, _y1 + 214, status_msg);
    draw_set_color(make_color_rgb(170, 245, 205));
    draw_text_ext_transformed(_cx, _y1 + 236, current_takeaway, 14, (_pw - 40) / 0.82, 0.82, 0.82, 0);
} else if (status_msg != "") {
    draw_set_color(status_col);
    draw_text(_cx, _y1 + 220, status_msg);
} else {
    draw_set_color(c_ltgray);
    draw_text_transformed(_cx, _y1 + 220, "Type the cybersecurity term that matches this floor's incident!", 0.90, 0.90, 0);
}

draw_set_color(make_color_rgb(160, 175, 195));
draw_text_transformed(_cx, _y1 + 258, "TYPE [A-Z]   |   [BACKSPACE] Erase   |   [ESC] Step Back & Investigate Rooms", 0.82, 0.82, 0);

// Reset draw state
draw_set_font(fnt_default);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);
