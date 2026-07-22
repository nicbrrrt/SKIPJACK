// --- Draw GUI Event for obj_atbash_test_gui ---

draw_set_alpha(0.92);
draw_set_color(make_color_rgb(10, 10, 20));
draw_rectangle(0, 0, 640, 360, false);
draw_set_alpha(1.0);

var shake_x = 0;
var shake_y = 0;
if (shake_timer > 0) {
    shake_x = irandom_range(-4, 4);
    shake_y = irandom_range(-4, 4);
}

var px = 40 + shake_x;
var py = 30 + shake_y;
var pw = 560;
var ph = 300;

draw_set_color(make_color_rgb(20, 20, 30));
draw_rectangle(px, py, px + pw, py + ph, false);
draw_set_color(c_yellow);
draw_rectangle(px, py, px + pw, py + ph, true);

draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// TITLE
draw_set_color(c_yellow);
draw_text(px + pw / 2, py + 10, "[ ATBASH FINAL EVALUATION ]");

draw_line(px + 20, py + 25, px + pw - 20, py + 25);

// PROGRESS BAR
var p_y = py + 35;
var box_w = 30;
var box_h = 10;
var box_gap = 10;
var total_w = (total_questions * box_w) + ((total_questions - 1) * box_gap);
var start_x = px + (pw / 2) - (total_w / 2);

for (var i = 0; i < total_questions; i++) {
    var bx = start_x + i * (box_w + box_gap);
    if (i < current_question) {
        draw_set_color(c_lime);
    } else if (i == current_question) {
        draw_set_color(c_yellow);
    } else {
        draw_set_color(c_dkgray);
    }
    draw_rectangle(bx, p_y, bx + box_w, p_y + box_h, false);
}

draw_set_color(c_white);
draw_text(px + pw / 2, p_y + 20, "Question " + string(current_question + 1) + " / " + string(total_questions));

// ENCRYPTED WORD
var enc_y = py + 80;
draw_set_color(c_yellow);
draw_text(px + pw / 2, enc_y, "Decrypt: " + encrypted[current_question]);

// INPUT SLOTS
var _len = string_length(words[current_question]);
var slot_width = 48;
var gap = 20;
var in_total_w = (_len * slot_width) + ((_len - 1) * gap);
var in_start_x = px + (pw / 2) - (in_total_w / 2) + (slot_width / 2);
var slot_y = py + 125;

for (var i = 0; i < _len; i++) {
    var _x = in_start_x + i * (slot_width + gap);
    
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

// STATUS MESSAGE
draw_set_color(text_color);
draw_text(px + pw / 2, py + 170, status_msg);

// SCORE
draw_set_color(c_lime);
draw_text(px + pw / 2, py + 200, "Solved: " + string(correct_count) + " / " + string(total_questions));

// INSTRUCTIONS
var bob = sin(anim_timer * 0.1) * 3;
draw_set_color(c_ltgray);
draw_text(px + pw / 2, py + ph - 20 + bob, "ARROWS: Change | ENTER: Submit | ESC: Quit");

// Reset draw state
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
