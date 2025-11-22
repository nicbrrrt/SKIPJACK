// Check if we are in the menu OR the settings room
if (room == rm_menu || room == rm_settings)
{
	// If we are, and the music *isn't* playing, start it.
	if (!audio_is_playing(ms_start))
	{
		audio_play_sound(ms_start, 10, true);
	}
}
// If we are in ANY other room (like the main game)
else 
{
	// If the menu music *is* playing, stop it.
	if (audio_is_playing(ms_start))
	{
		audio_stop_sound(ms_start);
	}
}