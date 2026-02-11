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

if (room == rm_level_1) {
    // 1. CODEX UPDATE: Only do this once
    if (!global.level1_intro_done) {
        // Add new definitions to your codex system here
        // Example: ds_list_add(global.codex_list, "Phishing", "Spyware", "Botnets");
        
        // 2. TRIGGER THE INTRO DIALOGUE
        // We use a slight delay or find Greg to speak
        var _greg = instance_find(obj_npc1, 0);
        if (_greg != noone) {
            with (_greg) {
                create_textevent([
                    "Welcome to the streets, Jack.",
                    "The system out here is crawling with malware. It's dangerous.",
                    "I've updated your Codex with definitions for Phishing, Spyware, and Botnets.",
                    "Come find me when you're ready to clear the sector."
                ], [id, id, id, id]);
            }
        }
        global.level1_intro_done = true; // Lock this so it doesn't repeat
    }
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