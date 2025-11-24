// Get cipher_key from battle manager (fallback random)
if (variable_instance_exists(obj_battle, "cipher_key")) {
    key = obj_battle.cipher_key;
} else key = irandom_range(1,25);

letters_len = 4;
plaintext = scr_random_letters(letters_len);   // generate random plaintext
encrypted = scr_caesar_encode(plaintext, key); // the player sees this

player_input = array_create(letters_len);
for (var i=0;i<letters_len;i++) player_input[i] = "";

current_slot = 0;
font = fnt_default;
