// --- Create Event of obj_battle ---

// Battle manager - NOW STARTS ACTIVE
global.battle_active = true;
state = "PATH"; // Changed from "IDLE" to start immediately
cipher_key = 0;
player_hp = 10;
enemy_hp = 10;
cipher_mode = "first";

show_debug_message("BATTLE: Room loaded. Starting PATH phase immediately...");

// Initialize global battle flag if missing
if (!variable_global_exists("battle_active")) {
    global.battle_active = true;
}

// --- SELF-START LOGIC ---
// Since the computer object is in the other room, we must spawn the
// first minigame (obj_path) ourselves right now.
if (!instance_exists(obj_path)) {
    instance_create_layer(0, 0, "Instances", obj_path);
}