// obj_game_controller — Create Event
// Instance-level variables only. ALL globals come from obj_game_init.

display_set_gui_size(640, 360);
randomize();

// Pause Menu State (instance vars, not global)
pause_menu_state          = "main";
hovered_button            = noone;
mouse_locked_until_release = false;

// Spawn the persistent UI button if it doesn't exist
if (!instance_exists(obj_ui_button)) {
    instance_create_depth(0, 0, -10000, obj_ui_button);
}