// --- Draw GUI Event for obj_atbash_combat_gui ---

draw_set_alpha(0.95);
draw_set_color(make_color_rgb(5, 5, 15));
draw_rectangle(0, 0, 640, 360, false);
draw_set_alpha(1.0);

var shake_x = 0;
var shake_y = 0;
if (shake_timer > 0) {
    shake_x = irandom_range(-4, 4);
    shake_y = irandom_range(-4, 4);
}

// PLAYER SPRITE
var px = 640 * 0.18 + player_lunge + shake_x;
var py = 360 * 0.55 + shake_y;
var _pcol = c_white;
if (player_hurt_timer > 0 && (player_hurt_timer mod 4 < 2)) {
    _pcol = c_red;
}
if (sprite_exists(asset_get_index("spr_jack_idle"))) {
    draw_sprite_ext(asset_get_index("spr_jack_idle"), 0, px, py, 3, 3, 0, _pcol, 1);
} else {
    draw_set_color(c_green);
    draw_rectangle(px - 16*3, py - 24*3, px + 16*3, py + 24*3, false);
}

// ENEMY SPRITE
var ex = 640 * 0.82 + enemy_lunge + shake_x;
var ey = 360 * 0.55 + shake_y;
var _ecol = c_white;
if (enemy_flash_timer > 0 && (enemy_flash_timer mod 3 == 0)) {
    _ecol = c_red;
}
if (sprite_exists(asset_get_index("spr_normalvirus_idle"))) {
    draw_sprite_ext(asset_get_index("spr_normalvirus_idle"), 0, ex, ey, 3, 3, 0, _ecol, 1);
} else {
    draw_set_color(c_red);
    draw_rectangle(ex - 16*3, ey - 24*3, ex + 16*3, ey + 24*3, false);
}

draw_set_font(fnt_dialogue);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// HUD (top bar)
draw_set_color(c_lime);
draw_text(20, 15, "PLAYER HP: " + string(player_hp));
draw_set_color(make_color_rgb(30, 30, 30));
draw_rectangle(20, 35, 120, 45, false);
draw_set_color(c_lime);
draw_rectangle(20, 35, 20 + (player_hp / 10) * 100, 45, false);

draw_set_halign(fa_right);
draw_set_color(c_red);
draw_text(620, 15, "ENEMY HP: " + string(enemy_hp));
draw_set_color(make_color_rgb(30, 30, 30));
draw_rectangle(520, 35, 620, 45, false);
draw_set_color(c_red);
draw_rectangle(620 - (enemy_hp / 10) * 100, 35, 620, 45, false);

// BATTLE PROMPT
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var prompt_y = 360 * 0.72;
if (phase == "shield") {
    draw_set_color(c_yellow);
    draw_text(320, prompt_y, "DECRYPT TO BREAK SHIELD");
} else {
    draw_set_color(c_orange);
    draw_text(320, prompt_y, "DECRYPT THE ATTACK CODE");
}

// ENCRYPTED DISPLAY
draw_set_color(c_yellow);
draw_text(320, prompt_y + 25, "Code: " + encrypted);

// INPUT SLOTS
var slot_width = 48;
var gap = 20;
var total_width = (letters_len * slot_width) + ((letters_len - 1) * gap);
var start_x = 320 - (total_width / 2) + (slot_width / 2) + shake_x;
var slot_y = 360 * 0.82 + shake_y;

for (var i = 0; i < letters_len; i++) {
    var _x = start_x + i * (slot_width + gap);
    
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
draw_text(320, slot_y + 45, status_msg);

// INSTRUCTIONS
draw_set_color(c_ltgray);
draw_text(320, 345, "ARROWS: Change | ENTER: Submit");

// Reset draw state
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
