// ── Menu / Cipher-select: keep ms_start playing ──────────────────────────────
if (room == rm_menu || room == rm_settings || room == rm_cipher_select)
{
    audio_stop_sound(snd_tutorial_void_music);
    if (!audio_is_playing(ms_start))
        audio_play_sound(ms_start, 10, true);
}
// ── Tutorial void: its own ambient track ─────────────────────────────────────
else if (room == rm_tutorial_void)
{
    audio_stop_sound(ms_start);
    if (!audio_is_playing(snd_tutorial_void_music))
        audio_play_sound(snd_tutorial_void_music, 10, true);
}
// ── All other rooms: silence both menu tracks ─────────────────────────────────
else
{
    audio_stop_sound(ms_start);
    audio_stop_sound(snd_tutorial_void_music);
}