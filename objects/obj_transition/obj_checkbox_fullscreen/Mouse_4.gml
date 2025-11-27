// 1. Find the *new* state we want (flip 0 to 1, or 1 to 0)
// In the Mouse Left Pressed Event

// Stop the hover sound in case it's still playing
audio_stop_sound(snd_button_hover);

// Play the click sound
audio_play_sound(snd_button_click, 10, false);

// (Your code to go to the next room, like room_goto(rm_settings),
// would go right here)

var _new_state = !image_index;

// 2. Set the window to that new state
window_set_fullscreen(_new_state);

// 3. Update our sprite to show the new state
image_index = _new_state;