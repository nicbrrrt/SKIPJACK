/// @description obj_caesar_key_pedestal — Draw Event
/// Renders the Caesar Key Vault pedestal and floating cipher key icon.

var _pulse = 0.5 + 0.5 * sin(anim_timer * 0.08);
var _bob   = sin(anim_timer * 0.1) * 2;

// Subtle vault floor aura around pedestal
draw_set_alpha(0.06 + _pulse * 0.05);
draw_set_color(collected ? c_lime : make_color_rgb(255, 200, 40));
draw_circle(x, y, 11, false);

// Pedestal base
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(35, 42, 58));
draw_rectangle(x - 7, y - 7, x + 7, y + 7, false);
draw_set_color(collected ? c_lime : make_color_rgb(255, 195, 30));
draw_rectangle(x - 7, y - 7, x + 7, y + 7, true);

if (!collected) {
    var _key_spr = sprite_exists(spr_dungeon_key) ? spr_dungeon_key : (sprite_exists(spr_key) ? spr_key : -1);
    if (_key_spr != -1) {
        // Floating cipher key sprite above pedestal
        var _kx = x - (sprite_get_width(_key_spr) * 0.5) + sprite_get_xoffset(_key_spr);
        var _ky = y - (sprite_get_height(_key_spr) * 0.5) + sprite_get_yoffset(_key_spr) - 4 + _bob;
        draw_sprite_ext(_key_spr, 0, _kx, _ky, 1.0, 1.0, 0, c_white, 1.0);
    } else {
        // Floating key icon at center (Procedural Fallback)
        var _ky = y - 3 + _bob;
        draw_set_color(make_color_rgb(255, 225, 65));
        draw_circle(x - 2, _ky, 3, true);
        draw_line_width(x + 1, _ky, x + 6, _ky, 2);
        draw_line(x + 4, _ky, x + 4, _ky + 3);
        draw_line(x + 6, _ky, x + 6, _ky + 3);
    }

    if (player_near && !ui_open) {
        draw_set_alpha(0.55);
        draw_set_color(make_color_rgb(10, 16, 26));
        draw_rectangle(x - 6, y - 19, x + 6, y - 11, false);
        draw_set_alpha(0.65);
        draw_set_color(make_color_rgb(255, 210, 50));
        draw_rectangle(x - 6, y - 19, x + 6, y - 11, true);
    }
} else {
    // Collected check glow
    draw_set_color(c_aqua);
    draw_circle(x, y, 3, false);
}

draw_set_color(c_white);
draw_set_alpha(1.0);
