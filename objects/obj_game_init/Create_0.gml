// obj_game_init — Create Event
// THE SINGLE SOURCE OF TRUTH FOR ALL GLOBALS.
// Uses variable_global_exists() guards so that reloading a room
// never clobbers flags that were set mid-game.

// --- SAVE SYSTEM ---
if (!variable_global_exists("save_filename")) {
    global.save_filename = "save_v1.json";
    global.save_path     = working_directory + global.save_filename;
}

// --- BATTLE STATE ---
if (!variable_global_exists("last_battle_id"))   global.last_battle_id   = "none";
if (!variable_global_exists("battle_result"))    global.battle_result    = "none";
if (!variable_global_exists("battle_active"))    global.battle_active    = false;
if (!variable_global_exists("is_jrpg"))          global.is_jrpg          = false;
if (!variable_global_exists("return_room"))      global.return_room      = rm_menu;
if (!variable_global_exists("return_x"))         global.return_x         = 0;
if (!variable_global_exists("return_y"))         global.return_y         = 0;
if (!variable_global_exists("puzzle_word_list")) global.puzzle_word_list = []; // populated by NPCs (Clipper/Lea) before a scramble battle

// --- STORY FLAGS ---
if (!variable_global_exists("tutorial_complete"))     global.tutorial_complete     = false;
if (!variable_global_exists("level1_intro_done"))     global.level1_intro_done     = false;
if (!variable_global_exists("greg_defeated"))         global.greg_defeated         = false;
if (!variable_global_exists("greg_quest_started"))    global.greg_quest_started    = false;
if (!variable_global_exists("quest_clipper_done"))    global.quest_clipper_done    = false;
if (!variable_global_exists("quest_lea_done"))        global.quest_lea_done        = false;
if (!variable_global_exists("cryptography_learned"))  global.cryptography_learned  = false;
if (!variable_global_exists("caesar_learned"))        global.caesar_learned        = false;
if (!variable_global_exists("clipper_defeated"))      global.clipper_defeated      = false;
if (!variable_global_exists("lea_defeated"))          global.lea_defeated          = false;
if (!variable_global_exists("boss_spawned"))          global.boss_spawned          = false;

// --- TUTORIAL FLAGS ---
if (!variable_global_exists("seen_path_tutorial"))    global.seen_path_tutorial    = false;
if (!variable_global_exists("seen_cipher_tutorial"))  global.seen_cipher_tutorial  = false;
if (!variable_global_exists("seen_qte_tutorial"))     global.seen_qte_tutorial     = false;

// --- NPC TARGETS ---
if (!variable_global_exists("greg_target_x"))  global.greg_target_x  = -1;
if (!variable_global_exists("greg_target_y"))  global.greg_target_y  = -1;
if (!variable_global_exists("target_x"))       global.target_x       = -1;
if (!variable_global_exists("target_y"))       global.target_y       = -1;

// --- LOAD/SPAWN FLAGS ---
if (!variable_global_exists("is_loading_from_save"))  global.is_loading_from_save  = false;

// --- CAMERA ---
if (!variable_global_exists("cam_width"))   global.cam_width  = 640;
if (!variable_global_exists("cam_height"))  global.cam_height = 360;

// --- UI/AUDIO ---
if (!variable_global_exists("game_volume"))  global.game_volume = 1;
if (!variable_global_exists("is_paused"))    global.is_paused   = false;