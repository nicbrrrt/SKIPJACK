// obj_battle_intro — Draw GUI Event
// During phase 1 (codex open), draw a reminder to close the codex.

if (phase == 1) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    var _bw = 340;
    var _bh = 40;
    var _bx = (_gw - _bw) / 2;
    var _by = _gh - 52;

    draw_set_alpha(0.88);
    draw_set_color(make_colour_rgb(8, 8, 30));
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

    draw_set_alpha(1);
    draw_set_color(c_yellow);
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);

    draw_set_font(fnt_dialogue);
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_gw / 2, _by + _bh / 2, "Press  [ C ]  or  [ ESC ]  to close the Codex");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
