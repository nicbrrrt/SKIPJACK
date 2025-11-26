// --- Step Event of obj_qte ---

if (active) {
    timer -= 1;
    
    // FAIL CONDITION: Timer runs out OR we hit the player
    // Since we calculated speed based on timer, they happen at the same time.
    if (timer <= 0) {
        active = false;
        hspeed = 0; // Stop moving
        show_debug_message("QTE FAILED: Packet hit the player!");
        
        with (obj_battle) event_user(2); // Trigger Damage
        instance_destroy();
    } 
    else {
        // --- INPUT LOGIC (Same as before) ---
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_down) || 
            keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right)) {
            
            var pressed_key = keyboard_lastkey;

            if (pressed_key == pattern[index]) {
                // Correct!
                index += 1;
                
                // WIN CONDITION
                if (index >= array_length(pattern)) {
                    active = false;
                    hspeed = 0; // Stop moving
                    show_debug_message("QTE SUCCESS: Caught!");
                    
                    with (obj_battle) event_user(3); // Trigger Success
                    instance_destroy();
                }
            } else {
                // Wrong Key - Fail immediately
                active = false;
                hspeed = 0;
                show_debug_message("QTE FAILED: Wrong input!");
                
                with (obj_battle) event_user(2); // Trigger Damage
                instance_destroy();
            }
        }
    }
}