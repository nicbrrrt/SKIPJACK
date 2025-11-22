// --- COLLISION LAYERS ---
// 1. Define the new lab layers
wall_layer_1 = layer_tilemap_get_id("ts_lab2"); 
wall_layer_2 = layer_tilemap_get_id("ts_lab3"); 
wall_layer_main = layer_tilemap_get_id("ts_lab"); 

// 2. Collisions for the tilemaps
my_tilemap = layer_tilemap_get_id("Buildings");
tilemap2 = layer_tilemap_get_id("Design");
tilemap1 = layer_tilemap_get_id("Lab");
tilemap3 = layer_tilemap_get_id("Lab2");
tilemap4 = layer_tilemap_get_id("Lab3");
tilemap5 = layer_tilemap_get_id("Lab4");