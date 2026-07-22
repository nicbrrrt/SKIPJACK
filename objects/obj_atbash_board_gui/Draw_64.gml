// --- Draw GUI Event for obj_atbash_board_gui ---
if (variable_global_exists("is_paused") && global.is_paused) exit;

var shake_x = 0;
var shake_y = 0;
if (shake_timer > 0) {
    shake_x = irandom_range(-4, 4);
    shake_y = irandom_range(-4, 4);
}

// Dark background panel
draw_set_alpha(0.92);
draw_set_color(c_black);
draw_rectangle(20 + shake_x, 10 + shake_y, 620 + shake_x, 350 + shake_y, false);
draw_set_alpha(1.0);
draw_set_color(c_yellow);
draw_rectangle(20 + shake_x, 10 + shake_y, 620 + shake_x, 350 + shake_y, true);

draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Title
draw_set_color(c_yellow);
draw_text(320 + shake_x, 18 + shake_y, "ATBASH MIRROR BOARD");

// Progress
draw_set_halign(fa_right);
draw_set_color(c_white);
draw_text(610 + shake_x, 18 + shake_y, "Word " + string(current_word + 1) + " of 2");
draw_set_halign(fa_center);

// Mini reference (compact alphabet mirror)
var ref_start_x = 320 - (13 * 22) / 2 + 11;
for (var i = 0; i < 13; i++) {
    var rx = ref_start_x + (i * 22) + shake_x;

    // Highlight column matching current encrypted letter
    var cur_enc_char = string_char_at(encrypted[current_word], current_slot + 1);
    var is_highlighted = (alpha_top[i] == cur_enc_char || alpha_bottom[i] == cur_enc_char);

    if (is_highlighted) {
        draw_set_alpha(0.3);
        draw_set_color(c_lime);
        draw_rectangle(rx - 10, 35 + shake_y, rx + 10, 65 + shake_y, false);
        draw_set_alpha(1.0);
    }

    draw_set_color(c_lime);
    draw_text(rx, 40 + shake_y, alpha_top[i]);
    draw_set_color(c_yellow);
    draw_text(rx, 58 + shake_y, alpha_bottom[i]);
}

// Encrypted word
draw_set_color(c_yellow);
draw_text(320 + shake_x, 85 + shake_y, "Encrypted: " + encrypted[current_word]);

// Hint
var _enc_char = string_char_at(encrypted[current_word], current_slot + 1);
var _dec_char = scr_atbash_decode(_enc_char);
draw_set_color(c_lime);
draw_text(320 + shake_x, 105 + shake_y, "Hint: " + _enc_char + " <-> " + _dec_char);

// Input slots
var _len = string_length(words[current_word]);
var slot_width = 48;
var gap = 20;
var total_w = (_len * slot_width) + ((_len - 1) * gap);
var in_start_x = 320 - (total_w / 2) + (slot_width / 2);
var slot_y = 140 + shake_y;

for (var i = 0; i < _len; i++) {
    var _x = in_start_x + i * (slot_width + gap) + shake_x;

    var _spr = asset_get_index("spr_slot");
    if (i == current_slot) _spr = asset_get_index("spr_slot_active");

    if (sprite_exists(_spr)) {
        draw_sprite(_spr, 0, _x, slot_y);
    } else {
        draw_set_color(i == current_slot ? c_yellow : c_white);
        draw_rectangle(_x - slot_width/2, slot_y - slot_width/2, _x + slot_width/2, slot_y + slot_width/2, true);
    }

    draw_set_color(c_white);
    var _txt = player_input[i];
    if (_txt == "") _txt = "?";
    draw_text(_x, slot_y, _txt);
}

// Status message
draw_set_color(text_color);
draw_text(320 + shake_x, 185 + shake_y, status_msg);

// Instructions
draw_set_color(c_white);
draw_text(320 + shake_x, 210 + shake_y, "ARROWS: Change | ENTER: Submit | ESC: Close");

anim_timer++;

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
