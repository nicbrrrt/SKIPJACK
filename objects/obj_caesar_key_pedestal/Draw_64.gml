/// @description obj_caesar_key_pedestal — Draw GUI Event
/// Renders the "Crack the Key" (Known-Plaintext Cryptanalysis) interactive mini-lesson.

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

// 2. Main Cryptanalysis Panel
var _pw = 564;
var _ph = 286;
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

// Header
draw_set_color(make_color_rgb(255, 215, 55));
draw_text_transformed(_cx, _y1 + 22, "CRYPTANALYSIS LAB — CRACK THE SHIFT KEY", 1.1, 1.1, 0);

// Explanation Box: Known-Plaintext Attack
draw_set_color(make_color_rgb(22, 32, 48));
draw_rectangle(_x1 + 16, _y1 + 38, _x2 - 16, _y1 + 88, false);
draw_set_color(make_color_rgb(75, 145, 190));
draw_rectangle(_x1 + 16, _y1 + 38, _x2 - 16, _y1 + 88, true);

var _lesson_txt = "KNOWN-PLAINTEXT CLUE: We intercepted an Encrypted letter ('" + sample_enc + "') that we know decodes to ('" + sample_plain + "'). Slide the Shift Dial [LEFT / RIGHT] until '" + sample_enc + "' lands on '" + sample_plain + "' to discover this floor's Caesar Key!";
draw_set_color(c_white);
draw_text_ext_transformed(_cx, _y1 + 63, _lesson_txt, 16, (_pw - 48) / 0.86, 0.86, 0.86, 0);

// 3. Visual A-Z Alphabet Ruler
var _strip_y  = _y1 + 118;
var _cell_w   = 20;
var _strip_w  = 26 * _cell_w;
var _strip_x1 = _cx - _strip_w * 0.5;

draw_set_color(make_color_rgb(20, 26, 40));
draw_rectangle(_strip_x1 - 6, _strip_y - 16, _strip_x1 + _strip_w + 6, _strip_y + 16, false);
draw_set_color(make_color_rgb(70, 90, 125));
draw_rectangle(_strip_x1 - 6, _strip_y - 16, _strip_x1 + _strip_w + 6, _strip_y + 16, true);

var _enc_idx    = ord(sample_enc) - ord("A");
var _plain_idx  = ord(sample_plain) - ord("A");
var _landed_ch  = scr_caesar_encode(sample_enc, dial_shift);
var _landed_idx = ord(_landed_ch) - ord("A");

for (var _a = 0; _a < 26; _a++) {
    var _lx = _strip_x1 + _a * _cell_w + _cell_w * 0.5;
    var _ch = chr(ord("A") + _a);

    if (_a == _landed_idx) {
        // Where the player's current dial shift lands
        draw_set_color((_a == _plain_idx) ? c_lime : c_aqua);
        draw_rectangle(_lx - 9, _strip_y - 13, _lx + 9, _strip_y + 13, false);
        draw_set_color(c_black);
        draw_text(_lx, _strip_y, _ch);
    } else if (_a == _enc_idx) {
        // Intercepted Encrypted Letter
        draw_set_color(make_color_rgb(255, 190, 40));
        draw_rectangle(_lx - 9, _strip_y - 13, _lx + 9, _strip_y + 13, false);
        draw_set_color(c_black);
        draw_text(_lx, _strip_y, _ch);
    } else if (_a == _plain_idx) {
        // Known Decoded Target Letter (pulsing green outline)
        draw_set_color(c_lime);
        draw_rectangle(_lx - 9, _strip_y - 13, _lx + 9, _strip_y + 13, true);
        draw_rectangle(_lx - 8, _strip_y - 12, _lx + 8, _strip_y + 12, true);
        draw_text(_lx, _strip_y, _ch);
    } else {
        draw_set_color(make_color_rgb(160, 175, 200));
        draw_text_transformed(_lx, _strip_y, _ch, 0.85, 0.85, 0);
    }
}

// Legend below A-Z strip
draw_set_color(make_color_rgb(255, 195, 45));
draw_text_transformed(_cx - 165, _strip_y + 25, "[GOLD] Encrypted ('" + sample_enc + "')", 0.80, 0.80, 0);
draw_set_color(c_aqua);
draw_text_transformed(_cx, _strip_y + 25, "[BLUE] Your Test Shift ('" + _landed_ch + "')", 0.80, 0.80, 0);
draw_set_color(c_lime);
draw_text_transformed(_cx + 170, _strip_y + 25, "[GREEN BOX] Target ('" + sample_plain + "')", 0.80, 0.80, 0);

// 4. Interactive Shift Dial Readout Box
var _dial_y   = _y1 + 188;
var _dial_str = (dial_shift > 0) ? ("+" + string(dial_shift)) : string(dial_shift);
var _aligned  = (_landed_ch == sample_plain);

draw_set_color(make_color_rgb(18, 28, 44));
draw_rectangle(_cx - 170, _dial_y - 22, _cx + 170, _dial_y + 22, false);
draw_set_color(_aligned ? c_lime : c_aqua);
draw_rectangle(_cx - 170, _dial_y - 22, _cx + 170, _dial_y + 22, true);

draw_set_color(c_white);
draw_text_transformed(_cx, _dial_y - 7, "<  TEST SHIFT KEY:  " + _dial_str + "  >", 1.05, 1.05, 0);
draw_set_color(_aligned ? c_lime : make_color_rgb(200, 220, 245));
draw_text_transformed(_cx, _dial_y + 11, "'" + sample_enc + "'  shifted by " + _dial_str + "  --->  '" + _landed_ch + "'   (Target: '" + sample_plain + "')", 0.85, 0.85, 0);

// 5. Status / Feedback
if (status_msg != "") {
    draw_set_color(status_col);
    draw_text_transformed(_cx, _y2 - 44, status_msg, 0.88, 0.88, 0);
} else {
    draw_set_color(_aligned ? c_lime : make_color_rgb(185, 205, 230));
    draw_text_transformed(
        _cx,
        _y2 - 44,
        _aligned ? "MATCH FOUND! Press [ENTER] to lock in this floor's Caesar Key!" : "Use [LEFT / RIGHT] arrows to align the Blue marker onto the Green Target box!",
        0.86,
        0.86,
        0
    );
}

// 6. Controls Footer
draw_set_color(make_color_rgb(150, 170, 195));
draw_text_transformed(_cx, _y2 - 18, "[LEFT / RIGHT] Adjust Shift Key   |   [ENTER] Confirm Key   |   [ESC] Cancel", 0.82, 0.82, 0);

draw_set_font(fnt_default);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);
