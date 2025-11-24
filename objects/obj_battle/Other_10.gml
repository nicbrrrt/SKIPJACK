// User Event 0 - Pathfinding completed
show_debug_message("=== BATTLE: User Event 0 TRIGGERED! ===");
show_debug_message("=== BATTLE: cipher_key = " + string(cipher_key) + " ===");
show_debug_message("=== BATTLE: state = " + string(state) + " ===");

state = "CIPHER1";
cipher_mode = "first";

// Spawn the cipher minigame
show_debug_message("=== BATTLE: Spawning obj_cipher... ===");
instance_create_layer(0, 0, "Instances", obj_cipher);
show_debug_message("=== BATTLE: obj_cipher should be spawned ===");