/// @description obj_dungeon_quiz — Draw GUI Event
/// Renders a clean, minimal Key Vault Security Quiz UI (640x360 GUI)
/// with Curriculum Scaffolding (Guided Tutorial -> Practice -> Final Exam).

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _sx = (shake_timer > 0) ? irandom_range(-4, 4) : 0;
var _sy = (shake_timer > 0) ? irandom_range(-4, 4) : 0;

var _cx = (_gui_w * 0.5) + _sx;
var _cy = (_gui_h * 0.5) + _sy;

var _curr      = variable_global_exists("floor_curriculum") ? global.floor_curriculum : scr_get_floor_curriculum(1, 4);
var _guided    = _curr.guided_ui;
var _is_exam   = _curr.is_final_exam;
var _clues_cur = variable_global_exists("clues_found")  ? global.clues_found  : 0;
var _clues_req = variable_global_exists("clues_needed") ? global.clues_needed : 2;

// Dim background backdrop
draw_set_alpha(0.82);
draw_set_color(c_black);
draw_rectangle(0, 0, _gui_w, _gui_h, false);

// Compact quiz panel
var _pw = 500;
var _ph = 248;
var _x1 = _cx - (_pw * 0.5);
var _y1 = _cy - (_ph * 0.5);
var _x2 = _cx + (_pw * 0.5);
var _y2 = _cy + (_ph * 0.5);

draw_set_alpha(0.96);
draw_set_color(make_color_rgb(14, 20, 32));
draw_rectangle(_x1, _y1, _x2, _y2, false);

// Gold security border
draw_set_alpha(1.0);
draw_set_color(_is_exam ? make_color_rgb(255, 85, 155) : make_color_rgb(255, 195, 35));
draw_rectangle(_x1, _y1, _x2, _y2, true);
draw_rectangle(_x1 + 3, _y1 + 3, _x2 - 3, _y2 - 3, true);

draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Header
draw_set_color(_is_exam ? make_color_rgb(255, 110, 175) : make_color_rgb(255, 210, 55));
draw_text_transformed(_cx, _y1 + 20, _is_exam ? "FINAL EXAM VAULT QUIZ" : "KEY VAULT LOCK", 1.05, 1.05, 0);

// Short 1-Line Question Box
draw_set_color(make_color_rgb(22, 32, 48));
draw_rectangle(_x1 + 18, _y1 + 36, _x2 - 18, _y1 + 74, false);
draw_set_color(make_color_rgb(65, 130, 175));
draw_rectangle(_x1 + 18, _y1 + 36, _x2 - 18, _y1 + 74, true);

draw_set_color(c_white);
draw_text_ext_transformed(_cx, _y1 + 55, current_scenario, 15, (_pw - 52) / 0.88, 0.88, 0.88, 0);

// Concise Clue Status Line
var _next_needed_ch = "";
if (string_length(player_guess) < string_length(target_word)) {
    _next_needed_ch = string_char_at(target_word, string_length(player_guess) + 1);
}

if (_clues_cur <= 0) {
    draw_set_color(make_color_rgb(255, 175, 65));
    draw_text_transformed(_cx, _y1 + 90, "CLUES: 0/" + string(_clues_req) + "  —  Inspect a glowing PC or NPC [E] first!", 0.82, 0.82, 0);
} else if (_guided && _clues_cur >= _clues_req) {
    draw_set_color(c_lime);
    draw_text_transformed(_cx, _y1 + 90, "TUTORIAL: Type the GREEN highlighted letter ('" + _next_needed_ch + "')!", 0.84, 0.84, 0);
} else if (_clues_cur < _clues_req) {
    draw_set_color(c_aqua);
    draw_text_transformed(_cx, _y1 + 90, "CLUES: " + string(_clues_cur) + "/" + string(_clues_req) + "  —  Letters Unlocked!", 0.84, 0.84, 0);
} else if (_is_exam) {
    draw_set_color(make_color_rgb(255, 140, 195));
    draw_text_transformed(_cx, _y1 + 90, "FINAL EXAM: Unscramble the keyword (No Letter Hints)!", 0.82, 0.82, 0);
} else {
    var _first_two = string_copy(target_word, 1, 2);
    draw_set_color(c_lime);
    draw_text_transformed(_cx, _y1 + 90, "CLUES: " + string(_clues_cur) + "/" + string(_clues_req) + "  —  Starts with '" + _first_two + "...'", 0.84, 0.84, 0);
}

// Scrambled letter tiles row
var _len      = array_length(letter_chars);
var _tile_sz  = 28;
var _tile_gap = 8;
var _total_w  = (_len * _tile_sz) + ((_len - 1) * _tile_gap);
var _start_x  = _cx - (_total_w * 0.5) + (_tile_sz * 0.5);
var _tiles_y  = _y1 + 124;

var _highlighted_next = false;
for (var _i = 0; _i < _len; _i++) {
    var _tx   = _start_x + _i * (_tile_sz + _tile_gap);
    var _used = letter_used[_i];
    var _is_next_guide = false;

    if (_guided && _clues_cur >= _clues_req && !_used && !_highlighted_next && letter_chars[_i] == _next_needed_ch) {
        _is_next_guide    = true;
        _highlighted_next = true;
    }

    draw_set_color(_used ? make_color_rgb(30, 35, 45) : (_is_next_guide ? make_color_rgb(20, 56, 32) : make_color_rgb(55, 42, 14)));
    draw_rectangle(_tx - 14, _tiles_y - 14, _tx + 14, _tiles_y + 14, false);

    draw_set_color(_used ? c_dkgray : (_is_next_guide ? c_lime : make_color_rgb(255, 195, 35)));
    draw_rectangle(_tx - 14, _tiles_y - 14, _tx + 14, _tiles_y + 14, true);

    draw_set_color(_used ? c_dkgray : ((_clues_cur > 0) ? (_is_next_guide ? c_lime : c_white) : make_color_rgb(255, 175, 60)));
    draw_text(_tx, _tiles_y, (_clues_cur > 0) ? letter_chars[_i] : "?");
}

// Player Answer Slots row
var _ans_y = _y1 + 168;
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

// Minimal Status & Footer
if (success_timer > 0) {
    draw_set_color(c_lime);
    draw_text_transformed(_cx, _y2 - 42, "VAULT UNLOCKED!", 0.95, 0.95, 0);
} else if (status_msg != "") {
    draw_set_color(status_col);
    draw_text_transformed(_cx, _y2 - 42, status_msg, 0.88, 0.88, 0);
}

draw_set_color(make_color_rgb(150, 170, 195));
draw_text_transformed(_cx, _y2 - 16, "[A-Z] Type   |   [BACKSPACE] Erase   |   [ESC] Back", 0.82, 0.82, 0);

// Reset draw state
draw_set_font(fnt_default);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);
