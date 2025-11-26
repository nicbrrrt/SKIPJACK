// Get cipher_key from battle manager (fallback random)
if (variable_instance_exists(obj_battle, "cipher_key")) {
    key = obj_battle.cipher_key;
} else {
    // Generate -5 to 5, excluding 0
    key = 0;
    while (key == 0) {
        key = irandom_range(-5, 5);
    }
}

letters_len = 4;
plaintext = scr_random_letters(letters_len);   // generate random plaintext
encrypted = scr_caesar_encode(plaintext, -key); // the player sees this

player_input = array_create(letters_len);
for (var i=0;i<letters_len;i++) player_input[i] = "";

current_slot = 0;
font = fnt_default;

// ... (Keep your existing code) ...

// VISUAL FEEDBACK VARIABLES
shake_timer = 0;       // How long to shake the screen
text_color = c_white;  // Default text color
status_msg = "";       // "ACCESS DENIED" or "DECRYPTED"
success_timer = 0;     // Delay before closing on win