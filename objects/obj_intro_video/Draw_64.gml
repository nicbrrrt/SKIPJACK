/// @description obj_intro_video — Draw GUI Event
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// 1. Skip Button (Bottom-Right corner in 640x360 GUI space)
var _btn_x1 = _gw - 120;
var _btn_y1 = _gh - 42;
var _btn_x2 = _gw - 20;
var _btn_y2 = _gh - 14;

// Button box
draw_set_alpha(skip_hover ? 0.9 : 0.65);
draw_set_color(skip_hover ? make_color_rgb(45, 60, 85) : make_color_rgb(20, 25, 35));
draw_rectangle(_btn_x1, _btn_y1, _btn_x2, _btn_y2, false);

// Button outline
draw_set_color(skip_hover ? c_white : make_color_rgb(180, 195, 215));
draw_rectangle(_btn_x1, _btn_y1, _btn_x2, _btn_y2, true);

// Button text
draw_set_alpha(1.0);
if (font_exists(fnt_dialogue)) {
    draw_set_font(fnt_dialogue);
}
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(skip_hover ? c_white : make_color_rgb(220, 230, 245));
draw_text_transformed((_btn_x1 + _btn_x2) * 0.5, (_btn_y1 + _btn_y2) * 0.5, "SKIP [ESC]", 0.75, 0.75, 0);

// Reset draw alignments
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

// 2. Fade to black transition when finishing or skipping
if (fade_alpha > 0.0) {
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}
