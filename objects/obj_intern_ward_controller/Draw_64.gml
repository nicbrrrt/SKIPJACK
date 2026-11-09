/// @description obj_intern_ward_controller ?" Draw GUI Event
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// -------------------------------------------------------------
// 1. IN-SHIFT HUD (Timer, Headcount, Room Oxygen, Grab Status)
// -------------------------------------------------------------
if (!shift_ended) {
    // Top HUD Bar Background
    draw_set_alpha(0.85);
    draw_set_color(make_color_rgb(14, 18, 28));
    draw_rectangle(0, 0, _gw, 48, false);
    draw_set_color(make_color_rgb(45, 60, 85));
    draw_line(0, 48, _gw, 48);

    // Shift Countdown Clock
    var _sec = max(0, ceil(shift_timer / 60));
    var _min = _sec div 60;
    var _rem = _sec mod 60;
    var _time_str = string_format(_min, 2, 0) + ":" + (_rem < 10 ? "0" : "") + string(_rem);
    _time_str = string_replace_all(_time_str, " ", "0");

    draw_set_font(fnt_main);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(_sec <= 30 ? (alarm_siren mod 30 < 15 ? c_red : c_white) : c_aqua);
    draw_text_transformed(24, 24, "SHIFT TIME: " + _time_str, 0.75, 0.75, 0);

    // Interns Headcount
    var _alive = 0;
    var _knocked = 0;
    with (obj_intern) {
        if (state == INTERN_STATE_KNOCKED_OUT) _knocked++;
        else if (state != INTERN_STATE_DEAD)   _alive++;
    }

    var _hc_col = (_knocked > 0) ? c_orange : (_alive == 10 ? c_lime : c_red);
    draw_set_color(_hc_col);
    var _hc_text = "INTERNS: " + string(_alive) + "/10 ALIVE";
    if (_knocked > 0) _hc_text += " (" + string(_knocked) + " DOWN!)";
    draw_text_transformed(_gw * 0.38, 24, _hc_text, 0.75, 0.75, 0);

    // Active Room Oxygen Meter
    var _jx = instance_exists(obj_jack) ? obj_jack.x : 0;
    var _jy = instance_exists(obj_jack) ? obj_jack.y : 0;
    var _cur_rm = scr_intern_get_room_at(_jx, _jy);

    if (_cur_rm == ROOM_INTERN_GREEN) {
        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_right);
        draw_set_valign(fa_middle);
        draw_set_color(c_lime);
        draw_text_transformed(_gw - 20, 24, "WELLNESS: " + string(green_count) + "/4 SOOTHING", 0.60, 0.60, 0);
    }
    else if (_cur_rm != ROOM_INTERN_NONE && _cur_rm != ROOM_INTERN_HALL) {
        var _ox_val = 100.0;
        if (_cur_rm == ROOM_INTERN_WORK)    _ox_val = oxygen_work;
        if (_cur_rm == ROOM_INTERN_STORAGE) _ox_val = oxygen_storage;
        if (_cur_rm == ROOM_INTERN_GLASS)   _ox_val = oxygen_glass;

        var _obw = 120;
        var _obh = 12;
        var _obx = _gw - 160;
        var _oby = 18;

        draw_set_alpha(0.9);
        draw_set_color(c_black);
        draw_rectangle(_obx - 1, _oby - 1, _obx + _obw + 1, _oby + _obh + 1, false);

        var _ofill = clamp(_ox_val / 100.0, 0, 1);
        draw_set_color((_ox_val < 25) ? (alarm_siren mod 20 < 10 ? c_red : c_white) : (_ox_val < 50 ? c_orange : c_aqua));
        draw_rectangle(_obx, _oby, _obx + _obw * _ofill, _oby + _obh, false);
        draw_set_color(c_white);
        draw_rectangle(_obx - 1, _oby - 1, _obx + _obw + 1, _oby + _obh + 1, true);

        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_right);
        draw_text_transformed(_obx - 10, 24, "ROOM O2:", 0.55, 0.55, 0);
    }

    // -------------------------------------------------------------
    // REAL-TIME THREAT TICKER SUB-BANNER (y: 48..72)
    // -------------------------------------------------------------
    var _min_ghp = 100;
    var _danger_gx = 0;
    var _danger_gy = 0;
    with (obj_intern_glass) {
        if (!is_shattered && glass_hp < _min_ghp) {
            _min_ghp = glass_hp;
            _danger_gx = x + 8;
            _danger_gy = y + 8;
        }
    }

    var _has_wobble = false;
    var _wobble_name = "";
    var _wobble_x = 0;
    var _wobble_y = 0;
    var _has_trapped = false;
    with (obj_intern_hazard) {
        if (is_trapped) {
            _has_trapped = true;
            _wobble_x = x + 8;
            _wobble_y = y + 8;
        } else if (is_wobbling) {
            _has_wobble = true;
            _wobble_name = (hazard_type == HAZARD_SHELF ? "STORAGE SHELF" : (hazard_type == HAZARD_LOCKER ? "SUPPLY LOCKER" : "WATER COOLER"));
            _wobble_x = x + 8;
            _wobble_y = y + 8;
        }
    }

    var _low_o2_rm = "";
    if (oxygen_work < 30)         _low_o2_rm = "WORK ROOM";
    else if (oxygen_storage < 30) _low_o2_rm = "STORAGE VAULT";
    else if (oxygen_glass < 30)   _low_o2_rm = "OBSERVATION DECK";

    var _ticker_txt = (alarm_siren mod 600 < 300)
        ? "[ STATUS: ALL SECTORS NOMINAL - 10 INTERNS ACCOUNTED FOR ]"
        : "[ TIP: USE [G] TO MOVE AGITATED INTERNS TO THE WELLNESS GREEN ROOM (MAX 4) ]";
    var _ticker_col = (alarm_siren mod 600 < 300) ? c_aqua : c_lime;

    if (_has_trapped) {
        _ticker_txt = (alarm_siren mod 20 < 10) ? "[ EMERGENCY: INTERN TRAPPED IN LOCKER! PRY OPEN WITH [E] ]" : "[ EMERGENCY: RESCUE TRAPPED INTERN! ]";
        _ticker_col = c_red;
    } else if (_low_o2_rm != "") {
        _ticker_txt = "[ DANGER: " + _low_o2_rm + " AIR CRITICAL! OPEN DOOR WITH [E] ]";
        _ticker_col = (alarm_siren mod 20 < 10) ? c_red : c_yellow;
    } else if (_min_ghp <= 25) {
        _ticker_txt = "[ CRITICAL: OBSERVATION GLASS INTEGRITY AT " + string(_min_ghp) + "%! BREACH IMMINENT! ]";
        _ticker_col = (alarm_siren mod 20 < 10) ? c_red : c_white;
    } else if (_has_wobble) {
        _ticker_txt = "[ WARNING: " + _wobble_name + " WOBBLING! STEADY WITH [E] ]";
        _ticker_col = c_yellow;
    } else if (_min_ghp <= 75) {
        _ticker_txt = "[ CAUTION: OBSERVATION GLASS CRACKED (" + string(_min_ghp) + "%) - REINFORCE WITH [E] ]";
        _ticker_col = c_orange;
    }

    draw_set_alpha(0.85);
    draw_set_color(make_color_rgb(10, 14, 22));
    draw_rectangle(0, 48, _gw, 72, false);
    draw_set_color(make_color_rgb(30, 42, 60));
    draw_line(0, 72, _gw, 72);

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_ticker_col);
    draw_text_transformed(_gw * 0.5, 60, _ticker_txt, 0.58, 0.58, 0);

    // -------------------------------------------------------------
    // OFF-SCREEN HAZARD EDGE ALERT ARROWS
    // -------------------------------------------------------------
    var _alert_tx = 0;
    var _alert_ty = 0;
    var _alert_lbl = "";
    var _alert_active = false;

    if (_has_trapped || _has_wobble) {
        _alert_tx = _wobble_x;
        _alert_ty = _wobble_y;
        _alert_lbl = "[!] STORAGE";
        _alert_active = true;
    } else if (_min_ghp <= 50) {
        _alert_tx = _danger_gx;
        _alert_ty = _danger_gy;
        _alert_lbl = "[!] GLASS";
        _alert_active = true;
    }

    if (_alert_active && view_enabled) {
        var _cam = view_camera[0];
        if (_cam != -1) {
            var _vx = camera_get_view_x(_cam);
            var _vy = camera_get_view_y(_cam);
            var _vw = camera_get_view_width(_cam);
            var _vh = camera_get_view_height(_cam);
            var _margin = 24;

            // Only draw if target is outside screen view!
            if (_alert_tx < _vx || _alert_tx > _vx + _vw || _alert_ty < _vy || _alert_ty > _vy + _vh) {
                var _cam_cx = _vx + _vw * 0.5;
                var _cam_cy = _vy + _vh * 0.5;
                var _adir = point_direction(_cam_cx, _cam_cy, _alert_tx, _alert_ty);

                // Map to GUI coordinates
                var _gui_cx = _gw * 0.5;
                var _gui_cy = _gh * 0.5;
                var _edge_x = clamp(_gui_cx + lengthdir_x(_gw * 0.44, _adir), 40, _gw - 40);
                var _edge_y = clamp(_gui_cy + lengthdir_y(_gh * 0.40, _adir), 80, _gh - 35);

                var _apulse = 0.8 + 0.2 * sin(current_time / 100);
                draw_sprite_ext(spr_arrow_up, 0, _edge_x, _edge_y, 1.2, 1.2, _adir - 90, _ticker_col, _apulse);
                draw_set_halign(fa_center);
                draw_set_valign(fa_top);
                draw_set_color(_ticker_col);
                draw_text_transformed(_edge_x, _edge_y + 10, _alert_lbl, 0.48, 0.48, 0);
            }
        }
    }

    // Held Intern Alert at Bottom
    if (global.held_intern_inst != noone) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_set_font(fnt_main);
        draw_set_color(c_yellow);
        draw_text_transformed(_gw * 0.5, _gh - 20, "[G] DROP / PLACE INTERN", 0.70, 0.70, 0);
    }

    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fnt_default);
    exit;
}

// -------------------------------------------------------------
// 2. SHIFT COMPLETION PAYSTUB REVIEW SCREEN
// -------------------------------------------------------------
// Dark Backdrop
draw_set_alpha(0.85);
draw_set_color(make_color_rgb(6, 8, 14));
draw_rectangle(0, 0, _gw, _gh, false);

var _pw = min(680, _gw - 40);
var _ph = min(480, _gh - 40);
var _px1 = (_gw - _pw) * 0.5;
var _py1 = (_gh - _ph) * 0.5;
var _px2 = _px1 + _pw;
var _py2 = _py1 + _ph;

// Paystub Card Window
draw_set_alpha(0.96);
draw_set_color(make_color_rgb(18, 22, 34));
draw_rectangle(_px1, _py1, _px2, _py2, false);

var _border_col = (shift_grade == "F") ? make_color_rgb(220, 60, 60) : make_color_rgb(255, 215, 60);
draw_set_color(_border_col);
draw_rectangle(_px1, _py1, _px2, _py2, true);
draw_rectangle(_px1 + 3, _py1 + 3, _px2 - 3, _py2 - 3, true);

// Header Banner
draw_set_color(make_color_rgb(28, 36, 56));
draw_rectangle(_px1 + 4, _py1 + 4, _px2 - 4, _py1 + 60, false);
draw_set_color(_border_col);
draw_line(_px1 + 4, _py1 + 60, _px2 - 4, _py1 + 60);

draw_set_font(fnt_title);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text_transformed((_px1 + _px2) * 0.5, _py1 + 24, "ACME CORP - HR COMPLIANCE DIVISION", 0.65, 0.65, 0);
draw_set_font(fnt_dialogue);
draw_set_color(_border_col);
draw_text_transformed((_px1 + _px2) * 0.5, _py1 + 46, "INTERN BABYSITTING REMEDIATION REPORT", 0.75, 0.75, 0);

// Performance Grade Stamp (Top Right)
var _gx = _px2 - 65;
var _gy = _py1 + 110;
draw_set_color(c_black);
draw_circle(_gx, _gy, 32, false);
draw_set_color((shift_grade == "F") ? c_red : (shift_grade == "S" ? c_yellow : c_lime));
draw_circle(_gx, _gy, 32, true);
draw_circle(_gx, _gy, 30, true);
draw_set_font(fnt_title);
draw_text_transformed(_gx, _gy, shift_grade, 1.3, 1.3, 0);

// Paystub Line Items
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_main);
var _ly = _py1 + 80;

draw_set_color(c_white);
draw_text_transformed(_px1 + 30, _ly, "SHIFT STATUS: 3:00 COMPLETED", 0.70, 0.70, 0);
_ly += 32;

draw_set_color(c_lime);
draw_text_transformed(_px1 + 30, _ly, "1. INTERNS SURVIVED:    " + string(interns_saved) + " / 10", 0.70, 0.70, 0);
_ly += 28;

draw_set_color((interns_lost > 0) ? make_color_rgb(255, 100, 100) : c_lime);
draw_text_transformed(_px1 + 30, _ly, "2. CASUALTIES/FATALITIES: " + string(interns_lost) + " (-$" + string(interns_lost * 150) + ")", 0.70, 0.70, 0);
_ly += 28;

draw_set_color((fried_count > 0) ? make_color_rgb(255, 140, 80) : c_lime);
draw_text_transformed(_px1 + 30, _ly, "3. TERMINALS VANDALIZED:  " + string(fried_count) + " (-$" + string(fried_count * 30) + ")", 0.70, 0.70, 0);
_ly += 32;

draw_set_color(_border_col);
draw_line(_px1 + 25, _ly, _px2 - 25, _ly);
_ly += 16;

draw_set_color(c_white);
draw_text_transformed(_px1 + 30, _ly, "TOTAL REMEDIATION DEDUCTIONS: -$" + string(total_fines), 0.75, 0.75, 0);
_ly += 38;

// HR Verdict
draw_set_font(fnt_dialogue);
if (shift_grade != "F") {
    draw_set_color(c_lime);
    draw_text_transformed(_px1 + 30, _ly, "HR VERDICT: PROBATION LIFTED! Your write-off violation debt has been cleared.", 0.65, 0.65, 0);
} else {
    draw_set_color(make_color_rgb(255, 100, 100));
    draw_text_transformed(_px1 + 30, _ly, "HR VERDICT: SHIFT FAILED! 3+ casualties recorded. Probation extended for next workday.", 0.65, 0.65, 0);
}

// Return to Homeroom Button
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_font(fnt_main);
draw_set_color(c_yellow);
draw_text_transformed((_px1 + _px2) * 0.5, _py2 - 16, "[ PRESS [E], [ENTER] OR [SPACE] TO RETURN TO HOMEROOM ]", 0.70, 0.70, 0);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_default);
draw_set_alpha(1.0);
draw_set_color(c_white);
