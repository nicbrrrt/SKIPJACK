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

// Top-left Homeroom button
var _home_hov = (_mx >= 92 && _mx <= 198 && _my >= 12 && _my <= 34);
draw_set_color(_home_hov ? make_color_rgb(65, 45, 25) : make_color_rgb(34, 24, 16));
draw_rectangle(92, 12, 198, 34, false);
draw_set_color(_home_hov ? c_yellow : make_color_rgb(205, 150, 90));
draw_rectangle(92, 12, 198, 34, true);
draw_set_color(_home_hov ? c_yellow : make_color_rgb(245, 215, 175));
draw_text_transformed(145, 23, "[H] HOMEROOM", 0.78, 0.78, 0);

// Top-left [?] GUIDE button (replays the 4-Step Chapter Select Tutorial)
var _g_hov = (_mx >= 206 && _mx <= 284 && _my >= 12 && _my <= 34);
draw_set_color(_g_hov ? make_color_rgb(24, 52, 68) : make_color_rgb(16, 30, 44));
draw_rectangle(206, 12, 284, 34, false);
draw_set_color(_g_hov ? c_aqua : make_color_rgb(75, 155, 195));
draw_rectangle(206, 12, 284, 34, true);
draw_set_color(_g_hov ? c_yellow : c_aqua);
draw_text_transformed(245, 23, "[?] GUIDE", 0.78, 0.78, 0);

// Top-right Demo Unlock All Toggle
var _all_unlocked = (variable_global_exists("unlock_all_ciphers") && global.unlock_all_ciphers);
draw_set_color(demo_unlock_hover ? make_color_rgb(40, 58, 40) : make_color_rgb(18, 26, 38));
draw_rectangle(_gw - 168, 12, _gw - 12, 34, false);
draw_set_color(_all_unlocked ? c_lime : (demo_unlock_hover ? c_yellow : make_color_rgb(80, 100, 130)));
draw_rectangle(_gw - 168, 12, _gw - 12, 34, true);
draw_text_transformed(_gw - 90, 23, _all_unlocked ? "[U / CTRL+U] ALL UNLOCKED" : "[U / CTRL+U] UNLOCK ALL", 0.72, 0.72, 0);

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

// =========================================================================
// 5. FIRST-TIME CHAPTER SELECTION SPOTLIGHT TUTORIAL OVERLAY (4 Steps)
// =========================================================================
if (variable_instance_exists(id, "tut_active") && tut_active) {
    var _sp_x1 = btn_x1 - 8;
    var _sp_y1 = btn1_y - 6;
    var _sp_x2 = btn_x2 + 8;
    var _sp_y2 = btn3_y + btn_h + 6;
    var _card_y1 = 248;
    var _card_y2 = 352;
    var _step_title = "";
    var _step_body  = "";

    if (tut_step == 0) {
        // Spotlight the 3 Encryption Chapters
        _sp_x1 = btn_x1 - 8;
        _sp_y1 = btn1_y - 6;
        _sp_x2 = btn_x2 + 8;
        _sp_y2 = btn3_y + btn_h + 6;
        _card_y1 = 246;
        _card_y2 = 352;
        _step_title = "WELCOME TO SKIPJACK — THE 3 ENCRYPTION CHAPTERS (1/4)";
        _step_body  = "Welcome aboard, Jack! Skipjack's campaign is divided into 3 Cryptography Chapters:\n• CHAPTER 1 (CAESAR): Shifts every letter by a fixed number (+K or -K).\n• CHAPTER 2 (VIGENERE): Shifts each letter using a repeating KEYWORD (A=+0, B=+1, C=+2...).\n• CHAPTER 3 (ATBASH): Reflects the alphabet in half like a mirror (A <-> Z, B <-> Y)!";
    } else if (tut_step == 1) {
        // Spotlight the Bottom 10-Floor Curriculum Selector
        _sp_x1 = _cx - 216;
        _sp_y1 = 242;
        _sp_x2 = _cx + 216;
        _sp_y2 = 346;
        _card_y1 = 84;
        _card_y2 = 194;
        _step_title = "10 FLOORS PER CHAPTER — TUTORIAL, PRACTICE & EXAM (2/4)";
        _step_body  = "Use this bottom selector to choose your starting floor (1 to 10) inside any Chapter:\n• FLOORS 1-3 (TUTORIAL): Full visual step-by-step demonstrations showing HOW to calibrate & decrypt!\n• FLOORS 4-9 (PRACTICE & MASTERY): Core detective cases & cipher locks as training wheels come off.\n• FLOOR 10 (FINAL EXAM): Pass Floor 10 to unlock the next Encryption Chapter!";
    } else if (tut_step == 2) {
        // Spotlight Top Bar ([H] Homeroom & [U] Demo Unlock)
        _sp_x1 = 88;
        _sp_y1 = 8;
        _sp_x2 = _gw - 8;
        _sp_y2 = 38;
        _card_y1 = 120;
        _card_y2 = 228;
        _step_title = "YOUR HOMEROOM [H] & DEMO SHORTCUTS [U / CTRL+U] (3/4)";
        _step_body  = "• [H] HOMEROOM: Visit your office between workdays to call Burt on the Wall Telephone and spend Scrap & Rare Cores on helpful desk statues!\n• [U / CTRL+U] UNLOCK ALL: Unlocks Chapters 2 & 3 immediately for testing or live demonstrations.\n• [?] GUIDE: Click '[?] GUIDE' in the top bar anytime you want to replay this menu walkthrough!";
    } else {
        // Spotlight Chapter 1: Caesar Cipher (Floor 1)
        _sp_x1 = btn_x1 - 8;
        _sp_y1 = btn1_y - 6;
        _sp_x2 = btn_x2 + 8;
        _sp_y2 = btn1_y + btn_h + 6;
        _card_y1 = 152;
        _card_y2 = 256;
        _step_title = "READY FOR YOUR FIRST SHIFT! (4/4)";
        _step_body  = "We've set your starting floor to FLOOR 1 (GUIDED TUTORIAL)!\nWhen you enter Floor 1, you'll get a live step-by-step visual demonstration showing exactly how to calibrate the Cipher Key and decode encrypted doors.\nClick CHAPTER 1: CAESAR CIPHER (PLAY >) right after this to begin!";
    }

    // 4-rectangle dark mask around the spotlighted region
    draw_set_alpha(0.78);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _sp_y1, false);
    draw_rectangle(0, _sp_y2, _gw, _gh, false);
    draw_rectangle(0, _sp_y1, _sp_x1, _sp_y2, false);
    draw_rectangle(_sp_x2, _sp_y1, _gw, _sp_y2, false);

    // Pulsing neon border around the spotlighted region
    var _pulse = 0.65 + 0.35 * sin(tut_anim_t * 0.12);
    draw_set_alpha(_pulse);
    draw_set_color(c_yellow);
    draw_rectangle(_sp_x1, _sp_y1, _sp_x2, _sp_y2, true);
    draw_rectangle(_sp_x1 - 2, _sp_y1 - 2, _sp_x2 + 2, _sp_y2 + 2, true);
    draw_set_alpha(1.0);

    // Kyle's Explanation Card
    var _card_x1 = 36;
    var _card_x2 = _gw - 36;
    draw_set_color(make_color_rgb(12, 18, 32));
    draw_rectangle(_card_x1, _card_y1, _card_x2, _card_y2, false);
    draw_set_color(c_aqua);
    draw_rectangle(_card_x1, _card_y1, _card_x2, _card_y2, true);
    draw_rectangle(_card_x1 + 2, _card_y1 + 2, _card_x2 - 2, _card_y2 - 2, true);

    // Draw Kyle Portrait on left side of card if sprite exists
    var _txt_x = _card_x1 + 16;
    if (sprite_exists(spr_kyle_portrait)) {
        var _px = _card_x1 + 12;
        var _py = _card_y1 + 24;
        draw_set_color(make_color_rgb(230, 238, 248));
        draw_rectangle(_px, _py, _px + 52, _py + 52, false);
        var _psw = sprite_get_width(spr_kyle_portrait);
        var _psh = sprite_get_height(spr_kyle_portrait);
        var _psc = min(50 / _psw, 50 / _psh);
        draw_sprite_ext(spr_kyle_portrait, 0, _px + (52 - _psw * _psc) * 0.5, _py + (52 - _psh * _psc) * 0.5, _psc, _psc, 0, c_white, 1.0);
        draw_set_color(make_color_rgb(255, 205, 55));
        draw_rectangle(_px, _py, _px + 52, _py + 52, true);
        _txt_x = _card_x1 + 74;
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(make_color_rgb(255, 215, 65));
    draw_text_transformed(_txt_x, _card_y1 + 8, _step_title, 0.78, 0.78, 0);

    draw_set_color(c_white);
    var _wrap_w = (_card_x2 - _txt_x - 14) / 0.68;
    draw_text_ext_transformed(_txt_x, _card_y1 + 25, _step_body, 14, _wrap_w, 0.68, 0.68, 0);

    draw_set_halign(fa_right);
    draw_set_valign(fa_middle);
    draw_set_color(c_lime);
    var _next_lbl = (tut_step < 3) ? "[E / ENTER / CLICK] NEXT >" : "[E / ENTER / CLICK] GOT IT — LET'S PLAY!";
    draw_text_transformed(_card_x2 - 12, _card_y2 - 11, _next_lbl, 0.74, 0.74, 0);

    draw_set_halign(fa_left);
    draw_set_color(make_color_rgb(160, 180, 205));
    draw_text_transformed(_txt_x, _card_y2 - 11, "[ESC] Skip Guide", 0.68, 0.68, 0);
}

// Reset draw state
draw_set_font(fnt_default);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
