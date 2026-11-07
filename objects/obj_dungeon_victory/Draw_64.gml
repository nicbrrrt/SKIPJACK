/// @description obj_dungeon_victory — Draw GUI Event
/// Renders the Extraction Elevator "Incident Debrief Report Card" in 640x360 GUI space,
/// showing Chapter & Floor progress (1..10) and Final Exam mastery status.

if (variable_global_exists("is_paused") && global.is_paused) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw * 0.5;
var _cy = _gh * 0.5;

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
    _sub_str = (clues_total >= clues_req)
        ? ("INVESTIGATION RANK: S  (Clues Gathered: " + string(clues_total) + "/" + string(clues_req) + ")")
        : ("INVESTIGATION RANK: A  (Clues Gathered: " + string(clues_total) + "/" + string(clues_req) + ")");
}
draw_set_color(make_color_rgb(255, 215, 55));
draw_text_transformed(_cx, _y1 + 42, _sub_str, 0.84, 0.84, 0);

// 2. Section 1 — Cyber Threat Neutralized Box
draw_set_color(make_color_rgb(18, 28, 44));
draw_rectangle(_x1 + 16, _y1 + 56, _x2 - 16, _y1 + 162, false);
draw_set_color(make_color_rgb(65, 165, 215));
draw_rectangle(_x1 + 16, _y1 + 56, _x2 - 16, _y1 + 162, true);

draw_set_halign(fa_left);
draw_set_color(c_aqua);
draw_text_transformed(_x1 + 26, _y1 + 70, "1. THREAT NEUTRALIZED:  " + case_word + "  (" + case_title + ")", 0.92, 0.92, 0);

draw_set_color(c_white);
draw_text_ext_transformed(_x1 + 26, _y1 + 94, "WHAT IT IS: " + case_hint, 15, (_pw - 56) / 0.84, 0.84, 0.84, 0);

draw_set_color(c_lime);
draw_text_ext_transformed(_x1 + 26, _y1 + 132, case_takeaway, 15, (_pw - 56) / 0.84, 0.84, 0.84, 0);

// 3. Section 2 — Cryptography & Key Analysis Box
draw_set_color(make_color_rgb(22, 24, 42));
draw_rectangle(_x1 + 16, _y1 + 172, _x2 - 16, _y1 + 262, false);
draw_set_color(make_color_rgb(255, 195, 45));
draw_rectangle(_x1 + 16, _y1 + 172, _x2 - 16, _y1 + 262, true);

var _cipher_hdr = "";
if (chapter_num == CHAPTER_VIGENERE) {
    _cipher_hdr = "2. CIPHER CRACKED:  VIGENERE KEYWORD CIPHER  (Keyword: " + vig_key + ")";
} else if (chapter_num == CHAPTER_ATBASH) {
    _cipher_hdr = "2. CIPHER CRACKED:  ATBASH MIRROR CIPHER  (Rule: A <-> Z)";
} else {
    var _k_str  = (floor_key > 0) ? ("+" + string(floor_key)) : string(floor_key);
    _cipher_hdr = "2. CIPHER CRACKED:  CAESAR SHIFT CIPHER  (Floor Key: " + _k_str + ")";
}
draw_set_color(make_color_rgb(255, 210, 55));
draw_text_transformed(_x1 + 26, _y1 + 188, _cipher_hdr, 0.90, 0.90, 0);

draw_set_color(make_color_rgb(215, 230, 250));
draw_text_ext_transformed(_x1 + 26, _y1 + 224, crypto_fact, 15, (_pw - 56) / 0.84, 0.84, 0.84, 0);

// 4. Action Prompts Footer
draw_set_halign(fa_center);
if (phase == "display" && phase_timer >= 20) {
    var _flash = (anim_timer mod 50) < 35;
    if (_flash) {
        draw_set_color(c_lime);
        var _btn_txt = "[ PRESS E / ENTER FOR FLOOR " + string(cleared_floor + 1) + " / 10 ]";
        if (is_final_exam) {
            _btn_txt = (chapter_num < CHAPTER_ATBASH)
                ? ("[ PRESS E / ENTER TO START CHAPTER " + string(chapter_num + 1) + " ]")
                : "[ PRESS E / ENTER TO FINISH CAMPAIGN ]";
        }
        draw_text_transformed(_cx, _y2 - 36, _btn_txt, 0.96, 0.96, 0);
    }
    draw_set_color(make_color_rgb(165, 180, 200));
    draw_text_transformed(_cx, _y2 - 16, "[ ESC ] Return to Chapter Select", 0.82, 0.82, 0);
} else if (phase == "fade_out") {
    draw_set_color(c_aqua);
    draw_text(_cx, _y2 - 26, "Loading next sector...");
}

// Reset draw state
draw_set_font(fnt_default);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
