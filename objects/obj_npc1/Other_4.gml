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