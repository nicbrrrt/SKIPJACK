// obj_final_boss_placeholder — Draw Event
draw_self();

if (!global.final_boss_defeated && visible) {
    var _bob = sin(get_timer() / 250000) * 5;
    draw_set_color(c_red);
    draw_set_halign(fa_center);
    draw_text(x, y - 40 + _bob, "!");
    draw_set_halign(fa_left);
    draw_set_color(c_white);
}
