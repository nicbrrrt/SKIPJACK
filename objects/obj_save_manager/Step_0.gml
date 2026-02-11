// --- PRESS F11 TO DELETE SAVE ---
if (keyboard_check_pressed(vk_f11)) {
    if (file_exists(global.save_filename)) {
        file_delete(global.save_filename);
        show_debug_message("SYSTEM: Save File Deleted!");
        game_restart(); // Optional: Restart to start fresh
    }
}