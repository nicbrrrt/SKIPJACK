/// @description obj_intern_ward_controller ?" Draw GUI Event
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// -------------------------------------------------------------
// 1. IN-SHIFT HUD (Timer, Headcount, Room Oxygen, Grab Status)
// -------------------------------------------------------------
if (!shift_ended) {
    // Top HUD Bar Background (100% opaque so no background bleeds into HUD)
    draw_set_alpha(1.0);
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

    // -------------------------------------------------------------
    // FACILITY MULTI-ROOM OXYGEN & VENT TELEMETRY GAUGES (Top Right)
    // -------------------------------------------------------------
    var _jx = instance_exists(obj_jack) ? obj_jack.x : 0;
    var _jy = instance_exists(obj_jack) ? obj_jack.y : 0;
    var _cur_rm = scr_intern_get_room_at(_jx, _jy);

    var _mw    = 84;
    var _mh    = 36;
    var _msp   = 6;
    var _ww    = 66;
    var _tot_w = 3 * _mw + 2 * _msp + _msp + _ww;
    var _sx    = _gw - _tot_w - 12;
    var _my    = 6;

    var _rdata = [
        { name: "OFFICE",  ox: oxygen_work,    vent: vent_work,    rid: ROOM_INTERN_WORK },
        { name: "STORAGE", ox: oxygen_storage, vent: vent_storage, rid: ROOM_INTERN_STORAGE },
        { name: "DECK",    ox: oxygen_glass,   vent: vent_glass,   rid: ROOM_INTERN_GLASS }
    ];

    for (var _ri = 0; _ri < 3; _ri++) {
        var _bx = _sx + _ri * (_mw + _msp);
        var _rm_name = _rdata[_ri].name;
        var _ox_val  = _rdata[_ri].ox;
        var _v_inst  = _rdata[_ri].vent;
        var _is_clog = (instance_exists(_v_inst) && _v_inst.is_clogged);
        var _jack_in = (_cur_rm == _rdata[_ri].rid);

        // Background box
        draw_set_alpha(0.92);
        draw_set_color(make_color_rgb(14, 18, 28));
        draw_rectangle(_bx, _my, _bx + _mw, _my + _mh, false);

        // Border highlighting
        if (_is_clog) {
            draw_set_color((alarm_siren mod 20 < 10) ? make_color_rgb(255, 30, 60) : make_color_rgb(255, 170, 40));
        } else if (_jack_in) {
            draw_set_color(make_color_rgb(0, 229, 255));
        } else {
            draw_set_color(make_color_rgb(45, 60, 85));
        }
        draw_rectangle(_bx, _my, _bx + _mw, _my + _mh, true);

        // Header: Room Name & Vent Status
        draw_set_font(fnt_dialogue);
        draw_set_valign(fa_top);
        draw_set_halign(fa_left);
        draw_set_color(_jack_in ? c_white : make_color_rgb(170, 195, 225));
        draw_text_transformed(_bx + 4, _my + 3, _rm_name, 0.40, 0.40, 0);

        draw_set_halign(fa_right);
        if (_is_clog) {
            draw_set_color((alarm_siren mod 20 < 10) ? c_red : c_yellow);
            draw_text_transformed(_bx + _mw - 4, _my + 3, "!CLOG!", 0.40, 0.40, 0);
        } else {
            draw_set_color(make_color_rgb(0, 230, 115));
            draw_text_transformed(_bx + _mw - 4, _my + 3, "O2 OK", 0.40, 0.40, 0);
        }

        // Oxygen Bar
        var _bar_x = _bx + 4;
        var _bar_y = _my + 18;
        var _bar_w = _mw - 8;
        var _bar_h = 12;

        draw_set_color(c_black);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);

        var _ofill = clamp(_ox_val / 100.0, 0, 1);
        var _fcol  = (_ox_val > 50) ? make_color_rgb(0, 229, 255) : ((_ox_val > 25) ? make_color_rgb(255, 150, 20) : ((alarm_siren mod 20 < 10) ? c_red : c_white));
        draw_set_color(_fcol);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w * _ofill, _bar_y + _bar_h, false);
        draw_set_color(make_color_rgb(70, 90, 120));
        draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, true);

        // Bar text percentage centered
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_black);
        draw_text_transformed(_bar_x + _bar_w * 0.5 + 1, _bar_y + _bar_h * 0.5 + 1, string(round(_ox_val)) + "%", 0.38, 0.38, 0);
        draw_set_color((_ox_val <= 25 && alarm_siren mod 20 < 10) ? c_black : c_white);
        draw_text_transformed(_bar_x + _bar_w * 0.5, _bar_y + _bar_h * 0.5, string(round(_ox_val)) + "%", 0.38, 0.38, 0);
    }

    // Wellness Green Room Module
    var _wbx = _sx + 3 * (_mw + _msp);
    draw_set_alpha(0.92);
    draw_set_color(make_color_rgb(14, 34, 22));
    draw_rectangle(_wbx, _my, _wbx + _ww, _my + _mh, false);
    draw_set_color((_cur_rm == ROOM_INTERN_GREEN) ? c_aqua : make_color_rgb(70, 165, 110));
    draw_rectangle(_wbx, _my, _wbx + _ww, _my + _mh, true);

    draw_set_font(fnt_dialogue);
    draw_set_valign(fa_top);
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(120, 255, 180));
    draw_text_transformed(_wbx + _ww * 0.5, _my + 3, "WELLNESS", 0.40, 0.40, 0);

    draw_set_valign(fa_middle);
    draw_set_color(c_lime);
    draw_text_transformed(_wbx + _ww * 0.5, _my + 24, string(green_count) + "/4 CHILL", 0.42, 0.42, 0);

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

    var _clogged_rm = "";
    if (instance_exists(vent_work) && vent_work.is_clogged)          _clogged_rm = "WORK ROOM";
    else if (instance_exists(vent_storage) && vent_storage.is_clogged) _clogged_rm = "STORAGE VAULT";
    else if (instance_exists(vent_glass) && vent_glass.is_clogged)     _clogged_rm = "OBSERVATION DECK";

    var _low_o2_rm = "";
    var _crit_val  = 100;
    if (oxygen_work < 30)         { _low_o2_rm = "WORK ROOM"; _crit_val = oxygen_work; }
    else if (oxygen_storage < 30) { _low_o2_rm = "STORAGE VAULT"; _crit_val = oxygen_storage; }
    else if (oxygen_glass < 30)   { _low_o2_rm = "OBSERVATION DECK"; _crit_val = oxygen_glass; }

    var _ticker_txt = (alarm_siren mod 600 < 300)
        ? "[ STATUS: ALL SECTORS NOMINAL - 10 INTERNS ACCOUNTED FOR ]"
        : "[ TIP: USE [G] TO MOVE AGITATED INTERNS TO THE WELLNESS GREEN ROOM (MAX 4) ]";
    var _ticker_col = (alarm_siren mod 600 < 300) ? c_aqua : c_lime;

    if (_has_trapped) {
        _ticker_txt = (alarm_siren mod 20 < 10) ? "[ EMERGENCY: INTERN TRAPPED IN LOCKER! PRY OPEN WITH [E] ]" : "[ EMERGENCY: RESCUE TRAPPED INTERN! ]";
        _ticker_col = c_red;
    } else if (_clogged_rm != "") {
        _ticker_txt = (alarm_siren mod 20 < 10) ? "[ EMERGENCY: AIR VENT CLOGGED IN " + _clogged_rm + "! PULL INTERN FREE WITH [E]! ]" : "[ AIRFLOW CUT OFF IN " + _clogged_rm + "! CLEAR VENT BEFORE INTERNS SUFFOCATE! ]";
        _ticker_col = c_red;
    } else if (_low_o2_rm != "") {
        _ticker_txt = "[ DANGER: " + _low_o2_rm + " OXYGEN CRITICAL (" + string(round(_crit_val)) + "%)! OPEN DOOR AND CLEAR VENT! ]";
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

        var _jx = instance_exists(obj_jack) ? obj_jack.x : 0;
        var _jy = instance_exists(obj_jack) ? obj_jack.y : 0;
        var _jrm = scr_intern_get_room_at(_jx, _jy);
        var _jtx = floor((_jx - 320) / 16);
        var _jty = floor((_jy - 240) / 16);
        var _is_grn = (_jrm == ROOM_INTERN_GREEN) || (_jtx >= 27 && _jtx <= 32 && _jty >= 1 && _jty <= 8);

        var _hint = "[G] DROP / PLACE INTERN";
        var _col  = c_yellow;

        if (_is_grn) {
            _hint = "[G] PLACE ON WELLNESS CUSHION (SOOTHE 4s)";
            _col  = c_lime;
        } else if (_jrm == ROOM_INTERN_WORK) {
            _hint = "[G] RETURN INTERN TO WORKSTATION";
            _col  = c_aqua;
        }

        // Drop shadow for legibility
        draw_set_color(c_black);
        draw_text_transformed(_gw * 0.5 + 1, _gh - 19, _hint, 0.70, 0.70, 0);

        draw_set_color(_col);
        draw_text_transformed(_gw * 0.5, _gh - 20, _hint, 0.70, 0.70, 0);
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

// Return / Retry / Menu Buttons
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_font(fnt_main);
draw_set_color(c_yellow);
draw_text_transformed((_px1 + _px2) * 0.5, _py2 - 28, "[ PRESS [E], [ENTER] OR [SPACE] TO RETURN TO HOMEROOM ]", 0.65, 0.65, 0);
draw_set_color(c_aqua);
draw_text_transformed((_px1 + _px2) * 0.5, _py2 - 10, "[ R ] RETRY SHIFT      [ M / ESC ] MAIN MENU", 0.65, 0.65, 0);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_default);
draw_set_alpha(1.0);
draw_set_color(c_white);
