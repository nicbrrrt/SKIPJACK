// In the Mouse Left Pressed Event

// Disabled while any review overlay is on screen
if (instance_exists(obj_review_screen)) exit;
if (instance_exists(obj_codex_manager) && obj_codex_manager.is_open) exit;

audio_stop_sound(snd_button_hover);

// Play the click sound
audio_play_sound(snd_button_click, 10, false);

// (Your code to go to the next room, like room_goto(rm_settings),
// would go right here)
global.return_room = rm_menu;

// 2. Go to settings
room_goto(rm_settings);