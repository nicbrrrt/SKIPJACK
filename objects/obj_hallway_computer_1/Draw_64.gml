// obj_hallway_computer_1 — Draw GUI Event

if (!is_open) exit;

var _gw = 640;
var _gh = 360;

draw_set_color(c_black);
draw_set_alpha(0.85);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

draw_set_font(fnt_dialogue);

// ── Sprite sizing ─────────────────────────────────────────────────────────────
var _sw = sprite_get_width(spr_hallway_computer_1);
var _sh = sprite_get_height(spr_hallway_computer_1);
var _max_spr_h = 210;
var _max_spr_w = _gw * 0.45;
var _scale  = min(_max_spr_w / _sw, _max_spr_h / _sh);
var _disp_w = _sw * _scale;
var _disp_h = _sh * _scale;

// ── Text metrics ──────────────────────────────────────────────────────────────
var _cap_str  = "An unsecured terminal. Interesting data.";
var _hint_str = "Press X to close";
var _hint_sc  = 0.85;
var _line_h   = string_height("Ag");
var _hint_h   = string_height(_hint_str) * _hint_sc;

// ── Window dimensions (sprite-driven) ────────────────────────────────────────
var _btn_row = 24;
var _gap     = 8;
var _box_w   = _disp_w * 2;
var _inner_w = _box_w - 32;
var _cap_lines = max(1, ceil(string_width(_cap_str) / _inner_w));
var _cap_h     = _cap_lines * _line_h;
var _box_h = _btn_row + _disp_h + _gap + _cap_h + _gap + _hint_h + _gap * 2;

var _fx1 = floor((_gw - _box_w) * 0.5);
var _fy1 = floor((_gh - _box_h) * 0.5);
var _fx2 = _fx1 + _box_w;
var _fy2 = _fy1 + _box_h;
var _cx  = (_fx1 + _fx2) * 0.5;

// ── Background + border ───────────────────────────────────────────────────────
draw_set_color(c_black);
draw_set_alpha(0.5);
draw_rectangle(_fx1, _fy1, _fx2, _fy2, false);
draw_set_alpha(1);
draw_set_color(c_lime);
draw_rectangle(_fx1, _fy1, _fx2, _fy2, true);

// ── Close button ──────────────────────────────────────────────────────────────
var _btn_sz = 18;
var _bx1 = _fx2 - _btn_sz - 3;
var _by1 = _fy1 + 3;
var _bx2 = _bx1 + _btn_sz;
var _by2 = _by1 + _btn_sz;
close_btn_x1 = _bx1; close_btn_y1 = _by1;
close_btn_x2 = _bx2; close_btn_y2 = _by2;

var _mx          = device_mouse_x_to_gui(0);
var _my          = device_mouse_y_to_gui(0);
var _hover_close = point_in_rectangle(_mx, _my, _bx1, _by1, _bx2, _by2);
draw_set_color(_hover_close ? c_red : c_lime);
draw_rectangle(_bx1, _by1, _bx2, _by2, true);
draw_set_halign(fa_center); draw_set_valign(fa_middle);
draw_set_color(_hover_close ? c_red : c_lime);
draw_text_transformed((_bx1 + _bx2) * 0.5, (_by1 + _by2) * 0.5, "X", 0.85, 0.85, 0);

// ── Sprite ────────────────────────────────────────────────────────────────────
var _spr_area_y = _fy1 + _btn_row;
var _spr_cx     = _cx;
var _spr_cy     = _spr_area_y + _disp_h * 0.5;
var _spr_draw_x = _spr_cx - _sw * _scale * 0.5 + sprite_get_xoffset(spr_hallway_computer_1) * _scale;
var _spr_draw_y = _spr_cy - _sh * _scale * 0.5 + sprite_get_yoffset(spr_hallway_computer_1) * _scale;
draw_sprite_ext(spr_hallway_computer_1, 0, _spr_draw_x, _spr_draw_y, _scale, _scale, 0, c_white, 1);

// ── Caption ───────────────────────────────────────────────────────────────────
var _text_y = _spr_area_y + _disp_h + _gap;
draw_set_halign(fa_center); draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text_ext(_cx, _text_y, _cap_str, _line_h, _inner_w);

// ── Hint ──────────────────────────────────────────────────────────────────────
draw_set_color(c_lime);
draw_set_alpha(0.55);
draw_text_transformed(_cx, _text_y + _cap_h + _gap, _hint_str, _hint_sc, _hint_sc, 0);
draw_set_alpha(1);

draw_set_halign(fa_left); draw_set_valign(fa_top); draw_set_color(c_white);
