/// @description obj_dungeon_victory — Draw GUI Event
/// Renders the Extraction Elevator "Incident Debrief Report Card" in 640x360 GUI space,
/// showing Chapter & Floor progress (1..10) and Final Exam mastery status.

if (variable_global_exists("is_paused") && global.is_paused) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw * 0.5;
var _cy = _gh * 0.5 - 14;

// Dark background backdrop
draw_set_alpha(screen_alpha * 0.92);
draw_set_color(make_color_rgb(6, 10, 20));
draw_rectangle(0, 0, _gw, _gh, false);

// Subtle background particles
for (var i = 0; i < array_length(stars); i++) {
    var _s     = stars[i];
    var _pulse = 0.5 + 0.5 * sin(anim_timer * _s.spd * 0.05 + _s.ang);
    draw_set_color(merge_color(c_navy, c_aqua, _pulse));
    draw_set_alpha(screen_alpha * _pulse * 0.45);
    draw_circle(_s.sx, _s.sy, _s.sz * _pulse, false);
}

draw_set_alpha(screen_alpha);

// Main Debrief Card Panel
var _pw = 580;
var _ph = 324;
var _x1 = _cx - _pw * 0.5;
var _y1 = _cy - _ph * 0.5;
var _x2 = _cx + _pw * 0.5;
var _y2 = _cy + _ph * 0.5;

var _bcol = is_final_exam ? make_color_rgb(255, 215, 50) : c_aqua;
draw_set_color(make_color_rgb(12, 18, 30));
draw_rectangle(_x1, _y1, _x2, _y2, false);
draw_set_color(_bcol);
draw_rectangle(_x1, _y1, _x2, _y2, true);
draw_rectangle(_x1 + 3, _y1 + 3, _x2 - 3, _y2 - 3, true);

draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// 1. Header Banner
var _bob     = sin(anim_timer * 0.06) * 1.5;
var _ch_name = scr_get_chapter_name(chapter_num);
draw_set_color(_bcol);
if (is_final_exam) {
    draw_text_transformed(_cx, _y1 + 22 + _bob, "CHAPTER " + string(chapter_num) + " FINAL EXAM PASSED! (" + _ch_name + ")", 1.05, 1.05, 0);
} else {
    draw_text_transformed(_cx, _y1 + 22 + _bob, "CH." + string(chapter_num) + " (" + _ch_name + ") — FLOOR " + string(cleared_floor) + " / 10 CLEARED", 1.02, 1.02, 0);
}

// Next Phase / Unlock Status Subtitle
var _sub_str = "";
if (is_final_exam) {
    if (chapter_num == CHAPTER_CAESAR)        _sub_str = "NEW CHAPTER UNLOCKED:  CHAPTER 2 (VIGENERE CIPHER)!";
    else if (chapter_num == CHAPTER_VIGENERE) _sub_str = "NEW CHAPTER UNLOCKED:  CHAPTER 3 (ATBASH CIPHER)!";
    else                                      _sub_str = "ALL 3 CRYPTOGRAPHY CHAPTERS MASTERED — CONGRATULATIONS!";
} else if (cleared_floor == 3) {
    _sub_str = "TUTORIAL COMPLETE!  Next Up: Duolingo-Style Practice (Floors 4-9)";
} else if (cleared_floor == 6) {
    _sub_str = "CORE PRACTICE COMPLETE!  Next Up: Mastery Mode (Training Wheels Off)";
} else if (cleared_floor == 9) {
    _sub_str = "PRACTICE COMPLETE!  Next Up: FLOOR 10 CHAPTER FINAL EXAM!";
} else {
    var _rank = (case_wrong <= 0) ? "S" : ((case_wrong == 1) ? "A" : "B");
    _sub_str = "INVESTIGATION RANK: " + _rank + "  (Evidence: " + string(case_ev) + "/" + string(case_ev_req) + "   Wrong Accusations: " + string(case_wrong) + ")";
}
draw_set_color(make_color_rgb(255, 215, 55));
draw_text_transformed(_cx, _y1 + 42, _sub_str, 0.84, 0.84, 0);

// 2. Section 1 — What Happened on This Floor (The Accidental Slip-Up Story) (PAGE 0: Incident Debrief)
if (page == 0) {
draw_set_color(make_color_rgb(18, 28, 44));
draw_rectangle(_x1 + 16, _y1 + 52, _x2 - 16, _y1 + 142, false);
draw_set_color(make_color_rgb(65, 165, 215));
draw_rectangle(_x1 + 16, _y1 + 52, _x2 - 16, _y1 + 142, true);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_aqua);
draw_text_transformed(_x1 + 24, _y1 + 57, "1. WHAT HAPPENED:  " + case_word + "  (" + case_title + ")", 0.80, 0.80, 0);

draw_set_color(c_white);
draw_text_ext_transformed(_x1 + 24, _y1 + 74, case_lesson, 15, (_pw - 52) / 0.72, 0.72, 0.72, 0);

// 3. Section 2 — Cybersecurity Safety Lesson (How to Prevent This in Real Life)
draw_set_color(make_color_rgb(14, 34, 26));
draw_rectangle(_x1 + 16, _y1 + 148, _x2 - 16, _y1 + 220, false);
draw_set_color(c_lime);
draw_rectangle(_x1 + 16, _y1 + 148, _x2 - 16, _y1 + 220, true);

draw_set_color(c_lime);
draw_text_transformed(_x1 + 24, _y1 + 153, "2. CYBERSECURITY LESSON — HOW TO PREVENT THIS:", 0.78, 0.78, 0);

draw_set_color(make_color_rgb(230, 255, 235));
draw_text_ext_transformed(_x1 + 24, _y1 + 170, case_prevention, 15, (_pw - 52) / 0.72, 0.72, 0.72, 0);

// 4. Section 3 — Cryptography & Key Analysis Box
draw_set_color(make_color_rgb(22, 24, 42));
draw_rectangle(_x1 + 16, _y1 + 226, _x2 - 16, _y1 + 276, false);
draw_set_color(make_color_rgb(255, 195, 45));
draw_rectangle(_x1 + 16, _y1 + 226, _x2 - 16, _y1 + 276, true);

var _cipher_hdr = "";
if (chapter_num == CHAPTER_VIGENERE) {
    _cipher_hdr = "3. CIPHER CRACKED:  VIGENERE KEYWORD CIPHER  (Keyword: " + vig_key + ")";
} else if (chapter_num == CHAPTER_ATBASH) {
    _cipher_hdr = "3. CIPHER CRACKED:  ATBASH MIRROR CIPHER  (Rule: A <-> Z)";
} else {
    var _k_str  = (floor_key > 0) ? ("+" + string(floor_key)) : string(floor_key);
    _cipher_hdr = "3. CIPHER CRACKED:  CAESAR SHIFT CIPHER  (Floor Key: " + _k_str + ")";
}
draw_set_color(make_color_rgb(255, 210, 55));
draw_text_transformed(_x1 + 24, _y1 + 231, _cipher_hdr, 0.76, 0.76, 0);

draw_set_color(make_color_rgb(215, 230, 250));
draw_text_ext_transformed(_x1 + 24, _y1 + 247, crypto_fact, 13, (_pw - 52) / 0.68, 0.68, 0.68, 0);
draw_set_valign(fa_middle);
} else if (page == 1) {
    // =====================================================================
    // PAGE 1 — INTERACTIVE "WHAT WOULD YOU DO?" CYBER SAFETY CHECK (+$50 BONUS)
    // =====================================================================
    var _q_sx = (safety_quiz_shake > 0) ? irandom_range(-4, 4) : 0;

    // Question Prompt Box
    draw_set_color(make_color_rgb(18, 28, 46));
    draw_rectangle(_x1 + 16 + _q_sx, _y1 + 54, _x2 - 16 + _q_sx, _y1 + 100, false);
    draw_set_color(c_aqua);
    draw_rectangle(_x1 + 16 + _q_sx, _y1 + 54, _x2 - 16 + _q_sx, _y1 + 100, true);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(make_color_rgb(255, 215, 65));
    draw_text_transformed(_x1 + 24 + _q_sx, _y1 + 58, "CYBER SAFETY CHECK  —  Answer right on the 1st try for a +$50 Paycheck Bonus!", 0.72, 0.72, 0);

    draw_set_color(c_white);
    draw_text_ext_transformed(_x1 + 24 + _q_sx, _y1 + 73, safety_quiz_question, 13, (_pw - 48) / 0.72, 0.72, 0.72, 0);

    // 3 Selectable Choice Cards
    var _gmx = device_mouse_x_to_gui(0);
    var _gmy = device_mouse_y_to_gui(0);
    draw_set_valign(fa_middle);

    for (var _qi = 0; _qi < 3; _qi++) {
        var _qy1  = _y1 + 108 + (_qi * 40);
        var _qy2  = _qy1 + 34;
        var _qsel = (safety_quiz_sel == _qi);
        var _qelm = safety_quiz_eliminated[_qi];
        var _qhov = point_in_rectangle(_gmx, _gmy, _x1 + 20, _qy1, _x2 - 20, _qy2);

        var _qbg = make_color_rgb(18, 24, 38);
        var _qbd = make_color_rgb(65, 95, 130);
        var _qtx = make_color_rgb(215, 230, 245);

        if (safety_quiz_solved && _qi == safety_quiz_correct_idx) {
            _qbg = make_color_rgb(18, 60, 34);
            _qbd = c_lime;
            _qtx = c_lime;
        } else if (_qelm) {
            _qbg = make_color_rgb(40, 18, 22);
            _qbd = make_color_rgb(185, 65, 65);
            _qtx = make_color_rgb(175, 115, 115);
        } else if (_qsel || _qhov) {
            _qbg = make_color_rgb(28, 48, 76);
            _qbd = c_aqua;
            _qtx = c_white;
        }

        draw_set_color(_qbg);
        draw_rectangle(_x1 + 20 + _q_sx, _qy1, _x2 - 20 + _q_sx, _qy2, false);
        draw_set_color(_qbd);
        draw_rectangle(_x1 + 20 + _q_sx, _qy1, _x2 - 20 + _q_sx, _qy2, true);

        draw_set_halign(fa_left);
        draw_set_color(_qtx);
        var _qpref = _qelm ? "[X]  " : ("[" + string(_qi + 1) + "]  ");
        draw_text_ext_transformed(_x1 + 30 + _q_sx, (_qy1 + _qy2) * 0.5, _qpref + safety_quiz_options[_qi], 13, (_pw - 64) / 0.70, 0.70, 0.70, 0);
    }

    // Feedback Box at bottom of Page 1
    draw_set_color(make_color_rgb(14, 24, 34));
    draw_rectangle(_x1 + 16, _y1 + 232, _x2 - 16, _y1 + 276, false);
    draw_set_color(safety_quiz_solved ? c_lime : make_color_rgb(75, 115, 150));
    draw_rectangle(_x1 + 16, _y1 + 232, _x2 - 16, _y1 + 276, true);

    draw_set_halign(fa_center);
    var _sq_msg = (safety_quiz_feedback != "")
        ? safety_quiz_feedback
        : "Select the safest real-life response using [W/S], [1-3], or Mouse Click, then press [E / ENTER]!";
    draw_set_color((safety_quiz_feedback != "") ? safety_quiz_feedback_col : make_color_rgb(200, 220, 240));
    draw_text_ext_transformed(_cx, _y1 + 254, _sq_msg, 13, (_pw - 48) / 0.70, 0.70, 0.70, 0);
} else {
    // =====================================================================
    // PAGE 2 — CORPORATE PAYSTUB, PERFORMANCE GRADE & STATUE DELIVERIES
    // =====================================================================
    var _grade_col = c_aqua;
    if (paycheck.grade == "S") _grade_col = make_color_rgb(255, 215, 50);
    if (paycheck.grade == "A") _grade_col = c_lime;
    if (paycheck.grade == "C") _grade_col = make_color_rgb(255, 130, 100);

    // Paystub box
    draw_set_color(make_color_rgb(20, 30, 28));
    draw_rectangle(_x1 + 16, _y1 + 56, _x2 - 16, _y1 + 214, false);
    draw_set_color(_grade_col);
    draw_rectangle(_x1 + 16, _y1 + 56, _x2 - 16, _y1 + 214, true);

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text_transformed(_x1 + 28, _y1 + 68, "CORPORATE PAYSTUB  -  FLOOR PERFORMANCE REPORT", 0.86, 0.86, 0);

    // Big performance grade
    draw_set_halign(fa_center);
    draw_set_color(_grade_col);
    draw_text_transformed(_x2 - 64, _y1 + 92, paycheck.grade, 3.2, 3.2, 0);
    draw_set_color(make_color_rgb(190, 205, 220));
    draw_text_transformed(_x2 - 64, _y1 + 124, "RANK", 0.74, 0.74, 0);

    // Itemized lines (including Cyber Safety Check Bonus!)
    var _lines_lbl = [
        "Base IT Hazard Pay",
        "Cipher Speed & Accuracy  (" + string(paycheck.fails) + " failed codes / timeouts, -$25 each)",
        "Salvage Task Bonus  (" + string((task1_done ? 1 : 0) + (task2_done ? 1 : 0)) + "/2 tasks)",
        "Clean Security Record  (busted " + string(paycheck.busted) + "x)",
        "Corporate Recovery Audit (" + string(hr_scrapped) + " Pcs) " + (is_compliant ? "[COMPLIANT]" : "[INTERN DUTY]"),
        "Cyber Safety Check Bonus  " + ((safety_quiz_bonus > 0) ? "[1ST-TRY MASTERY!]" : "[COMPLETED]")
    ];
    var _lines_amt = [paycheck.hazard, paycheck.speed, paycheck.salvage, paycheck.clean, paycheck.fine, safety_quiz_bonus];

    for (var _li = 0; _li < 6; _li++) {
        var _ly = _y1 + 86 + _li * 15;
        draw_set_halign(fa_left);
        draw_set_color((_li == 5 && safety_quiz_bonus > 0) ? c_lime : make_color_rgb(205, 220, 235));
        draw_text_transformed(_x1 + 28, _ly, _lines_lbl[_li], 0.70, 0.70, 0);
        draw_set_halign(fa_right);
        var _amt = _lines_amt[_li];
        draw_set_color((_amt < 0) ? make_color_rgb(255, 110, 100) : ((_amt == 0) ? make_color_rgb(150, 160, 175) : c_lime));
        draw_text_transformed(_x2 - 130, _ly, ((_amt < 0) ? "-$" : "+$") + string(abs(_amt)), 0.76, 0.76, 0);
    }

    draw_set_color(make_color_rgb(95, 120, 110));
    draw_line(_x1 + 28, _y1 + 180, _x2 - 130, _y1 + 180);
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text_transformed(_x1 + 28, _y1 + 194, "NET PAYCHECK", 0.84, 0.84, 0);
    draw_set_halign(fa_right);
    draw_set_color(c_lime);
    draw_text_transformed(_x2 - 130, _y1 + 194, "+$" + string(paycheck.total), 0.90, 0.90, 0);
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(190, 205, 220));
    draw_text_transformed(_x2 - 64, _y1 + 194, "BANK: $" + string(global.player_cash), 0.76, 0.76, 0);

    // Deliveries / Workshop box
    var _has_delivery = (array_length(delivered_statues) > 0);
    draw_set_color(_has_delivery ? make_color_rgb(40, 32, 14) : make_color_rgb(22, 24, 38));
    draw_rectangle(_x1 + 16, _y1 + 218, _x2 - 16, _y1 + 272, false);
    draw_set_color(_has_delivery ? make_color_rgb(255, 205, 70) : make_color_rgb(95, 110, 150));
    draw_rectangle(_x1 + 16, _y1 + 218, _x2 - 16, _y1 + 272, true);

    draw_set_halign(fa_left);
    if (_has_delivery) {
        var _dnames = "";
        for (var _di = 0; _di < array_length(delivered_statues); _di++) {
            _dnames += ((_di > 0) ? ", " : "") + delivered_statues[_di];
        }
        draw_set_color(make_color_rgb(255, 215, 90));
        draw_text_transformed(_x1 + 28, _y1 + 232, "STATUE DELIVERED TO YOUR HOMEROOM!", 0.88, 0.88, 0);
        draw_set_color(c_white);
        draw_text_transformed(_x1 + 28, _y1 + 248, _dnames, 0.80, 0.80, 0);
        draw_set_color(make_color_rgb(190, 205, 220));
        draw_text_transformed(_x1 + 28, _y1 + 262, "Place it on a pedestal at the Display Table to activate its effect.", 0.68, 0.68, 0);
    } else {
        var _n_pending = 0;
        for (var _pi = 0; _pi < STATUE_COUNT; _pi++) {
            if (global.statues_pending[_pi]) _n_pending++;
        }
        draw_set_color(make_color_rgb(150, 190, 235));
        draw_text_transformed(_x1 + 28, _y1 + 232, "POUCH:  " + string(global.scrap_count) + " Scrap   " + string(global.rare_cores) + " Rare Cores", 0.84, 0.84, 0);
        draw_set_color(make_color_rgb(190, 205, 220));
        draw_text_transformed(_x1 + 28, _y1 + 249,
            (_n_pending > 0) ? "Mechanic orders still in fabrication: " + string(_n_pending) : "No statue orders yet.",
            0.72, 0.72, 0);
        draw_text_transformed(_x1 + 28, _y1 + 262, "Call Burt on the Wall Telephone in your Homeroom to commission a statue.", 0.68, 0.68, 0);
    }
    draw_set_halign(fa_center);
}

// 4. Action Prompts Footer
draw_set_halign(fa_center);
if (phase == "display" && phase_timer >= 20) {
    var _flash = (anim_timer mod 50) < 35;
    if (_flash) {
        draw_set_color(c_lime);
        var _has_intern = (variable_global_exists("intern_duty_flagged") && global.intern_duty_flagged);
        var _btn_txt = "";
        if (page == 0) {
            _btn_txt = "[ PRESS E / ENTER FOR CYBER SAFETY CHECK (+$50 BONUS) ]";
        } else if (page == 1) {
            _btn_txt = safety_quiz_solved
                ? "[ PRESS E / ENTER / CLICK TO CLAIM YOUR PAYSTUB > ]"
                : "[ W/S or 1-3 ] Select Answer      [ E / ENTER ] Submit";
        } else {
            _btn_txt = _has_intern
                ? "[ E / ENTER ] ENTER INTERN DUTY (3-MIN SHIFT)"
                : ("[ E / ENTER ] FLOOR " + string(cleared_floor + 1) + " / 10      [ H ] HOMEROOM");
            if (is_final_exam && !_has_intern) {
                _btn_txt = (chapter_num < CHAPTER_ATBASH)
                    ? ("[ E / ENTER ] START CHAPTER " + string(chapter_num + 1) + "      [ H ] HOMEROOM")
                    : "[ E / ENTER ] FINISH CAMPAIGN      [ H ] HOMEROOM";
            }
        }
        draw_text_transformed(_cx, _y2 - 36, _btn_txt, 0.90, 0.90, 0);
    }
    draw_set_color(make_color_rgb(165, 180, 200));
    draw_text_transformed(_cx, _y2 - 16, "[ ESC ] Return to Chapter Select", 0.82, 0.82, 0);
} else if (phase == "fade_out") {
    draw_set_color(c_aqua);
    draw_text(_cx, _y2 - 26, "Loading next sector...");
}

// Clickable Cyber Terms Bar on Debrief & Safety Check pages + Quick-Definition Popup
if (page == 0 || page == 1) {
    var _vic_scan = [case_lesson, case_prevention, safety_quiz_question];
    for (var _vi = 0; _vi < array_length(safety_quiz_options); _vi++) {
        array_push(_vic_scan, safety_quiz_options[_vi]);
    }
    var _vic_terms = scr_scan_clickable_terms(_vic_scan, 4);
    if (array_length(_vic_terms) > 0) {
        scr_draw_clickable_term_bar(_x1 + 14, _y2 + 1, _pw - 28, _vic_terms, "CLICK TERM TO DEFINE & ARCHIVE TO HOMEROOM CODEX:");
    }
}
scr_draw_term_quick_popup();

// Reset draw state
draw_set_font(fnt_default);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
