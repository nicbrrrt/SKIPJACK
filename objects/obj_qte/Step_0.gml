if (active) {
    timer -= 1;
    
    // FAIL CONDITION
    if (timer <= 0) {
        active = false;
        hspeed = 0;
        if (instance_exists(obj_battle)) {
            with (obj_battle) event_user(2); 
        }
        instance_destroy();
    } 
    else {
        // INPUT LOGIC
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_down) || 
            keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right)) {
            
            var pressed_key = keyboard_lastkey;

            if (pressed_key == pattern[index]) {
                index += 1;
                
                // WIN CONDITION: STAY IN RM_COMBAT
                if (index >= array_length(pattern)) {
                    active = false;
                    hspeed = 0; 
                    
                    // Trigger the Decryption phase in the current battle manager
                    if (instance_exists(obj_battle)) {
                        with (obj_battle) event_user(3); 
                    }

                    instance_destroy(); 
                }
            } 
            else {
                // WRONG KEY - FAIL
                active = false;
                hspeed = 0;
                if (instance_exists(obj_battle)) {
                    with (obj_battle) event_user(2); 
                }
                instance_destroy();
            }
        }
    }
}