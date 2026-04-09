// --- Mouse Left Pressed Event for obj_button_review ---

audio_stop_sound(snd_button_hover);
audio_play_sound(snd_button_click, 10, false);

if (instance_exists(obj_codex_manager)) {
    obj_codex_manager.current_page = 0;
    obj_codex_manager.is_open = true;
}
