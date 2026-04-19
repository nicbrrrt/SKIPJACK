// --- obj_review_screen Step Event ---

// ESC closes the overlay
if (keyboard_check_pressed(vk_escape)) {
    instance_destroy();
    exit;
}

var _len = array_length(tabs);

// Arrow keys navigate tabs
if (keyboard_check_pressed(vk_right)) {
    current_tab = min(current_tab + 1, _len - 1);
    if (asset_get_type("snd_page_flip") == asset_sound)
        audio_play_sound(snd_page_flip, 10, false);
}

if (keyboard_check_pressed(vk_left)) {
    current_tab = max(current_tab - 1, 0);
    if (asset_get_type("snd_page_flip") == asset_sound)
        audio_play_sound(snd_page_flip, 10, false);
}
