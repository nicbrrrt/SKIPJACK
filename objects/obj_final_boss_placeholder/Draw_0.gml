// obj_final_boss_placeholder — Draw Event
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

if (!global.final_boss_defeated && visible) {
    var _bob = sin(get_timer() / 250000) * 5;
    draw_set_color(c_red);
    draw_set_halign(fa_center);
    draw_text(x, y - 40 + _bob, "!");
    draw_set_halign(fa_left);
    draw_set_color(c_white);
}
