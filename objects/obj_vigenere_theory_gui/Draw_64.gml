var _pw = 680;
var _ph = 320;
var _px = (640 - _pw) / 2;
var _py = (360 - _ph) / 2;

draw_set_alpha(0.92);
draw_set_color(make_color_rgb(10, 10, 20));
draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
draw_set_alpha(1.0);

draw_set_color(c_fuchsia);
draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);

draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_color(c_fuchsia);
draw_text(_px + _pw / 2, _py + 10, "[ THE VIGENERE CIPHER ]");

draw_set_color(make_color_rgb(80, 80, 80));
draw_line(_px + 12, _py + 27, _px + _pw - 12, _py + 27);

var _lx = _px + 18;
var _ly = _py + 35;
var _ls = 17;

draw_set_halign(fa_left);
draw_set_color(c_white);
draw_text(_lx, _ly,           "Invented in the 16th century, this cipher was once considered 'le chiffre indÃ©chiffrable'");
draw_text(_lx, _ly + _ls,     "(the indecipherable cipher) due to its strength against frequency analysis.");

draw_set_color(c_fuchsia);
draw_text(_lx, _ly + _ls * 2.6, "HOW IT WORKS:");
draw_set_color(c_white);
draw_text(_lx, _ly + _ls * 3.6, "Instead of a single shift, VigenÃ¨re uses a KEYWORD. Each letter of the keyword");
draw_text(_lx, _ly + _ls * 4.6, "provides a different shift amount (A=0, B=1, C=2...) for each letter of the message.");
draw_text(_lx, _ly + _ls * 5.6, "The keyword repeats over the plaintext until the message is fully encrypted.");

draw_set_color(c_fuchsia);
draw_text(_lx, _ly + _ls * 7.1, "EXAMPLE (Keyword: KEY):");
draw_set_color(c_white);
draw_text(_lx, _ly + _ls * 8.1, "Plain:   C  O  D  E");
draw_text(_lx, _ly + _ls * 9.1, "Key:     K  E  Y  K   (K shifts by 10, E by 4, Y by 24)");
draw_text(_lx, _ly + _ls * 10.1, "Cipher:  M  S  B  O");

draw_set_color(c_fuchsia);
draw_text(_lx, _ly + _ls * 11.6, "DECRYPTION:");
draw_set_color(c_white);
draw_text(_lx, _ly + _ls * 12.6, "Line up the keyword again, and shift backward by the keyword's letter value.");

var _bob = sin(get_timer() / 300000) * 2;
draw_set_color(c_lime);
draw_set_halign(fa_center);
draw_text(_px + _pw / 2, _py + _ph - 16 + _bob, "[ E ] or [ ESC ] to close");

draw_set_halign(fa_left);
draw_set_color(c_white);
draw_set_alpha(1.0);
