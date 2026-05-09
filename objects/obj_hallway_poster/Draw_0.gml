// rm_hallway_poster — Draw Event (world space)
// No world sprite — the object is invisible except for the "!" prompt.

// Always show the pulsing "!" so the object is visible when entering the room.
// Hides only while the popup is open (no need to prompt what's already open).
if (!is_open && global.kyle_lesson_done) {
    var _pulse = 0.7 + sin(current_time * 0.005) * 0.3;

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(has_been_opened ? c_white : c_yellow);
    draw_set_alpha(_pulse);
    draw_text_transformed(x, y - 24, "!", 2.2, 2.2, 0);

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
