/// @description obj_door_caesar_lock — Draw Event
/// Renders a crimson/purple Caesar-cipher-encrypted barrier tile.

var _x1 = draw_x;
var _y1 = draw_y;
var _x2 = _x1 + 15;
var _y2 = _y1 + 15;

if (locked) {
    var _pulse = 0.5 + 0.5 * sin(anim_t * 0.12);

    // Dark crimson/violet gate fill
    draw_set_alpha(0.92);
    draw_set_color(make_color_rgb(55, 12, 32));
    draw_rectangle(_x1, _y1, _x2, _y2, false);

    // Glowing magenta/red cipher laser bars
    draw_set_alpha(0.85 + _pulse * 0.15);
    draw_set_color(make_color_rgb(255, 65, 125));
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    draw_line(_x1 + 2, _y1 + 5, _x2 - 2, _y1 + 10);
    draw_line(_x1 + 2, _y1 + 10, _x2 - 2, _y1 + 5);

    // Center cipher lock node
    draw_set_color(make_color_rgb(255, 160, 210));
    draw_rectangle(_x1 + 6, _y1 + 5, _x1 + 9, _y1 + 10, false);
} else {
    // Unlocked threshold indicator
    draw_set_alpha(0.35);
    draw_set_color(c_aqua);
    draw_rectangle(_x1 + 1, _y1 + 1, _x2 - 1, _y2 - 1, true);
}

draw_set_color(c_white);
draw_set_alpha(1.0);
