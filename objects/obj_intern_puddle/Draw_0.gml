/// @description obj_intern_puddle - Draw Event
// Animated glistening water puddle with ripples and sheen
var _t = ripple_timer;
var _pulse = sin(_t * 0.05) * 1.5;
var _rx = radius_x + _pulse * 0.5;
var _ry = radius_y + _pulse * 0.25;

// Water body - semi-transparent layered blue & cyan
draw_set_alpha(0.35);
draw_set_color(make_color_rgb(30, 110, 200));
draw_ellipse(x - _rx - 2, y - _ry - 1, x + _rx + 2, y + _ry + 1, false);

draw_set_alpha(0.55);
draw_set_color(make_color_rgb(50, 170, 240));
draw_ellipse(x - _rx, y - _ry, x + _rx, y + _ry, false);

// Surface sheen & ripple rings
draw_set_alpha(0.40);
draw_set_color(c_white);
var _rip_rad = (_t * 0.35) mod 16;
draw_ellipse(x - _rip_rad * 1.2, y - _rip_rad * 0.5, x + _rip_rad * 1.2, y + _rip_rad * 0.5, true);

// Inner light reflection curve
draw_set_alpha(0.70);
draw_line_width_color(x - _rx * 0.5, y - _ry * 0.4, x + _rx * 0.3, y - _ry * 0.4, 2, c_white, c_aqua);

draw_set_alpha(1.0);

// Interaction Prompts & Progress Bar
if (near_player) {
    var _has_mop = (variable_global_exists("player_has_mop") && global.player_has_mop);
    var _cx = x;
    var _by = y - _ry - 10;

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_font(fnt_dialogue);

    if (!_has_mop) {
        // Warning: need mop from storage!
        var _bob = sin(current_time / 100) * 2;
        draw_set_color(c_yellow);
        draw_text_transformed(_cx, _by + _bob, "[!] GET MOP AT STORAGE!", 0.40, 0.40, 0);
    } else {
        // Equipped mop: Spam [E] to Mop!
        draw_set_color(c_aqua);
        draw_text_transformed(_cx, _by - 2, "SPAM [E] MOP WATER!", 0.40, 0.40, 0);

        var _bw  = 34;
        var _bh  = 4;
        var _bx1 = _cx - _bw * 0.5;
        var _by1 = _by;

        draw_set_alpha(0.95);
        draw_set_color(c_black);
        draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, false);

        draw_set_color(merge_color(c_aqua, c_lime, mop_meter));
        draw_rectangle(_bx1, _by1, _bx1 + _bw * clamp(mop_meter, 0, 1), _by1 + _bh, false);

        draw_set_color(c_white);
        draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, true);
        draw_set_alpha(1.0);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fnt_default);
}
