// In o_play_button
// This is the ONLY code that should be in this event.
// In the Mouse Left Pressed Event

// Stop the hover sound in case it's still playing
audio_stop_sound(snd_button_hover);

// Play the click sound
audio_play_sound(snd_button_click, 10, false);

// (Your code to go to the next room, like room_goto(rm_settings),
// would go right here)
with (obj_transition)
{
    fade_mode = "fading_out";
    target_room = rm_cutscene_lab;
}

// 1. DEFINE THE PATH LOCALLY (Fallback to prevent the crash)
var _path = working_directory + "save_v1.json";

// 2. CHECK FOR FILE
if (file_exists(_path)) {
    show_debug_message("SAVE FOUND: Handing over to Save Manager...");
    
    // Ensure the manager knows the path before loading
    if (instance_exists(obj_save_manager)) {
        global.save_path = _path; 
        obj_save_manager.load_game();
    }
} else {
    show_debug_message("NO SAVE: Starting fresh intro.");
    room_goto(rm_cutscene_lab);
}