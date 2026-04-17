var _pw = 580;
var _ph = 300;
var _px = (640 - _pw) / 2;  // 30
var _py = (360 - _ph) / 2;  // 30

// --- Background ---
draw_set_alpha(0.92);
draw_set_color(make_color_rgb(10, 10, 20));
draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
draw_set_alpha(1.0);

// --- Border ---
draw_set_color(c_yellow);
draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);

// --- Title ---
draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_color(c_yellow);
draw_text(_px + _pw / 2, _py + 10, "[ THE CAESAR CIPHER ]");

// --- Divider ---
draw_set_color(make_color_rgb(80, 80, 80));
draw_line(_px + 12, _py + 27, _px + _pw - 12, _py + 27);

// --- Content ---
var _lx = _px + 18;
var _ly = _py + 35;
var _ls = 17;

draw_set_halign(fa_left);
draw_set_color(c_white);
draw_text(_lx, _ly,           "One of history's oldest ciphers, used by Julius Caesar (~60 BC)");
draw_text(_lx, _ly + _ls,     "to encrypt military communications by shifting letters.");

draw_set_color(c_yellow);
draw_text(_lx, _ly + _ls * 2.6, "HOW IT WORKS:");
draw_set_color(c_white);
draw_text(_lx, _ly + _ls * 3.6, "Each letter is shifted forward a fixed number of positions.");
draw_text(_lx, _ly + _ls * 4.6, "Example (Shift 3):   A -> D     B -> E     Z -> C");

draw_set_color(c_yellow);
draw_text(_lx, _ly + _ls * 6.1, "KEY TERMS:");
draw_set_color(c_white);
draw_text(_lx, _ly + _ls * 7.1, "SHIFT / OFFSET  The number of positions each letter moves.");
draw_text(_lx, _ly + _ls * 8.1, "ROTATION        Letters wrap around: after Z comes A again.");
draw_text(_lx, _ly + _ls * 9.1, "KEY             Another name for the shift value.");

draw_set_color(c_yellow);
draw_text(_lx, _ly + _ls * 10.6, "DECRYPTION:");
draw_set_color(c_white);
draw_text(_lx, _ly + _ls * 11.6, "Shift backward by the same amount to decode the message.");

// --- Close hint ---
var _bob = sin(get_timer() / 300000) * 2;
draw_set_color(c_lime);
draw_set_halign(fa_center);
draw_text(_px + _pw / 2, _py + _ph - 16 + _bob, "[ E ] or [ ESC ] to close");

// --- Reset draw state ---
draw_set_halign(fa_left);
draw_set_color(c_white);
draw_set_alpha(1.0);
