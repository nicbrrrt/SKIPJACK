// --- Step Event for obj_codex_manager ---

// Simplified for the presentation: Just check for 'C' and tutorial_complete
if (global.tutorial_complete && keyboard_check_pressed(ord("C"))) {
    is_open = !is_open;
    
    if (instance_exists(obj_jack)) {
        obj_jack.isInCutscene = is_open; 
        obj_jack.image_speed = 0; // Freeze animation
    }
}

// Page Flipping (Only if the tablet is actually open)
if (is_open) {
    var _len = array_length(modules);
    
    if (keyboard_check_pressed(vk_right)) {
        current_page = min(current_page + 1, _len - 1);
        
        // SAFE SOUND CHECK: Only play if the sound exists in the project
        if (asset_get_type("snd_page_flip") == asset_sound) {
            audio_play_sound(snd_page_flip, 10, false);
        }
    }
    
    if (keyboard_check_pressed(vk_left)) {
        current_page = max(current_page - 1, 0);
        
        // SAFE SOUND CHECK
        if (asset_get_type("snd_page_flip") == asset_sound) {
            audio_play_sound(snd_page_flip, 10, false);
        }
    }
}