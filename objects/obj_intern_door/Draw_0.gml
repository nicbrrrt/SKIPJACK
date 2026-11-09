/// @description obj_intern_door ?" Draw Event
var _cx = x + 8;
var _cy = y + 8;
var _x1 = x;
var _y1 = y;
var _x2 = _x1 + 15;
var _y2 = _y1 + 15;

// 1. Brushed steel threshold plate
draw_set_alpha(0.55);
draw_set_color(make_color_rgb(24, 34, 48));
draw_rectangle(_x1, _y1, _x2, _y2, false);
draw_set_alpha(0.45);
draw_set_color(make_color_rgb(65, 95, 130));
draw_rectangle(_x1, _y1, _x2, _y2, true);

// 2. Sliding Door Leaves (retract to edges as open_amt -> 1.0)
var _slide = round(open_amt * 7);
var _leaf_w = 7 - _slide;

if (_leaf_w > 0) {
    // Left & Right sliding steel door leaves
    draw_set_alpha(0.92);
    draw_set_color(make_color_rgb(30, 42, 60));
    draw_rectangle(_x1 + 1, _y1 + 1, _x1 + _leaf_w, _y2 - 1, false);
    draw_rectangle(_x2 - _leaf_w, _y1 + 1, _x2 - 1, _y2 - 1, false);

    // Door border frame
    draw_set_color(is_locked ? c_red : make_color_rgb(75, 165, 215));
    draw_rectangle(_x1, _y1, _x2, _y2, true);

    // Center lock LED indicator when closed
    if (_slide <= 2) {
        draw_set_color(is_locked ? c_red : c_yellow);
        draw_rectangle(_x1 + 6, _y1 + 6, _x1 + 9, _y1 + 9, false);
    }
} else {
    // Fully open doorway: glowing green side jambs
    draw_set_alpha(0.75);
    draw_set_color(c_lime);
    draw_rectangle(_x1, _y1 + 1, _x1 + 1, _y2 - 1, false);
    draw_rectangle(_x2 - 1, _y1 + 1, _x2, _y2 - 1, false);
}

// Interaction prompt when closed/locked and Jack is near
if ((is_closed || is_locked) && near_player) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_font(fnt_dialogue);
    draw_set_color(c_lime);
    draw_text_transformed(_cx, y - 4, "[E] OPEN DOOR", 0.40, 0.40, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fnt_default);
}

draw_set_alpha(1.0);
draw_set_color(c_white);
