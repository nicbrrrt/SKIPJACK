// obj_level1_tooltips — Draw GUI Event
// Shows a compact reminder panel in the bottom-right corner.

var _gw = display_get_gui_width();   // 640
var _gh = display_get_gui_height();  // 360

var _pad  = 10;
var _bw   = 188;
var _bh   = 82;
var _bx   = _gw - _bw - 8;
var _by   = _gh - _bh - 8;

// Background
draw_set_alpha(0.88);
draw_set_color(make_colour_rgb(10, 10, 35));
draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

// Border
draw_set_alpha(1);
draw_set_color(make_colour_rgb(80, 140, 220));
draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);

draw_set_font(fnt_dialogue);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Title
draw_set_color(make_colour_rgb(160, 210, 255));
draw_text(_bx + _pad, _by + 7, "Controls");

// Divider
draw_set_color(make_colour_rgb(60, 90, 160));
draw_line(_bx + _pad, _by + 22, _bx + _bw - _pad, _by + 22);

// Entries
draw_set_color(c_white);
draw_text(_bx + _pad, _by + 28, "WASD   Move");
draw_text(_bx + _pad, _by + 44, "E          Interact with NPCs");

// Dismiss hint
draw_set_color(make_colour_rgb(140, 180, 140));
draw_text(_bx + _pad, _by + 62, "X   Close this panel");

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
