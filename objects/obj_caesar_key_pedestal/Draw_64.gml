/// @description obj_caesar_key_pedestal — Draw GUI Event
/// Renders a clean, visual Chapter Key Calibration interface (Caesar, Vigenere, or Atbash)
/// with Guided Hand-Holding callouts on Tutorial Floors 1-3.

if (!ui_open) exit;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _sx = (shake_timer > 0) ? irandom_range(-4, 4) : 0;
var _sy = (shake_timer > 0) ? irandom_range(-4, 4) : 0;
var _cx = (_gui_w * 0.5) + _sx;
var _cy = (_gui_h * 0.5) + _sy;

var _ch      = variable_global_exists("dungeon_chapter")      ? global.dungeon_chapter      : CHAPTER_CAESAR;
var _vig_key = variable_global_exists("dungeon_vigenere_key") ? global.dungeon_vigenere_key : "CAB";
var _guided  = (variable_global_exists("floor_curriculum") && variable_struct_exists(global.floor_curriculum, "guided_ui"))
    ? global.floor_curriculum.guided_ui
    : false;

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

// Header & 1-Line Prompt
var _hdr_title = "FIND THE CAESAR SHIFT KEY";
var _sub_line  = "Slide the dial until '" + sample_enc + "' lands on '" + sample_plain + "'";

if (_ch == CHAPTER_VIGENERE) {
    _hdr_title = "CALIBRATE VIGENERE KEYWORD ('" + _vig_key + "')";
    _sub_line  = "Match 1st Keyword Letter: Slide until '" + sample_enc + "' lands on '" + sample_plain + "'";
} else if (_ch == CHAPTER_ATBASH) {
    _hdr_title = "CALIBRATE ATBASH MIRROR (A <-> Z)";
    _sub_line  = "Count inward from 'Z' to match '" + sample_enc + "' with its mirror '" + sample_plain + "'";
}

draw_set_color(make_color_rgb(255, 215, 55));
draw_text_transformed(_cx, _y1 + 20, _hdr_title, 1.02, 1.02, 0);
draw_set_color(make_color_rgb(190, 210, 235));
draw_text_transformed(_cx, _y1 + 42, _sub_line, 0.85, 0.85, 0);

// 3. Visual A-Z Alphabet Ruler
var _strip_y  = _y1 + 82;
var _cell_w   = 20;
var _strip_w  = 26 * _cell_w;
var _strip_x1 = _cx - _strip_w * 0.5;

draw_set_color(make_color_rgb(20, 26, 40));
draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, false);
draw_set_color(make_color_rgb(70, 90, 125));
draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, true);

var _enc_idx    = ord(sample_enc) - ord("A");
var _plain_idx  = ord(sample_plain) - ord("A");
var _landed_ch  = (_ch == CHAPTER_ATBASH)
    ? chr(ord("Z") - dial_shift)
    : scr_caesar_encode(sample_enc, dial_shift);
var _landed_idx = ord(_landed_ch) - ord("A");
var _aligned    = (_landed_ch == sample_plain);

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
    } else if (_a == _plain_idx) {
        draw_set_color(c_lime);
        draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, true);
        draw_rectangle(_lx - 8, _strip_y - 11, _lx + 8, _strip_y + 11, true);
        draw_text(_lx, _strip_y, _ch_lbl);
    } else {
        draw_set_color(make_color_rgb(160, 175, 200));
        draw_text_transformed(_lx, _strip_y, _ch_lbl, 0.85, 0.85, 0);
    }
}

// 4. Visual 3-Card Equation: [ START ]  +  [ DIAL ]  =  [ TARGET ]
var _cards_y  = _y1 + 148;
var _dial_str = (dial_shift > 0) ? ("+" + string(dial_shift)) : string(dial_shift);
var _mid_lbl  = "SHIFT KEY";

if (_ch == CHAPTER_VIGENERE) {
    var _kw_letter = chr(ord("A") + dial_shift);
    _mid_lbl  = "KEY LETTER";
    _dial_str = _kw_letter + " (+" + string(dial_shift) + ")";
} else if (_ch == CHAPTER_ATBASH) {
    _mid_lbl  = "MIRROR STEP";
    _dial_str = _landed_ch + " (-" + string(dial_shift) + ")";
}

// Left Card: Start Letter
draw_set_color(make_color_rgb(38, 32, 16));
draw_rectangle(_cx - 190, _cards_y - 24, _cx - 90, _cards_y + 24, false);
draw_set_color(make_color_rgb(255, 195, 45));
draw_rectangle(_cx - 190, _cards_y - 24, _cx - 90, _cards_y + 24, true);
draw_text_transformed(_cx - 140, _cards_y - 11, "START", 0.72, 0.72, 0);
draw_set_color(c_white);
draw_text_transformed(_cx - 140, _cards_y + 8, sample_enc, 1.15, 1.15, 0);

// Center Interactive Dial Card
draw_set_color(make_color_rgb(18, 30, 46));
draw_rectangle(_cx - 72, _cards_y - 26, _cx + 72, _cards_y + 26, false);
draw_set_color(_aligned ? c_lime : c_aqua);
draw_rectangle(_cx - 72, _cards_y - 26, _cx + 72, _cards_y + 26, true);
draw_text_transformed(_cx, _cards_y - 11, _mid_lbl, 0.75, 0.75, 0);
draw_set_color(c_white);
draw_text_transformed(_cx, _cards_y + 8, "< " + _dial_str + " >", 1.05, 1.05, 0);

// Right Card: Target Letter
draw_set_color(make_color_rgb(16, 38, 28));
draw_rectangle(_cx + 90, _cards_y - 24, _cx + 190, _cards_y + 24, false);
draw_set_color(c_lime);
draw_rectangle(_cx + 90, _cards_y - 24, _cx + 190, _cards_y + 24, true);
draw_text_transformed(_cx + 140, _cards_y - 11, "TARGET", 0.72, 0.72, 0);
draw_set_color(c_white);
draw_text_transformed(_cx + 140, _cards_y + 8, sample_plain, 1.15, 1.15, 0);

// 5. Guided Tutorial Hint (Floors 1-3) & Status Footer
if (status_msg != "") {
    draw_set_color(status_col);
    draw_text_transformed(_cx, _y2 - 42, status_msg, 0.88, 0.88, 0);
} else if (_aligned) {
    draw_set_color(c_lime);
    draw_text_transformed(_cx, _y2 - 42, "MATCH! Press [ENTER] to save Key!", 0.90, 0.90, 0);
} else if (_guided) {
    var _dir_hint = (target_shift > dial_shift) ? "[RIGHT]" : "[LEFT]";
    var _t_str    = (target_shift > 0) ? ("+" + string(target_shift)) : string(target_shift);
    if (_ch == CHAPTER_VIGENERE) _t_str = chr(ord("A") + target_shift) + " (+" + string(target_shift) + ")";
    if (_ch == CHAPTER_ATBASH)   _t_str = sample_plain;
    draw_set_color(c_aqua);
    draw_text_transformed(_cx, _y2 - 42, "TUTORIAL: Press " + _dir_hint + " until dial reaches " + _t_str + "!", 0.84, 0.84, 0);
}

draw_set_color(make_color_rgb(150, 170, 195));
draw_text_transformed(_cx, _y2 - 16, "[LEFT / RIGHT] Turn Dial   |   [ENTER] Confirm   |   [ESC] Back", 0.82, 0.82, 0);

draw_set_font(fnt_default);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);
