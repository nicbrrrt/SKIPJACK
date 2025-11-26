// --- Create Event of obj_battle ---

// 1. SAFETY INITIALIZATION (Prevents the Crash)
// If these variables don't exist yet, we create them right now.
if (!variable_global_exists("seen_path_tutorial")) {
    global.seen_path_tutorial = false;
    global.seen_cipher_tutorial = false;
    global.seen_qte_tutorial = false;
}

// 2. WRONG ROOM SAFETY CHECK
if (room != rm_combat) { 
    show_debug_message("ERROR: obj_battle found in wrong room! Destroying it.");
    instance_destroy();
    exit; 
}

// 3. BATTLE SETUP
global.battle_active = true;
state = "PATH"; 
cipher_key = 0;
player_hp = 10;
enemy_hp = 10;
cipher_mode = "first";

show_debug_message("BATTLE: Room loaded. Starting PATH phase...");

// Initialize global battle flag if missing
if (!variable_global_exists("battle_active")) {
    global.battle_active = true;
}

// --- SELF-START LOGIC WITH TUTORIAL ---

if (!instance_exists(obj_path)) {
    
    // Check if we have seen the tutorial yet
    if (global.seen_path_tutorial == false) {
        
        // Show Tutorial
        var tut = instance_create_layer(0, 0, "Instances", obj_tutorial);
        tut.text_title = "PATHFINDING PROTOCOL";
        tut.text_body = "Connect the START (S) to the GOAL (G) using arrow keys.\n\nAvoid firewalls and obstacles.";
        tut.next_object = obj_path; // Tell it to spawn obj_path when done
        
        // Mark as seen so it doesn't show next time
        global.seen_path_tutorial = true;
        
    } else {
        // We have seen it, just spawn the game normally
        instance_create_layer(0, 0, "Instances", obj_path);
    }
}