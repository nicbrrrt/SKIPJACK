// obj_path Step Event - WITH NO BACKTRACKING
var cursor_moved = false;

// Store previous cursor position
var prev_cursor_x = cursor_x;
var prev_cursor_y = cursor_y;

// Move cursor with arrow keys - WITH WALL CHECKING AND NO BACKTRACKING
if (keyboard_check_pressed(vk_right)) {
    var new_x = cursor_x + 1;
    var new_y = cursor_y;
    if (new_x < grid_w && !is_obstacle(new_x, new_y) && !is_in_path(new_x, new_y)) {
        cursor_x = new_x;
        cursor_moved = true;
    }
}
if (keyboard_check_pressed(vk_left)) {
    var new_x = cursor_x - 1;
    var new_y = cursor_y;
    if (new_x >= 0 && !is_obstacle(new_x, new_y) && !is_in_path(new_x, new_y)) {
        cursor_x = new_x;
        cursor_moved = true;
    }
}
if (keyboard_check_pressed(vk_down)) {
    var new_x = cursor_x;
    var new_y = cursor_y + 1;
    if (new_y < grid_h && !is_obstacle(new_x, new_y) && !is_in_path(new_x, new_y)) {
        cursor_y = new_y;
        cursor_moved = true;
    }
}
if (keyboard_check_pressed(vk_up)) {
    var new_x = cursor_x;
    var new_y = cursor_y - 1;
    if (new_y >= 0 && !is_obstacle(new_x, new_y) && !is_in_path(new_x, new_y)) {
        cursor_y = new_y;
        cursor_moved = true;
    }
}

// Auto-add path when cursor moves to a new cell
if (cursor_moved && (cursor_x != prev_cursor_x || cursor_y != prev_cursor_y)) {
    var gx = cursor_x;
    var gy = cursor_y;
    
    var is_start = (gx == start[0] && gy == start[1]);
    
    if (!is_start) {
        array_push(path_nodes, [gx, gy]);
        show_debug_message("Auto-added node at: " + string(gx) + "," + string(gy));
    }
}

// Remove last node with BACKSPACE (undo) - STILL ALLOWED
if (keyboard_check_pressed(vk_backspace)) {
    if (array_length(path_nodes) > 0) {
        array_pop(path_nodes);
        show_debug_message("Removed last node");
        
        // Move cursor back to the last node position
        if (array_length(path_nodes) > 0) {
            var last_node = path_nodes[array_length(path_nodes) - 1];
            cursor_x = last_node[0];
            cursor_y = last_node[1];
        } else {
            // If no nodes left, go back to start
            cursor_x = start[0];
            cursor_y = start[1];
        }
    }
}

// Clear entire path with DELETE key
if (keyboard_check_pressed(vk_delete)) {
    path_nodes = [];
    cursor_x = start[0];
    cursor_y = start[1];
    show_debug_message("Cleared entire path");
}

// Submit with ENTER key
if (keyboard_check_pressed(vk_enter)) {
    var valid = true;
    
    if (array_length(path_nodes) == 0) {
        valid = false;
        show_debug_message("No path created!");
    } else {
        // Check if path reaches target
        var last_node = path_nodes[array_length(path_nodes) - 1];
        var reached_target = (last_node[0] == target[0] && last_node[1] == target[1]);
        
        if (!reached_target) {
            valid = false;
            show_debug_message("Path doesn't reach target!");
        }
        
        // Check length
        if (array_length(path_nodes) > max_path_length) {
            valid = false;
            show_debug_message("Path too long!");
        }
    }
    
    if (valid) {
        success = true;
        var the_key = irandom_range(1, 25);
        
        // ADDED DEBUG MESSAGES
        show_debug_message("=== PATH: SUCCESS! Valid path found ===");
        show_debug_message("=== PATH: Generated key: " + string(the_key) + " ===");
        
        // Check if obj_battle exists
        if (instance_exists(obj_battle)) {
            show_debug_message("=== PATH: obj_battle found! Calling event_user(0) ===");
            with (obj_battle) {
                cipher_key = the_key;
                event_user(0); // Path success
            }
        } else {
            show_debug_message("=== PATH: ERROR - obj_battle does not exist! ===");
        }
        
        instance_destroy();
        show_debug_message("=== PATH: obj_path destroyed ===");
    } else {
        // Reset on failure
        path_nodes = [];
        cursor_x = start[0];
        cursor_y = start[1];
        show_debug_message("Invalid path! Try again.");
    }
}

// Helper function to check if a cell is an obstacle
function is_obstacle(gx, gy) {
    for (var i = 0; i < array_length(obstacles); i++) {
        var obs = obstacles[i];
        if (obs[0] == gx && obs[1] == gy) {
            return true;
        }
    }
    return false;
}

// NEW: Helper function to check if a cell is already in the path
function is_in_path(gx, gy) {
    for (var i = 0; i < array_length(path_nodes); i++) {
        var node = path_nodes[i];
        if (node[0] == gx && node[1] == gy) {
            return true;
        }
    }
    return false;
}