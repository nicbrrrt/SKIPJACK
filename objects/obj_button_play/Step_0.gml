if (mouse_check_button_pressed(mb_left)) 
{
    // Check if mouse is touching the button
    if (position_meeting(mouse_x, mouse_y, id)) 
    {
        show_debug_message("CLICK DETECTED! Forcing Game Start...");

        // 1. NUKE EVERYTHING (Don't check IF they exist, just try to destroy them)
        // This ensures the slate is clean for the new game.
        if (instance_exists(obj_transition)) instance_destroy(obj_transition);
        if (instance_exists(obj_jack)) instance_destroy(obj_jack);
        if (instance_exists(obj_game_controller)) instance_destroy(obj_game_controller);
        
        // 2. CREATE A FRESH TRANSITION
        var _new_trans = instance_create_depth(0, 0, -9999, obj_transition);
        
        // 3. SET THE DESTINATION (CRITICAL STEP!)
        // Make sure "rm_cutscene_intro" is the EXACT name of your room resource.
        _new_trans.target_room = rm_cutscene_lab; 
        
        // 4. START THE FADE
        _new_trans.fade_mode = "fading_out";
        _new_trans.fade_alpha = 0; // Ensure it starts invisible
    }
}