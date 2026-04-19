// --- Mouse Leave Event ---

// Ignore while the Review codex overlay is on screen
if (instance_exists(obj_codex_manager) && obj_codex_manager.is_open) exit;

image_index = 0;