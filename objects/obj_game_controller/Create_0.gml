/// Create Event - obj_game_controller
global.return_room = rm_menu;
global.game_volume = 1;
global.is_paused = false;

pause_menu_state = "main";
hovered_button = noone;

// Mouse debounce / click-lock so clicks don't "carry" between menu switches
mouse_locked_until_release = false;
