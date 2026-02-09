// --- Step Event of obj_codex_menu ---

// Use keyboard_check_pressed to ensure it only fires once per tap
if (keyboard_check_pressed(ord("C"))) {
    // We use a small timer or "io_clear" to prevent Jack from instantly re-opening it
    io_clear(); 
    
    if (instance_exists(obj_jack)) {
        obj_jack.isInCutscene = false; // Unfreeze Jack
    }
    instance_destroy();
    show_debug_message("CODEX: Menu closed.");
}