// --- USER EVENT 0 (CIPHER SPAWN) ---

show_debug_message("BATTLE: Spawning Cipher...");
state = "CIPHER1"; 

if (global.seen_cipher_tutorial == false) {
    var tut = instance_create_layer(0, 0, "Instances", obj_tutorial);
    tut.text_title = "DECRYPTION REQUIRED";
    tut.text_body = "The enemy shield is up.\n\nUse UP/DOWN to shift the letters until they decrypt the message based on the KEY.\n(Key -1 means A becomes Z)";
    tut.next_object = obj_cipher;
    
    global.seen_cipher_tutorial = true;
} else {
    instance_create_layer(0, 0, "Instances", obj_cipher);
}