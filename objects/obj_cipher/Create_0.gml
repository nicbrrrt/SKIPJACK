/// @description obj_cipher — Create Event
/// Works both inside obj_battle (rm_combat) and standalone on dungeon Caesar doors.

depth = -15000;

target_door_x   = x;
target_door_y   = y;
is_holding_lock = false;

// Check if this cipher lock belongs to the Security Holding Room (Brig)
if (!instance_exists(obj_battle)) {
    if (instance_exists(obj_dungeon_generator)
        && obj_dungeon_generator.logic_map[obj_dungeon_generator.active_col][obj_dungeon_generator.active_row] == ROOM_HOLDING)
    {
        is_holding_lock = true;
    } else {
        var _tx = target_door_x;
        var _ty = target_door_y;
        with (obj_door_caesar_lock) {
            if (point_distance(draw_x, draw_y, _tx, _ty) <= 40 && is_holding_door) {
                other.is_holding_lock = true;
            }
        }
    }
}

// Get cipher_key from battle manager, or Holding Room key, or dungeon floor key, or fallback random
if (instance_exists(obj_battle) && variable_instance_exists(obj_battle, "cipher_key")) {
    key = obj_battle.cipher_key;
} else if (is_holding_lock && variable_global_exists("holding_cipher_key")) {
    key = global.holding_cipher_key;
} else if (variable_global_exists("dungeon_cipher_key")) {
    key = global.dungeon_cipher_key;
} else {
    key = 0;
    while (key == 0) {
        key = irandom_range(-5, 5);
    }
}

letters_len = 4;
if (instance_exists(obj_battle)) {
    plaintext = scr_random_letters(letters_len); // Battle mode: random letters
} else {
    // Dungeon mode: real 4-letter cybersecurity/computing words so decoding feels rewarding!
    plaintext = choose("DATA", "CODE", "LOCK", "BYTE", "HASH", "PORT", "NODE", "AUTH", "SAFE", "HOST", "PING", "ROOT");
}
encrypted   = scr_caesar_encode(plaintext, -key); // the player sees this

player_input = array_create(letters_len);
for (var i = 0; i < letters_len; i++) player_input[i] = "";

current_slot = 0;
font         = fnt_default;

// VISUAL FEEDBACK VARIABLES
shake_timer   = 0;       // How long to shake the screen
text_color    = c_white; // Default text color
status_msg    = "";      // "ACCESS DENIED" or "DECRYPTED"
success_timer = 0;       // Delay before closing on win

// --- THE DEBUG ADDITION ---
show_debug_message("CHEAT SHEET: The answer is " + string(plaintext) + " (Key: " + string(key) + ")");

// --- SHIFT MINI GAME: start sound ---
if (instance_exists(obj_battle)) {
    audio_play_sound(ms_start, 10, false);
} else {
    audio_play_sound(snd_select, 10, false);
}
