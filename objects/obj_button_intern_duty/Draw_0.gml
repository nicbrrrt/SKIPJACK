// --- Draw Event for obj_button_intern_duty ---

if (instance_exists(obj_review_screen)) exit;
if (instance_exists(obj_codex_manager) && obj_codex_manager.is_open) exit;

draw_self();

