// rm_menu — Room Creation Code
// Globals are set by obj_game_init (which lives in this room).
// This code just cleans up persistent objects that shouldn't exist in the menu.

if (instance_exists(obj_transition)) {
    instance_destroy(obj_transition);
}

if (instance_exists(obj_jack)) {
    instance_destroy(obj_jack);
}