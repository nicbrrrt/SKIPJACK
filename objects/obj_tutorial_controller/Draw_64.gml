// obj_tutorial_controller — Draw GUI Event
// Renders a small WASD progress tracker in the top-left corner of the screen.
// Each key letter turns lime green once the player has pressed it.
// Hidden while the dialogue box is open so it doesn't overlap.

// Only show the tracker during phase 1 (WASD practice), and not while dialogue is open
if (tutorial_done || tutorial_phase != 1 || instance_exists(obj_textevent)) exit;

var _x        = 16;
var _y        = 16;
var _scale    = 1.2;
var _row_h    = 22;  // vertical row spacing at scale 1.2
var _key_gap  = 28;  // horizontal gap between key letters (unscaled)
var _col_done = c_lime;
var _col_todo = c_white;

draw_set_font(fnt_dialogue);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Dynamic box — wide enough for OBJECTIVES:, "Move using:", and the 4 key letters
var _key_span = 5 + _key_gap * _scale * 3 + string_width("D") * _scale + 8;
var _box_w    = max(max(string_width("OBJECTIVES:") * _scale, string_width("Move using:") * _scale + 10), _key_span) + 12;
var _box_h    = _row_h * 3 + 10;

draw_set_color(c_black);
draw_set_alpha(0.6);
draw_rectangle(_x - 5, _y - 5, _x + _box_w, _y + _box_h, false);
draw_set_alpha(1.0);

draw_set_color(c_yellow);
draw_text_transformed(_x, _y, "OBJECTIVES:", _scale, _scale, 0);

draw_set_color(c_white);
draw_text_transformed(_x + 5, _y + _row_h, "Move using:", _scale, _scale, 0);

draw_set_color(w_pressed ? _col_done : _col_todo);
draw_text_transformed(_x + 5,                              _y + _row_h * 2, "W", _scale, _scale, 0);

draw_set_color(a_pressed ? _col_done : _col_todo);
draw_text_transformed(_x + 5 + _key_gap * _scale,          _y + _row_h * 2, "A", _scale, _scale, 0);

draw_set_color(s_pressed ? _col_done : _col_todo);
draw_text_transformed(_x + 5 + _key_gap * _scale * 2,      _y + _row_h * 2, "S", _scale, _scale, 0);

draw_set_color(d_pressed ? _col_done : _col_todo);
draw_text_transformed(_x + 5 + _key_gap * _scale * 3,      _y + _row_h * 2, "D", _scale, _scale, 0);

draw_set_color(c_white);
