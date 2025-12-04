if (active) {
    timer -= 1;
    
    // --- FAIL CONDITION: Timer runs out OR we hit the player ---
    if (timer <= 0) {
        active = false;
        hspeed = 0; // Stop moving
        show_debug_message("QTE FAILED: Packet hit the player!");
        
        // Trigger Damage on main battle object
        if (instance_exists(obj_battle)) {
            with (obj_battle) event_user(2); 
        }
        
        instance_destroy();
    } 
    else {
        // --- INPUT LOGIC ---
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_down) || 
            keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right)) {
            
            var pressed_key = keyboard_lastkey;

            // CHECK IF INPUT MATCHES PATTERN
            if (pressed_key == pattern[index]) {
                // Correct! Move to next arrow
                index += 1;
                
                // --- WIN CONDITION (ALL ARROWS HIT) ---
                if (index >= array_length(pattern)) {
                    active = false;
                    hspeed = 0; 
                    show_debug_message("QTE SUCCESS: Transitioning to Battle...");
                    
                    // 1. DESTROY THE MANAGER (Important!)
                    // We must destroy obj_battle so it doesn't try to send us back to the lab
                    if (instance_exists(obj_battle)) {
                        instance_destroy(obj_battle); 
                    }

                    // 2. DESTROY THIS MINIGAME
                    instance_destroy(); 

                    // 3. GO TO THE SCRAMBLE BATTLE ROOM
                    // Make sure "rm_battle_scramble" exists in your Asset Browser!
                    room_goto(rm_battle_scramble);
                }
            } 
            else {
                // WRONG KEY - FAIL IMMEDIATELY
                active = false;
                hspeed = 0;
                show_debug_message("QTE FAILED: Wrong input!");
                
                if (instance_exists(obj_battle)) {
                    with (obj_battle) event_user(2); // Trigger Damage
                }
                instance_destroy();
            }
        }
    }
}