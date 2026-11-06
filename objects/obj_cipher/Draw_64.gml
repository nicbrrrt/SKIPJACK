// --- Draw GUI Event of obj_cipher (Clean, Visual & Minimal Text) ---

draw_set_font(fnt_dialogue);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var gui_width  = display_get_gui_width();
var gui_height = display_get_gui_height();

var shake_x = (shake_timer > 0) ? irandom_range(-5, 5) : 0;
var shake_y = (shake_timer > 0) ? irandom_range(-5, 5) : 0;

var center_x = (gui_width / 2) + shake_x;
var center_y = (gui_height / 2) + shake_y;

// --- 1. GREY OUT FULL SCREEN BACKDROP & DRAW CIPHER PANEL ---
if (!instance_exists(obj_battle)) {
    draw_set_alpha(0.82);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gui_width, gui_height, false);
}

var _pw  = 548;
var _ph  = 276;
var _px1 = center_x - _pw * 0.5;
var _py1 = center_y - _ph * 0.5;
var _px2 = center_x + _pw * 0.5;
var _py2 = center_y + _ph * 0.5;

draw_set_alpha(0.96);
draw_set_color(make_color_rgb(14, 18, 30));
draw_rectangle(_px1, _py1, _px2, _py2, false);
draw_set_alpha(1.0);
draw_set_color(is_holding_lock ? make_color_rgb(255, 135, 40) : make_color_rgb(255, 85, 145));
draw_rectangle(_px1, _py1, _px2, _py2, true);
draw_rectangle(_px1 + 3, _py1 + 3, _px2 - 3, _py2 - 3, true);

// --- 2. CLEAN HEADER & KEY BADGE PILL ---
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _has_key = instance_exists(obj_battle)
            || (!is_holding_lock && variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key);
var _k_str   = (key > 0) ? ("+" + string(key)) : string(key);

var _title_str = "CAESAR CIPHER LOCK";
if (instance_exists(obj_battle)) {
    var mode = variable_instance_exists(obj_battle, "cipher_mode") ? obj_battle.cipher_mode : "first";
    _title_str = (mode == "first") ? "DECRYPT SHIELD" : "UNCORRUPT PACKET";
} else if (is_holding_lock) {
    _title_str = "HOLDING CELL LOCK";
}

draw_set_color(is_holding_lock ? make_color_rgb(255, 145, 50) : make_color_rgb(255, 105, 160));
draw_text_transformed(center_x, _py1 + 20, _title_str, 1.05, 1.05, 0);

// Compact Key Pill
var _pill_y = _py1 + 44;
draw_set_color(make_color_rgb(22, 30, 48));
draw_rectangle(center_x - 125, _pill_y - 11, center_x + 125, _pill_y + 11, false);

if (_has_key) {
    draw_set_color(c_lime);
    draw_rectangle(center_x - 125, _pill_y - 11, center_x + 125, _pill_y + 11, true);
    draw_text_transformed(center_x, _pill_y, "SHIFT KEY:  " + _k_str, 0.92, 0.92, 0);
} else if (is_holding_lock) {
    draw_set_color(make_color_rgb(255, 200, 55));
    draw_rectangle(center_x - 125, _pill_y - 11, center_x + 125, _pill_y + 11, true);
    draw_text_transformed(center_x, _pill_y, "KEY: ???  (Check Cell PC / Note)", 0.84, 0.84, 0);
} else {
    draw_set_color(make_color_rgb(255, 190, 55));
    draw_rectangle(center_x - 125, _pill_y - 11, center_x + 125, _pill_y + 11, true);
    draw_text_transformed(center_x, _pill_y, "KEY: ???  (Find Gold Key Vault)", 0.84, 0.84, 0);
}

// --- 3. VISUAL A-Z ALPHABET RULER (No text clutter) ---
var _strip_y  = _py1 + 78;
var _cell_w   = 20;
var _strip_w  = 26 * _cell_w;
var _strip_x1 = center_x - _strip_w * 0.5;

draw_set_color(make_color_rgb(22, 28, 44));
draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, false);
draw_set_color(make_color_rgb(70, 90, 125));
draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, true);

var _active_enc_ch  = string_char_at(encrypted, current_slot + 1);
var _active_enc_idx = ord(_active_enc_ch) - ord("A");
var _active_usr_ch  = player_input[current_slot];
var _active_usr_idx = (_active_usr_ch != "") ? (ord(_active_usr_ch) - ord("A")) : -1;

for (var _a = 0; _a < 26; _a++) {
    var _lx = _strip_x1 + _a * _cell_w + _cell_w * 0.5;
    var _ch = chr(ord("A") + _a);

    if (_a == _active_usr_idx) {
        draw_set_color(c_lime);
        draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, false);
        draw_set_color(c_black);
        draw_text(_lx, _strip_y, _ch);
    } else if (_a == _active_enc_idx) {
        draw_set_color(make_color_rgb(255, 185, 40));
        draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, false);
        draw_set_color(c_black);
        draw_text(_lx, _strip_y, _ch);
    } else {
        draw_set_color(make_color_rgb(160, 175, 200));
        draw_text_transformed(_lx, _strip_y, _ch, 0.85, 0.85, 0);
    }
}

// --- 4. ENCRYPTED WORD & 4 DECODING SLOTS ---
var slot_width        = 48;
var slot_gap          = 26;
var total_slots_width = (slot_width * letters_len) + (slot_gap * (letters_len - 1));
var slots_start_x     = center_x - (total_slots_width / 2) + (slot_width / 2);
var slots_y           = _py1 + 162;

for (var i = 0; i < letters_len; i++) {
    var slot_center_x = slots_start_x + (i * (slot_width + slot_gap));
    var slot_center_y = slots_y;
    var _slot_enc_ch  = string_char_at(encrypted, i + 1);

    // Encrypted Letter above slot + small arrow
    draw_set_color((i == current_slot) ? make_color_rgb(255, 205, 50) : make_color_rgb(175, 190, 210));
    draw_text(slot_center_x, slot_center_y - 40, _slot_enc_ch);
    draw_set_color(c_gray);
    draw_text_transformed(slot_center_x, slot_center_y - 26, "v", 0.72, 0.72, 0);

    // Slot box
    if (i == current_slot) {
        draw_sprite(spr_slot_active, 0, slot_center_x, slot_center_y);
    } else {
        draw_sprite(spr_slot, 0, slot_center_x, slot_center_y);
    }

    // Decoded Letter + concise Shift number below
    if (player_input[i] != "") {
        draw_set_color(c_white);
        draw_text(slot_center_x, slot_center_y, player_input[i]);

        var _diff = (ord(player_input[i]) - ord(_slot_enc_ch) + 26) mod 26;
        if (_diff > 13) _diff -= 26;
        var _diff_str = (_diff > 0) ? ("+" + string(_diff)) : string(_diff);

        var _matches_key = (_has_key && _diff == key);
        draw_set_color(_matches_key ? c_lime : make_color_rgb(170, 190, 215));
        draw_text_transformed(slot_center_x, slot_center_y + 30, _diff_str, 0.85, 0.85, 0);
    } else {
        draw_set_color(c_gray);
        draw_text(slot_center_x, slot_center_y, "?");
    }
}

// --- 5. SHORT STATUS FEEDBACK & CLEAN FOOTER ---
if (status_msg != "") {
    draw_set_color(text_color);
    draw_text_transformed(center_x, _py2 - 42, status_msg, 0.88, 0.88, 0);
}

draw_set_color(make_color_rgb(150, 170, 195));
if (instance_exists(obj_battle)) {
    draw_text_transformed(center_x, _py2 - 18, "[ARROWS] Select & Shift   |   [ENTER] Submit", 0.82, 0.82, 0);
} else {
    draw_text_transformed(center_x, _py2 - 18, "[ARROWS] Select & Shift   |   [ENTER] Unlock   |   [ESC] Back", 0.82, 0.82, 0);
}

draw_set_font(fnt_default);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);
