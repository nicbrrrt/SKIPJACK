/// @description obj_dungeon_wall — Draw Event
/// Renders corporate walls with 3D top caps, emergency lockdown strips, or structural void casing.

if (wall_style == 1) {
    // Structural building void (makes hallways and compact rooms visibly narrower/smaller)
    draw_set_alpha(0.95);
    draw_set_color(make_color_rgb(10, 12, 18));
    draw_rectangle(x, y, x + 15, y + 15, false);

    draw_set_alpha(0.25);
    draw_set_color(make_color_rgb(24, 30, 42));
    draw_line(x, y, x + 15, y + 15);
    draw_set_color(c_white);
    draw_set_alpha(1.0);
    exit;
}

// Base wall sprite
draw_self();

// 3D Corporate Wall Top Cap (top 5px)
draw_set_alpha(0.85);
draw_set_color(make_color_rgb(24, 30, 44));
draw_rectangle(x, y, x + 15, y + 4, false);

// Top highlight bevel
draw_set_color(make_color_rgb(58, 70, 94));
draw_line(x, y, x + 15, y);

// Baseboard trim at bottom of wall
draw_set_color(make_color_rgb(20, 24, 34));
draw_rectangle(x, y + 13, x + 15, y + 15, false);

// Emergency Lockdown LED Strip along wall face
var _pulse = 0.45 + 0.45 * sin((current_time * 0.005) + (x + y) * 0.05);
draw_set_alpha(_pulse);
if (room_theme == ROOM_CAESAR_KEY) {
    draw_set_color(make_color_rgb(255, 200, 40));
} else if (room_theme == ROOM_END && variable_global_exists("lockdown_lifted") && global.lockdown_lifted) {
    draw_set_color(c_aqua);
} else {
    draw_set_color(make_color_rgb(255, 45, 55)); // Red corporate lockdown alert strip
}
draw_line(x + 1, y + 6, x + 14, y + 6);

// Mounted Corporate Monitor / Briefing Screen on wall (wall_style == 2)
if (wall_style == 2) {
    draw_set_alpha(1.0);
    draw_set_color(make_color_rgb(12, 18, 28));
    draw_rectangle(x + 1, y + 3, x + 14, y + 12, false);
    draw_set_color(make_color_rgb(255, 60, 75));
    draw_rectangle(x + 1, y + 3, x + 14, y + 12, true);
    // Lockdown alert bar on monitor
    draw_set_alpha(0.8);
    draw_line(x + 3, y + 6, x + 12, y + 6);
    draw_set_color(c_aqua);
    draw_line(x + 3, y + 9, x + 10, y + 9);
}

draw_set_color(c_white);
draw_set_alpha(1.0);
