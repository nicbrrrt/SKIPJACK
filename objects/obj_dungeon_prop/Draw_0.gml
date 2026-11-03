/// @description obj_dungeon_prop — Draw Event
/// Draws corporate office props (computers, chairs, scattered papers).

var _cx = x + 8;
var _by = y + 15;

if (prop_type == TILE_PROP_PC) {
    // Corporate Desk Base
    draw_set_alpha(0.95);
    draw_set_color(make_color_rgb(38, 46, 62));
    draw_rectangle(x + 1, y + 4, x + 14, y + 14, false);
    draw_set_color(make_color_rgb(70, 82, 105));
    draw_rectangle(x + 1, y + 4, x + 14, y + 14, true);

    // Animated Computer Terminal (spr_computer has bottom-center origin 8,32)
    var _frame = floor(current_time / 180 + sub_img) mod sprite_get_number(spr_computer);
    draw_sprite_ext(spr_computer, _frame, _cx, _by, 0.75, 0.65, 0, c_white, 1.0);
}
else if (prop_type == TILE_PROP_CHAIR) {
    // Office Chair (spr_class_chair has bottom-center origin)
    draw_sprite_ext(spr_class_chair, 0, _cx, _by, 0.65, 0.45, 0, c_white, 1.0);
}
else if (prop_type == TILE_PROP_PAPER) {
    // Scattered Lockdown Papers on floor
    draw_sprite_ext(spr_paper, 0, _cx, y + 11, 0.75, 0.75, rot_angle, c_white, 0.9);
}

draw_set_color(c_white);
draw_set_alpha(1.0);
