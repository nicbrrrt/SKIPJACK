//STEP

if (mouse_check_button_pressed(mb_left)) {
    show_debug_message("Clicked! Overlapping Transition? " + string(instance_exists(obj_transition)));
}

if (fade_mode == "fading_in")
{
    fade_alpha = fade_alpha - fade_speed;
    if (fade_alpha <= 0)
    {
        fade_alpha = 0;
        // OLD CODE: fade_mode = "idle"; 
        // NEW CODE: Destroy it so the door can make a new one later!
        instance_destroy(); 
    }
}
// ... (Keep the rest of the code the same)
else if (fade_mode == "fading_out")
{ 
    fade_alpha = fade_alpha + fade_speed;
    if (fade_alpha >= 1)
    {
        fade_alpha = 1;
        fade_timer = fade_timer_max; // Start the timer
        fade_mode = "waiting";     // Go to our new "waiting" mode
    }
}
else if (fade_mode == "waiting")
{
    // This is the "black screen" pause
    fade_timer = fade_timer - 1; 
    
    // When timer hits zero, CHANGE ROOM and MOVE PLAYER
    if (fade_timer <= 0)
    {
        room_goto(target_room);
        
        // --- NEW: Move Jack to the correct spot ---
        // Since Jack is Persistent, he exists. We just need to move him.
        if (instance_exists(obj_jack)) {
            obj_jack.x = target_x;
            obj_jack.y = target_y;
        }

        fade_mode = "fading_in"; 
    }
}