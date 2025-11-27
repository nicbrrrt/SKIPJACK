/// Step Event - obj_game_controller

// 1. MOUSE LOCK LOGIC (Fixes the "Double Click" bug)
// If the mouse is locked, wait until the user releases the button before allowing clicks.
if (mouse_locked_until_release)
{
    if (!mouse_check_button(mb_left))
    {
        mouse_locked_until_release = false; // Unlocked! Ready to click.
    }
    else
    {
        exit; // Stop processing any inputs below until mouse is released
    }
}

// 2. ESCAPE KEY TOGGLE
if (keyboard_check_pressed(vk_escape))
{
    if (global.is_paused)
    {
        // --- UNPAUSE ---
        global.is_paused = false;
        instance_activate_all(); // Wake everyone up
        audio_resume_all();      // Resume music
    }
    else
    {
        // --- PAUSE ---
        // Only pause if the player actually exists (don't pause the main menu)
        if (instance_exists(obj_jack))
        {
            global.is_paused = true;
            
            // 1. Freeze everyone EXCEPT this controller
            instance_deactivate_all(true); 
            
            // 2. Immediately wake myself up so I can control the menu
            instance_activate_object(id); 

            // 3. Pause Audio
            audio_pause_all();

            // 4. Reset Menu State
            pause_menu_state = "main";
            mouse_locked_until_release = true; // Lock click so we don't accidentally click a button instantly
        }
    }
}

// 3. MENU INTERACTION (Only runs when Paused)
if (global.is_paused)
{
    // Get Mouse Coordinates on the GUI layer (not the room world)
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    
    // Define Button Centers (Must match your Draw GUI code!)
    var _guiW = display_get_gui_width();
    var _guiH = display_get_gui_height();
    var _cx = _guiW / 2;
    var _cy = _guiH / 2 - 50;

    // Check for Left Click
    if (mouse_check_button_pressed(mb_left))
    {
        // --- BUTTON 1: RESUME ---
        // (Checking a box around the "Resume" text)
        if (point_in_rectangle(_mx, _my, _cx - 100, _cy, _cx + 100, _cy + 40))
        {
            global.is_paused = false;
            instance_activate_all();
            audio_resume_all();
        }
        
        // --- BUTTON 2: QUIT TO MENU ---
        // (Checking a box around the "Quit" text, 100 pixels lower)
        if (point_in_rectangle(_mx, _my, _cx - 100, _cy + 100, _cx + 100, _cy + 140))
        {
            // 1. Unpause first so we can find and destroy objects
            instance_activate_all();
            global.is_paused = false;

            // 2. DESTROY PERSISTENT OBJECTS (The "Ghost Fix")
            // If we don't do this, Jack will appear on the Main Menu!
            if (instance_exists(obj_jack)) instance_destroy(obj_jack);
            if (instance_exists(obj_transition)) instance_destroy(obj_transition);
            if (instance_exists(obj_warp)) instance_destroy(obj_warp);
            if (instance_exists(obj_textevent)) instance_destroy(obj_textevent);

            // 3. Go to Menu
            room_goto(rm_menu);
        }
    }
}