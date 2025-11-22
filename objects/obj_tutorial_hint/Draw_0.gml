draw_set_color(c_red);
draw_set_alpha(1.0);

var _draw_x = display_get_gui_width() / 2;
var _draw_y = display_get_gui_height() / 2;

draw_rectangle(_draw_x - 25, _draw_y - 25, _draw_x + 25, _draw_y + 25, false);