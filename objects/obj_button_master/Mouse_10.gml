// --- Mouse Enter Event ---

// Ignore hover while the Review codex overlay is on screen
if (instance_exists(obj_codex_manager) && obj_codex_manager.is_open) exit;

if (!audio_is_playing(snd_button_hover)) {
    audio_play_sound(snd_button_hover, 10, false);
}
image_index = 1;

// Optional: Play a "hover" sound
// audio_play_sound(snd_button_hover, 1, false);