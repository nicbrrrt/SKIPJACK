// --- PRESS F11 TO DELETE SAVE ---
if (keyboard_check_pressed(vk_f11)) {
    if (file_exists(global.save_path)) {
        file_delete(global.save_path);
        show_debug_message("SYSTEM: Save File Deleted!");
    }
    // Reset persistent codex state and tutorial flag before restarting
    global.tutorial_complete = false;
    global.saved_codex_modules = [];
    if (instance_exists(obj_codex_manager)) {
        obj_codex_manager.modules = [];
        obj_codex_manager.unlocked = false;
        obj_codex_manager.is_open = false;
    }
    game_restart(); // always restart on F11
}