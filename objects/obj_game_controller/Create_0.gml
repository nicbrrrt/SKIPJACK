// --- Basic Game Settings ---
display_set_gui_size(640, 360);
randomize();
global.game_volume = 1;
global.is_paused = false;
global.level1_intro_done = false;

global.greg_target_x = -1;
global.greg_target_y = -1;
global.greg_boss_talked = false;
global.is_jrpg = false;

// --- Room & Story Progress ---
global.tutorial_complete = false;
global.return_room = rm_menu;
global.target_x = -1;
global.target_y = -1;

// --- ADDED FOR SAVE SYSTEM & QUESTS ---
global.greg_defeated = false;      // Track if Greg is beaten
global.greg_quest_started = false; // Track if objectives are visible
global.quest_clipper_done = false; // Track Clipper's specific objective
global.quest_lea_done = false;     // Track Lea's specific objective
global.boss_spawned = false;       // Track if the final boss is active
global.is_loading_from_save = false; // Important for Jack's spawn logic

// --- ADDED FOR NPC DIALOGUE STATES ---
global.cryptography_learned = false;
global.caesar_learned = false;
global.clipper_defeated = false;
global.lea_defeated = false;
// --------------------------------------

// --- Battle System Flags ---
global.last_battle_id = "none";
global.battle_result = "none";

// --- Menu State ---
pause_menu_state = "main";
hovered_button = noone;
mouse_locked_until_release = false;

// --- UI BUTTON SPAWN ---
if (!instance_exists(obj_ui_button)) {
    instance_create_depth(0, 0, -10000, obj_ui_button);
}