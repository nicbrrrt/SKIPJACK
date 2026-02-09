/// Create Event - obj_game_controller
global.tutorial_complete = false;
global.return_room = rm_menu;
global.game_volume = 1;
global.is_paused = false;

// --- ADD THESE TWO LINES HERE ---
global.last_battle_id = "none";
global.battle_result = "none";
// --------------------------------

pause_menu_state = "main";
hovered_button = noone;

// Mouse debounce / click-lock so clicks don't "carry" between menu switches
mouse_locked_until_release = false;

// --- Add these to your initialization code ---
if (!variable_global_exists("tutorial_complete")) global.tutorial_complete = false;
global.target_x = -1;
global.target_y = -1;

randomize();