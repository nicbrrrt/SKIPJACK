/// @description obj_intern_hazard ?" Draw Event
var _cx = x + 8;
var _cy = y + 8;
var _by = y + 16;

// -----------------------------------------------------------------
// 1. HAZARD: SHELF
// -----------------------------------------------------------------
if (hazard_type == HAZARD_SHELF) {
    if (is_fallen) {
        // Tipped over shelf on floor
        draw_set_alpha(0.85);
        draw_set_color(make_color_rgb(50, 55, 65));
        draw_rectangle(x - 6, y + 8, x + 22, y + 15, false);
        draw_set_color(c_dkgray);
        draw_rectangle(x - 6, y + 8, x + 22, y + 15, true);

        // Scattered boxes
        draw_sprite_ext(spr_box, 0, x - 2, y + 6, 0.45, 0.45, 15, c_white, 1.0);
        draw_sprite_ext(spr_box, 0, x + 14, y + 7, 0.40, 0.40, -25, c_white, 1.0);

        if (is_interact_target) {
            var _bw = 32;
            var _bh = 4;
            var _bx1 = _cx - _bw * 0.5;
            var _by1 = y - 10;
            draw_set_halign(fa_center);
            draw_set_valign(fa_bottom);
            draw_set_font(fnt_dialogue);
            draw_set_color(c_yellow);
            draw_text_transformed(_cx, _by1 - 2, "SPAM [E] TO LIFT!", 0.38, 0.38, 0);

            draw_set_alpha(0.95);
            draw_set_color(c_black);
            draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, false);
            draw_set_color(merge_color(c_orange, c_lime, struggle_meter));
            draw_rectangle(_bx1, _by1, _bx1 + _bw * clamp(struggle_meter, 0, 1), _by1 + _bh, false);
            draw_set_color(c_white);
            draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, true);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_set_font(fnt_default);
        }
    } else {
        // Standing shelf (wobbles around bottom center _by)
        var _rad = degtorad(wobble_angle);
        var _cos = cos(_rad);
        var _sin = sin(_rad);

        // Draw metal frame
        draw_set_alpha(0.95);
        draw_set_color(make_color_rgb(45, 50, 60));
        draw_rectangle(x + 1, y - 6, x + 15, y + 15, false);
        draw_set_color(make_color_rgb(90, 100, 120));
        draw_rectangle(x + 1, y - 6, x + 15, y + 15, true);

        // Shelves and boxes
        draw_set_color(make_color_rgb(110, 120, 140));
        draw_line(x + 1, y, x + 15, y);
        draw_line(x + 1, y + 7, x + 15, y + 7);
        draw_sprite_ext(spr_box, 0, _cx, y - 2, 0.35, 0.35, wobble_angle, c_white, 1.0);
        draw_sprite_ext(spr_box, 0, _cx, y + 5, 0.35, 0.35, wobble_angle, c_white, 1.0);

        if (is_wobbling) {
            // Telegraph exclamation & steady prompt
            var _bob = sin(current_time / 80) * 2;
            draw_sprite_ext(spr_exclamation, 0, _cx, y - 16 + _bob, 0.5, 0.5, 0, c_white, 1.0);

            if (is_interact_target) {
                var _bw = 32;
                var _bh = 4;
                var _bx1 = _cx - _bw * 0.5;
                var _by1 = y - 24;
                draw_set_halign(fa_center);
                draw_set_valign(fa_bottom);
                draw_set_font(fnt_dialogue);
                draw_set_color(c_yellow);
                draw_text_transformed(_cx, _by1 - 2, "SPAM [E] STEADY!", 0.38, 0.38, 0);

                draw_set_alpha(0.95);
                draw_set_color(c_black);
                draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, false);
                draw_set_color(merge_color(c_orange, c_lime, wobble_fix_meter));
                draw_rectangle(_bx1, _by1, _bx1 + _bw * clamp(wobble_fix_meter, 0, 1), _by1 + _bh, false);
                draw_set_color(c_white);
                draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, true);
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
                draw_set_font(fnt_default);
            }
        }
    }
}
// -----------------------------------------------------------------
// 2. HAZARD: LOCKER
// -----------------------------------------------------------------
else if (hazard_type == HAZARD_LOCKER) {
    var _lx_off = (is_wobbling || is_trapped) ? irandom_range(-1, 1) : 0;

    // Draw Blue Corporate Hallway Locker
    draw_set_alpha(0.95);
    draw_set_color(make_color_rgb(32, 64, 110));
    draw_rectangle(x + 1 + _lx_off, y - 10, x + 15 + _lx_off, y + 15, false);
    draw_set_color(make_color_rgb(70, 130, 210));
    draw_rectangle(x + 1 + _lx_off, y - 10, x + 15 + _lx_off, y + 15, true);

    // Vent slits and handle
    draw_set_color(c_black);
    draw_line(x + 4 + _lx_off, y - 6, x + 12 + _lx_off, y - 6);
    draw_line(x + 4 + _lx_off, y - 3, x + 12 + _lx_off, y - 3);
    draw_set_color(c_yellow);
    draw_circle(x + 12 + _lx_off, y + 4, 1.5, false);

    if (is_wobbling) {
        var _bob = sin(current_time / 80) * 2;
        draw_sprite_ext(spr_exclamation, 0, _cx, y - 20 + _bob, 0.5, 0.5, 0, c_white, 1.0);
        if (is_interact_target) {
            var _bw = 32;
            var _bh = 4;
            var _bx1 = _cx - _bw * 0.5;
            var _by1 = y - 26;
            draw_set_halign(fa_center);
            draw_set_valign(fa_bottom);
            draw_set_font(fnt_dialogue);
            draw_set_color(c_yellow);
            draw_text_transformed(_cx, _by1 - 2, "SPAM [E] FIX LOCKER!", 0.38, 0.38, 0);

            draw_set_alpha(0.95);
            draw_set_color(c_black);
            draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, false);
            draw_set_color(merge_color(c_orange, c_lime, wobble_fix_meter));
            draw_rectangle(_bx1, _by1, _bx1 + _bw * clamp(wobble_fix_meter, 0, 1), _by1 + _bh, false);
            draw_set_color(c_white);
            draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, true);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_set_font(fnt_default);
        }
    }
    else if (is_trapped) {
        // Trapped intern struggle bar & prompt!
        var _bw = 36;
        var _bh = 5;
        var _bx1 = _cx - _bw * 0.5;
        var _by1 = y - 22;
        var _fill = clamp(struggle_meter, 0, 1);

        draw_set_alpha(0.95);
        draw_set_color(c_black);
        draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, false);
        draw_set_color(merge_color(c_red, c_lime, _fill));
        draw_rectangle(_bx1, _by1, _bx1 + _bw * _fill, _by1 + _bh, false);
        draw_set_color(c_white);
        draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, true);

        if (is_interact_target) {
            draw_set_halign(fa_center);
            draw_set_font(fnt_dialogue);
            draw_set_color(c_yellow);
            draw_text_transformed(_cx, _by1 - 8, "SPAM [E] PRY OPEN!", 0.38, 0.38, 0);
            draw_set_halign(fa_left);
            draw_set_font(fnt_default);
        }
    }
}
// -----------------------------------------------------------------
// 3. HAZARD: WATER DISPENSER
// -----------------------------------------------------------------
else if (hazard_type == HAZARD_WATER) {
    if (is_fallen) {
        // Fallen water cooler + puddle
        draw_set_alpha(0.45);
        draw_set_color(c_aqua);
        draw_ellipse(x - 8, y + 6, x + 24, y + 16, false);
        draw_set_alpha(0.9);
        draw_set_color(c_white);
        draw_rectangle(x + 2, y + 10, x + 14, y + 15, false);

        if (is_interact_target) {
            var _bw = 32;
            var _bh = 4;
            var _bx1 = _cx - _bw * 0.5;
            var _by1 = y - 10;
            draw_set_halign(fa_center);
            draw_set_valign(fa_bottom);
            draw_set_font(fnt_dialogue);
            draw_set_color(c_yellow);
            draw_text_transformed(_cx, _by1 - 2, "SPAM [E] RIGHT COOLER!", 0.38, 0.38, 0);

            draw_set_alpha(0.95);
            draw_set_color(c_black);
            draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, false);
            draw_set_color(merge_color(c_orange, c_lime, struggle_meter));
            draw_rectangle(_bx1, _by1, _bx1 + _bw * clamp(struggle_meter, 0, 1), _by1 + _bh, false);
            draw_set_color(c_white);
            draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, true);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_set_font(fnt_default);
        }
    } else {
        var _rad = degtorad(wobble_angle);
        draw_set_alpha(0.95);
        draw_set_color(make_color_rgb(220, 225, 235));
        draw_rectangle(x + 3, y + 3, x + 13, y + 15, false);
        draw_set_color(make_color_rgb(140, 150, 165));
        draw_rectangle(x + 3, y + 3, x + 13, y + 15, true);

        // Blue water jug on top
        draw_set_color(make_color_rgb(40, 140, 240));
        draw_ellipse(x + 4, y - 7, x + 12, y + 3, false);
        draw_set_color(c_aqua);
        draw_ellipse(x + 5, y - 6, x + 11, y + 2, true);

        if (is_wobbling) {
            var _bob = sin(current_time / 80) * 2;
            draw_sprite_ext(spr_exclamation, 0, _cx, y - 16 + _bob, 0.5, 0.5, 0, c_white, 1.0);
            if (is_interact_target) {
                var _bw = 32;
                var _bh = 4;
                var _bx1 = _cx - _bw * 0.5;
                var _by1 = y - 24;
                draw_set_halign(fa_center);
                draw_set_valign(fa_bottom);
                draw_set_font(fnt_dialogue);
                draw_set_color(c_yellow);
                draw_text_transformed(_cx, _by1 - 2, "SPAM [E] STEADY!", 0.38, 0.38, 0);

                draw_set_alpha(0.95);
                draw_set_color(c_black);
                draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, false);
                draw_set_color(merge_color(c_orange, c_lime, wobble_fix_meter));
                draw_rectangle(_bx1, _by1, _bx1 + _bw * clamp(wobble_fix_meter, 0, 1), _by1 + _bh, false);
                draw_set_color(c_white);
                draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, true);
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
                draw_set_font(fnt_default);
            }
        }
    }
}

draw_set_alpha(1.0);
draw_set_color(c_white);
