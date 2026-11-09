/// @description obj_intern_ward_controller ?" Draw Event
var _ox = 320;
var _oy = 240;

// -------------------------------------------------------------
// 1. DISTANT SKYSCRAPER SKYLINE (Beyond the Panoramic Glass Room)
// -------------------------------------------------------------
var _sky_x1 = _ox + 30 * 16;
var _sky_y1 = _oy - 4 * 16;
var _sky_x2 = _ox + 48 * 16;
var _sky_y2 = _oy + 6 * 16 - 1;

// Twilight gradient
draw_rectangle_color(_sky_x1, _sky_y1, _sky_x2, _sky_y2,
    make_color_rgb(14, 20, 36), make_color_rgb(14, 20, 36),
    make_color_rgb(35, 55, 95), make_color_rgb(35, 55, 95), false);

// Distant corporate towers
draw_set_color(make_color_rgb(18, 25, 42));
draw_rectangle(_sky_x1 + 10, _sky_y1 + 14, _sky_x1 + 45, _sky_y2, false);
draw_rectangle(_sky_x1 + 60, _sky_y1 + 4,  _sky_x1 + 110, _sky_y2, false);
draw_rectangle(_sky_x1 + 130, _sky_y1 + 22, _sky_x1 + 180, _sky_y2, false);

// Tower window lights
draw_set_color(make_color_rgb(255, 220, 120));
for (var _wx = _sky_x1 + 66; _wx < _sky_x1 + 105; _wx += 8) {
    for (var _wy = _sky_y1 + 10; _wy < _sky_y2 - 8; _wy += 10) {
        if ((_wx + _wy) mod 3 != 0) {
            draw_rectangle(_wx, _wy, _wx + 3, _wy + 4, false);
        }
    }
}

// -------------------------------------------------------------
// 2. ROOM SIGNS & FLOOR MARKINGS
// -------------------------------------------------------------
draw_set_font(fnt_dialogue);
draw_set_alpha(0.65);
draw_set_halign(fa_center);

// Work Room sign on floor
draw_set_color(make_color_rgb(60, 140, 180));
draw_text_transformed(_ox + 8 * 16, _oy + 7 * 16 + 2, "[TERMINAL WORK BULLPEN]", 0.38, 0.38, 0);

// Storage Room sign on floor
draw_set_color(make_color_rgb(180, 140, 60));
draw_text_transformed(_ox + 24 * 16, _oy + 1 * 16 + 2, "[SUPPLY ARCHIVES & STORAGE]", 0.38, 0.38, 0);

// Glass Room sign on floor
draw_set_color(c_aqua);
draw_text_transformed(_ox + 37 * 16, _oy + 7 * 16 + 2, "[PANORAMIC OBSERVATION DECK]", 0.38, 0.38, 0);

draw_set_halign(fa_left);
draw_set_font(fnt_default);
draw_set_alpha(1.0);
draw_set_color(c_white);
