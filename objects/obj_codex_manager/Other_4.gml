// --- Room Start Event for obj_codex_manager ---
// Auto-close the codex when entering any room so it never carries over
// from the menu into gameplay (or between gameplay rooms).
if (is_open) {
    is_open        = false;
    current_module = 0;
    if (instance_exists(obj_jack)) {
        obj_jack.isInCutscene = false;
        obj_jack.image_speed  = 1;
    }
}
