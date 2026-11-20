/// @description obj_caesar_key_pedestal — Draw GUI Event
/// Renders Tiered Chapter Key Calibration across Floors 1-10 (Guided, Known-Plaintext, Mastery/Exam).

if (!ui_open) exit;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _sx = (shake_timer > 0) ? irandom_range(-4, 4) : 0;
var _sy = (shake_timer > 0) ? irandom_range(-4, 4) : 0;
var _cx = (_gui_w * 0.5) + _sx;
var _cy = (_gui_h * 0.5) + _sy;

var _ch      = variable_global_exists("dungeon_chapter")      ? global.dungeon_chapter      : CHAPTER_CAESAR;
var _flr     = variable_global_exists("chapter_floor")        ? global.chapter_floor        : 1;
var _vig_key = variable_global_exists("dungeon_vigenere_key") ? global.dungeon_vigenere_key : "CAB";
var _clues   = variable_global_exists("clues_found")          ? global.clues_found          : 0;
var _tier    = (_flr <= 3) ? 1 : ((_flr <= 6) ? 2 : 3);
var _guided  = (_tier == 1);

// 1. Grey out background
draw_set_alpha(0.84);
draw_set_color(c_black);
draw_rectangle(0, 0, _gui_w, _gui_h, false);

// 2. Compact Cryptanalysis Panel
var _pw = 540;
var _ph = 256;
var _x1 = _cx - _pw * 0.5;
var _y1 = _cy - _ph * 0.5;
var _x2 = _cx + _pw * 0.5;
var _y2 = _cy + _ph * 0.5;

draw_set_alpha(0.96);
draw_set_color(make_color_rgb(14, 20, 32));
draw_rectangle(_x1, _y1, _x2, _y2, false);
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(255, 205, 45));
draw_rectangle(_x1, _y1, _x2, _y2, true);
draw_rectangle(_x1 + 3, _y1 + 3, _x2 - 3, _y2 - 3, true);

draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Header & Tier-Specific Sub-Line
var _hdr_title = "FIND THE CAESAR SHIFT KEY";
var _sub_line  = "Slide the dial until '" + sample_enc + "' lands on '" + sample_plain + "'";

if (_ch == CHAPTER_CAESAR) {
    if (_tier == 1) {
        var _t_disp = (target_shift > 0) ? ("+" + string(target_shift)) : string(target_shift);
        _hdr_title = "GUIDED CALIBRATION — CAESAR SHIFT (" + _t_disp + ")";
        _sub_line  = "Slide the dial until '" + sample_enc + "' lands on '" + sample_plain + "' (Shift " + _t_disp + ")";
    } else if (_tier == 2) {
        _hdr_title = "KNOWN-PLAINTEXT DEDUCTION (CAESAR CIPHER)";
        _sub_line  = "Captured Header: '" + kpt_cipher_word + "' -> '" + kpt_plain_word + "'  (Align '" + sample_enc + "' -> '" + sample_plain + "' on Ruler)";
    } else {
        _hdr_title = (_flr >= 10) ? "FINAL EXAM — QUICK-CYCLE BRUTE-FORCE DIAL" : "CRYPTANALYSIS — QUICK-CYCLE BRUTE-FORCE DIAL";
        _sub_line  = "Cycle [LEFT / RIGHT] across all 26 shifts until '" + kpt_cipher_word + "' forms a real English word!";
    }
} else if (_ch == CHAPTER_VIGENERE) {
    if (_tier == 1) {
        var _kw_breakdown = "";
        for (var _ki = 1; _ki <= string_length(_vig_key); _ki++) {
            var _kch = string_char_at(_vig_key, _ki);
            var _ksh = ord(_kch) - ord("A");
            _kw_breakdown += ((_ki > 1) ? "  •  " : "") + _kch + "=+" + string(_ksh);
        }
        _hdr_title = "GUIDED VIGENERE KEYWORD ('" + _vig_key + "'  |  " + _kw_breakdown + ")";
        _sub_line  = "Match 1st Keyword Letter: Slide until '" + sample_enc + "' lands on '" + sample_plain + "'";
    } else if (_tier == 2) {
        _hdr_title = "KNOWN-PLAINTEXT DEDUCTION (VIGENERE CIPHER)";
        _sub_line  = "Captured Header: '" + kpt_cipher_word + "' -> '" + kpt_plain_word + "'  (Align 1st Letter '" + sample_enc + "' -> '" + sample_plain + "')";
    } else {
        if (_clues >= 1) {
            _hdr_title = "PHASE 1 INTEL RECOVERED — KEYWORD: '" + _vig_key + "'";
            _sub_line  = "Security Terminal Intel: Set 1st Keyword Letter '" + string_char_at(_vig_key, 1) + "' (Shift +" + string(target_shift) + ") on Dial!";
        } else {
            _hdr_title = "VIGENERE KEYWORD: [REDACTED — SCAN SECURITY SECTOR PC]";
            _sub_line  = "Scan Phase 1 Security PC for Keyword, or deduce 1st letter from '" + kpt_cipher_word + "' -> '" + kpt_plain_word + "'!";
        }
    }
} else if (_ch == CHAPTER_ATBASH) {
    if (_tier == 1) {
        _hdr_title = "GUIDED ATBASH MIRROR (A <-> Z, B <-> Y)";
        _sub_line  = "Look at the 2-Row Mirror Bar: Match top letter '" + sample_enc + "' to its bottom mirror '" + sample_plain + "'";
    } else if (_tier == 2) {
        _hdr_title = "KNOWN-PLAINTEXT DEDUCTION (ATBASH MIRROR)";
        _sub_line  = "Captured Header: '" + kpt_cipher_word + "' -> '" + kpt_plain_word + "'  (Match '" + sample_enc + "' -> '" + sample_plain + "' on Mirror Bar)";
    } else {
        _hdr_title = (_flr >= 10) ? "FINAL EXAM — REPAIR CORRUPTED ATBASH MIRROR STRIP" : "CRYPTANALYSIS — REPAIR 3 MISSING MIRROR ANCHORS";
        _sub_line  = "Use [A/D] to pick Anchor Slot and [W/S] to set the 3 mirror letters (A<->Z, E<->V, M<->N)!";
    }
}

draw_set_color(make_color_rgb(255, 215, 55));
draw_text_transformed(_cx, _y1 + 20, _hdr_title, 0.84, 0.84, 0);
draw_set_color(make_color_rgb(190, 210, 235));
draw_text_transformed(_cx, _y1 + 42, _sub_line, 0.72, 0.72, 0);

// 3. Visual A-Z Alphabet Ruler (or 2-Row Mirror Bar in Chapter 3 Atbash)
var _enc_idx    = ord(sample_enc) - ord("A");
var _plain_idx  = ord(sample_plain) - ord("A");
var _landed_ch  = (_ch == CHAPTER_ATBASH)
    ? chr(ord("Z") - dial_shift)
    : scr_caesar_encode(sample_enc, dial_shift);
var _landed_idx = ord(_landed_ch) - ord("A");
var _aligned    = (_landed_ch == sample_plain);
var _hide_target_on_ruler = (_tier == 3 && _ch == CHAPTER_CAESAR && !_aligned);

if (_ch == CHAPTER_ATBASH) {
    scr_draw_atbash_mirror_bar(_cx, _y1 + 70, _enc_idx, _landed_idx, _plain_idx, (_tier <= 2), _aligned ? c_lime : c_aqua);
} else {
    var _strip_y  = _y1 + 82;
    var _cell_w   = 20;
    var _strip_w  = 26 * _cell_w;
    var _strip_x1 = _cx - _strip_w * 0.5;

    draw_set_color(make_color_rgb(20, 26, 40));
    draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, false);
    draw_set_color(make_color_rgb(70, 90, 125));
    draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, true);

    for (var _a = 0; _a < 26; _a++) {
        var _lx = _strip_x1 + _a * _cell_w + _cell_w * 0.5;
        var _ch_lbl = chr(ord("A") + _a);

        if (_a == _landed_idx) {
            draw_set_color(_aligned ? c_lime : c_aqua);
            draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, false);
            draw_set_color(c_black);
            draw_text(_lx, _strip_y, _ch_lbl);
        } else if (_a == _enc_idx) {
            draw_set_color(make_color_rgb(255, 190, 40));
            draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, false);
            draw_set_color(c_black);
            draw_text(_lx, _strip_y, _ch_lbl);
        } else if (_a == _plain_idx && !_hide_target_on_ruler) {
            draw_set_color(c_lime);
            draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, true);
            draw_rectangle(_lx - 8, _strip_y - 11, _lx + 8, _strip_y + 11, true);
            draw_text(_lx, _strip_y, _ch_lbl);
        } else {
            draw_set_color(make_color_rgb(160, 175, 200));
            draw_text_transformed(_lx, _strip_y, _ch_lbl, 0.85, 0.85, 0);
        }
    }
    if (_guided) {
        scr_draw_tutorial_ruler_hops(_strip_x1, _strip_y, _cell_w, _enc_idx, target_shift);
    }
}

// 4. Bottom Interactive Section (Adapts by Tier & Chapter)
var _cards_y  = _y1 + 148;
var _dial_str = (dial_shift > 0) ? ("+" + string(dial_shift)) : string(dial_shift);

if (_ch == CHAPTER_ATBASH && _tier == 3) {
    // Tier 3 Atbash: 3 Interactive Mirror Anchor Slots (A<->Z, E<->V, M<->N)
    var _anc_x = [_cx - 150, _cx, _cx + 150];
    var _anc_hints = ["1st <-> 26th", "5th <-> 22nd", "13th <-> 14th"];
    var _all_anc_ok = true;
    for (var _ai = 0; _ai < 3; _ai++) {
        var _ax  = _anc_x[_ai];
        var _sel = (atbash_anchor_slot == _ai);
        var _ok  = (atbash_anchor_guess[_ai] == atbash_anchor_target[_ai]);
        if (!_ok) _all_anc_ok = false;

        draw_set_color(_sel ? make_color_rgb(22, 44, 68) : make_color_rgb(16, 24, 38));
        draw_rectangle(_ax - 64, _cards_y - 26, _ax + 64, _cards_y + 26, false);
        draw_set_color(_ok ? c_lime : (_sel ? c_yellow : make_color_rgb(75, 115, 155)));
        draw_rectangle(_ax - 64, _cards_y - 26, _ax + 64, _cards_y + 26, true);

        draw_set_color(make_color_rgb(180, 215, 245));
        draw_text_transformed(_ax, _cards_y - 13, "ANCHOR " + string(_ai + 1) + " (" + _anc_hints[_ai] + ")", 0.56, 0.56, 0);
        draw_set_color(_ok ? c_lime : c_white);
        draw_text_transformed(_ax, _cards_y + 8, atbash_anchor_top[_ai] + "  <->  [ " + atbash_anchor_guess[_ai] + " ]", 0.92, 0.92, 0);
    }
    _aligned = _all_anc_ok;
} else if (_ch == CHAPTER_CAESAR && _tier == 3) {
    // Tier 3 Caesar: 3-Card Quick-Cycle Brute-Force Word Decoder
    var _live_word = scr_caesar_encode(kpt_cipher_word, dial_shift);

    draw_set_color(make_color_rgb(38, 32, 16));
    draw_rectangle(_cx - 210, _cards_y - 24, _cx - 84, _cards_y + 24, false);
    draw_set_color(make_color_rgb(255, 195, 45));
    draw_rectangle(_cx - 210, _cards_y - 24, _cx - 84, _cards_y + 24, true);
    draw_text_transformed(_cx - 147, _cards_y - 11, "CIPHERTEXT", 0.68, 0.68, 0);
    draw_set_color(c_white);
    draw_text_transformed(_cx - 147, _cards_y + 8, kpt_cipher_word, 0.95, 0.95, 0);

    draw_set_color(make_color_rgb(18, 30, 46));
    draw_rectangle(_cx - 72, _cards_y - 26, _cx + 72, _cards_y + 26, false);
    draw_set_color(_aligned ? c_lime : c_aqua);
    draw_rectangle(_cx - 72, _cards_y - 26, _cx + 72, _cards_y + 26, true);
    draw_text_transformed(_cx, _cards_y - 11, "QUICK-CYCLE", 0.70, 0.70, 0);
    draw_set_color(c_white);
    draw_text_transformed(_cx, _cards_y + 8, "< " + _dial_str + " >", 1.02, 1.02, 0);

    draw_set_color(make_color_rgb(16, 38, 28));
    draw_rectangle(_cx + 84, _cards_y - 24, _cx + 210, _cards_y + 24, false);
    draw_set_color(_aligned ? c_lime : c_aqua);
    draw_rectangle(_cx + 84, _cards_y - 24, _cx + 210, _cards_y + 24, true);
    draw_text_transformed(_cx + 147, _cards_y - 11, "LIVE PREVIEW", 0.68, 0.68, 0);
    draw_set_color(_aligned ? c_lime : c_white);
    draw_text_transformed(_cx + 147, _cards_y + 8, _live_word, 0.95, 0.95, 0);
} else {
    // Standard 3-Card Single-Letter Calibration ([ START ] + [ DIAL ] = [ TARGET ])
    var _mid_lbl = "SHIFT KEY";
    if (_ch == CHAPTER_VIGENERE) {
        var _kw_letter = chr(ord("A") + dial_shift);
        _mid_lbl  = "KEY LETTER";
        _dial_str = _kw_letter + " (+" + string(dial_shift) + ")";
    } else if (_ch == CHAPTER_ATBASH) {
        _mid_lbl  = "MIRROR STEP";
        _dial_str = _landed_ch + " (-" + string(dial_shift) + ")";
    }

    draw_set_color(make_color_rgb(38, 32, 16));
    draw_rectangle(_cx - 190, _cards_y - 24, _cx - 90, _cards_y + 24, false);
    draw_set_color(make_color_rgb(255, 195, 45));
    draw_rectangle(_cx - 190, _cards_y - 24, _cx - 90, _cards_y + 24, true);
    draw_text_transformed(_cx - 140, _cards_y - 11, "START", 0.72, 0.72, 0);
    draw_set_color(c_white);
    draw_text_transformed(_cx - 140, _cards_y + 8, sample_enc, 1.15, 1.15, 0);

    draw_set_color(make_color_rgb(18, 30, 46));
    draw_rectangle(_cx - 72, _cards_y - 26, _cx + 72, _cards_y + 26, false);
    draw_set_color(_aligned ? c_lime : c_aqua);
    draw_rectangle(_cx - 72, _cards_y - 26, _cx + 72, _cards_y + 26, true);
    draw_text_transformed(_cx, _cards_y - 11, _mid_lbl, 0.75, 0.75, 0);
    draw_set_color(c_white);
    draw_text_transformed(_cx, _cards_y + 8, "< " + _dial_str + " >", 1.05, 1.05, 0);

    draw_set_color(make_color_rgb(16, 38, 28));
    draw_rectangle(_cx + 90, _cards_y - 24, _cx + 190, _cards_y + 24, false);
    draw_set_color(c_lime);
    draw_rectangle(_cx + 90, _cards_y - 24, _cx + 190, _cards_y + 24, true);
    draw_text_transformed(_cx + 140, _cards_y - 11, "TARGET", 0.72, 0.72, 0);
    draw_set_color(c_white);
    draw_text_transformed(_cx + 140, _cards_y + 8, sample_plain, 1.15, 1.15, 0);
}

// 5. Guided Tutorial Hint & Status Footer
if (status_msg != "") {
    draw_set_color(status_col);
    draw_text_transformed(_cx, _y2 - 42, status_msg, 0.80, 0.80, 0);
} else if (_aligned) {
    draw_set_color(c_lime);
    draw_text_transformed(_cx, _y2 - 42, "MATCH! Press [ENTER] to save Key!", 0.90, 0.90, 0);
} else if (_guided) {
    var _dir_hint = (target_shift > dial_shift) ? "[RIGHT]" : "[LEFT]";
    var _t_str    = (target_shift > 0) ? ("+" + string(target_shift)) : string(target_shift);
    if (_ch == CHAPTER_VIGENERE) _t_str = chr(ord("A") + target_shift) + " (+" + string(target_shift) + ")";
    if (_ch == CHAPTER_ATBASH)   _t_str = sample_plain;
    draw_set_color(c_aqua);
    draw_text_transformed(_cx, _y2 - 42, "STEP-BY-STEP: Count from Amber '" + sample_enc + "' to Green '" + sample_plain + "' -> Press " + _dir_hint + " to reach " + _t_str + "!   [TAB: How to Solve]", 0.72, 0.72, 0);
} else if (_tier == 2) {
    draw_set_color(make_color_rgb(180, 215, 245));
    draw_text_transformed(_cx, _y2 - 42, "KNOWN-PLAINTEXT: Align Amber '" + sample_enc + "' (from '" + kpt_cipher_word + "') with Green '" + sample_plain + "' (from '" + kpt_plain_word + "')!", 0.72, 0.72, 0);
} else if (_tier == 3 && _ch == CHAPTER_CAESAR) {
    draw_set_color(make_color_rgb(180, 215, 245));
    draw_text_transformed(_cx, _y2 - 42, "BRUTE-FORCE: Cycle [LEFT / RIGHT] until LIVE PREVIEW forms a real 5-letter English word, then press [ENTER]!", 0.70, 0.70, 0);
} else if (_tier == 3 && _ch == CHAPTER_ATBASH) {
    draw_set_color(make_color_rgb(180, 215, 245));
    draw_text_transformed(_cx, _y2 - 42, "MIRROR REPAIR: [A/D] Select Anchor   |   [W/S] Cycle Letter (A<->Z, E<->V, M<->N)   |   [ENTER] Lock In", 0.70, 0.70, 0);
}

draw_set_color(make_color_rgb(150, 170, 195));
var _footer_ctrl = "[LEFT / RIGHT] Turn Dial   |   [ENTER] Confirm   |   [ESC] Back";
if (_guided) _footer_ctrl = "[LEFT / RIGHT] Turn Dial   |   [ENTER] Confirm   |   [TAB] How to Solve   |   [ESC] Back";
if (_ch == CHAPTER_ATBASH && _tier == 3) _footer_ctrl = "[A/D] Select Anchor   |   [W/S] Cycle Mirror Letter   |   [ENTER] Confirm   |   [ESC] Back";
draw_text_transformed(_cx, _y2 - 16, _footer_ctrl, 0.76, 0.76, 0);

// 6. Full Visual "HOW TO CALIBRATE" Demonstration Modal (Tutorial Floors 1-3)
if (_guided && variable_instance_exists(id, "demo_modal_open") && demo_modal_open) {
    scr_draw_tutorial_how_to_solve_modal(_gui_w, _gui_h, "pedestal", _ch, sample_enc, sample_plain, target_shift, _vig_key, 1);
}

draw_set_font(fnt_default);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);
