// --- Step Event of obj_start_combat ---

// 1. SAFETY CHECK: Only run code if the player exists
if (instance_exists(obj_jack)) {
    
    // Get the specific instance of the player
    var _player = instance_find(obj_jack, 0);

    // 2. DISTANCE CHECK: Are we close enough?
    if (point_distance(x, y, _player.x, _player.y) < interaction_range) {
        
        // 3. INPUT CHECK: Did they press E?
        if (keyboard_check_pressed(ord("E"))) {
            
            show_debug_message("=== START COMBAT - E KEY PRESSED ==="); 
            
            // --- THE TRANSITION LOGIC ---
            
            // Save the Return Ticket (Where to go back to)
            global.return_room = room;
            global.return_x = _player.x;
            global.return_y = _player.y;

            // Go to the combat room
            room_goto(rm_combat);
        }
    }
}