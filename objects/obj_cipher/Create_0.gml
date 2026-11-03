/// @description obj_cipher — Create Event
/// Works both inside obj_battle (rm_combat) and standalone on dungeon Caesar doors.

depth = -15000;

target_door_x = x;
target_door_y = y;

// Get cipher_key from battle manager, or dungeon floor key, or fallback random
if (instance_exists(obj_battle) && variable_instance_exists(obj_battle, "cipher_key")) {
    key = obj_battle.cipher_key;
} else if (variable_global_exists("dungeon_cipher_key")) {
    key = global.dungeon_cipher_key;
} else {
    key = 0;
    while (key == 0) {
        key = irandom_range(-5, 5);
    }
}

letters_len = 4;
plaintext   = scr_random_letters(letters_len);   // generate random plaintext
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
audio_play_sound(ms_start, 10, false);
