// --- Room Start Event for obj_npc1 ---

// Only move if we are in Level 1 and the target variables actually exist
if (room == rm_level_1) {
    if (variable_global_exists("greg_target_x") && global.greg_target_x != -1) {
        x = global.greg_target_x;
        y = global.greg_target_y;
        
        // Reset the variables so he doesn't teleport every time you enter the room
        global.greg_target_x = -1;
        global.greg_target_y = -1;
        
        show_debug_message("SYSTEM: Greg snapped to " + string(x) + ", " + string(y));
    }
}

// If we just got back from defeating him, force the dialogue
if (room == rm_level_1 && global.last_battle_id == "greg_boss_defeated") {
    global.greg_quest_started = true;
    
    create_textevent([
        "Impressive work, Jack. But that was just the baseline.",
        "Go find Clipper and Lea. They have the info you need.",
        "Check your HUD for their locations."
    ], [id, id, id]);

    global.last_battle_id = "none"; 
}