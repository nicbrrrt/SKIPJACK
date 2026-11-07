/// @description obj_cipher — Draw GUI Event
/// Renders the Chapter Cipher Door Lock UI (Caesar, Vigenere, or Atbash)
/// with 3-tier pedagogical scaffolding:
///   - Floors 1-3 (Guided Tutorial): Highlights the exact target answer on the ruler
///   - Floors 4-6 (Practice): Full ruler + green shift-match confirmation under each slot
///   - Floors 7-10 (Mastery / Final Exam): Hides green shift-match preview (and masks Atbash row)

draw_set_font(fnt_dialogue);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var gui_width  = display_get_gui_width();
var gui_height = display_get_gui_height();

var shake_x = (shake_timer > 0) ? irandom_range(-5, 5) : 0;
var shake_y = (shake_timer > 0) ? irandom_range(-5, 5) : 0;

var center_x = (gui_width * 0.5) + shake_x;
var center_y = (gui_height * 0.5) + shake_y;

// --- 1. GREY OUT FULL SCREEN BACKDROP & DRAW CIPHER PANEL ---
if (!instance_exists(obj_battle)) {
    draw_set_alpha(0.82);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gui_width, gui_height, false);
}

var _pw  = 556;
var _ph  = 288;
var _px1 = center_x - _pw * 0.5;
var _py1 = center_y - _ph * 0.5;
var _px2 = center_x + _pw * 0.5;
var _py2 = center_y + _ph * 0.5;

var _border_col = make_color_rgb(255, 85, 145);
if (is_holding_lock)                    _border_col = make_color_rgb(255, 135, 40);
else if (chapter_mode == CHAPTER_VIGENERE) _border_col = make_color_rgb(195, 95, 245);
else if (chapter_mode == CHAPTER_ATBASH)   _border_col = make_color_rgb(75, 225, 145);

draw_set_alpha(0.96);
draw_set_color(make_color_rgb(14, 18, 30));
draw_rectangle(_px1, _py1, _px2, _py2, false);
draw_set_alpha(1.0);
draw_set_color(_border_col);
draw_rectangle(_px1, _py1, _px2, _py2, true);
draw_rectangle(_px1 + 3, _py1 + 3, _px2 - 3, _py2 - 3, true);

// --- 2. CLEAN HEADER & KEY BADGE PILL ---
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _has_key = instance_exists(obj_battle)
            || (!is_holding_lock && variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key);

var _title_str = "CAESAR CIPHER LOCK";
if (instance_exists(obj_battle)) {
    var mode = variable_instance_exists(obj_battle, "cipher_mode") ? obj_battle.cipher_mode : "first";
    _title_str = (mode == "first") ? "DECRYPT SHIELD" : "UNCORRUPT PACKET";
} else if (is_holding_lock) {
    _title_str = "HOLDING CELL LOCK";
} else if (is_final_exam && is_elevator_lock) {
    _title_str = "FINAL EXAM ELEVATOR LOCK  [NO HINTS]";
} else if (chapter_mode == CHAPTER_VIGENERE) {
    _title_str = "VIGENERE KEYWORD LOCK";
} else if (chapter_mode == CHAPTER_ATBASH) {
    _title_str = "ATBASH MIRROR LOCK";
}

draw_set_color(_border_col);
draw_text_transformed(center_x, _py1 + 19, _title_str, 1.02, 1.02, 0);

// Compact Key Pill
var _pill_y = _py1 + 43;
draw_set_color(make_color_rgb(22, 30, 48));
draw_rectangle(center_x - 145, _pill_y - 11, center_x + 145, _pill_y + 11, false);

if (_has_key) {
    draw_set_color(c_lime);
    draw_rectangle(center_x - 145, _pill_y - 11, center_x + 145, _pill_y + 11, true);
    if (chapter_mode == CHAPTER_VIGENERE) {
        draw_text_transformed(center_x, _pill_y, "KEYWORD:  " + vigenere_key + "   (A=+0, B=+1, C=+2...)", 0.84, 0.84, 0);
    } else if (chapter_mode == CHAPTER_ATBASH) {
        draw_text_transformed(center_x, _pill_y, "MIRROR RULE:  A <-> Z,  B <-> Y ... M <-> N", 0.84, 0.84, 0);
    } else {
        var _k_str = (key > 0) ? ("+" + string(key)) : string(key);
        draw_text_transformed(center_x, _pill_y, "SHIFT KEY:  " + _k_str, 0.90, 0.90, 0);
    }
} else if (is_holding_lock) {
    draw_set_color(make_color_rgb(255, 200, 55));
    draw_rectangle(center_x - 145, _pill_y - 11, center_x + 145, _pill_y + 11, true);
    draw_text_transformed(center_x, _pill_y, "KEY: ???  (Check Cell PC / Note)", 0.84, 0.84, 0);
} else {
    draw_set_color(make_color_rgb(255, 190, 55));
    draw_rectangle(center_x - 145, _pill_y - 11, center_x + 145, _pill_y + 11, true);
    draw_text_transformed(center_x, _pill_y, "KEY: ???  (Unlock Gold Key Vault)", 0.84, 0.84, 0);
}

// Active slot letters
var _active_enc_ch    = string_char_at(encrypted, current_slot + 1);
var _active_enc_idx   = ord(_active_enc_ch) - ord("A");
var _active_usr_ch    = player_input[current_slot];
var _active_usr_idx   = (_active_usr_ch != "") ? (ord(_active_usr_ch) - ord("A")) : -1;
var _active_plain_ch  = string_char_at(plaintext, current_slot + 1);
var _active_plain_idx = ord(_active_plain_ch) - ord("A");

// --- 3. VISUAL RULER (Single A-Z Strip for Caesar/Vigenere OR 2-Row Mirror Bar for Atbash) ---
if (chapter_mode == CHAPTER_ATBASH) {
    var _m_y1     = _py1 + 72;
    var _m_y2     = _py1 + 98;
    var _m_cell_w = 36;
    var _m_tot_w  = 13 * _m_cell_w;
    var _m_x1     = center_x - _m_tot_w * 0.5;

    draw_set_color(make_color_rgb(20, 28, 42));
    draw_rectangle(_m_x1 - 6, _m_y1 - 12, _m_x1 + _m_tot_w + 6, _m_y2 + 12, false);
    draw_set_color(make_color_rgb(70, 125, 105));
    draw_rectangle(_m_x1 - 6, _m_y1 - 12, _m_x1 + _m_tot_w + 6, _m_y2 + 12, true);

    for (var _m = 0; _m < 13; _m++) {
        var _mx       = _m_x1 + _m * _m_cell_w + _m_cell_w * 0.5;
        var _top_idx  = _m;          // A..M (0..12)
        var _bot_idx  = 25 - _m;     // Z..N (25..13)
        var _top_ch   = chr(ord("A") + _top_idx);
        var _bot_ch   = chr(ord("A") + _bot_idx);

        // On Mastery (Floors 7-9) mask alternating bottom letters; on Final Exam (Floor 10) mask inner bottom letters
        var _mask_bot = false;
        if (is_final_exam && _m > 0 && _m < 12) {
            _mask_bot = true;
        } else if (hide_shift_match && (_m mod 2 == 1)) {
            _mask_bot = true;
        }

        // Top Row Cell (A..M)
        if (_top_idx == _active_usr_idx) {
            draw_set_color(c_lime);
            draw_rectangle(_mx - 11, _m_y1 - 10, _mx + 11, _m_y1 + 10, false);
            draw_set_color(c_black);
            draw_text_transformed(_mx, _m_y1, _top_ch, 0.85, 0.85, 0);
        } else if (_top_idx == _active_enc_idx) {
            draw_set_color(make_color_rgb(255, 190, 40));
            draw_rectangle(_mx - 11, _m_y1 - 10, _mx + 11, _m_y1 + 10, false);
            draw_set_color(c_black);
            draw_text_transformed(_mx, _m_y1, _top_ch, 0.85, 0.85, 0);
        } else if (guided_ui && _has_key && _top_idx == _active_plain_idx) {
            draw_set_color(c_lime);
            draw_rectangle(_mx - 11, _m_y1 - 10, _mx + 11, _m_y1 + 10, true);
            draw_text_transformed(_mx, _m_y1, _top_ch, 0.85, 0.85, 0);
        } else {
            draw_set_color(make_color_rgb(165, 215, 190));
            draw_text_transformed(_mx, _m_y1, _top_ch, 0.82, 0.82, 0);
        }

        // Bottom Row Cell (Z..N)
        var _bot_disp = _mask_bot ? "?" : _bot_ch;
        if (_bot_idx == _active_usr_idx && !_mask_bot) {
            draw_set_color(c_lime);
            draw_rectangle(_mx - 11, _m_y2 - 10, _mx + 11, _m_y2 + 10, false);
            draw_set_color(c_black);
            draw_text_transformed(_mx, _m_y2, _bot_disp, 0.85, 0.85, 0);
        } else if (_bot_idx == _active_enc_idx && !_mask_bot) {
            draw_set_color(make_color_rgb(255, 190, 40));
            draw_rectangle(_mx - 11, _m_y2 - 10, _mx + 11, _m_y2 + 10, false);
            draw_set_color(c_black);
            draw_text_transformed(_mx, _m_y2, _bot_disp, 0.85, 0.85, 0);
        } else if (guided_ui && _has_key && _bot_idx == _active_plain_idx) {
            draw_set_color(c_lime);
            draw_rectangle(_mx - 11, _m_y2 - 10, _mx + 11, _m_y2 + 10, true);
            draw_text_transformed(_mx, _m_y2, _bot_ch, 0.85, 0.85, 0);
        } else {
            draw_set_color(_mask_bot ? c_gray : make_color_rgb(230, 210, 120));
            draw_text_transformed(_mx, _m_y2, _bot_disp, 0.82, 0.82, 0);
        }
    }
} else {
    var _strip_y  = _py1 + 80;
    var _cell_w   = 20;
    var _strip_w  = 26 * _cell_w;
    var _strip_x1 = center_x - _strip_w * 0.5;

    draw_set_color(make_color_rgb(22, 28, 44));
    draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, false);
    draw_set_color(make_color_rgb(70, 90, 125));
    draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, true);

    for (var _a = 0; _a < 26; _a++) {
        var _lx = _strip_x1 + _a * _cell_w + _cell_w * 0.5;
        var _ch = chr(ord("A") + _a);

        if (_a == _active_usr_idx) {
            draw_set_color(c_lime);
            draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, false);
            draw_set_color(c_black);
            draw_text(_lx, _strip_y, _ch);
        } else if (_a == _active_enc_idx) {
            draw_set_color(make_color_rgb(255, 185, 40));
            draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, false);
            draw_set_color(c_black);
            draw_text(_lx, _strip_y, _ch);
        } else if (guided_ui && _has_key && _a == _active_plain_idx) {
            // Guided Tutorial Mode (Floors 1-3): Highlight the exact target answer in green!
            draw_set_color(c_lime);
            draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, true);
            draw_rectangle(_lx - 8, _strip_y - 11, _lx + 8, _strip_y + 11, true);
            draw_text(_lx, _strip_y, _ch);
        } else {
            draw_set_color(make_color_rgb(160, 175, 200));
            draw_text_transformed(_lx, _strip_y, _ch, 0.85, 0.85, 0);
        }
    }
}

// --- 4. ENCRYPTED WORD & DECODING SLOTS ---
var slot_width        = 48;
var slot_gap          = (letters_len == 5) ? 20 : 26;
var total_slots_width = (slot_width * letters_len) + (slot_gap * (letters_len - 1));
var slots_start_x     = center_x - (total_slots_width * 0.5) + (slot_width * 0.5);
var slots_y           = _py1 + 174;

for (var i = 0; i < letters_len; i++) {
    var slot_center_x = slots_start_x + (i * (slot_width + slot_gap));
    var slot_center_y = slots_y;
    var _slot_enc_ch  = string_char_at(encrypted, i + 1);

    // In Chapter 2 (Vigenere), show each slot's repeating Keyword letter & shift badge above the encrypted letter!
    if (chapter_mode == CHAPTER_VIGENERE && _has_key) {
        var _kw_len = string_length(vigenere_key);
        var _kw_ch  = string_char_at(vigenere_key, (i mod _kw_len) + 1);
        var _kw_sh  = slot_shifts[i];
        draw_set_color(make_color_rgb(215, 130, 255));
        draw_text_transformed(slot_center_x, slot_center_y - 54, _kw_ch + " (+" + string(_kw_sh) + ")", 0.72, 0.72, 0);
    }

    // Encrypted Letter above slot + small arrow
    draw_set_color((i == current_slot) ? make_color_rgb(255, 205, 50) : make_color_rgb(175, 190, 210));
    draw_text(slot_center_x, slot_center_y - 38, _slot_enc_ch);
    draw_set_color(c_gray);
    draw_text_transformed(slot_center_x, slot_center_y - 25, "v", 0.72, 0.72, 0);

    // Slot box
    if (i == current_slot) {
        draw_sprite(spr_slot_active, 0, slot_center_x, slot_center_y);
    } else {
        draw_sprite(spr_slot, 0, slot_center_x, slot_center_y);
    }

    // Decoded Letter + concise Shift/Mirror indicator below
    if (player_input[i] != "") {
        draw_set_color(c_white);
        draw_text(slot_center_x, slot_center_y, player_input[i]);

        if (chapter_mode == CHAPTER_ATBASH) {
            var _is_mirror = (player_input[i] == scr_atbash_decode(_slot_enc_ch));
            // On Mastery/Exam floors (hide_shift_match), don't spoil green match before submitting
            draw_set_color((!hide_shift_match && _has_key && _is_mirror) ? c_lime : make_color_rgb(170, 190, 215));
            draw_text_transformed(slot_center_x, slot_center_y + 30, _slot_enc_ch + "<->" + player_input[i], 0.75, 0.75, 0);
        } else {
            var _diff = (ord(player_input[i]) - ord(_slot_enc_ch) + 26) mod 26;
            if (_diff > 13) _diff -= 26;
            var _diff_str = (_diff > 0) ? ("+" + string(_diff)) : string(_diff);

            var _matches_key = (!hide_shift_match && _has_key && _diff == slot_shifts[i]);
            draw_set_color(_matches_key ? c_lime : make_color_rgb(170, 190, 215));
            draw_text_transformed(slot_center_x, slot_center_y + 30, _diff_str, 0.85, 0.85, 0);
        }
    } else {
        draw_set_color(c_gray);
        draw_text(slot_center_x, slot_center_y, "?");
    }
}

// --- 5. GUIDED TUTORIAL CALLOUT (Floors 1-3) OR STATUS FEEDBACK ---
if (status_msg != "") {
    draw_set_color(text_color);
    draw_text_transformed(center_x, _py2 - 42, status_msg, 0.88, 0.88, 0);
} else if (guided_ui && _has_key) {
    draw_set_color(c_lime);
    draw_text_transformed(
        center_x, _py2 - 42,
        "TUTORIAL: Press [UP/DOWN] so Slot #" + string(current_slot + 1) + " ('" + _active_enc_ch + "') becomes '" + _active_plain_ch + "'!",
        0.82, 0.82, 0
    );
}

draw_set_color(make_color_rgb(150, 170, 195));
if (instance_exists(obj_battle)) {
    draw_text_transformed(center_x, _py2 - 18, "[ARROWS] Select & Shift   |   [ENTER] Submit", 0.82, 0.82, 0);
} else {
    draw_text_transformed(center_x, _py2 - 18, "[ARROWS] Select & Shift   |   [ENTER] Unlock   |   [ESC] Back", 0.82, 0.82, 0);
}

draw_set_font(fnt_default);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);
