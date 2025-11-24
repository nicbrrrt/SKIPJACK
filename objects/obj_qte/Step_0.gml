if (active) {
    timer -= 1;
    
    // Time's up - fail
    if (timer <= 0) {
        active = false;
        show_debug_message("QTE FAILED: Time's up!");
        with (obj_battle) event_user(2); // QTE fail
        instance_destroy();
    } else {
        // Check for arrow key presses
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_down) || 
            keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right)) {
            
            var pressed_key = keyboard_lastkey;
            
            // Check if it matches the current pattern step
            if (pressed_key == pattern[index]) {
                // Correct input!
                index += 1;
                show_debug_message("QTE: Correct! Step " + string(index) + "/" + string(pattern_length));
                
                // Success if finished entire pattern
                if (index >= array_length(pattern)) {
                    active = false;
                    show_debug_message("QTE SUCCESS: Packet caught!");
                    with (obj_battle) event_user(3); // QTE success
                    instance_destroy();
                }
            } else {
                // Wrong key - fail
                active = false;
                show_debug_message("QTE FAILED: Wrong input!");
                with (obj_battle) event_user(2); // QTE fail
                instance_destroy();
            }
        }
    }
}