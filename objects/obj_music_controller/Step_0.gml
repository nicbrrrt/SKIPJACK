// ── Menu / Cipher-select: keep ms_start playing ──────────────────────────────
if (room == rm_menu || room == rm_settings || room == rm_cipher_select)
{
    audio_stop_sound(snd_tutorial_void_music);
    audio_stop_sound(snd_generic_background_music);
    audio_stop_sound(corporate);
    audio_stop_sound(snd_intern_minigame);
    if (!audio_is_playing(ms_start))
        audio_play_sound(ms_start, 10, true);
}
// ── Tutorial void: its own ambient track ─────────────────────────────────────
else if (room == rm_tutorial_void)
{
    audio_stop_sound(ms_start);
    audio_stop_sound(snd_generic_background_music);
    audio_stop_sound(corporate);
    audio_stop_sound(snd_intern_minigame);
    if (!audio_is_playing(snd_tutorial_void_music))
        audio_play_sound(snd_tutorial_void_music, 10, true);
}
// ── Corporate Lockdown Dungeon or Intern Babysitting Minigame ─────────────────
else if (room == dungeon_test)
{
    audio_stop_sound(ms_start);
    audio_stop_sound(snd_tutorial_void_music);
    audio_stop_sound(snd_generic_background_music);
    
    var _is_intern_duty = instance_exists(obj_intern_ward_controller) || (instance_exists(obj_dungeon_generator) && variable_instance_exists(obj_dungeon_generator, "is_intern_mode") && obj_dungeon_generator.is_intern_mode);
    
    if (_is_intern_duty) {
        audio_stop_sound(corporate);
        if (!audio_is_playing(snd_intern_minigame)) {
            var _bgm = audio_play_sound(snd_intern_minigame, 10, true);
            audio_sound_gain(_bgm, 0.75, 0);
        }
    } else {
        audio_stop_sound(snd_intern_minigame);
        if (!audio_is_playing(corporate)) {
            var _bgm = audio_play_sound(corporate, 10, true);
            audio_sound_gain(_bgm, 0.45, 0); // Lowered volume of corporate a tad bit
        }
    }
}
// ── Homeroom: play the cozy original track (snd_generic_background_music) ────
else if (room == rm_homeroom)
{
    audio_stop_sound(ms_start);
    audio_stop_sound(snd_tutorial_void_music);
    audio_stop_sound(corporate);
    audio_stop_sound(snd_intern_minigame);
    if (!audio_is_playing(snd_generic_background_music)) {
        var _bgm = audio_play_sound(snd_generic_background_music, 10, true);
        audio_sound_gain(_bgm, 0.65, 0);
    }
}
// ── All other rooms: silence menu & dungeon tracks ───────────────────────────
else
{
    audio_stop_sound(ms_start);
    audio_stop_sound(snd_tutorial_void_music);
    audio_stop_sound(snd_generic_background_music);
    audio_stop_sound(corporate);
    audio_stop_sound(snd_intern_minigame);
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