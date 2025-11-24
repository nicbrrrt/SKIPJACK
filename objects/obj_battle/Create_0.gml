// Battle manager - starts in IDLE state
global.battle_active = false;
state = "IDLE"; // Changed from "PATH"
cipher_key = 0;
player_hp = 10;
enemy_hp = 10;
cipher_mode = "first";

show_debug_message("BATTLE: Ready! Waiting for start command...");

// Initialize global battle flag
if (!variable_global_exists("battle_active")) {
    global.battle_active = false;
}