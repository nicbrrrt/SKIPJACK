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

// --- Atbash Cipher button (conditionally unlocked) ---
var _atbash_unlocked = ((variable_global_exists("final_boss_defeated") && global.final_boss_defeated) || (variable_global_exists("unlock_all_ciphers") && global.unlock_all_ciphers));
var _animating_atbash = (unlocking_cipher == "atbash" && unlock_anim_timer > 0);

if (_atbash_unlocked) {
    if (_animating_atbash && unlock_anim_timer > 60) {
        // Draw locked
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
    } else {
        // Draw unlocked with optional flash
        var col_atbash_border = atbash_hover ? c_yellow : c_white;
        draw_set_color(atbash_hover ? make_color_rgb(40, 40, 80) : make_color_rgb(20, 20, 50));
        
        var _scale = 1;
        if (_animating_atbash) {
            _scale = 1 + (unlock_anim_timer / 60) * 0.1; // pop effect
        }
        var _w2 = (btn_w / 2) * _scale;
        var _h2 = (btn_h / 2) * _scale;
        var _cy = btn2_y + btn_h / 2;
        
        draw_rectangle(cx - _w2, _cy - _h2, cx + _w2, _cy + _h2, false);
        draw_set_color(col_atbash_border);
        draw_rectangle(cx - _w2, _cy - _h2, cx + _w2, _cy + _h2, true);
        
        draw_set_font(fnt_button);
        draw_set_color(col_atbash_border);
        draw_text_transformed(cx, _cy, "Atbash Cipher", _scale, _scale, 0);
        
        if (_animating_atbash) {
            draw_set_alpha(unlock_anim_timer / 60);
            draw_set_color(c_white);
            draw_rectangle(cx - _w2, _cy - _h2, cx + _w2, _cy + _h2, false);
            draw_set_alpha(1);
        }
    }
} else {
    // LOCKED
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
}

// --- Vigenère Cipher button ---
var _vigenere_unlocked = ((variable_global_exists("atbash_boss_defeated") && global.atbash_boss_defeated) || (variable_global_exists("unlock_all_ciphers") && global.unlock_all_ciphers));
var _animating_vigenere = (unlocking_cipher == "vigenere" && unlock_anim_timer > 0);

if (_vigenere_unlocked) {
    if (_animating_vigenere && unlock_anim_timer > 60) {
        var col_disabled_fill   = make_color_rgb(40, 40, 40);
        var col_disabled_border = make_color_rgb(60, 60, 60);
        var col_disabled_text   = make_color_rgb(90, 90, 90);
        draw_set_color(col_disabled_fill);
        draw_rectangle(btn_x1, btn3_y, btn_x2, btn3_y + btn_h, false);
        draw_set_color(col_disabled_border);
        draw_rectangle(btn_x1, btn3_y, btn_x2, btn3_y + btn_h, true);
        draw_set_font(fnt_button);
        draw_set_color(col_disabled_text);
        draw_text(cx, btn3_y + btn_h / 2, "Vigenere Cipher  [LOCKED]");
    } else {
        var col_vigenere_border = vigenere_hover ? c_yellow : c_white;
        draw_set_color(vigenere_hover ? make_color_rgb(40, 40, 80) : make_color_rgb(20, 20, 50));
        
        var _scale = 1;
        if (_animating_vigenere) {
            _scale = 1 + (unlock_anim_timer / 60) * 0.1;
        }
        var _w2 = (btn_w / 2) * _scale;
        var _h2 = (btn_h / 2) * _scale;
        var _cy = btn3_y + btn_h / 2;
        
        draw_rectangle(cx - _w2, _cy - _h2, cx + _w2, _cy + _h2, false);
        draw_set_color(col_vigenere_border);
        draw_rectangle(cx - _w2, _cy - _h2, cx + _w2, _cy + _h2, true);
        
        draw_set_font(fnt_button);
        draw_set_color(col_vigenere_border);
        draw_text_transformed(cx, _cy, "Vigenere Cipher", _scale, _scale, 0);
        
        if (_animating_vigenere) {
            draw_set_alpha(unlock_anim_timer / 60);
            draw_set_color(c_white);
            draw_rectangle(cx - _w2, _cy - _h2, cx + _w2, _cy + _h2, false);
            draw_set_alpha(1);
        }
    }
} else {
    var col_disabled_fill   = make_color_rgb(40, 40, 40);
    var col_disabled_border = make_color_rgb(60, 60, 60);
    var col_disabled_text   = make_color_rgb(90, 90, 90);
    draw_set_color(col_disabled_fill);
    draw_rectangle(btn_x1, btn3_y, btn_x2, btn3_y + btn_h, false);
    draw_set_color(col_disabled_border);
    draw_rectangle(btn_x1, btn3_y, btn_x2, btn3_y + btn_h, true);
    draw_set_font(fnt_button);
    draw_set_color(col_disabled_text);
    draw_text(cx, btn3_y + btn_h / 2, "Vigenere Cipher  [LOCKED]");
}

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


