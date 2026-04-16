// --- Draw GUI Event for obj_cipher_select ---
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var cx  = _gw / 2;
draw_set_alpha(1);

// --- Dark background ---
draw_set_color(make_color_rgb(15, 18, 30));
draw_rectangle(0, 0, _gw, _gh, false);

// --- NPC intro placeholder ---
draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_aqua);
draw_text(cx, _gh * 0.19, "[NPC]: \"Agent, select your cipher protocol to proceed.\"");
draw_text(cx, _gh * 0.26, "(Placeholder — full NPC introduction to be added later.)");

// --- Section title ---
draw_set_font(fnt_title);
draw_set_color(c_white);
draw_text(cx, _gh * 0.36, "SELECT CIPHER");

// --- Caesar Cipher button (active) ---
var col_border = caesar_hover ? c_yellow : c_white;
draw_set_color(caesar_hover ? make_color_rgb(40, 40, 80) : make_color_rgb(20, 20, 50));
draw_rectangle(btn_x1, btn1_y, btn_x2, btn1_y + btn_h, false);  // fill
draw_set_color(col_border);
draw_rectangle(btn_x1, btn1_y, btn_x2, btn1_y + btn_h, true);   // outline
draw_set_font(fnt_button);
draw_set_color(col_border);
draw_text(cx, btn1_y + btn_h / 2, "Caesar Cipher");

// --- Atbash Cipher button (disabled) ---
var col_disabled_fill   = make_color_rgb(40, 40, 40);
var col_disabled_border = make_color_rgb(60, 60, 60);
var col_disabled_text   = make_color_rgb(90, 90, 90);
draw_set_color(col_disabled_fill);
draw_rectangle(btn_x1, btn2_y, btn_x2, btn2_y + btn_h, false);
draw_set_color(col_disabled_border);
draw_rectangle(btn_x1, btn2_y, btn_x2, btn2_y + btn_h, true);
draw_set_font(fnt_button);
draw_set_color(col_disabled_text);
draw_text(cx, btn2_y + btn_h / 2, "Atbash Cipher  [LOCKED]");

// --- Vigenère Cipher button (disabled) ---
draw_set_color(col_disabled_fill);
draw_rectangle(btn_x1, btn3_y, btn_x2, btn3_y + btn_h, false);
draw_set_color(col_disabled_border);
draw_rectangle(btn_x1, btn3_y, btn_x2, btn3_y + btn_h, true);
draw_set_color(col_disabled_text);
draw_text(cx, btn3_y + btn_h / 2, "Vigenere Cipher  [LOCKED]");

// --- Back button (top-left) ---
draw_set_color(make_color_rgb(100, 100, 120));
draw_rectangle(10, 10, 70, 30, false);
draw_set_font(fnt_button);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_text(15, 20, "< BACK");

// Reset draw state
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_alpha(1);
