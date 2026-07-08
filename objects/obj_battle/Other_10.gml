// --- USER EVENT 0 (CIPHER SPAWN) ---
if (variable_global_exists("is_paused") && global.is_paused) exit;

show_debug_message("BATTLE: Spawning Cipher...");
state = "CIPHER1";
cipher_key = scr_roll_cipher_key();

if (global.seen_cipher_tutorial == false) {
    var tut = instance_create_layer(0, 0, "Instances", obj_tutorial);
    tut.text_title     = "DECRYPTION REQUIRED";
    tut.text_body      = "The enemy shield is up.\n\nUse UP/DOWN to shift the letters until they decrypt the message based on the KEY.\n(Key -1 means A becomes Z)";
    tut.next_object    = obj_cipher;
    tut.tutorial_image      = spr_tutorial_img_2;
    tut.tutorial_image_body = "Press UP to cycle forward through letters.\nPress DOWN to cycle backward through letters.\nPress LEFT or RIGHT to switch tiles.";
    global.seen_cipher_tutorial = true;
} else {
    instance_create_layer(0, 0, "Instances", obj_cipher);
}