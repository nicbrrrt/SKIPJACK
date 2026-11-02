/// @description obj_dungeon_goal — Draw Event
/// Renders a pulsing cyber extraction portal at the center of the End room.

var _pulse = 0.5 + 0.5 * sin(anim_timer * 0.1);
var _outer_r = 7 + _pulse * 2;
var _inner_r = 4;

// Outer glow
draw_set_alpha(0.35 + _pulse * 0.25);
draw_set_color(c_aqua);
draw_circle(x, y, _outer_r + 2, false);

// Portal base pad
draw_set_alpha(0.9);
draw_set_color(make_color_rgb(10, 30, 50));
draw_circle(x, y, 7, false);

// Outer ring
draw_set_alpha(1.0);
draw_set_color(merge_color(c_aqua, c_lime, _pulse));
draw_circle(x, y, 7, true);

// Inner bright core
draw_set_color(c_lime);
draw_circle(x, y, _inner_r * (0.7 + _pulse * 0.3), false);

draw_set_color(c_white);
draw_set_alpha(1.0);
