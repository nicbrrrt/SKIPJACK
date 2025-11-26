draw_set_font(fnt_default);
var gw = display_get_gui_width();
var gh = display_get_gui_height();
var cx = gw / 2;
var cy = gh / 2;

draw_set_alpha(0.9 * alpha);

// 1. Draw Background Box (Black with Green Border)
draw_set_color(c_black);
draw_rectangle(cx - box_width/2, cy - box_height/2, cx + box_width/2, cy + box_height/2, false);
draw_set_color(c_lime); // Hacker Green
draw_rectangle(cx - box_width/2, cy - box_height/2, cx + box_width/2, cy + box_height/2, true);

// 2. Draw Text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Title
draw_set_color(c_lime);
draw_text_transformed(cx, cy - 60, text_title, 1.5, 1.5, 0);

// Body
draw_set_color(c_white);
draw_text_ext(cx, cy, text_body, 20, box_width - 40);

// Footer
draw_set_color(c_gray);
draw_text(cx, cy + 80, "[PRESS SPACE TO START]");

// Reset
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);