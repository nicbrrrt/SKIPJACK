/// @description obj_caesar_key_pedestal — Draw Event
/// Renders the Caesar Key Vault pedestal and floating cipher key icon.

var _pulse = 0.5 + 0.5 * sin(anim_timer * 0.08);
var _bob   = sin(anim_timer * 0.1) * 2;

// Vault floor aura around pedestal
draw_set_alpha(0.25 + _pulse * 0.15);
draw_set_color(collected ? c_lime : make_color_rgb(255, 200, 40));
draw_circle(x, y, 14, false);

// Pedestal base
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(35, 42, 58));
draw_rectangle(x - 7, y - 7, x + 7, y + 7, false);
draw_set_color(collected ? c_lime : make_color_rgb(255, 195, 30));
draw_rectangle(x - 7, y - 7, x + 7, y + 7, true);

if (!collected) {
    // Floating key icon at center
    var _ky = y - 3 + _bob;
    draw_set_color(make_color_rgb(255, 225, 65));
    draw_circle(x - 2, _ky, 3, true);
    draw_line_width(x + 1, _ky, x + 6, _ky, 2);
    draw_line(x + 4, _ky, x + 4, _ky + 3);
    draw_line(x + 6, _ky, x + 6, _ky + 3);
} else {
    // Collected check glow
    draw_set_color(c_aqua);
    draw_circle(x, y, 3, false);
}

draw_set_color(c_white);
draw_set_alpha(1.0);
