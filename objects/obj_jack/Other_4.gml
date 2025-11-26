// --- Room Start Event of obj_jack ---

// --- 1. RE-DEFINE COLLISION LAYERS (Necessary because Layer IDs change per room) ---
wall_layer_1 = layer_tilemap_get_id("ts_lab2"); 
wall_layer_2 = layer_tilemap_get_id("ts_lab3"); 
wall_layer_main = layer_tilemap_get_id("ts_lab"); 

my_tilemap = layer_tilemap_get_id("Buildings");
tilemap2 = layer_tilemap_get_id("Design");
tilemap1 = layer_tilemap_get_id("Lab");
tilemap3 = layer_tilemap_get_id("Lab2");
tilemap4 = layer_tilemap_get_id("Lab3");
tilemap5 = layer_tilemap_get_id("Lab4");

// --- 2. RETURN TICKET LOGIC ---
// Check if the global variable exists first (prevents crash on first run)
if (variable_global_exists("return_room") && global.return_room != -1) {
    
    // Check if the room we just loaded IS the return room
    if (room == global.return_room) {
        x = global.return_x;
        y = global.return_y;
        
        // TEAR UP THE TICKET (So we don't teleport again randomly)
        global.return_room = -1; 
        
        show_debug_message("Player returned to saved position.");
    }
}

// ... (Your existing Return Ticket code is above this) ...

// --- VISIBILITY CHECK ---
// If we are in the battle room, hide the top-down player object.
// We only want to see the cool battle sprites we are drawing in the GUI.
if (room == rm_combat) {
    visible = false;   // Turn invisible
    speed = 0;         // Stop moving (just in case)
} else {
    visible = true;    // Make sure we are visible when we go back to the Lab!
}