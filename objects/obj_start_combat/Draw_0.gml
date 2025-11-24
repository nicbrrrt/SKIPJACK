if (visible) {
    // Draw the exclamation sprite
    draw_sprite(spr_computer, 0, x, y);
    
    // Show "Press E" text when player is close
    var _player = instance_find(obj_jack, 0);
    if (_player != noone && point_distance(x, y, _player.x, _player.y) < interaction_range) {
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_text(x, y - 20, "Press E");
        draw_set_halign(fa_left);
    }
}