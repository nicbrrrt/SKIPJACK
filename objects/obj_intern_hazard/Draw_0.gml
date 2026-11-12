/// @description obj_intern_hazard ?" Draw Event
var _cx = x + 8;
var _cy = y + 8;
var _by = y + 16;

// -----------------------------------------------------------------
// 1. HAZARD: SHELF
// -----------------------------------------------------------------
if (hazard_type == HAZARD_SHELF) {
    var _shelf_spr = (((x div 16) mod 2) == 0 && sprite_exists(spr_intern_shelf_1)) ? spr_intern_shelf_1 : spr_intern_shelf;
    if (!sprite_exists(_shelf_spr)) {
        _shelf_spr = sprite_exists(spr_intern_shelf) ? spr_intern_shelf : -1;
    }

    if (is_fallen) {
        if (_shelf_spr != -1) {
            // Tipped over storage shelf on floor
            var _ox = sprite_get_xoffset(_shelf_spr);
            var _oy = sprite_get_yoffset(_shelf_spr);
            var _pdx = 8 - _ox;
            var _pdy = 17 - _oy;
            var _dist = point_distance(0, 0, _pdx, _pdy);
            var _dir  = point_direction(0, 0, _pdx, _pdy);
            var _draw_x = _cx - lengthdir_x(_dist, _dir + 90);
            var _draw_y = (y + 8) - lengthdir_y(_dist, _dir + 90);

            // Floor contact shadow
            draw_set_alpha(0.35);
            draw_set_color(c_black);
            draw_ellipse(_cx - 16, y + 12, _cx + 16, y + 16, false);

            draw_set_alpha(1.0);
            draw_sprite_ext(_shelf_spr, 0, _draw_x, _draw_y, 1.0, 1.0, 90, c_white, 1.0);

            // Scattered scrap from fallen shelf
            if (sprite_exists(spr_terminal_scrap)) {
                draw_sprite_ext(spr_terminal_scrap, 0, x - 5, y + 5, 0.9, 0.9, 10, c_white, 1.0);
                draw_sprite_ext(spr_terminal_scrap, 0, x + 15, y + 6, 0.8, 0.8, -15, c_white, 0.95);
            } else {
                draw_sprite_ext(spr_box, 0, x - 4, y + 6, 0.45, 0.45, 15, c_white, 1.0);
                draw_sprite_ext(spr_box, 0, x + 16, y + 7, 0.40, 0.40, -25, c_white, 1.0);
            }
        } else {
            // Tipped over shelf on floor (Procedural Fallback)
            draw_set_alpha(0.85);
            draw_set_color(make_color_rgb(50, 55, 65));
            draw_rectangle(x - 6, y + 8, x + 22, y + 15, false);
            draw_set_color(c_dkgray);
            draw_rectangle(x - 6, y + 8, x + 22, y + 15, true);

            // Scattered scrap
            if (sprite_exists(spr_terminal_scrap)) {
                draw_sprite_ext(spr_terminal_scrap, 0, x - 4, y + 5, 0.9, 0.9, 10, c_white, 1.0);
                draw_sprite_ext(spr_terminal_scrap, 0, x + 13, y + 6, 0.8, 0.8, -15, c_white, 0.95);
            } else {
                draw_sprite_ext(spr_box, 0, x - 2, y + 6, 0.45, 0.45, 15, c_white, 1.0);
                draw_sprite_ext(spr_box, 0, x + 14, y + 7, 0.40, 0.40, -25, c_white, 1.0);
            }
        }

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
        if (_shelf_spr != -1) {
            // Standing shelf grounded at y + 16, wobbles around bottom center (_cx, _by)
            var _ox = sprite_get_xoffset(_shelf_spr);
            var _oy = sprite_get_yoffset(_shelf_spr);
            var _pdx = 8 - _ox;
            var _pdy = 34 - _oy;
            var _dist = point_distance(0, 0, _pdx, _pdy);
            var _dir  = point_direction(0, 0, _pdx, _pdy);
            var _draw_x = _cx - lengthdir_x(_dist, _dir + wobble_angle);
            var _draw_y = _by - lengthdir_y(_dist, _dir + wobble_angle);

            // Ground shadow
            draw_set_alpha(0.35);
            draw_set_color(c_black);
            draw_ellipse(_cx - 8, y + 13, _cx + 8, y + 16, false);

            draw_set_alpha(1.0);
            draw_sprite_ext(_shelf_spr, 0, _draw_x, _draw_y, 1.0, 1.0, wobble_angle, c_white, 1.0);
        } else {
            // Standing shelf (wobbles around bottom center _by) (Procedural Fallback)
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
        }

        if (is_wobbling) {
            // Telegraph exclamation & steady prompt
            var _bob = sin(current_time / 80) * 2;
            draw_sprite_ext(spr_exclamation, 0, _cx, y - 24 + _bob, 0.5, 0.5, 0, c_white, 1.0);

            if (is_interact_target) {
                var _bw = 32;
                var _bh = 4;
                var _bx1 = _cx - _bw * 0.5;
                var _by1 = y - 30;
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
    var _use_locker_sprite = sprite_exists(spr_dungeon_locker_hidden) || sprite_exists(spr_dungeon_locker);

    if (_use_locker_sprite) {
        // Drop shadow under locker base
        draw_set_alpha(0.35);
        draw_set_color(c_black);
        draw_ellipse(_cx - 8, y + 12, _cx + 8, y + 16, false);

        // Auto-detect wall orientation or use locker_variant:
        var _variant = variable_instance_exists(id, "locker_variant") ? locker_variant : 0;
        if (_variant == 0) {
            var _has_north = position_meeting(x + 8, y - 8, obj_dungeon_wall);
            var _has_other = position_meeting(x + 8, y + 24, obj_dungeon_wall) || position_meeting(x - 8, y + 8, obj_dungeon_wall) || position_meeting(x + 24, y + 8, obj_dungeon_wall);
            if (!_has_north && _has_other) {
                _variant = 1;
            }
        }

        // Sprite selection:
        // - Variant 1 (East, West, or South wall): spr_dungeon_locker_1
        // - Variant 0 (North wall): spr_dungeon_locker (empty) / spr_dungeon_locker_hidden (trapped intern)
        var _spr = is_trapped ? spr_dungeon_locker_hidden : spr_dungeon_locker;
        if (_variant == 1 && sprite_exists(spr_dungeon_locker_1)) {
            _spr = spr_dungeon_locker_1;
        } else if (!sprite_exists(_spr)) {
            _spr = sprite_exists(spr_dungeon_locker) ? spr_dungeon_locker : spr_dungeon_locker_hidden;
        }

        var _draw_x = _cx - (sprite_get_width(_spr) * 0.5) + sprite_get_xoffset(_spr) + _lx_off;
        var _draw_y = (y + 16) - sprite_get_height(_spr) + sprite_get_yoffset(_spr);

        draw_set_alpha(1.0);
        draw_sprite_ext(_spr, 0, _draw_x, _draw_y, 1.0, 1.0, 0, c_white, 1.0);
    } else {
        // Draw Blue Corporate Hallway Locker (Procedural Fallback)
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
    }

    if (is_wobbling) {
        var _bob = sin(current_time / 80) * 2;
        draw_sprite_ext(spr_exclamation, 0, _cx, y - 26 + _bob, 0.5, 0.5, 0, c_white, 1.0);
        if (is_interact_target) {
            var _bw = 32;
            var _bh = 4;
            var _bx1 = _cx - _bw * 0.5;
            var _by1 = y - 32;
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
        var _by1 = y - 26;
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
    var _use_cooler_sprite = sprite_exists(spr_water_cooler);

    if (is_fallen) {
        if (_use_cooler_sprite) {
            // Tipped over water cooler sprite resting horizontally on the floor
            var _ox = sprite_get_xoffset(spr_water_cooler);
            var _oy = sprite_get_yoffset(spr_water_cooler);
            var _pdx = 8 - _ox;
            var _pdy = 16 - _oy;
            var _dist = point_distance(0, 0, _pdx, _pdy);
            var _dir  = point_direction(0, 0, _pdx, _pdy);
            var _draw_x = _cx - lengthdir_x(_dist, _dir + 90);
            var _draw_y = (y + 8) - lengthdir_y(_dist, _dir + 90);

            // Subtle floor contact shadow
            draw_set_alpha(0.35);
            draw_set_color(c_black);
            draw_ellipse(_cx - 16, y + 12, _cx + 16, y + 16, false);

            draw_set_alpha(1.0);
            draw_sprite_ext(spr_water_cooler, 0, _draw_x, _draw_y, 1.0, 1.0, 90, c_white, 1.0);
        } else {
            // Fallen water cooler on its side (Procedural Fallback)
            draw_set_alpha(0.9);
            draw_set_color(make_color_rgb(220, 225, 235));
            draw_rectangle(x + 2, y + 10, x + 14, y + 15, false);
            draw_set_color(make_color_rgb(140, 150, 165));
            draw_rectangle(x + 2, y + 10, x + 14, y + 15, true);

            // Plastic jug lying cracked on its side
            draw_set_color(make_color_rgb(40, 140, 240));
            draw_ellipse(x - 5, y + 9, x + 3, y + 15, false);
            draw_set_color(c_aqua);
            draw_ellipse(x - 4, y + 10, x + 2, y + 14, true);
        }

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
        if (_use_cooler_sprite) {
            // Standing water cooler grounded at y + 16, wobbling around bottom center (_cx, _by)
            var _ox = sprite_get_xoffset(spr_water_cooler);
            var _oy = sprite_get_yoffset(spr_water_cooler);
            var _pdx = 8 - _ox;
            var _pdy = 32 - _oy;
            var _dist = point_distance(0, 0, _pdx, _pdy);
            var _dir  = point_direction(0, 0, _pdx, _pdy);
            var _draw_x = _cx - lengthdir_x(_dist, _dir + wobble_angle);
            var _draw_y = _by - lengthdir_y(_dist, _dir + wobble_angle);

            // Ground shadow
            draw_set_alpha(0.35);
            draw_set_color(c_black);
            draw_ellipse(_cx - 8, y + 13, _cx + 8, y + 16, false);

            draw_set_alpha(1.0);
            draw_sprite_ext(spr_water_cooler, 0, _draw_x, _draw_y, 1.0, 1.0, wobble_angle, c_white, 1.0);
        } else {
            // Procedural Fallback
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
        }

        if (is_wobbling) {
            var _bob = sin(current_time / 80) * 2;
            draw_sprite_ext(spr_exclamation, 0, _cx, y - 22 + _bob, 0.5, 0.5, 0, c_white, 1.0);
            if (is_interact_target) {
                var _bw = 32;
                var _bh = 4;
                var _bx1 = _cx - _bw * 0.5;
                var _by1 = y - 28;
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
