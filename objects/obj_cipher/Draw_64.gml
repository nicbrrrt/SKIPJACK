draw_set_font(fnt_default);
draw_set_color(c_white);

// RESET TO DEFAULT
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

var center_x = gui_width / 2;
var center_y = gui_height / 2;

// --- DRAW DARK BACKGROUND PANEL ---
// Creates a clean area in the middle for the game
draw_set_alpha(0.8);
draw_set_color(c_black);
draw_rectangle(0, center_y - 100, gui_width, center_y + 100, false);
draw_set_alpha(1);
draw_set_color(c_white);

// Title
draw_set_halign(fa_center);
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
draw_text(center_x, center_y - 40, "Encrypted: " + encrypted);
draw_set_halign(fa_left);

// SLOTS
var slot_width = 48;
var total_slots_width = (slot_width * 4) + (20 * 3);
var slots_start_x = center_x - (total_slots_width / 2) + (slot_width / 2);
var slots_y = center_y + 20; // Moved down slightly

for (var i = 0; i < letters_len; i++) {
    var slot_center_x = slots_start_x + (i * (slot_width + 20));
    var slot_center_y = slots_y;
    
    // Draw slot
    if (i == current_slot) {
        draw_sprite(spr_slot_active, 0, slot_center_x, slot_center_y);
    } else {
        draw_sprite(spr_slot, 0, slot_center_x, slot_center_y);
    }
    
    // LETTER
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

// Instructions
draw_set_halign(fa_center);
draw_text(center_x, center_y + 70, "ARROWS: Move/Change | ENTER: Submit");
draw_set_halign(fa_left);