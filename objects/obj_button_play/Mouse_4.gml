// In o_play_button
// Transitions to rm_cipher_select; the cipher select screen handles save loading.

// Disabled while Review Mode overlay is on screen
if (instance_exists(obj_codex_manager) && obj_codex_manager.is_open) exit;

audio_stop_sound(snd_button_hover);

// Play the click sound
audio_play_sound(snd_button_click, 10, false);

with (obj_transition)
{
    fade_mode   = "fading_out";
    target_room = rm_cipher_select;
}
