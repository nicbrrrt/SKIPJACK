/// @description obj_intern_wrench_station - Draw Event
var _cx = x + 8;
var _cy = y + 8;

var _has_wrench = (variable_global_exists("player_has_wrench") && global.player_has_wrench);
var _holding_intern = (variable_global_exists("held_intern_inst") && global.held_intern_inst != noone);

// 1. Industrial Mechanic Tool Chest & Pegboard
// Floor Shadow
draw_set_alpha(0.3);
draw_set_color(c_black);
draw_ellipse(x + 1, y + 12, x + 15, y + 16, false);
draw_set_alpha(1.0);

// Red heavy steel cabinet base
draw_set_color(make_color_rgb(180, 40, 35));
draw_rectangle(x + 2, y + 6, x + 14, y + 15, false);
draw_set_color(make_color_rgb(110, 20, 20));
draw_rectangle(x + 2, y + 6, x + 14, y + 15, true);

// Cabinet drawer seams & chrome pulls
draw_set_color(make_color_rgb(80, 15, 15));
draw_line(x + 3, y + 9, x + 13, y + 9);
draw_line(x + 3, y + 12, x + 13, y + 12);
draw_set_color(make_color_rgb(220, 230, 240));
draw_line(x + 6, y + 8, x + 10, y + 8);
draw_line(x + 6, y + 11, x + 10, y + 11);

// Dark pegboard backer
draw_set_color(make_color_rgb(45, 55, 65));
draw_rectangle(x + 2, y + 1, x + 14, y + 5, false);
draw_set_color(make_color_rgb(75, 85, 95));
draw_rectangle(x + 2, y + 1, x + 14, y + 5, true);

// 2. Shiny Chrome Mechanic's Wrench hanging on hooks (if not equipped by Jack)
if (!_has_wrench) {
    // Wrench handle angled across pegboard
    draw_set_color(make_color_rgb(210, 220, 230));
    draw_line_width(x + 4, y + 4, x + 11, y - 2, 2);
    // Open-end wrench jaws head
    draw_set_color(make_color_rgb(240, 245, 255));
    draw_circle(x + 11, y - 2, 2, false);
    draw_set_color(make_color_rgb(45, 55, 65));
    draw_circle(x + 11, y - 2, 1, false);
}

// 3. Interaction Prompt
if (near_player) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_font(fnt_dialogue);

    if (_holding_intern) {
        draw_set_color(c_orange);
        draw_text_transformed(_cx, y - 6, "! HANDS FULL (DROP INTERN) !", 0.38, 0.38, 0);
    } else if (!_has_wrench) {
        draw_set_color(c_yellow);
        draw_text_transformed(_cx, y - 6, "[E] EQUIP WRENCH", 0.40, 0.40, 0);
    } else {
        draw_set_color(c_white);
        draw_text_transformed(_cx, y - 6, "[E] RETURN WRENCH", 0.40, 0.40, 0);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fnt_default);
}
