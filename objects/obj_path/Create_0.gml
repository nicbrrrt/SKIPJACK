// obj_path Create Event - WITH RANDOM MAPS
show_debug_message("PATH: Create event running");

// Seed the random generator for true randomness
randomize();

// Grid setup
grid_w = 8; 
grid_h = 6;
cell = 32;
origin_x = 120; 
origin_y = 80;

// Get random map and positions
var map_data = scr_get_random_map();
var positions = scr_get_random_start_target();

start = positions.start;
target = positions.target;

// Create obstacles from the selected map
obstacles = [];
for (var gy = 0; gy < grid_h; gy++) {
    for (var gx = 0; gx < grid_w; gx++) {
        if (map_data[gy][gx] == 1) { // 1 represents a wall
            // Don't put obstacles on start or target
            if (gx != start[0] || gy != start[1]) && (gx != target[0] || gy != target[1]) {
                array_push(obstacles, [gx, gy]);
            }
        }
    }
}

path_nodes = [];
max_path_length = 15; // Slightly longer for more complex maps
success = false;
valid = false; // ← ADD THIS LINE RIGHT HERE

// Cursor position (starts at start position)
cursor_x = start[0];
cursor_y = start[1];

show_debug_message("PATH: Loaded map with " + string(array_length(obstacles)) + " obstacles");
show_debug_message("PATH: Start at " + string(start[0]) + "," + string(start[1]));
show_debug_message("PATH: Target at " + string(target[0]) + "," + string(target[1]));