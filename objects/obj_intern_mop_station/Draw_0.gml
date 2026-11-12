/// @description obj_intern_mop_station - Draw Event
var _cx = x + 8;
var _cy = y + 8;

var _has_mop = (variable_global_exists("player_has_mop") && global.player_has_mop);

var _spr_station = sprite_exists(spr_intern_mop_station) ? spr_intern_mop_station : (sprite_exists(spr_mop_intern_station) ? spr_mop_intern_station : -1);
var _spr_mop     = sprite_exists(spr_intern_mop) ? spr_intern_mop : (sprite_exists(spr_mop) ? spr_mop : -1);

if (_spr_station != -1) {
    // Floor Shadow
    draw_set_alpha(0.35);
    draw_set_color(c_black);
    draw_ellipse(x + 1, y + 12, x + 15, y + 16, false);
    draw_set_alpha(1.0);

    // Mop Station Bucket grounded at y + 16
    var _sx = _cx - (sprite_get_width(_spr_station) * 0.5) + sprite_get_xoffset(_spr_station);
    var _sy = (y + 16) - sprite_get_height(_spr_station) + sprite_get_yoffset(_spr_station);
    draw_sprite_ext(_spr_station, 0, _sx, _sy, 1.0, 1.0, 0, c_white, 1.0);

    // If mop is not equipped by Jack, draw it resting in/beside the station
    if (!_has_mop && _spr_mop != -1) {
        var _mx = _cx - (sprite_get_width(_spr_mop) * 0.5) + sprite_get_xoffset(_spr_mop);
        var _my = _sy - 2;
        draw_sprite_ext(_spr_mop, 0, _mx, _my, 1.0, 1.0, 0, c_white, 1.0);
    }
} else {
    // 1. Industrial Yellow Janitor Mop Bucket (Procedural Fallback)
    // Shadow
    draw_set_alpha(0.3);
    draw_set_color(c_black);
    draw_ellipse(x + 1, y + 12, x + 15, y + 16, false);
    draw_set_alpha(1.0);

    // Wheels
    draw_set_color(make_color_rgb(40, 40, 45));
    draw_circle(x + 3, y + 13, 2, false);
    draw_circle(x + 13, y + 13, 2, false);

    // Bucket body (bright safety yellow)
    draw_set_color(make_color_rgb(245, 205, 25));
    draw_rectangle(x + 2, y + 5, x + 14, y + 12, false);
    draw_set_color(make_color_rgb(180, 150, 10));
    draw_rectangle(x + 2, y + 5, x + 14, y + 12, true);

    // Caution triangle on bucket
    draw_set_color(c_black);
    draw_triangle(x + 6, y + 11, x + 10, y + 11, x + 8, y + 7, false);

    // Wringer on top (gray metal press)
    draw_set_color(make_color_rgb(130, 140, 150));
    draw_rectangle(x + 9, y + 1, x + 14, y + 5, false);

    // 2. Mop leaning out of bucket (if not currently equipped by Jack!)
    if (!_has_mop) {
        // Wooden handle angled up-left
        draw_set_color(make_color_rgb(180, 130, 70));
        draw_line_width(x + 5, y + 7, x - 2, y - 8, 2);

        // Mop cotton head
        draw_set_color(make_color_rgb(220, 230, 240));
        draw_circle(x + 4, y + 6, 3, false);
    }
}

// 3. Interaction Prompt
if (near_player) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_font(fnt_dialogue);

    if (!_has_mop) {
        draw_set_color(c_yellow);
        draw_text_transformed(_cx, y - 6, "[E] EQUIP MOP", 0.40, 0.40, 0);
    } else {
        draw_set_color(c_white);
        draw_text_transformed(_cx, y - 6, "[E] RETURN MOP", 0.40, 0.40, 0);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fnt_default);
}
