var _size = 20;
var _pulse = 1 + sin(current_time / 80) * 0.08;

draw_set_color(c_red);
draw_rectangle(gui_x - _size * _pulse, gui_y - _size * _pulse,
               gui_x + _size * _pulse, gui_y + _size * _pulse, false);
draw_set_color(c_black);
draw_rectangle(gui_x - _size * _pulse, gui_y - _size * _pulse,
               gui_x + _size * _pulse, gui_y + _size * _pulse, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
if (variable_global_exists("fnt_dialogue")) draw_set_font(fnt_dialogue);
draw_set_color(c_yellow);
draw_text_transformed(gui_x, gui_y, block_char, 1.3, 1.3, 0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
