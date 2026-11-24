/// @description obj_dungeon_quiz — Draw GUI Event
/// Renders the Key Vault "Spot the Cyber Red Flag" Threat Analyzer (640x360 GUI)
/// with Security Sector Terminal Forensic Scanner integration.

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _sx = (shake_timer > 0) ? irandom_range(-4, 4) : 0;
var _sy = (shake_timer > 0) ? irandom_range(-4, 4) : 0;

var _cx = (_gui_w * 0.5) + _sx;
var _cy = (_gui_h * 0.5) - 12 + _sy;

var _curr      = variable_global_exists("floor_curriculum") ? global.floor_curriculum : scr_get_floor_curriculum(1, 4);
var _guided    = _curr.guided_ui;
var _is_exam   = _curr.is_final_exam;
var _clues_cur = variable_global_exists("clues_found")  ? global.clues_found  : 0;
var _clues_req = variable_global_exists("clues_needed") ? global.clues_needed : 1;
var _show_scan = (_clues_cur >= _clues_req) || _guided || kyle_hint_unlocked;
var _popup_open = (variable_global_exists("active_term_popup") && global.active_term_popup != undefined);

// Dim background backdrop
draw_set_alpha(0.84);
draw_set_color(c_black);
draw_rectangle(0, 0, _gui_w, _gui_h, false);

// Main Threat Analyzer Panel
var _pw = 560;
var _ph = 328;
var _x1 = _cx - (_pw * 0.5);
var _y1 = _cy - (_ph * 0.5);
var _x2 = _cx + (_pw * 0.5);
var _y2 = _cy + (_ph * 0.5);

draw_set_alpha(0.97);
draw_set_color(make_color_rgb(12, 18, 30));
draw_rectangle(_x1, _y1, _x2, _y2, false);

// Gold / Exam security border
draw_set_alpha(1.0);
draw_set_color(_is_exam ? make_color_rgb(255, 85, 155) : make_color_rgb(255, 195, 35));
draw_rectangle(_x1, _y1, _x2, _y2, true);
draw_rectangle(_x1 + 3, _y1 + 3, _x2 - 3, _y2 - 3, true);

draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// 1. Header Banner
draw_set_color(_is_exam ? make_color_rgb(255, 110, 175) : make_color_rgb(255, 210, 55));
draw_text_transformed(_cx, _y1 + 14, _is_exam ? "FINAL EXAM VAULT — SPOT THE CYBER RED FLAG" : ("KEY VAULT THREAT ANALYZER  [" + target_word + ": " + case_title + "]"), 0.86, 0.86, 0);

// 2. Captured Incident Artifact Box + Beginner Plain-English Translation Strip
draw_set_color(make_color_rgb(18, 28, 46));
draw_rectangle(_x1 + 16, _y1 + 26, _x2 - 16, _y1 + 100, false);
draw_set_color(make_color_rgb(255, 165, 50));
draw_rectangle(_x1 + 16, _y1 + 26, _x2 - 16, _y1 + 100, true);

draw_set_halign(fa_left);
draw_set_color(make_color_rgb(255, 200, 75));
draw_text_transformed(_x1 + 22, _y1 + 35, artifact_header, 0.66, 0.66, 0);

// Render raw technical log with inline clickable underlined cyan Codex terms!
var _clicked_log_term = scr_draw_linked_cyber_text(
    _x1 + 22, _y1 + 43, artifact_body, 15, (_pw - 44) / 0.66, 0.66,
    c_white, "", !_popup_open, _y1 + 41, _y1 + 70
);
if (is_struct(_clicked_log_term)) {
    var _is_new_t = scr_silent_archive_cyber_term(_clicked_log_term);
    global.active_term_popup          = _clicked_log_term;
    global.active_term_popup_just_new = _is_new_t;
    global.term_popup_history         = [];
    if (asset_get_type("snd_button_click") == asset_sound) audio_play_sound(snd_button_click, 6, false);
}
draw_set_valign(fa_middle);

// Beginner Plain-English Translation Sub-Box inside the Log Panel
draw_set_color(make_color_rgb(12, 36, 48));
draw_rectangle(_x1 + 20, _y1 + 69, _x2 - 20, _y1 + 97, false);
draw_set_color(make_color_rgb(65, 200, 235));
draw_rectangle(_x1 + 20, _y1 + 69, _x2 - 20, _y1 + 97, true);

draw_set_halign(fa_left);
draw_set_color(make_color_rgb(155, 245, 255));
draw_text_ext_transformed(_x1 + 26, _y1 + 83, plain_summary, 12, (_pw - 54) / 0.62, 0.62, 0.62, 0);

// 3. Forensic Scanner / Kyle Breakdown Status Strip
var _gmx = device_mouse_x_to_gui(0);
var _gmy = device_mouse_y_to_gui(0);
draw_set_halign(fa_center);
var _scan_y1 = _y1 + 104;
var _scan_y2 = _y1 + 129;
if (_show_scan) {
    draw_set_color(make_color_rgb(14, 42, 32));
    draw_rectangle(_x1 + 16, _scan_y1, _x2 - 16, _scan_y2, false);
    draw_set_color(c_lime);
    draw_rectangle(_x1 + 16, _scan_y1, _x2 - 16, _scan_y2, true);
    draw_set_color(make_color_rgb(185, 255, 200));
    draw_text_ext_transformed(_cx, (_scan_y1 + _scan_y2) * 0.5, scanner_note, 12, (_pw - 44) / 0.64, 0.64, 0.64, 0);
} else {
    var _hov_scan = point_in_rectangle(_gmx, _gmy, _x1 + 16, _scan_y1, _x2 - 16, _scan_y2);
    draw_set_color(_hov_scan ? make_color_rgb(64, 44, 18) : make_color_rgb(42, 28, 14));
    draw_rectangle(_x1 + 16, _scan_y1, _x2 - 16, _scan_y2, false);
    draw_set_color(_hov_scan ? c_yellow : make_color_rgb(255, 175, 60));
    draw_rectangle(_x1 + 16, _scan_y1, _x2 - 16, _scan_y2, true);
    draw_set_color(_hov_scan ? c_white : make_color_rgb(255, 215, 110));
    draw_text_transformed(_cx, (_scan_y1 + _scan_y2) * 0.5, "UNSURE WHAT THIS LOG MEANS?  Press [K] or CLICK HERE for Kyle's Red-Flag Guide!", 0.66, 0.66, 0);
}

// 4. Question Prompt
draw_set_color(c_aqua);
draw_text_transformed(_cx, _y1 + 144, prompt_text, 0.76, 0.76, 0);

// 5. Three Interactive Option Cards
for (var _i = 0; _i < 3; _i++) {
    var _oy1  = _y1 + 160 + (_i * 38);
    var _oy2  = _oy1 + 32;
    var _sel  = (selected_option == _i);
    var _elim = option_eliminated[_i];
    var _hov  = point_in_rectangle(_gmx, _gmy, _x1 + 18, _oy1, _x2 - 18, _oy2);
    var _is_tut_hint = ((_guided || kyle_hint_unlocked) && _i == correct_option_idx && !_is_exam);

    var _bg_col = make_color_rgb(18, 25, 38);
    var _bd_col = make_color_rgb(65, 95, 130);
    var _tx_col = make_color_rgb(215, 230, 245);

    if (success_timer > 0 && _i == correct_option_idx) {
        _bg_col = make_color_rgb(20, 62, 34);
        _bd_col = c_lime;
        _tx_col = c_lime;
    } else if (_elim) {
        _bg_col = make_color_rgb(38, 18, 22);
        _bd_col = make_color_rgb(180, 65, 65);
        _tx_col = make_color_rgb(175, 115, 115);
    } else if (_sel || _hov) {
        _bg_col = _is_tut_hint ? make_color_rgb(20, 56, 36) : make_color_rgb(28, 48, 76);
        _bd_col = _is_tut_hint ? c_lime : c_aqua;
        _tx_col = c_white;
    } else if (_is_tut_hint) {
        _bg_col = make_color_rgb(16, 44, 28);
        _bd_col = c_lime;
        _tx_col = make_color_rgb(175, 255, 195);
    }

    draw_set_color(_bg_col);
    draw_rectangle(_x1 + 18, _oy1, _x2 - 18, _oy2, false);
    draw_set_color(_bd_col);
    draw_rectangle(_x1 + 18, _oy1, _x2 - 18, _oy2, true);

    draw_set_halign(fa_left);
    draw_set_color(_tx_col);
    var _is_demo_ans = (variable_global_exists("demo_mode_active") && global.demo_mode_active && _i == correct_option_idx);
    var _prefix = "[" + string(_i + 1) + "]  ";
    if (_elim) _prefix = "[X]  ";
    else if (_is_demo_ans) _prefix = "[" + string(_i + 1) + " - * DEMO]  ";
    else if (_is_tut_hint) _prefix = _guided ? ("[" + string(_i + 1) + " - TUTORIAL MATCH]  ") : ("[" + string(_i + 1) + " - KYLE MATCH]  ");

    draw_text_ext_transformed(_x1 + 28, (_oy1 + _oy2) * 0.5, _prefix + quiz_options[_i], 13, (_pw - 58) / 0.70, 0.70, 0.70, 0);
}

// 6. Status Feedback & Controls Footer
draw_set_halign(fa_center);
if (status_msg != "") {
    draw_set_color(status_col);
    draw_text_ext_transformed(_cx, _y2 - 30, status_msg, 12, (_pw - 36) / 0.68, 0.68, 0.68, 0);
} else {
    draw_set_color(make_color_rgb(190, 210, 230));
    draw_text_transformed(_cx, _y2 - 30, "TIP: " + current_takeaway, 0.70, 0.70, 0);
}

draw_set_color(make_color_rgb(145, 165, 190));
draw_text_transformed(_cx, _y2 - 11, (success_timer > 0) ? "[E / ENTER / CLICK] Open Gold Key Vault >" : "[W/S or 1-3 or CLICK] Select Red Flag   |   [E / ENTER] Confirm   |   [K] Kyle Guide   |   [ESC] Cancel", 0.64, 0.64, 0);

// Clickable Cyber Terms Bar below Key Vault panel + Quick-Definition Popup
var _qz_scan = [artifact_header, artifact_body, plain_summary, prompt_text, current_takeaway];
for (var _qi = 0; _qi < array_length(quiz_options); _qi++) {
    array_push(_qz_scan, quiz_options[_qi]);
}
var _qz_terms = scr_scan_clickable_terms(_qz_scan, 5);
if (array_length(_qz_terms) > 0) {
    scr_draw_clickable_term_bar(_x1 + 12, _y2 + 4, _pw - 24, _qz_terms, "CLICK ANY TERM TO DEFINE & ARCHIVE TO CODEX:");
}
scr_draw_term_quick_popup();

draw_set_font(fnt_default);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
