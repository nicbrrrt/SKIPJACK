// --- Room Start Event for obj_game_controller ---

// --- FORCE SPAWN JACK ON LOAD ---
if (variable_global_exists("is_loading_from_save") && global.is_loading_from_save) {
    
    // 1. Check if Jack is missing
    if (!instance_exists(obj_jack)) {
        // Create him at the saved coordinates
        var _inst = instance_create_depth(global.target_x, global.target_y, -1000, obj_jack);
        show_debug_message("SYSTEM: Jack was missing, force-spawned at saved location.");
    } else {
        // If he somehow exists, just snap him to the right spot
        obj_jack.x = global.target_x;
        obj_jack.y = global.target_y;
    }
    
    // 2. Unpause the game state just in case
    global.is_paused = false;
    instance_activate_all(); 
    
    // 3. Reset the flag so we don't spawn him twice
    global.is_loading_from_save = false;
}

// Ensure the game is NEVER in a "Cutscene" state when a room first loads
if (instance_exists(obj_jack)) {
    obj_jack.isInCutscene = false; 
    obj_jack.visible = true;
}

if (room == rm_level_1 && !global.level1_intro_done) {
    // 1. Find the Manager and UNLOCK it
    if (instance_exists(obj_codex_manager)) {
        with(obj_codex_manager) {
            unlocked = true; 
            // Breado's Data:
            add_module("MALWARE 101", "PHISHING: Fake emails used to steal data.\nBOTNET: A network of hijacked computers.\nSPYWARE: Software that tracks you in secret.");
        }
    }
    
    // 2. Trigger the Intro Dialogue
    var _npc = instance_find(obj_npc1, 0); // Greg/Breado
    if (_npc != noone) {
        with (_npc) {
            create_textevent([
                "Welcome to the streets, Jack.",
                "I've uploaded the malware basics to your tablet. Check it with 'C'.",
                "Find Clipper and Lea to continue your training."
            ], [id, id, id]);
        }
    }
    global.level1_intro_done = true;
    global.tutorial_complete = true; // VERY IMPORTANT: Jack checks this for the 'C' key!
}

// Keep your existing rm_battle_scramble logic below this...
if (room == rm_battle_scramble) {
    if (!instance_exists(obj_battle_scramble)) {
        instance_create_depth(0, 0, -10000, obj_battle_scramble);
    }
}

if (room == rm_level_1) {
    if (instance_exists(obj_save_manager)) {
        obj_save_manager.save_game();
    }
}

if (variable_global_exists("is_loading_from_save") && global.is_loading_from_save) {
    if (instance_exists(obj_jack)) {
        obj_jack.x = global.target_x;
        obj_jack.y = global.target_y;
        obj_jack.isInCutscene = false; // Ensure he isn't frozen
    }
    global.is_loading_from_save = false; // Reset the flag
}

// --- DYNAMIC NPC SPAWN ---
if (room == rm_level_1 && global.level1_intro_done) {
    if (!instance_exists(obj_lea)) {
        instance_create_depth(236, 28, -100, obj_lea);
    }
    if (!instance_exists(obj_clipper)) {
        instance_create_depth(728, 376, -100, obj_clipper);
    }
}