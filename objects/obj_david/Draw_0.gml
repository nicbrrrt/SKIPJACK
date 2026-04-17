draw_self();

// Floating "?" while not yet beaten
if (!global.david_defeated && visible) {
    var _bob = sin(get_timer() / 250000) * 5;
    draw_set_color(c_yellow);
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_text(x, y - 40 + _bob, "?");
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
        draw_text(x, y - 24, global.david_defeated ? "[E] TALK" : "[E] CHALLENGE");
        draw_set_halign(fa_left);
    }
}
