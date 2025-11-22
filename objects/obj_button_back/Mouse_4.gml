// --- Left Pressed Event for obj_button_back ---

// Stop the hover sound in case it's still playing
audio_stop_sound(snd_button_hover);

// Play the click sound
audio_play_sound(snd_button_click, 10, false);

// (Your code to go to the next room, like room_goto(rm_settings),
// would go right here)
// 1. Go to the room we were told to go to
room_goto(global.return_room);

// 2. Check: Are we returning to the game level?
if (global.return_room == rm_level_1)
{
    // 3. If yes, re-pause the game immediately!
    global.is_paused = true;
    instance_deactivate_all(true); 
    audio_pause_all();
}