// User Event 3 - QTE Success (PACKET CAUGHT)
if (variable_global_exists("is_paused") && global.is_paused) exit;

show_debug_message("BATTLE: QTE SUCCESS - Packet caught! Now decrypt it...");
state = "DECRYPT_PACKET";
cipher_mode = "packet";
cipher_key = scr_roll_cipher_key();

// Spawn second cipher to uncorrupt the packet
show_debug_message("BATTLE: Spawning cipher to uncorrupt packet...");
instance_create_layer(0, 0, "Instances", obj_cipher);