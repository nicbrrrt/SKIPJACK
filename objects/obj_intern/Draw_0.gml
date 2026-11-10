/// @description obj_intern — Draw Event
if (state == INTERN_STATE_DEAD) {
    // Fainted / deceased chalk outline
    draw_set_alpha(0.40);
    draw_set_color(c_red);
    draw_circle(x, y, 6, false);
    draw_set_color(c_white);
    draw_circle(x, y, 6, true);
    draw_set_alpha(1.0);

    // Casualty badge
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var _cw = 62;
    var _ch = 8;
    var _cx_box = x - _cw * 0.5;
    var _cy_box = y - 18;
    draw_set_color(c_black);
    draw_rectangle(_cx_box, _cy_box, _cx_box + _cw, _cy_box + _ch, false);
    draw_set_color(c_red);
    draw_rectangle(_cx_box, _cy_box, _cx_box + _cw, _cy_box + _ch, true);
    draw_set_color(c_white);
    draw_text_transformed(x, _cy_box + _ch * 0.5, "CASUALTY (-$150)", 0.32, 0.32, 0);
    draw_set_halign(fa_left);
    draw_set_font(fnt_default);
    exit;
}

if (state == INTERN_STATE_VENT_STUCK) {
    // Intern is stuck head-first inside the air vent shaft; vent draws the kicking legs!
    exit;
}

var _wobble = (state == INTERN_STATE_SEEK_ROOM || state == INTERN_STATE_TANTRUM || state == INTERN_STATE_FUMING) ? sin(walk_timer * 0.35) * 5 : 0;
var _held   = (state == INTERN_STATE_HELD);

// -------------------------------------------------------------
// Draw Baby Intern Body (Uses Spritesheets intern1..intern5)
// -------------------------------------------------------------
var _variant = variable_instance_exists(id, "intern_variant") ? intern_variant : ((intern_id mod 5) + 1);
var _spr = intern1;
switch (_variant) {
    case 1: _spr = intern1; break;
    case 2: _spr = intern2; break;
    case 3: _spr = intern3; break;
    case 4: _spr = intern4; break;
    case 5: _spr = intern5; break;
    default: _spr = intern1; break;
}

// Drop shadow under intern feet (not while held)
if (state != INTERN_STATE_HELD) {
    draw_set_alpha(0.35);
    draw_set_color(c_black);
    draw_ellipse(x - 6, y + 1, x + 6, y + 5, false);
    draw_set_alpha(1.0);
}

// Full LimeZu Character Spritesheet (896 x 640 grid of 16x32 character frames)
var _src_x = 48; // Default Idle Down
var _src_y = 0;
var _draw_y_offset = -28;

if (state == INTERN_STATE_WORK) {
    // Row 7: reading / typing papers at desk (6 frames)
    _src_x = ((walk_timer div 8) mod 6) * 16;
    _src_y = 224;
    _draw_y_offset = -28;
}
else if (state == INTERN_STATE_SOOTHED) {
    // Row 3: relaxing snuggled on cushion (6 frames)
    _src_x = ((walk_timer div 20) mod 6) * 16;
    _src_y = 96;
    _draw_y_offset = -16;
}
else if (state == INTERN_STATE_KNOCKED_OUT) {
    // Row 3: fainted / resting on floor
    _src_x = 0;
    _src_y = 96;
    _draw_y_offset = -16;
}
else if (state == INTERN_STATE_FUMING) {
    // Row 2 frame 0: angry red-faced stance / foot stomp
    _src_x = ((walk_timer div 6) mod 2) * 16;
    _src_y = 64;
    _draw_y_offset = -28;
}
else if (state == INTERN_STATE_TANTRUM) {
    // Row 2: 4-directional angry sprint / tantrum
    var _wf = (walk_timer div 3) mod 6;
    if (face_dir >= 45 && face_dir < 135) {
        // Moving North (Up) - Cols 6..11
        _src_x = (6 + _wf) * 16;
        _src_y = 64;
    } else if (face_dir >= 135 && face_dir < 225) {
        // Moving West (Left) - Cols 12..17
        _src_x = (12 + _wf) * 16;
        _src_y = 64;
    } else if (face_dir >= 225 && face_dir < 315) {
        // Moving South (Down) - Cols 18..23
        _src_x = (18 + _wf) * 16;
        _src_y = 64;
    } else {
        // Moving East (Right) - Cols 0..5
        _src_x = _wf * 16;
        _src_y = 64;
    }
    _draw_y_offset = -28;
}
else if (state == INTERN_STATE_SEEK_ROOM) {
    // Row 1: 4-directional 6-frame walk cycle (paced smoothly to move speed 2.85)
    var _wf = (walk_timer div 4) mod 6;
    if (face_dir >= 45 && face_dir < 135) {
        // Moving North (Up) - Cols 6..11
        _src_x = (6 + _wf) * 16;
        _src_y = 32;
    } else if (face_dir >= 135 && face_dir < 225) {
        // Moving West (Left) - Cols 12..17
        _src_x = (12 + _wf) * 16;
        _src_y = 32;
    } else if (face_dir >= 225 && face_dir < 315) {
        // Moving South (Down) - Cols 18..23
        _src_x = (18 + _wf) * 16;
        _src_y = 32;
    } else {
        // Moving East (Right) - Cols 0..5
        _src_x = _wf * 16;
        _src_y = 32;
    }
    _draw_y_offset = -28;
}
else if (state == INTERN_STATE_HELD) {
    // Idle South facing camera while held up
    _src_x = 48;
    _src_y = 0;
    _draw_y_offset = -26;
}
else {
    // Idle directional pose
    if (face_dir >= 45 && face_dir < 135)       { _src_x = 16; _src_y = 0; } // Up (Col 1)
    else if (face_dir >= 135 && face_dir < 225) { _src_x = 32; _src_y = 0; } // West / Left (Col 2)
    else if (face_dir >= 225 && face_dir < 315) { _src_x = 48; _src_y = 0; } // Down (Col 3)
    else                                        { _src_x = 0;  _src_y = 0; } // East / Right (Col 0)
    _draw_y_offset = -28;
}

var _draw_x = round(x - 8);
var _draw_y = round(y + _draw_y_offset);
draw_sprite_part_ext(_spr, 0, _src_x, _src_y, 16, 32, _draw_x, _draw_y, 1, 1, c_white, 1.0);

// Tantrum flailing arms visual effect
if (state == INTERN_STATE_TANTRUM) {
    var _flail_rad1 = degtorad(flail_angle);
    var _flail_rad2 = degtorad(flail_angle + 180);
    var _arm_len = 11;
    var _pivot_x = x;
    var _pivot_y = y - 14;

    // Windmilling arms
    draw_set_color(make_color_rgb(220, 230, 245));
    draw_line_width(_pivot_x, _pivot_y, _pivot_x + cos(_flail_rad1) * _arm_len, _pivot_y + sin(_flail_rad1) * _arm_len, 2);
    draw_line_width(_pivot_x, _pivot_y, _pivot_x + cos(_flail_rad2) * _arm_len, _pivot_y + sin(_flail_rad2) * _arm_len, 2);

    // Red fists at ends
    draw_set_color(c_red);
    draw_circle(_pivot_x + cos(_flail_rad1) * _arm_len, _pivot_y + sin(_flail_rad1) * _arm_len, 2, false);
    draw_circle(_pivot_x + cos(_flail_rad2) * _arm_len, _pivot_y + sin(_flail_rad2) * _arm_len, 2, false);

    // Tantrum impact pop stars
    if (flail_cooldown mod 8 < 4) {
        draw_set_color(c_yellow);
        draw_text_transformed(_pivot_x + irandom_range(-12, 12), _pivot_y + irandom_range(-10, 10), "*", 0.65, 0.65, 0);
    }
}

if (state == INTERN_STATE_KNOCKED_OUT) {
    if (is_slipped) {
        // Orbiting yellow stars above head
        var _star_t = current_time * 0.005;
        for (var _si = 0; _si < 3; _si++) {
            var _ang = _star_t + _si * (2 * pi / 3);
            var _sx = x + cos(_ang) * 9;
            var _sy = (y - 20) + sin(_ang) * 4;
            draw_set_color(c_yellow);
            draw_text_transformed(_sx, _sy, "*", 0.6, 0.6, 0);
        }
    } else {
        draw_set_color(c_yellow);
        draw_text_transformed(x, y - 26, "Z z Z", 0.4, 0.4, 0);
    }
}

// -------------------------------------------------------------
// Intern Health Bar (Displayed when damaged < 100 HP)
// -------------------------------------------------------------
if (intern_hp < 100 && state != INTERN_STATE_DEAD && state != INTERN_STATE_VENT_STUCK) {
    var _hp_w = 26;
    var _hp_h = 3;
    var _hp_x = x - _hp_w * 0.5;
    var _hp_y = y - 44; // Above status badge
    var _hp_pct = clamp(intern_hp / intern_max_hp, 0, 1);
    var _hp_col = c_lime;
    if (_hp_pct <= 0.25) _hp_col = c_red;
    else if (_hp_pct <= 0.50) _hp_col = c_yellow;

    draw_set_alpha(0.85);
    draw_set_color(c_black);
    draw_rectangle(_hp_x - 1, _hp_y - 1, _hp_x + _hp_w + 1, _hp_y + _hp_h + 1, false);
    draw_set_color(_hp_col);
    draw_rectangle(_hp_x, _hp_y, _hp_x + _hp_w * _hp_pct, _hp_y + _hp_h, false);
    draw_set_color(c_white);
    draw_rectangle(_hp_x - 1, _hp_y - 1, _hp_x + _hp_w + 1, _hp_y + _hp_h + 1, true);
    draw_set_alpha(1.0);
}

// -------------------------------------------------------------
// State of Mind Floating Badges & Indicators
// -------------------------------------------------------------
var _badge_text = "";
var _badge_col  = c_white;

if (state == INTERN_STATE_WORK) {
    if (boredom < 60) {
        _badge_text = "CALM";
        _badge_col  = make_color_rgb(110, 240, 140);
    } else {
        _badge_text = "RESTLESS";
        _badge_col  = make_color_rgb(255, 215, 80);
    }
}
else if (state == INTERN_STATE_BORED) {
    _badge_text = "BORED";
    _badge_col  = make_color_rgb(255, 220, 50);
}
else if (state == INTERN_STATE_SEEK_ROOM) {
    if (target_room == ROOM_INTERN_WORK) {
        _badge_text = "CALM -> WORK";
        _badge_col  = make_color_rgb(120, 230, 255);
    } else {
        _badge_text = "BORED";
        _badge_col  = make_color_rgb(255, 220, 50);
    }
}
else if (state == INTERN_STATE_MISCHIEF) {
    _badge_text = "! AGITATED !";
    _badge_col  = make_color_rgb(255, 140, 40);
}
else if (state == INTERN_STATE_FUMING) {
    var _rem_fume = max(1, ceil(fuming_timer / 60));
    _badge_text = "! FUMING (" + string(_rem_fume) + "s) !";
    _badge_col  = (current_time mod 180 < 90) ? make_color_rgb(255, 80, 20) : make_color_rgb(255, 210, 50);
}
else if (state == INTERN_STATE_TANTRUM) {
    _badge_text = "! TANTRUM (DANGER) !";
    _badge_col  = (current_time mod 180 < 90) ? c_red : c_yellow;
}
else if (state == INTERN_STATE_SOOTHED) {
    var _rem_sec = max(1, ceil(soothe_timer / 60));
    _badge_text = "CALMING (" + string(_rem_sec) + "s)";
    _badge_col  = make_color_rgb(120, 255, 180);
}
else if (state == INTERN_STATE_HELD) {
    _badge_text = "HELD";
    _badge_col  = c_aqua;
}
else if (state == INTERN_STATE_KNOCKED_OUT && is_slipped) {
    _badge_text = "! SLIPPED !";
    _badge_col  = make_color_rgb(255, 200, 50);
}

if (_badge_text != "" && state != INTERN_STATE_DEAD && (state != INTERN_STATE_KNOCKED_OUT || is_slipped)) {
    draw_set_font(fnt_dialogue);
    var _scale = 0.36;
    var _tw = string_width(_badge_text) * _scale + 6;
    var _th = 8;
    var _bx = x - _tw * 0.5;
    var _by = y - 36;

    // Dark pill container
    draw_set_alpha(0.82);
    draw_set_color(make_color_rgb(10, 14, 22));
    draw_rectangle(_bx, _by, _bx + _tw, _by + _th, false);
    draw_set_alpha(0.9);
    draw_set_color(_badge_col);
    draw_rectangle(_bx, _by, _bx + _tw, _by + _th, true);

    // Text label
    draw_set_alpha(1.0);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(x, _by + _th * 0.5, _badge_text, _scale, _scale, 0);
}

if (state == INTERN_STATE_SOOTHED) {
    // Gentle floating zen aura while in Green Room
    var _pulse = 0.5 + 0.5 * sin(current_time / 140 + intern_id);
    draw_set_alpha(0.25 + 0.15 * _pulse);
    draw_set_color(make_color_rgb(80, 240, 140));
    draw_circle(x, y - 6, 7 + 2 * _pulse, true);
    draw_set_alpha(1.0);
}

// CPR Revive Struggle Bar (Only for the single closest target!)
if (state == INTERN_STATE_KNOCKED_OUT) {
    if (is_cpr_target) {
        var _bw = 38;
        var _bh = 6;
        var _bx1 = x - _bw * 0.5;
        var _by1 = y - 22;
        var _fill = clamp(revive_meter, 0, 1);

        draw_set_alpha(0.95);
        draw_set_color(c_black);
        draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, false);
        draw_set_color(merge_color(c_red, c_lime, _fill));
        draw_rectangle(_bx1, _by1, _bx1 + _bw * _fill, _by1 + _bh, false);
        draw_set_color(c_white);
        draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, true);

        if (near_player) {
            draw_set_color(c_yellow);
            var _rev_prompt = is_slipped ? "SPAM [E] HELP UP!" : "SPAM [E] CPR REVIVE!";
            draw_text_transformed(x, _by1 - 8, _rev_prompt, 0.38, 0.38, 0);
        }
    } else {
        draw_set_alpha(0.65);
        draw_set_color(c_orange);
        draw_text_transformed(x, y - 18, "KO", 0.35, 0.35, 0);
    }
}
// Grab prompt
else if (near_player && global.held_intern_inst == noone && state != INTERN_STATE_HELD && state != INTERN_STATE_SOOTHED) {
    if (state == INTERN_STATE_TANTRUM) {
        draw_set_color(c_red);
        draw_text_transformed(x, y + 10, "! TOO ANGRY TO GRAB !", 0.35, 0.35, 0);
    } else {
        draw_set_color(c_white);
        draw_text_transformed(x, y + 10, "[G] PICK UP", 0.38, 0.38, 0);
    }
}

draw_set_halign(fa_left);
draw_set_font(fnt_default);
draw_set_alpha(1.0);
draw_set_color(c_white);
