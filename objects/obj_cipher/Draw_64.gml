// --- Draw GUI Event of obj_cipher ---

draw_set_font(fnt_default);
draw_set_color(c_white);

// RESET TO DEFAULT
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// --- 1. DEFINE VARIABLES FIRST ---
var gui_width  = display_get_gui_width();
var gui_height = display_get_gui_height();

// --- 2. CALCULATE SHAKE ---
var shake_x = 0;
var shake_y = 0;
if (shake_timer > 0) {
    shake_x = irandom_range(-5, 5);
    shake_y = irandom_range(-5, 5);
}

// Add shake offsets to the center position
var center_x = (gui_width / 2) + shake_x;
var center_y = (gui_height / 2) + shake_y;

// --- DRAW DARK BACKGROUND PANEL ---
draw_set_alpha(0.85);
draw_set_color(c_black);
draw_rectangle(0, center_y - 105, gui_width, center_y + 155, false);
draw_set_alpha(1);
draw_set_color(c_white);

// --- TITLE ---
draw_set_halign(fa_center);

if (instance_exists(obj_battle)) {
    var mode = "first";
    if (variable_instance_exists(obj_battle, "cipher_mode")) {
        mode = obj_battle.cipher_mode;
    }
    if (mode == "first") {
        draw_text(center_x, center_y - 80, "DECRYPT TO DISABLE SHIELD");
        draw_text(center_x, center_y - 60, "KEY: " + string(key));
    } else {
        draw_text(center_x, center_y - 80, "UNCORRUPT THE PACKET");
        draw_text(center_x, center_y - 60, "KEY: " + string(key));
    }
} else {
    // Standalone Dungeon Caesar Door Mode
    draw_set_color(make_color_rgb(255, 90, 145));
    draw_text(center_x, center_y - 82, "DECRYPT CAESAR DOOR LOCK");

    var _has_key = (variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key);
    if (_has_key) {
        draw_set_color(c_lime);
        var _k_str = (key > 0) ? ("+" + string(key)) : string(key);
        draw_text(center_x, center_y - 62, "KEY: " + _k_str);
    } else {
        draw_set_color(c_orange);
        draw_text(center_x, center_y - 62, "KEY: ??? (Find Key in Vault Room!)");
    }
    draw_set_color(c_white);
}

draw_text(center_x, center_y - 40, "Encrypted: " + encrypted);
draw_set_halign(fa_left);

// --- SLOTS ---
var slot_width = 48;
var total_slots_width = (slot_width * 4) + (20 * 3);
var slots_start_x = center_x - (total_slots_width / 2) + (slot_width / 2);
var slots_y = center_y + 20;

for (var i = 0; i < letters_len; i++) {
    var slot_center_x = slots_start_x + (i * (slot_width + 20));
    var slot_center_y = slots_y;
    
    // Draw slot sprite
    if (i == current_slot) {
        draw_sprite(spr_slot_active, 0, slot_center_x, slot_center_y);
    } else {
        draw_sprite(spr_slot, 0, slot_center_x, slot_center_y);
    }
    
    // Draw Letter
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    if (player_input[i] != "") {
        draw_text(slot_center_x, slot_center_y, player_input[i]);
    } else {
        draw_set_color(c_gray);
        draw_text(slot_center_x, slot_center_y, "?");
        draw_set_color(c_white);
    }
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// --- STATUS MESSAGE (Win/Loss Feedback) ---
draw_set_halign(fa_center);
draw_set_color(text_color);
draw_text(center_x, center_y + 100, status_msg);
draw_set_color(c_white);

// --- INSTRUCTIONS ---
if (instance_exists(obj_battle)) {
    draw_text(center_x, center_y + 130, "ARROWS: Change | ENTER: Submit");
} else {
    draw_text(center_x, center_y + 130, "ARROWS: Change | ENTER: Submit | ESC: Cancel");
}
draw_set_halign(fa_left);
