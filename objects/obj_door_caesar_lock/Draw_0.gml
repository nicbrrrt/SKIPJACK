/// @description obj_door_caesar_lock — Draw Event
/// Renders a cipher-encrypted or lockdown-sealed barrier tile.

var _x1 = draw_x;
var _y1 = draw_y;
var _x2 = _x1 + 15;
var _y2 = _y1 + 15;

if (locked) {
    var _pulse = 0.5 + 0.5 * sin(anim_t * 0.12);

    var _overridden = (variable_global_exists("lockdown_overridden") && global.lockdown_overridden);
    var _powered    = (variable_global_exists("power_restored")      && global.power_restored);
    var _elev_gated = (is_elevator_door && (!_overridden || !_powered));

    // Gate background fill
    draw_set_alpha(0.92);
    if (is_breaker_door) {
        draw_set_color(make_color_rgb(16, 32, 46));
    } else if (_elev_gated) {
        draw_set_color(make_color_rgb(32, 22, 18));
    } else {
        draw_set_color(make_color_rgb(55, 12, 32));
    }
    draw_rectangle(_x1, _y1, _x2, _y2, false);

    // Glowing laser bars
    draw_set_alpha(0.85 + _pulse * 0.15);
    if (is_breaker_door) {
        draw_set_color(make_color_rgb(65, 200, 255));
    } else if (_elev_gated) {
        draw_set_color(make_color_rgb(255, 130, 40));
    } else {
        draw_set_color(make_color_rgb(255, 65, 125));
    }
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    draw_line(_x1 + 2, _y1 + 5, _x2 - 2, _y1 + 10);
    draw_line(_x1 + 2, _y1 + 10, _x2 - 2, _y1 + 5);

    // Center lock node
    if (is_breaker_door) {
        draw_set_color((unseal_anim_t > 0 && (unseal_anim_t mod 4 < 2)) ? c_lime : make_color_rgb(255, 80, 95));
    } else if (_elev_gated) {
        draw_set_color(make_color_rgb(255, 200, 90));
    } else {
        draw_set_color(make_color_rgb(255, 160, 210));
    }
    draw_rectangle(_x1 + 6, _y1 + 5, _x1 + 9, _y1 + 10, false);
} else {
    // Unlocked threshold indicator (plus expanding green ring when Breaker Room unseals on camera!)
    draw_set_alpha(0.35);
    draw_set_color(is_breaker_door ? c_lime : c_aqua);
    draw_rectangle(_x1 + 1, _y1 + 1, _x2 - 1, _y2 - 1, true);

    if (unseal_flash > 0) {
        var _uf = unseal_flash / 90;
        var _ur = (1 - _uf) * 22 + 4;
        draw_set_alpha(_uf * 0.85);
        draw_set_color(c_lime);
        draw_circle(_x1 + 8, _y1 + 8, _ur, true);
    }
}

draw_set_color(c_white);
draw_set_alpha(1.0);
