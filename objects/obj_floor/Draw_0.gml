/// @description obj_floor — Draw Event
/// Renders corporate office tiles, hallway carpet runners, or brushed steel elevator flooring.

draw_self();

if (floor_style == 0) {
    // Corporate polished floor tile subtle check pattern
    var _checker = ((floor(x / 16) + floor(y / 16)) mod 2 == 0);
    draw_set_alpha(_checker ? 0.12 : 0.20);
    draw_set_color(make_color_rgb(30, 42, 62));
    draw_rectangle(x, y, x + 15, y + 15, false);

    // Subtle tile seam
    draw_set_alpha(0.22);
    draw_set_color(make_color_rgb(18, 24, 36));
    draw_rectangle(x, y, x + 15, y + 15, true);
}
else if (floor_style == 1) {
    // Corporate hallway / office runner carpet (crimson lockdown / gold key vault / dark slate)
    draw_set_alpha(0.78);
    if (room_theme == ROOM_CAESAR_KEY) {
        draw_set_color(make_color_rgb(70, 52, 18));
    } else if (room_theme == ROOM_CAESAR_LOCKED) {
        draw_set_color(make_color_rgb(68, 18, 36));
    } else {
        draw_set_color(make_color_rgb(56, 22, 28));
    }
    draw_rectangle(x, y, x + 15, y + 15, false);

    // Subtle woven inner trim
    draw_set_alpha(0.35);
    if (room_theme == ROOM_CAESAR_KEY) {
        draw_set_color(make_color_rgb(220, 175, 45));
    } else {
        draw_set_color(make_color_rgb(170, 45, 60));
    }
    draw_rectangle(x + 2, y + 2, x + 13, y + 13, true);
}
else if (floor_style == 2) {
    // Brushed steel elevator cab floor
    draw_set_alpha(0.92);
    draw_set_color(make_color_rgb(62, 72, 86));
    draw_rectangle(x, y, x + 15, y + 15, false);

    // Metallic diamond-plate tread lines
    draw_set_alpha(0.55);
    draw_set_color(make_color_rgb(95, 110, 130));
    draw_line(x + 3, y + 3, x + 7, y + 7);
    draw_line(x + 9, y + 9, x + 13, y + 13);
    draw_line(x + 11, y + 3, x + 7, y + 7);

    // Dark steel panel border
    draw_set_color(make_color_rgb(34, 40, 50));
    draw_rectangle(x, y, x + 15, y + 15, true);
}
else if (floor_style == 3) {
    // Wellness Green Room lush botanical runner carpet
    draw_set_alpha(0.85);
    draw_set_color(make_color_rgb(28, 62, 42)); // calming deep sage
    draw_rectangle(x, y, x + 15, y + 15, false);

    // Subtle mint woven border
    draw_set_alpha(0.40);
    draw_set_color(make_color_rgb(70, 165, 110)); // soft mint
    draw_rectangle(x + 2, y + 2, x + 13, y + 13, true);
}

draw_set_color(c_white);
draw_set_alpha(1.0);
