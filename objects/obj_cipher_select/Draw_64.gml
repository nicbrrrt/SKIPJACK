/// @description obj_cipher_select — Draw GUI Event
/// Renders the 3-Chapter Dungeon Select Screen (Caesar -> Vigenere -> Atbash)
/// and the interactive Floor / Phase Selector (1..10) in 640x360 GUI space.

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw * 0.5;
draw_set_alpha(1.0);

// 1. Dark Corporate Cybersecurity Backdrop
draw_set_color(make_color_rgb(10, 14, 24));
draw_rectangle(0, 0, _gw, _gh, false);

// Subtle grid lines
draw_set_alpha(0.06);
draw_set_color(c_aqua);
for (var _gx = 0; _gx < _gw; _gx += 32) draw_line(_gx, 0, _gx, _gh);
for (var _gy = 0; _gy < _gh; _gy += 32) draw_line(0, _gy, _gw, _gy);
draw_set_alpha(1.0);

// 2. Top Bar: Back Button & Demo Unlock Toggle
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _back_hov = (_mx >= 12 && _mx <= 84 && _my >= 12 && _my <= 34);

draw_set_color(_back_hov ? make_color_rgb(35, 55, 80) : make_color_rgb(20, 28, 44));
draw_rectangle(12, 12, 84, 34, false);
draw_set_color(_back_hov ? c_aqua : make_color_rgb(100, 125, 160));
draw_rectangle(12, 12, 84, 34, true);

draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text_transformed(48, 23, "< MENU", 0.85, 0.85, 0);

// Top-right Demo Unlock All Toggle
var _all_unlocked = (variable_global_exists("unlock_all_ciphers") && global.unlock_all_ciphers);
draw_set_color(demo_unlock_hover ? make_color_rgb(40, 58, 40) : make_color_rgb(18, 26, 38));
draw_rectangle(_gw - 156, 12, _gw - 12, 34, false);
draw_set_color(_all_unlocked ? c_lime : (demo_unlock_hover ? c_yellow : make_color_rgb(80, 100, 130)));
draw_rectangle(_gw - 156, 12, _gw - 12, 34, true);
draw_text_transformed(_gw - 84, 23, _all_unlocked ? "[U] DEMO: ALL UNLOCKED" : "[U] DEMO: UNLOCK ALL", 0.75, 0.75, 0);

// 3. Header Title & Subtitle
draw_set_font(fnt_dialogue);
draw_set_color(c_aqua);
draw_text_transformed(_cx, 34, "SELECT ENCRYPTION CHAPTER", 1.25, 1.25, 0);
draw_set_color(make_color_rgb(170, 190, 215));
draw_text_transformed(_cx, 58, "Each Chapter features 10 Floors: Floors 1-3 Tutorial  |  Floors 4-9 Practice  |  Floor 10 Final Exam", 0.80, 0.80, 0);

var _best = variable_global_exists("chapter_best_floor") ? global.chapter_best_floor : [1, 1, 1];
var _vig_unlocked = (variable_global_exists("vigenere_unlocked") && global.vigenere_unlocked)
                 || (variable_global_exists("final_boss_defeated") && global.final_boss_defeated)
                 || _all_unlocked;
var _atb_unlocked = (variable_global_exists("atbash_unlocked") && global.atbash_unlocked)
                 || (variable_global_exists("atbash_boss_defeated") && global.atbash_boss_defeated)
                 || _all_unlocked;

// --- CHAPTER 1 BUTTON: CAESAR CIPHER ---
draw_set_color(caesar_hover ? make_color_rgb(24, 42, 68) : make_color_rgb(16, 24, 42));
draw_rectangle(btn_x1, btn1_y, btn_x2, btn1_y + btn_h, false);
draw_set_color(caesar_hover ? c_aqua : make_color_rgb(70, 165, 220));
draw_rectangle(btn_x1, btn1_y, btn_x2, btn1_y + btn_h, true);
if (caesar_hover) draw_rectangle(btn_x1 + 2, btn1_y + 2, btn_x2 - 2, btn1_y + btn_h - 2, true);

draw_set_halign(fa_left);
draw_set_color(caesar_hover ? c_yellow : c_white);
draw_text_transformed(btn_x1 + 14, btn1_y + 14, "CHAPTER 1:  CAESAR CIPHER", 0.96, 0.96, 0);
draw_set_color(make_color_rgb(150, 190, 225));
draw_text_transformed(btn_x1 + 14, btn1_y + 31, "Fixed Alphabet Shift (+K / -K)  •  10 Floors", 0.78, 0.78, 0);

draw_set_halign(fa_right);
draw_set_color(c_lime);
draw_text_transformed(btn_x2 - 14, btn1_y + 22, "PLAY >", 0.90, 0.90, 0);

// --- CHAPTER 2 BUTTON: VIGENERE CIPHER ---
if (_vig_unlocked) {
    draw_set_color(vigenere_hover ? make_color_rgb(38, 24, 64) : make_color_rgb(20, 16, 38));
    draw_rectangle(btn_x1, btn2_y, btn_x2, btn2_y + btn_h, false);
    draw_set_color(vigenere_hover ? c_yellow : make_color_rgb(195, 95, 245));
    draw_rectangle(btn_x1, btn2_y, btn_x2, btn2_y + btn_h, true);
    if (vigenere_hover) draw_rectangle(btn_x1 + 2, btn2_y + 2, btn_x2 - 2, btn2_y + btn_h - 2, true);

    draw_set_halign(fa_left);
    draw_set_color(vigenere_hover ? c_yellow : c_white);
    draw_text_transformed(btn_x1 + 14, btn2_y + 14, "CHAPTER 2:  VIGENERE CIPHER", 0.96, 0.96, 0);
    draw_set_color(make_color_rgb(205, 165, 235));
    draw_text_transformed(btn_x1 + 14, btn2_y + 31, "Repeating Keyword Shifts (A=0, B=1...)  •  10 Floors", 0.78, 0.78, 0);

    draw_set_halign(fa_right);
    draw_set_color(c_lime);
    draw_text_transformed(btn_x2 - 14, btn2_y + 22, "PLAY >", 0.90, 0.90, 0);
} else {
    draw_set_color(make_color_rgb(20, 22, 30));
    draw_rectangle(btn_x1, btn2_y, btn_x2, btn2_y + btn_h, false);
    draw_set_color(make_color_rgb(60, 68, 82));
    draw_rectangle(btn_x1, btn2_y, btn_x2, btn2_y + btn_h, true);

    draw_set_halign(fa_left);
    draw_set_color(make_color_rgb(120, 130, 148));
    draw_text_transformed(btn_x1 + 14, btn2_y + 14, "CHAPTER 2:  VIGENERE CIPHER  [LOCKED]", 0.92, 0.92, 0);
    draw_set_color(make_color_rgb(95, 105, 122));
    draw_text_transformed(btn_x1 + 14, btn2_y + 31, "Pass Chapter 1 Final Exam (Floor 10) to unlock", 0.76, 0.76, 0);
}

// --- CHAPTER 3 BUTTON: ATBASH CIPHER ---
if (_atb_unlocked) {
    draw_set_color(atbash_hover ? make_color_rgb(20, 48, 38) : make_color_rgb(14, 28, 24));
    draw_rectangle(btn_x1, btn3_y, btn_x2, btn3_y + btn_h, false);
    draw_set_color(atbash_hover ? c_yellow : make_color_rgb(75, 225, 145));
    draw_rectangle(btn_x1, btn3_y, btn_x2, btn3_y + btn_h, true);
    if (atbash_hover) draw_rectangle(btn_x1 + 2, btn3_y + 2, btn_x2 - 2, btn3_y + btn_h - 2, true);

    draw_set_halign(fa_left);
    draw_set_color(atbash_hover ? c_yellow : c_white);
    draw_text_transformed(btn_x1 + 14, btn3_y + 14, "CHAPTER 3:  ATBASH CIPHER", 0.96, 0.96, 0);
    draw_set_color(make_color_rgb(155, 225, 185));
    draw_text_transformed(btn_x1 + 14, btn3_y + 31, "Alphabet Mirror Reflection (A <-> Z)  •  10 Floors", 0.78, 0.78, 0);

    draw_set_halign(fa_right);
    draw_set_color(c_lime);
    draw_text_transformed(btn_x2 - 14, btn3_y + 22, "PLAY >", 0.90, 0.90, 0);
} else {
    draw_set_color(make_color_rgb(20, 22, 30));
    draw_rectangle(btn_x1, btn3_y, btn_x2, btn3_y + btn_h, false);
    draw_set_color(make_color_rgb(60, 68, 82));
    draw_rectangle(btn_x1, btn3_y, btn_x2, btn3_y + btn_h, true);

    draw_set_halign(fa_left);
    draw_set_color(make_color_rgb(120, 130, 148));
    draw_text_transformed(btn_x1 + 14, btn3_y + 14, "CHAPTER 3:  ATBASH CIPHER  [LOCKED]", 0.92, 0.92, 0);
    draw_set_color(make_color_rgb(95, 105, 122));
    draw_text_transformed(btn_x1 + 14, btn3_y + 31, "Pass Chapter 2 Final Exam (Floor 10) to unlock", 0.76, 0.76, 0);
}

// =========================================================================
// 4. INTERACTIVE FLOOR / PHASE SELECTOR PANEL (Bottom)
// =========================================================================
var _box_y1 = 246;
var _box_y2 = 342;
draw_set_color(make_color_rgb(14, 20, 34));
draw_rectangle(_cx - 210, _box_y1, _cx + 210, _box_y2, false);
draw_set_color(make_color_rgb(60, 105, 145));
draw_rectangle(_cx - 210, _box_y1, _cx + 210, _box_y2, true);

draw_set_halign(fa_center);
var _sel_y = 268;

// Left [<] button
draw_set_color(floor_prev_hover ? c_aqua : make_color_rgb(30, 44, 68));
draw_rectangle(_cx - 130, _sel_y - 12, _cx - 94, _sel_y + 12, false);
draw_set_color(c_aqua);
draw_rectangle(_cx - 130, _sel_y - 12, _cx - 94, _sel_y + 12, true);
draw_set_color(floor_prev_hover ? c_black : c_white);
draw_text(_cx - 112, _sel_y, "<");

// Right [>] button
draw_set_color(floor_next_hover ? c_aqua : make_color_rgb(30, 44, 68));
draw_rectangle(_cx + 94, _sel_y - 12, _cx + 130, _sel_y + 12, false);
draw_set_color(c_aqua);
draw_rectangle(_cx + 94, _sel_y - 12, _cx + 130, _sel_y + 12, true);
draw_set_color(floor_next_hover ? c_black : c_white);
draw_text(_cx + 112, _sel_y, ">");

// Center Selected Floor Label
var _phase_tag = "TUTORIAL (HAND-HOLDING)";
var _phase_col = c_aqua;
if (selected_floor >= 4 && selected_floor <= 6) {
    _phase_tag = "PRACTICE (DUOLINGO LOOP)";
    _phase_col = make_color_rgb(255, 210, 55);
} else if (selected_floor >= 7 && selected_floor <= 9) {
    _phase_tag = "MASTERY (NO HINTS)";
    _phase_col = make_color_rgb(255, 145, 50);
} else if (selected_floor == 10) {
    _phase_tag = "CHAPTER FINAL EXAM";
    _phase_col = make_color_rgb(255, 85, 155);
}

draw_set_color(c_white);
draw_text_transformed(_cx, _sel_y, "START FLOOR:  " + string(selected_floor) + " / 10", 0.95, 0.95, 0);

// 3 Quick-Jump Phase Pills
var _pill_y = 304;

// Pill 1: Floor 1 Tutorial
var _on_tut = (selected_floor <= 3);
draw_set_color(_on_tut ? make_color_rgb(16, 48, 64) : make_color_rgb(20, 26, 38));
draw_rectangle(_cx - 196, _pill_y - 11, _cx - 72, _pill_y + 11, false);
draw_set_color((_on_tut || preset_tut_hover) ? c_aqua : make_color_rgb(70, 90, 115));
draw_rectangle(_cx - 196, _pill_y - 11, _cx - 72, _pill_y + 11, true);
draw_text_transformed(_cx - 134, _pill_y, "FLR 1-3: TUTORIAL", 0.74, 0.74, 0);

// Pill 2: Floor 4 Practice
var _on_prc = (selected_floor >= 4 && selected_floor <= 9);
draw_set_color(_on_prc ? make_color_rgb(48, 40, 16) : make_color_rgb(20, 26, 38));
draw_rectangle(_cx - 62, _pill_y - 11, _cx + 62, _pill_y + 11, false);
draw_set_color((_on_prc || preset_prc_hover) ? make_color_rgb(255, 210, 55) : make_color_rgb(70, 90, 115));
draw_rectangle(_cx - 62, _pill_y - 11, _cx + 62, _pill_y + 11, true);
draw_text_transformed(_cx, _pill_y, "FLR 4-9: PRACTICE", 0.74, 0.74, 0);

// Pill 3: Floor 10 Final Exam
var _on_exm = (selected_floor == 10);
draw_set_color(_on_exm ? make_color_rgb(56, 18, 38) : make_color_rgb(20, 26, 38));
draw_rectangle(_cx + 72, _pill_y - 11, _cx + 196, _pill_y + 11, false);
draw_set_color((_on_exm || preset_exm_hover) ? make_color_rgb(255, 85, 155) : make_color_rgb(70, 90, 115));
draw_rectangle(_cx + 72, _pill_y - 11, _cx + 196, _pill_y + 11, true);
draw_text_transformed(_cx + 134, _pill_y, "FLR 10: FINAL EXAM", 0.74, 0.74, 0);

// Active Phase Intent Description at very bottom of box
draw_set_color(_phase_col);
draw_text_transformed(_cx, 329, "ACTIVE MODE:  " + _phase_tag, 0.78, 0.78, 0);

// Reset draw state
draw_set_font(fnt_default);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
