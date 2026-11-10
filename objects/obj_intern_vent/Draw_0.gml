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

    // Green operational status LED
    draw_set_color(make_color_rgb(0, 230, 115));
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

    // Floating pill tag: "! VENT CLOGGED !"
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var _tag_y = (room_assigned == ROOM_INTERN_GLASS) ? (y - 34 + _bob) : (y - 24 + _bob);

    draw_set_alpha(0.85);
    draw_set_color(make_color_rgb(14, 18, 28));
    draw_rectangle(_cx - 36, _tag_y - 5, _cx + 36, _tag_y + 5, false);
    draw_set_color((current_time mod 200 < 100) ? c_red : c_yellow);
    draw_rectangle(_cx - 36, _tag_y - 5, _cx + 36, _tag_y + 5, true);
    draw_set_alpha(1.0);
    draw_text_transformed(_cx, _tag_y, "! VENT CLOGGED !", 0.35, 0.35, 0);

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
