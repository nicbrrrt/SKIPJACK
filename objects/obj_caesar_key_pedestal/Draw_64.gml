/// @description obj_caesar_key_pedestal — Draw GUI Event
/// Renders a clean, visual "Crack the Key" interface with minimal text.

if (!ui_open) exit;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _sx = (shake_timer > 0) ? irandom_range(-4, 4) : 0;
var _sy = (shake_timer > 0) ? irandom_range(-4, 4) : 0;
var _cx = (_gui_w * 0.5) + _sx;
var _cy = (_gui_h * 0.5) + _sy;

// 1. Grey out background
draw_set_alpha(0.84);
draw_set_color(c_black);
draw_rectangle(0, 0, _gui_w, _gui_h, false);

// 2. Compact Cryptanalysis Panel
var _pw = 540;
var _ph = 248;
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
draw_set_color(make_color_rgb(255, 215, 55));
draw_text_transformed(_cx, _y1 + 20, "FIND THE SHIFT KEY", 1.05, 1.05, 0);
draw_set_color(make_color_rgb(190, 210, 235));
draw_text_transformed(_cx, _y1 + 42, "Slide the dial until '" + sample_enc + "' lands on '" + sample_plain + "'", 0.88, 0.88, 0);

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
var _landed_ch  = scr_caesar_encode(sample_enc, dial_shift);
var _landed_idx = ord(_landed_ch) - ord("A");
var _aligned    = (_landed_ch == sample_plain);

for (var _a = 0; _a < 26; _a++) {
    var _lx = _strip_x1 + _a * _cell_w + _cell_w * 0.5;
    var _ch = chr(ord("A") + _a);

    if (_a == _landed_idx) {
        draw_set_color(_aligned ? c_lime : c_aqua);
        draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, false);
        draw_set_color(c_black);
        draw_text(_lx, _strip_y, _ch);
    } else if (_a == _enc_idx) {
        draw_set_color(make_color_rgb(255, 190, 40));
        draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, false);
        draw_set_color(c_black);
        draw_text(_lx, _strip_y, _ch);
    } else if (_a == _plain_idx) {
        draw_set_color(c_lime);
        draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, true);
        draw_rectangle(_lx - 8, _strip_y - 11, _lx + 8, _strip_y + 11, true);
        draw_text(_lx, _strip_y, _ch);
    } else {
        draw_set_color(make_color_rgb(160, 175, 200));
        draw_text_transformed(_lx, _strip_y, _ch, 0.85, 0.85, 0);
    }
}

// 4. Visual 3-Card Equation: [ ENCRYPTED ]  +  [ SHIFT DIAL ]  =  [ TARGET ]
var _cards_y  = _y1 + 148;
var _dial_str = (dial_shift > 0) ? ("+" + string(dial_shift)) : string(dial_shift);

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
draw_rectangle(_cx - 68, _cards_y - 26, _cx + 68, _cards_y + 26, false);
draw_set_color(_aligned ? c_lime : c_aqua);
draw_rectangle(_cx - 68, _cards_y - 26, _cx + 68, _cards_y + 26, true);
draw_text_transformed(_cx, _cards_y - 11, "SHIFT KEY", 0.75, 0.75, 0);
draw_set_color(c_white);
draw_text_transformed(_cx, _cards_y + 8, "<  " + _dial_str + "  >", 1.15, 1.15, 0);

// Right Card: Target Letter
draw_set_color(make_color_rgb(16, 38, 28));
draw_rectangle(_cx + 90, _cards_y - 24, _cx + 190, _cards_y + 24, false);
draw_set_color(c_lime);
draw_rectangle(_cx + 90, _cards_y - 24, _cx + 190, _cards_y + 24, true);
draw_text_transformed(_cx + 140, _cards_y - 11, "TARGET", 0.72, 0.72, 0);
draw_set_color(c_white);
draw_text_transformed(_cx + 140, _cards_y + 8, sample_plain, 1.15, 1.15, 0);

// 5. Minimal Status & Footer
if (status_msg != "") {
    draw_set_color(status_col);
    draw_text_transformed(_cx, _y2 - 40, status_msg, 0.88, 0.88, 0);
} else if (_aligned) {
    draw_set_color(c_lime);
    draw_text_transformed(_cx, _y2 - 40, "MATCH! Press [ENTER] to save Key!", 0.90, 0.90, 0);
}

draw_set_color(make_color_rgb(150, 170, 195));
draw_text_transformed(_cx, _y2 - 16, "[LEFT / RIGHT] Turn Dial   |   [ENTER] Confirm   |   [ESC] Back", 0.82, 0.82, 0);

draw_set_font(fnt_default);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);
