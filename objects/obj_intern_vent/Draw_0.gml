/// @description obj_intern_vent — Draw Event
var _cx = x + 8;
var _cy = y + 8;

// 1. Draw Metallic Wall Ventilation Grille Casing
draw_set_alpha(0.95);
draw_set_color(make_color_rgb(32, 40, 52));
draw_rectangle(x, y, x + 15, y + 15, false);
draw_set_color(make_color_rgb(85, 105, 130));
draw_rectangle(x, y, x + 15, y + 15, true);

// Inner ventilation shaft cavity
draw_set_color(make_color_rgb(12, 16, 24));
draw_rectangle(x + 2, y + 2, x + 13, y + 13, false);

if (!is_clogged) {
    if (vent_hp > 0 && !is_down) {
        // Rotating ventilation fan blades behind louvers
        var _rad = degtorad(fan_rot);
        var _c = cos(_rad) * 4;
        var _s = sin(_rad) * 4;
        draw_set_color(make_color_rgb(50, 75, 95));
        draw_line(_cx - _c, _cy - _s, _cx + _c, _cy + _s);
        draw_line(_cx + _s, _cy - _c, _cx - _s, _cy + _c);

        // Intake horizontal louvers
        draw_set_color(make_color_rgb(70, 90, 110));
        draw_line(x + 2, y + 4,  x + 13, y + 4);
        draw_line(x + 2, y + 7,  x + 13, y + 7);
        draw_line(x + 2, y + 10, x + 13, y + 10);

        // Operational status LED (Green when 100%, Yellow when damaged)
        var _led_c = (vent_hp >= 80) ? make_color_rgb(0, 230, 115) : make_color_rgb(255, 200, 30);
        draw_set_color(_led_c);
        draw_circle(x + 13, y + 2, 1, false);

        // Gentle breezy airflow drift lines blowing into the room
        draw_set_alpha(0.35);
        draw_set_color(make_color_rgb(120, 230, 255));
        var _blow_dir = (room_assigned == ROOM_INTERN_GLASS) ? -1 : 1;
        var _wave = sin(current_time / 150) * 3;
        var _b_offset = (breeze_timer mod 36);
        draw_line(_cx - 3 + _wave, _cy + _blow_dir * _b_offset, _cx + 3 + _wave, _cy + _blow_dir * (_b_offset + 5));
        draw_set_alpha(1.0);
    } else {
        // BROKEN / OFFLINE VENT: Jammed louvers, dark casing, smoke & sparks
        draw_set_color(make_color_rgb(20, 20, 25));
        draw_rectangle(x + 2, y + 2, x + 13, y + 13, false);
        draw_set_color(make_color_rgb(60, 30, 30));
        draw_line(x + 2, y + 5,  x + 13, y + 5);
        draw_line(x + 2, y + 9,  x + 13, y + 9);

        // Red flashing alarm beacon LED
        var _alarm_col = (current_time mod 200 < 100) ? c_red : c_black;
        draw_set_color(_alarm_col);
        draw_circle(x + 13, y + 2, 1.5, false);

        // Smoke puff drift
        draw_set_alpha(0.45);
        draw_set_color(make_color_rgb(70, 70, 80));
        var _smoke_y = (room_assigned == ROOM_INTERN_GLASS) ? (y - (current_time mod 24) * 0.5) : (y + 12 + (current_time mod 24) * 0.5);
        var _smoke_wobble = sin(current_time / 100) * 2;
        draw_circle(_cx + _smoke_wobble, _smoke_y, 3, false);
        draw_set_alpha(1.0);
    }

    // -------------------------------------------------------------
    // DAMAGED OR BROKEN VENT HUD PROMPTS
    // -------------------------------------------------------------
    if (vent_hp < 100) {
        var _bob = sin(current_time / 80) * 2;
        var _tag_y = (room_assigned == ROOM_INTERN_GLASS) ? (y - 24 + _bob) : (y - 14 + _bob);

        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        var _tag_txt = is_down ? "! VENT OFFLINE !" : "! DAMAGED (" + string(round(vent_hp)) + "%) !";
        var _tag_col = is_down ? ((current_time mod 200 < 100) ? c_red : c_yellow) : c_orange;

        draw_set_alpha(0.85);
        draw_set_color(make_color_rgb(14, 18, 28));
        draw_rectangle(_cx - 36, _tag_y - 5, _cx + 36, _tag_y + 5, false);
        draw_set_color(_tag_col);
        draw_rectangle(_cx - 36, _tag_y - 5, _cx + 36, _tag_y + 5, true);
        draw_set_alpha(1.0);
        draw_text_transformed(_cx, _tag_y, _tag_txt, 0.35, 0.35, 0);

        // Player prompt when nearby
        if (is_interact_target) {
            var _prompt_y = (room_assigned == ROOM_INTERN_GLASS) ? (y + 14) : (y + 28);
            var _has_wrench = (variable_global_exists("player_has_wrench") && global.player_has_wrench);

            if (_has_wrench) {
                draw_set_color(c_yellow);
                draw_text_transformed(_cx, _prompt_y, "HOLD [E] REPAIR WITH WRENCH", 0.38, 0.38, 0);

                // Repair progress bar
                var _pw = 36;
                var _ph = 4;
                var _px = _cx - _pw * 0.5;
                var _py = _prompt_y + 6;
                draw_set_color(c_black);
                draw_rectangle(_px - 1, _py - 1, _px + _pw + 1, _py + _ph + 1, false);
                draw_set_color(merge_color(c_red, c_lime, vent_hp / 100.0));
                draw_rectangle(_px, _py, _px + _pw * clamp(vent_hp / 100.0, 0, 1), _py + _ph, false);
                draw_set_color(c_white);
                draw_rectangle(_px - 1, _py - 1, _px + _pw + 1, _py + _ph + 1, true);
            } else {
                draw_set_color(c_orange);
                draw_text_transformed(_cx, _prompt_y, "[WRENCH REQUIRED - STORAGE]", 0.36, 0.36, 0);
            }
        }
    }
} else {
    // -------------------------------------------------------------
    // CLOGGED VENT: Intern crawled in and got stuck!
    // Frantic kicking legs sticking out into the room!
    // -------------------------------------------------------------
    // Red blinking alarm beacon LED
    var _led_col = (current_time mod 200 < 100) ? c_red : c_white;
    draw_set_color(_led_col);
    draw_circle(x + 13, y + 2, 1.5, false);

    // Determine intern variant sprite
    var _var = 1;
    if (instance_exists(stuck_intern) && variable_instance_exists(stuck_intern, "intern_variant")) {
        _var = stuck_intern.intern_variant;
    }
    var _spr = intern1;
    switch (_var) {
        case 1: _spr = intern1; break;
        case 2: _spr = intern2; break;
        case 3: _spr = intern3; break;
        case 4: _spr = intern4; break;
        case 5: _spr = intern5; break;
        default: _spr = intern1; break;
    }

    // Kicking leg wiggle
    var _kick_frame = (clog_timer div 3) mod 6;
    var _kick_wobble = sin(clog_timer * 0.35) * 3;

    // Draw the intern's lower body (legs & shoes) sticking out from the duct
    // Using bottom 16 px of LimeZu 16x32 frame (South facing walk cols 18..23)
    var _src_x = (18 + _kick_frame) * 16;
    var _src_y = 32 + 16;
    var _leg_y = (room_assigned == ROOM_INTERN_GLASS) ? (y - 12) : (y + 10);
    draw_sprite_part_ext(_spr, 0, _src_x, _src_y, 16, 16, round(x + _kick_wobble), _leg_y, 1, 1, c_white, 1.0);

    // Hazard exclamation beacon above vent
    var _bob = sin(current_time / 80) * 2;
    var _ind_y = (room_assigned == ROOM_INTERN_GLASS) ? (y - 24 + _bob) : (y - 14 + _bob);
    draw_sprite_ext(spr_exclamation, 0, _cx, _ind_y, 0.5, 0.5, 0, c_white, 1.0);

    // Floating pill tag: "! VENT CLOGGED (XX%) !"
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var _tag_y = (room_assigned == ROOM_INTERN_GLASS) ? (y - 34 + _bob) : (y - 24 + _bob);

    var _clog_txt = (vent_hp > 0) ? ("! VENT CLOGGED (" + string(round(vent_hp)) + "%) !") : "! VENT DESTROYED !";
    draw_set_alpha(0.85);
    draw_set_color(make_color_rgb(14, 18, 28));
    draw_rectangle(_cx - 42, _tag_y - 5, _cx + 42, _tag_y + 5, false);
    draw_set_color((current_time mod 200 < 100) ? c_red : c_yellow);
    draw_rectangle(_cx - 42, _tag_y - 5, _cx + 42, _tag_y + 5, true);
    draw_set_alpha(1.0);
    draw_text_transformed(_cx, _tag_y, _clog_txt, 0.34, 0.34, 0);

    // Stuck intern health bar
    if (instance_exists(stuck_intern) && stuck_intern.intern_hp < 100) {
        var _ihp_w = 26;
        var _ihp_h = 3;
        var _ihp_x = _cx - _ihp_w * 0.5;
        var _ihp_y = _tag_y - 8;
        var _ihp_pct = clamp(stuck_intern.intern_hp / stuck_intern.intern_max_hp, 0, 1);
        var _ihp_col = (_ihp_pct <= 0.25) ? c_red : ((_ihp_pct <= 0.50) ? c_yellow : c_lime);
        draw_set_color(c_black);
        draw_rectangle(_ihp_x - 1, _ihp_y - 1, _ihp_x + _ihp_w + 1, _ihp_y + _ihp_h + 1, false);
        draw_set_color(_ihp_col);
        draw_rectangle(_ihp_x, _ihp_y, _ihp_x + _ihp_w * _ihp_pct, _ihp_y + _ihp_h, false);
        draw_set_color(c_white);
        draw_rectangle(_ihp_x - 1, _ihp_y - 1, _ihp_x + _ihp_w + 1, _ihp_y + _ihp_h + 1, true);
    }

    // Player prompt & struggle bar when Jack is near
    if (is_interact_target) {
        var _prompt_y = (room_assigned == ROOM_INTERN_GLASS) ? (y + 14) : (y + 30);
        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_yellow);
        draw_text_transformed(_cx, _prompt_y, "SPAM [E] PULL OUT INTERN!", 0.38, 0.38, 0);

        // Progress bar for struggle pull
        var _pw = 36;
        var _ph = 4;
        var _px = _cx - _pw * 0.5;
        var _py = _prompt_y + 6;
        draw_set_color(c_black);
        draw_rectangle(_px - 1, _py - 1, _px + _pw + 1, _py + _ph + 1, false);
        draw_set_color(merge_color(c_orange, c_lime, struggle_pull));
        draw_rectangle(_px, _py, _px + _pw * clamp(struggle_pull, 0, 1), _py + _ph, false);
        draw_set_color(c_white);
        draw_rectangle(_px - 1, _py - 1, _px + _pw + 1, _py + _ph + 1, true);
    }
}
