/// Step Event - obj_game_controller

// 1. MOUSE LOCK LOGIC
if (mouse_locked_until_release)
{
    if (!mouse_check_button(mb_left))
    {
        mouse_locked_until_release = false;
    }
    else
    {
        exit; 
    }
}

// 2. ESCAPE KEY TOGGLE
if (keyboard_check_pressed(vk_escape))
{
    if (global.is_paused)
    {
        // --- UNPAUSE ---
        global.is_paused = false;
        instance_activate_all();
        audio_resume_all();
    }
    else
    {
        // --- PAUSE CONDITION FIX ---
        // Allow pause if Jack exists OR if we are in a battle (even if Jack is hidden)
        if (instance_exists(obj_jack) || instance_exists(obj_battle_scramble))
        {
            global.is_paused = true;
            
            // 1. Freeze everyone
            instance_deactivate_all(true); 
            
            // 2. Wake controller up
            instance_activate_object(id); 

            audio_pause_all();
            pause_menu_state = "main";
            mouse_locked_until_release = true;
        }
    }
}

// --- THAT'S IT! NO BUTTON LOGIC HERE ---
// The button clicks are now handled entirely inside the Draw GUI event.