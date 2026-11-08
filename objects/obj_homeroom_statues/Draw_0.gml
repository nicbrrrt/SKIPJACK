/// @description obj_homeroom_statues — Draw Event
/// Draws the Wall Telephone and the 3-Pedestal Display Table with the equipped statues.

var _cat = scr_get_statue_catalog();

// ---------------------------------------------------------------------------
// WALL TELEPHONE
// ---------------------------------------------------------------------------
var _px = phone_x;
var _py = phone_y;

// Does Jack have something waiting? (blink green when an order is in progress or a delivered statue is unplaced)
var _pending = false;
var _unplaced = false;
for (var _i = 0; _i < STATUE_COUNT; _i++) {
    if (global.statues_pending[_i]) _pending = true;
    if (global.statues_owned[_i] && !scr_has_active_statue(_i)) _unplaced = true;
}

draw_set_alpha(1.0);
draw_set_color(make_color_rgb(60, 42, 30));
draw_rectangle(_px - 7, _py - 10, _px + 7, _py + 8, false);
draw_set_color(make_color_rgb(226, 214, 190));
draw_rectangle(_px - 6, _py - 9, _px + 6, _py + 7, false);
draw_set_color(make_color_rgb(40, 30, 24));
draw_rectangle(_px - 6, _py - 9, _px + 6, _py + 7, true);
// Dial pad dots
draw_set_color(make_color_rgb(70, 55, 45));
for (var _r = 0; _r < 3; _r++) {
    for (var _c = 0; _c < 3; _c++) {
        draw_point(_px - 3 + _c * 3, _py + _r * 3);
    }
}
// Handset (left side) + curly cord
draw_set_color(make_color_rgb(35, 28, 28));
draw_rectangle(_px - 10, _py - 8, _px - 7, _py + 2, false);
draw_line(_px - 9, _py + 2, _px - 9, _py + 6);
draw_line(_px - 9, _py + 6, _px - 5, _py + 8);
// Message LED
var _led = make_color_rgb(110, 60, 55);
if (_pending)  _led = (current_time mod 900 < 450) ? c_lime : make_color_rgb(40, 110, 50);
if (_unplaced) _led = (current_time mod 600 < 300) ? c_yellow : make_color_rgb(110, 95, 30);
draw_set_color(_led);
draw_circle(_px + 3, _py - 6, 1.5, false);

// ---------------------------------------------------------------------------
// 3-PEDESTAL DISPLAY TABLE
// ---------------------------------------------------------------------------
var _tx = table_cx;
var _ty = table_base_y;

// Table legs, top surface & front face
draw_set_color(make_color_rgb(70, 46, 28));
draw_rectangle(_tx - 46, _ty + 2, _tx - 42, _ty + 12, false);
draw_rectangle(_tx + 42, _ty + 2, _tx + 46, _ty + 12, false);
draw_set_color(make_color_rgb(150, 104, 62));
draw_rectangle(_tx - 48, _ty - 12, _tx + 48, _ty + 2, false);
draw_set_color(make_color_rgb(104, 70, 42));
draw_rectangle(_tx - 48, _ty + 2, _tx + 48, _ty + 8, false);
draw_set_color(make_color_rgb(60, 40, 26));
draw_rectangle(_tx - 48, _ty - 12, _tx + 48, _ty + 8, true);

for (var _s = 0; _s < 3; _s++) {
    var _sx  = _tx + (_s - 1) * 30;
    var _sid = global.equipped_statues[_s];
    if (_sid >= 0 && global.statues_owned[_sid]) {
        // Soft aura so active statues read as "powered"
        var _pulse = 0.5 + 0.5 * sin(current_time / 300 + _s);
        draw_set_alpha(0.10 + 0.07 * _pulse);
        draw_set_color(_cat[_sid].col);
        draw_circle(_sx, _ty - 16, 15, false);
        draw_set_alpha(1.0);
        scr_draw_statue_sprite(_sid, _sx, _ty - 3, 0.8);
    } else {
        // Empty brass plinth
        draw_set_color(make_color_rgb(88, 62, 40));
        draw_rectangle(_sx - 8, _ty - 8, _sx + 8, _ty - 3, false);
        draw_set_color(make_color_rgb(214, 168, 70));
        draw_rectangle(_sx - 8, _ty - 8, _sx + 8, _ty - 7, false);
    }
}

draw_set_alpha(1.0);
draw_set_color(c_white);
