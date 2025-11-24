// User Event 3 - QTE Success (PACKET CAUGHT)
show_debug_message("BATTLE: QTE SUCCESS - Packet caught! Now decrypt it...");
state = "DECRYPT_PACKET";
cipher_mode = "packet";

// Spawn second cipher to uncorrupt the packet
show_debug_message("BATTLE: Spawning cipher to uncorrupt packet...");
instance_create_layer(0, 0, "Instances", obj_cipher);