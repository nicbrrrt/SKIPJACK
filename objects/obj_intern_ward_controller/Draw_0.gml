/// @description obj_intern_ward_controller — Draw Event
var _ox = 320;
var _oy = 240;

// -------------------------------------------------------------
// ROOM SIGNS & FLOOR MARKINGS
// -------------------------------------------------------------
draw_set_font(fnt_dialogue);
draw_set_alpha(0.65);
draw_set_halign(fa_center);

// Work Room sign on floor
draw_set_color(make_color_rgb(60, 140, 180));
draw_text_transformed(_ox + 8 * 16, _oy + 7 * 16 + 2, "[TERMINAL WORK BULLPEN]", 0.38, 0.38, 0);

// Storage Room sign on floor (centered in Storage Room cols 17..24)
draw_set_color(make_color_rgb(180, 140, 60));
draw_text_transformed(_ox + 20.5 * 16, _oy + 1 * 16 + 2, "[SUPPLY ARCHIVES & STORAGE]", 0.38, 0.38, 0);

// Wellness Green Room sign on floor (centered in Green Room cols 26..33)
draw_set_color(make_color_rgb(100, 220, 140));
draw_text_transformed(_ox + 29.5 * 16, _oy + 1 * 16 + 2, "[WELLNESS GREEN ROOM (4 SPOTS)]", 0.36, 0.36, 0);

// Glass Room sign on floor (centered in Observation Deck cols 35..40)
draw_set_color(c_aqua);
draw_text_transformed(_ox + 37.5 * 16, _oy + 9 * 16 + 2, "[PANORAMIC OBSERVATION DECK]", 0.38, 0.38, 0);

draw_set_halign(fa_left);
draw_set_font(fnt_default);
draw_set_alpha(1.0);
draw_set_color(c_white);
