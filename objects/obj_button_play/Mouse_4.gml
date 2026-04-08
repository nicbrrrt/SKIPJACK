// In o_play_button
// This is the ONLY code that should be in this event.
// In the Mouse Left Pressed Event

// Stop the hover sound in case it's still playing
audio_stop_sound(snd_button_hover);

// Play the click sound
audio_play_sound(snd_button_click, 10, false);

with (obj_transition)
{
    fade_mode = "fading_out";
    target_room = rm_cutscene_lab;
}

// If a save exists, load it (overrides the transition target).
// Otherwise the transition above naturally lands on rm_cutscene_lab.
if (file_exists(global.save_path)) {
    show_debug_message("SAVE FOUND: Handing over to Save Manager...");
    if (instance_exists(obj_save_manager)) {
        obj_save_manager.load_game();
    }
} else {
    show_debug_message("NO SAVE: Starting fresh intro.");
}