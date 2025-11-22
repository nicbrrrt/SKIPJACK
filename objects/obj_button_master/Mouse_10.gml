// --- Mouse Enter Event ---

// Check if the hover sound is NOT already playing
// This prevents spam if you move the mouse back and forth quickly
if (!audio_is_playing(snd_button_hover))
{
	audio_play_sound(snd_button_hover, 10, false);
}
// Go to Frame 1 (the "hover" look)
image_index = 1;

// Optional: Play a "hover" sound
// audio_play_sound(snd_button_hover, 1, false);