/// @description obj_intern_door ?" Draw Event
var _cx = x + 8;
var _cy = y + 8;
var _x1 = x;
var _y1 = y;
var _x2 = _x1 + 15;
var _y2 = _y1 + 15;

var _spr_door = sprite_exists(spr_door_panel_intern) ? spr_door_panel_intern : (sprite_exists(spr_door_panel) ? spr_door_panel : -1);

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

if (_spr_door != -1) {
    if (_leaf_w > 0) {
        // Left & Right sliding door leaves using sprite without red tint or square overlay
        draw_sprite_part_ext(_spr_door, 0, 0, 0, _leaf_w, 16, _x1 + 1, _y1, 1.0, 1.0, c_white, 1.0);
        draw_sprite_part_ext(_spr_door, 0, 16 - _leaf_w, 0, _leaf_w, 16, _x2 - _leaf_w, _y1, 1.0, 1.0, c_white, 1.0);

        // Subtle center seam line when fully closed
        if (_slide <= 1) {
            draw_set_alpha(0.65);
            draw_set_color(make_color_rgb(40, 65, 90));
            draw_line(_x1 + 8, _y1 + 1, _x1 + 8, _y2 - 1);
        }
    } else {
        // Fully open doorway: glowing green side jambs
        draw_set_alpha(0.75);
        draw_set_color(c_lime);
        draw_rectangle(_x1, _y1 + 1, _x1 + 1, _y2 - 1, false);
        draw_rectangle(_x2 - 1, _y1 + 1, _x2, _y2 - 1, false);
    }
} else {
    // Procedural Fallback
    if (_leaf_w > 0) {
        // Left & Right sliding steel door leaves
        draw_set_alpha(0.92);
        draw_set_color(make_color_rgb(30, 42, 60));
        draw_rectangle(_x1 + 1, _y1 + 1, _x1 + _leaf_w, _y2 - 1, false);
        draw_rectangle(_x2 - _leaf_w, _y1 + 1, _x2 - 1, _y2 - 1, false);

        // Door border frame
        draw_set_color(make_color_rgb(75, 165, 215));
        draw_rectangle(_x1, _y1, _x2, _y2, true);

        // Center seam line when closed
        if (_slide <= 1) {
            draw_set_alpha(0.65);
            draw_set_color(make_color_rgb(40, 65, 90));
            draw_line(_x1 + 8, _y1 + 1, _x1 + 8, _y2 - 1);
        }
    } else {
        // Fully open doorway: glowing green side jambs
        draw_set_alpha(0.75);
        draw_set_color(c_lime);
        draw_rectangle(_x1, _y1 + 1, _x1 + 1, _y2 - 1, false);
        draw_rectangle(_x2 - 1, _y1 + 1, _x2, _y2 - 1, false);
    }
}

// Interaction prompt & progress bar when closed/locked and Jack is near
if ((is_closed || is_locked) && near_player) {
    var _bw = 36;
    var _bh = 4;
    var _bx1 = _cx - _bw * 0.5;
    var _by1 = y - 10;

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_font(fnt_dialogue);
    draw_set_color(c_yellow);
    draw_text_transformed(_cx, _by1 - 2, "SPAM [E] TO UNLOCK!", 0.38, 0.38, 0);

    // Progress bar for spam unlock
    draw_set_alpha(0.95);
    draw_set_color(c_black);
    draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, false);
    draw_set_color(merge_color(c_orange, c_lime, unlock_meter));
    draw_rectangle(_bx1, _by1, _bx1 + _bw * clamp(unlock_meter, 0, 1), _by1 + _bh, false);
    draw_set_color(c_white);
    draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, true);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fnt_default);
}

draw_set_alpha(1.0);
draw_set_color(c_white);
