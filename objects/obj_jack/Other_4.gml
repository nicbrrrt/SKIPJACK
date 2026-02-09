// --- Room Start Event for obj_jack ---

// 1. RE-SCAN FOR COLLISION LAYER
// In every room, make sure your wall tile layer is named "Collision"
my_tilemap = layer_tilemap_get_id("Collision");

// 2. GREG TELEPORT LOGIC
if (room == rm_level_1) {
    if (variable_global_exists("target_x") && global.target_x != -1) {
        x = global.target_x;
        y = global.target_y;
        global.target_x = -1; 
    }
}