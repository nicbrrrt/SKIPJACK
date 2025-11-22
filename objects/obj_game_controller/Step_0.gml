/// Step Event - obj_game_controller

// === ESC toggle (runs every frame) ===
if (keyboard_check_pressed(vk_escape))
{
    if (global.is_paused)
    {
        // Unpause: resume audio & reactivate game objects.
        global.is_paused = false;

        // Reactivate everything that was deactivated (if you used any deactivation).
        // If you used instance_deactivate_all(true) before, prefer instance_activate_all() here:
        instance_activate_all();
        audio_resume_all();

        // Reset state to ensure a clean return
        pause_menu_state = "main";
        hovered_button = noone;
        mouse_locked_until_release = true; // lock clicks until release to avoid accidental click
    }
    else
    {
        // Only pause while in-game (player exists)
        if (instance_exists(obj_jack))
        {
            global.is_paused = true;

            // Deactivate gameplay instances but keep controller active.
            // SAFE method: deactivate common gameplay objects individually if you know them,
            // otherwise try this: deactivate every instance except this controller:
            with (all)
            {
                if (id != other.id) // 'other' is the controller here, so this will deactivate everything except the controller
                {
                    // instance_deactivate(); // if your GMS version supports instance_deactivate()
                    // If instance_deactivate() is not available in your version, use:
                    // instance_deactivate_object(object_index);
                    // [I can't know all your gameplay object names; adjust if needed.]
                }
            }

            // Pause audio
            audio_pause_all();

            // Initialize pause menu state
            pause_menu_state = "main";
            hovered_button = noone;
            mouse_locked_until_release = true; // lock clicks until the player releases the mouse button
        }
    }
}

// Update mouse lock: if the left mouse button is released, unlock click consumption.
if (mouse_locked_until_release)
{
    if (!mouse_check_button(mb_left))
    {
        // mouse was released; unlock
        mouse_locked_until_release = false;
    }
}
