// Open/Close Codex
if (unlocked && keyboard_check_pressed(ord("C"))) {
    is_open = !is_open;
    if (instance_exists(obj_jack)) obj_jack.can_move = !is_open; // Freeze Jack while reading
}