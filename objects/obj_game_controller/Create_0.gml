// --- Basic Game Settings ---
randomize();
global.game_volume = 1;
global.is_paused = false;
global.level1_intro_done = false;

global.greg_target_x = -1;
global.greg_target_y = -1;

global.greg_boss_talked = false;

// --- Room & Story Progress ---
global.tutorial_complete = false; // Starts as false every new game
global.return_room = rm_menu;
global.target_x = -1;
global.target_y = -1;

// --- Battle System Flags ---
global.last_battle_id = "none";
global.battle_result = "none";

// --- Menu State ---
pause_menu_state = "main";
hovered_button = noone;
mouse_locked_until_release = false;

// --- UI BUTTON SPAWN ---
// We use a very low depth (-10000) to ensure the button is at the very front
if (!instance_exists(obj_ui_button)) {
    instance_create_depth(0, 0, -10000, obj_ui_button);
}