anim_timer++;
var _pw = 500; var _ph = 360;
var _px = (640 - _pw) / 2; var _py = (360 - _ph) / 2;
var _sx = _px + random_range(-shake_timer, shake_timer);
var _sy = _py + random_range(-shake_timer, shake_timer);

draw_set_alpha(0.92); draw_set_color(make_color_rgb(10, 10, 20)); draw_rectangle(_sx, _sy, _sx + _pw, _sy + _ph, false); draw_set_alpha(1.0);
draw_set_color(c_fuchsia); draw_rectangle(_sx, _sy, _sx + _pw, _sy + _ph, true);

draw_set_font(fnt_dialogue); draw_set_halign(fa_center); draw_set_color(c_fuchsia);
draw_text(_sx + _pw / 2, _sy + 10, "VIGENERE DECRYPTION (" + string(current_word + 1) + "/2)");
draw_set_color(c_white); draw_text(_sx + _pw / 2, _sy + 35, "KEYWORD: " + keyword);

var _word_len = string_length(words[current_word]);
var _box_w = 40; var _box_space = 46;
var _total_w = (_word_len * _box_space) - (_box_space - _box_w);
var _start_x = _sx + (_pw - _total_w) / 2;

draw_set_color(c_silver); draw_text(_sx + _pw / 2, _sy + 70, "CIPHERTEXT");
var _cy = _sy + 90;
for (var i = 0; i < _word_len; i++) {
    var _bx = _start_x + (i * _box_space);
    var _char = string_char_at(encrypted[current_word], i + 1);
    
    draw_set_color(c_dkgray); draw_rectangle(_bx, _cy, _bx + _box_w, _cy + _box_w, false);
    draw_set_color(c_red); draw_rectangle(_bx, _cy, _bx + _box_w, _cy + _box_w, true);
    
    draw_set_color(c_white); draw_text(_bx + _box_w / 2, _cy + 8, _char);
    
    var _k_char = string_char_at(keyword, ((i) mod string_length(keyword)) + 1);
    draw_set_color(c_fuchsia); draw_text(_bx + _box_w / 2, _cy - 16, _k_char);
}

var _py_input = _cy + 60;
draw_set_color(c_silver); draw_text(_sx + _pw / 2, _py_input - 20, "DECODED WORD");

for (var i = 0; i < _word_len; i++) {
    var _bx = _start_x + (i * _box_space);
    
    if (i == current_slot) {
        draw_set_color(make_color_rgb(30, 30, 60)); draw_rectangle(_bx, _py_input, _bx + _box_w, _py_input + _box_w, false);
        draw_set_color(c_lime); draw_rectangle(_bx, _py_input, _bx + _box_w, _py_input + _box_w, true);
        var _shift = (anim_timer mod 30 < 15) ? 2 : 0;
    } else {
        draw_set_color(c_dkgray); draw_rectangle(_bx, _py_input, _bx + _box_w, _py_input + _box_w, false);
        draw_set_color(c_white); draw_rectangle(_bx, _py_input, _bx + _box_w, _py_input + _box_w, true);
    }
    
    if (player_input[i] != "") { draw_set_color(c_lime); draw_text(_bx + _box_w / 2, _py_input + 8, player_input[i]); }
}

if (status_msg != "") { draw_set_color(text_color); draw_text(_sx + _pw / 2, _sy + _ph - 110, status_msg); }

draw_set_color(c_silver); draw_text(_sx + _pw / 2, _sy + _ph - 70, "Use [ARROWS] to select & shift letters, or [A-Z] to type.");
draw_set_color(c_fuchsia); draw_text(_sx + _pw / 2, _sy + _ph - 50, "Press [ENTER] to submit. [ESC] to quit.");
draw_set_halign(fa_left); draw_set_color(c_white);
