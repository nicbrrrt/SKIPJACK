// obj_tutorial_controller — Draw GUI Event
// Renders a small WASD progress tracker in the top-left corner of the screen.
// Each key letter turns lime green once the player has pressed it.
// Hidden while the dialogue box is open so it doesn't overlap.

// Only show the tracker during phase 1 (WASD practice), and not while dialogue is open
if (tutorial_done || tutorial_phase != 1 || instance_exists(obj_textevent)) exit;

var _x       = 16;
var _y       = 16;
var _spacing = 28;
var _col_done = c_lime;
var _col_todo = c_white;

draw_set_font(fnt_dialogue);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(c_black);
draw_set_alpha(0.6);
draw_rectangle(_x - 5, _y - 5, _x + 115, _y + 52, false);
draw_set_alpha(1.0);

draw_set_color(c_yellow);
draw_text(_x, _y, "OBJECTIVES:");

draw_set_color(c_white);
draw_text(_x + 5, _y + 18, "Move using:");

draw_set_color(w_pressed ? _col_done : _col_todo);
draw_text(_x + 5,                _y + 30, "W");

draw_set_color(a_pressed ? _col_done : _col_todo);
draw_text(_x + 5 + _spacing,     _y + 30, "A");

draw_set_color(s_pressed ? _col_done : _col_todo);
draw_text(_x + 5 + _spacing * 2, _y + 30, "S");

draw_set_color(d_pressed ? _col_done : _col_todo);
draw_text(_x + 5 + _spacing * 3, _y + 30, "D");

draw_set_color(c_white);
