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

// --- GLOBAL DEBUG TOGGLES ---
if (keyboard_check_pressed(vk_f2)) {
    if (!variable_global_exists("DEBUG_MODE")) global.DEBUG_MODE = false;
    global.DEBUG_MODE = !global.DEBUG_MODE;
    show_debug_message("[DEBUG] Debug mode " + (global.DEBUG_MODE ? "ENABLED" : "DISABLED"));
}

if (variable_global_exists("DEBUG_MODE") && global.DEBUG_MODE && keyboard_check_pressed(vk_f6)) {
    if (!variable_global_exists("unlock_all_ciphers")) global.unlock_all_ciphers = false;
    global.unlock_all_ciphers = true;
    global.final_boss_defeated = true; // Also unlocks Atbash by default logic
    
    if (instance_exists(obj_codex_manager)) {
        obj_codex_manager.tab_locked[0] = false;
        obj_codex_manager.tab_locked[1] = false;
        obj_codex_manager.tab_locked[2] = false;
        obj_codex_manager.tab_locked[3] = false;
    }
    
    // Attempt to play a sound if valid, just standard confirmation
    show_debug_message("[DEBUG] All ciphers/modules UNLOCKED for demo!");
}