/// @description obj_dungeon_goal — Draw Event
/// Renders a Corporate Extraction Elevator Cab at the center of ROOM_END.

var _pulse = 0.5 + 0.5 * sin(anim_timer * 0.1);

// 1. Elevator Cab Inner Floor Mat & Caution Border
draw_set_alpha(0.85);
draw_set_color(make_color_rgb(28, 36, 48));
draw_rectangle(x - 20, y - 20, x + 20, y + 20, false);

// Yellow/black safety threshold trim
draw_set_alpha(0.9);
draw_set_color(make_color_rgb(235, 190, 35));
draw_rectangle(x - 20, y - 20, x + 20, y + 20, true);

// 2. Brushed Steel Elevator Cab Frame & Retracted Sliding Doors
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(78, 90, 108));
// Top elevator header arch
draw_rectangle(x - 22, y - 25, x + 22, y - 19, false);
// Left & Right retracted double doors
draw_rectangle(x - 22, y - 20, x - 16, y + 20, false);
draw_rectangle(x + 16, y - 20, x + 22, y + 20, false);

draw_set_color(make_color_rgb(35, 42, 55));
draw_rectangle(x - 22, y - 25, x + 22, y - 19, true);
draw_rectangle(x - 22, y - 20, x - 16, y + 20, true);
draw_rectangle(x + 16, y - 20, x + 22, y + 20, true);

// 3. Digital Floor Indicator Display above Elevator Cab
draw_set_color(make_color_rgb(10, 16, 24));
draw_rectangle(x - 12, y - 24, x + 12, y - 20, false);
draw_set_color(merge_color(c_aqua, c_lime, _pulse));
// Upward indicator dots
draw_circle(x - 5, y - 22, 1.5, false);
draw_circle(x,     y - 22, 1.5, false);
draw_circle(x + 5, y - 22, 1.5, false);

// 4. Elevator Call/Floor Control Panel (right cab wall)
draw_set_color(make_color_rgb(22, 28, 38));
draw_rectangle(x + 17, y - 6, x + 21, y + 8, false);
draw_set_color(c_lime);
draw_circle(x + 19, y - 2, 1.2, false);
draw_set_color(c_red);
draw_circle(x + 19, y + 3, 1.2, false);

// 5. Center Extraction Pad & Upward Chevron inside Elevator
draw_set_alpha(0.35 + _pulse * 0.25);
draw_set_color(c_aqua);
draw_circle(x, y, 11 + _pulse * 2, false);

draw_set_alpha(0.95);
draw_set_color(make_color_rgb(14, 34, 52));
draw_circle(x, y, 9, false);

draw_set_alpha(1.0);
draw_set_color(merge_color(c_aqua, c_lime, _pulse));
draw_circle(x, y, 9, true);

// Up-arrow chevron in center of elevator pad
draw_set_color(c_lime);
draw_line_width(x - 4, y + 2, x, y - 4, 2);
draw_line_width(x, y - 4, x + 4, y + 2, 2);
draw_line_width(x, y - 3, x, y + 5, 2);

draw_set_color(c_white);
draw_set_alpha(1.0);
