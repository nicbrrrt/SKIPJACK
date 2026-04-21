// --- Mouse Leave Event ---

// Ignore while any review overlay is on screen
if (instance_exists(obj_review_screen)) exit;
if (instance_exists(obj_codex_manager) && obj_codex_manager.is_open) exit;

image_index = 0;