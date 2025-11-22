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