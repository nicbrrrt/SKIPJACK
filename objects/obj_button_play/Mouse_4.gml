// In o_play_button
// First time: go to rm_hallway for the tutorial.
// Returning players: go to the cipher select screen (handles save loading).

audio_stop_sound(snd_button_hover);
audio_play_sound(snd_button_click, 10, false);

var _dest = (!variable_global_exists("hall_tutorial_done") || !global.hall_tutorial_done)
            ? rm_hallway
            : rm_cipher_select;

with (obj_transition) {
    fade_mode   = "fading_out";
    target_room = _dest;
}
