// --- Step Event for obj_codex_manager ---

// 1. Identify "Illegal" rooms for the Codex UI
// We create a variable that is TRUE if we are in a battle, FALSE if we are not.
var _is_combat_room = (room == rm_combat || room == rm_battle_scramble);

// 2. Handle Opening/Closing
// We add "!_is_combat_room" so the 'C' key only opens the UI when NOT in battle.
if (global.tutorial_complete && !_is_combat_room && keyboard_check_pressed(ord("C"))) {
    is_open = !is_open;
    
    if (instance_exists(obj_jack)) {
        obj_jack.isInCutscene = is_open; 
        obj_jack.image_speed = 0; // Freeze animation
    }
}

// 3. Page Flipping (Only if the tablet is actually open)
if (is_open) {
    var _len = array_length(modules);
    
    if (keyboard_check_pressed(vk_right)) {
        current_page = min(current_page + 1, _len - 1);
        
        // SAFE SOUND CHECK
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