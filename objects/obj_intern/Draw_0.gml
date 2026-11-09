/// @description obj_intern ?" Draw Event
if (state == INTERN_STATE_DEAD) {
    // Fainted / deceased chalk outline
    draw_set_alpha(0.40);
    draw_set_color(c_red);
    draw_circle(x, y, 6, false);
    draw_set_color(c_white);
    draw_circle(x, y, 6, true);
    draw_set_alpha(1.0);
    exit;
}

var _wobble = (state == INTERN_STATE_SEEK_ROOM || state == INTERN_STATE_TANTRUM) ? sin(walk_timer * 0.22) * 9 : 0;
var _held   = (state == INTERN_STATE_HELD);

// -------------------------------------------------------------
// Draw Baby Intern Body
// -------------------------------------------------------------
var _by = y + 4;

// Drop shadow
draw_set_alpha(0.35);
draw_set_color(c_black);
draw_ellipse(x - 5, y + 2, x + 5, y + 6, false);
draw_set_alpha(1.0);

// Tiny business trousers / diaper
draw_set_color(make_color_rgb(45, 50, 65));
draw_rectangle(x - 4, y, x + 4, y + 4, false);

// Tiny white dress shirt
draw_set_color(c_white);
draw_rectangle(x - 4, y - 5, x + 4, y, false);

// Tiny corporate tie!
draw_set_color(tie_color);
draw_line(x, y - 5, x, y - 1);
draw_triangle(x - 1, y - 5, x + 1, y - 5, x, y - 1, false);

// Chubby baby head
var _face_col = (state == INTERN_STATE_TANTRUM) ? make_color_rgb(255, 140, 140) : make_color_rgb(255, 220, 185);
draw_set_color(_face_col);
draw_circle(x, y - 8, 4.5, false);

// Hair tuft
draw_set_color(hair_color);
draw_circle(x, y - 11, 3.5, false);

// Eyes & expression
draw_set_color(c_black);
if (state == INTERN_STATE_KNOCKED_OUT) {
    // Spiral dizzy eyes
    draw_text_transformed(x - 4, y - 10, "x", 0.35, 0.35, 0);
    draw_text_transformed(x + 1, y - 10, "x", 0.35, 0.35, 0);
} else if (state == INTERN_STATE_TANTRUM) {
    // Screaming crying eyes
    draw_text_transformed(x - 4, y - 10, ">", 0.35, 0.35, 0);
    draw_text_transformed(x + 1, y - 10, "<", 0.35, 0.35, 0);
} else {
    // Cute shiny black dots
    draw_circle(x - 1.5, y - 8, 0.8, false);
    draw_circle(x + 1.5, y - 8, 0.8, false);
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
else if (state == INTERN_STATE_TANTRUM) {
    _badge_text = "TANTRUM!";
    _badge_col  = (current_time mod 200 < 100) ? c_red : c_white;
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

if (_badge_text != "" && state != INTERN_STATE_KNOCKED_OUT && state != INTERN_STATE_DEAD) {
    draw_set_font(fnt_dialogue);
    var _scale = 0.36;
    var _tw = string_width(_badge_text) * _scale + 6;
    var _th = 8;
    var _bx = x - _tw * 0.5;
    var _by = y - 20;

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
            draw_text_transformed(x, _by1 - 8, "SPAM [E] CPR REVIVE!", 0.38, 0.38, 0);
        }
    } else {
        draw_set_alpha(0.65);
        draw_set_color(c_orange);
        draw_text_transformed(x, y - 18, "KO", 0.35, 0.35, 0);
    }
}
// Grab prompt
else if (near_player && global.held_intern_inst == noone && state != INTERN_STATE_HELD) {
    draw_set_color(c_white);
    draw_text_transformed(x, y + 10, "[G] PICK UP", 0.38, 0.38, 0);
}

draw_set_halign(fa_left);
draw_set_font(fnt_default);
draw_set_alpha(1.0);
draw_set_color(c_white);
