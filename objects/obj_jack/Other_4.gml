// --- Room Start Event for obj_jack ---

// Check if we are entering Level 1
if (room == rm_level_1) {
    // Check if the target variables have been set to a valid position
    if (variable_global_exists("target_x") && global.target_x != -1) {
        
        x = global.target_x;
        y = global.target_y;
        
        // Reset the variable so you don't teleport every time you enter the room
        global.target_x = -1; 
        
        show_debug_message("JACK: Teleport successful to " + string(x) + "," + string(y));
    }
}