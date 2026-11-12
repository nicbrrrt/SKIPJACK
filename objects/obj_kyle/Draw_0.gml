// Floor contact shadow
if (sprite_index != -1) {
    draw_set_alpha(0.35);
    draw_set_color(c_black);
    var _cx = (bbox_left + bbox_right) * 0.5;
    var _hw = max(6, (bbox_right - bbox_left) * 0.38);
    draw_ellipse(_cx - _hw, bbox_bottom - 3, _cx + _hw, bbox_bottom + 2, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}

draw_self();

// Floating "!" while lesson not yet done
if (!global.kyle_lesson_done && visible) {
    var _bob = sin(get_timer() / 250000) * 5;
    draw_set_color(c_yellow);
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_text(x, y - 40 + _bob, "!");
    draw_set_halign(fa_left);
    draw_set_color(c_white);
}

// [E] prompt when player is nearby
if (instance_exists(obj_jack)) {
    var _player = instance_find(obj_jack, 0);
    if (point_distance(x, y, _player.x, _player.y) < 48) {
        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_color(c_white);
        draw_text(x, y - 24, "[E] TALK");
        draw_set_halign(fa_left);
    }
}
