// --- Draw Event of obj_battle_button ---

var _size    = 16;
var _bg_col  = revealed ? c_white : c_dkgray;
var _txt_col = revealed ? c_black : c_white;
var _display = revealed ? my_char : "?";

// Box fill
draw_set_color(_bg_col);
draw_rectangle(x - _size, y - _size, x + _size, y + _size, false);

// Box border
draw_set_color(c_black);
draw_rectangle(x - _size, y - _size, x + _size, y + _size, true);

// Letter text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
if (variable_instance_exists(id, "fnt_dialogue")) draw_set_font(fnt_dialogue);
else draw_set_font(-1);
draw_set_color(_txt_col);
draw_text_transformed(x, y, _display, 1, 1, 0);

// Reset
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
