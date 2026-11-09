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
if (!variable_global_exists("jrpg_opponent"))    global.jrpg_opponent    = "none";
if (!variable_global_exists("battle_result"))    global.battle_result    = "none";
if (!variable_global_exists("battle_active"))    global.battle_active    = false;
if (!variable_global_exists("is_jrpg"))          global.is_jrpg          = false;
if (!variable_global_exists("return_room"))      global.return_room      = rm_menu;
if (!variable_global_exists("return_x"))         global.return_x         = 0;
if (!variable_global_exists("return_y"))         global.return_y         = 0;
if (!variable_global_exists("puzzle_word_list"))    global.puzzle_word_list    = []; // populated by NPCs (Clipper/Lea) before a scramble battle
if (!variable_global_exists("puzzle_hint_list"))    global.puzzle_hint_list    = [];
if (!variable_global_exists("battle_enemy_sprite"))        global.battle_enemy_sprite        = spr_npc2_idle;    // set by the triggering NPC before room_goto(rm_combat)
if (!variable_global_exists("battle_enemy_attack_sprite")) global.battle_enemy_attack_sprite = spr_virus_attack; // set by the triggering NPC before room_goto(rm_battle_scramble)

// --- STORY FLAGS ---
if (!variable_global_exists("tutorial_complete"))     global.tutorial_complete     = false;
if (!variable_global_exists("level1_intro_done"))     global.level1_intro_done     = false;
if (!variable_global_exists("greg_defeated"))         global.greg_defeated         = false;
if (!variable_global_exists("greg_quest_started"))    global.greg_quest_started    = false;
if (!variable_global_exists("quest_room101_active"))    global.quest_room101_active    = false;
if (!variable_global_exists("quest_room101_done"))      global.quest_room101_done      = false;
if (!variable_global_exists("quest_find_greg_done"))    global.quest_find_greg_done    = false;
if (!variable_global_exists("quest_greg_level1_done"))  global.quest_greg_level1_done  = false;
if (!variable_global_exists("quest_clipper_done"))    global.quest_clipper_done    = false;
if (!variable_global_exists("quest_lea_done"))        global.quest_lea_done        = false;
if (!variable_global_exists("cryptography_learned"))  global.cryptography_learned  = false;
if (!variable_global_exists("caesar_learned"))        global.caesar_learned        = false;
if (!variable_global_exists("clipper_defeated"))      global.clipper_defeated      = false;
if (!variable_global_exists("lea_defeated"))          global.lea_defeated          = false;
if (!variable_global_exists("boss_spawned"))          global.boss_spawned          = false;
if (!variable_global_exists("final_boss_defeated"))   global.final_boss_defeated   = false;
if (!variable_global_exists("atbash_progress"))       global.atbash_progress       = 0;
if (!variable_global_exists("unlock_all_ciphers"))    global.unlock_all_ciphers    = false;

// --- HALLWAY NPC FLAGS (Kyle / David) ---
if (!variable_global_exists("quest_talk_to_kyle"))    global.quest_talk_to_kyle    = false;
if (!variable_global_exists("kyle_lesson_done"))      global.kyle_lesson_done      = false;
if (!variable_global_exists("quest_talk_to_david"))   global.quest_talk_to_david   = false;
if (!variable_global_exists("david_defeated"))        global.david_defeated        = false;
if (!variable_global_exists("david_quiz_attempted"))  global.david_quiz_attempted  = false;
if (!variable_global_exists("quest_talk_to_breado"))  global.quest_talk_to_breado  = false;

// --- HALLWAY INSPECTABLE OBJECT FLAGS ---
// Stored globally so they survive room reloads (e.g. returning from David's battle)
if (!variable_global_exists("poster_opened"))         global.poster_opened         = false;
if (!variable_global_exists("paper_opened"))          global.paper_opened          = false;
if (!variable_global_exists("computer1_opened"))      global.computer1_opened      = false;
if (!variable_global_exists("computer2_opened"))      global.computer2_opened      = false;
if (!variable_global_exists("all_objects_inspected")) global.all_objects_inspected = false;

// --- TUTORIAL FLAGS ---
if (!variable_global_exists("seen_path_tutorial"))    global.seen_path_tutorial    = false;
if (!variable_global_exists("seen_cipher_tutorial"))  global.seen_cipher_tutorial  = false;
if (!variable_global_exists("seen_qte_tutorial"))     global.seen_qte_tutorial     = false;
if (!variable_global_exists("scramble_tutorial_done")) global.scramble_tutorial_done = false;
if (!variable_global_exists("atbash_tutorial_done"))  global.atbash_tutorial_done  = false;
if (!variable_global_exists("atbash_combat_tutorial_done")) global.atbash_combat_tutorial_done = false;
if (!variable_global_exists("vigenere_tutorial_done")) global.vigenere_tutorial_done = false;

// --- NPC TARGETS ---
if (!variable_global_exists("greg_target_x"))  global.greg_target_x  = -1;
if (!variable_global_exists("greg_target_y"))  global.greg_target_y  = -1;
if (!variable_global_exists("target_x"))       global.target_x       = -1;
if (!variable_global_exists("target_y"))       global.target_y       = -1;

// --- LOAD/SPAWN FLAGS ---
if (!variable_global_exists("is_loading_from_save"))  global.is_loading_from_save  = false;

// --- DEBUG ---
if (!variable_global_exists("DEBUG_MODE"))  global.DEBUG_MODE = false;

// --- CAMERA ---
if (!variable_global_exists("cam_width"))       global.cam_width       = 640;
if (!variable_global_exists("cam_height"))      global.cam_height      = 360;

// --- CAMERA PAN ---
if (!variable_global_exists("cam_pan_phase"))   global.cam_pan_phase   = "off";
if (!variable_global_exists("cam_pan_timer"))   global.cam_pan_timer   = 0;
if (!variable_global_exists("cam_pan_from_x"))  global.cam_pan_from_x  = 0;
if (!variable_global_exists("cam_pan_from_y"))  global.cam_pan_from_y  = 0;
if (!variable_global_exists("cam_pan_to_x"))    global.cam_pan_to_x    = 0;
if (!variable_global_exists("cam_pan_to_y"))    global.cam_pan_to_y    = 0;

// --- UI/AUDIO ---
if (!variable_global_exists("game_volume"))  global.game_volume = 1;
audio_master_gain(global.game_volume);
if (!variable_global_exists("is_paused"))    global.is_paused   = false;

// --- CONTROLS REMINDER (TAB panel, unlocked after intro tutorial) ---
if (!variable_global_exists("controls_hint_unlocked")) global.controls_hint_unlocked = false;
if (!variable_global_exists("controls_hint_visible"))  global.controls_hint_visible  = true;

// --- DIALOGUE TUTORIAL ---
if (!variable_global_exists("e_dialogue_intro_shown")) global.e_dialogue_intro_shown = false;

// --- 3-CHAPTER x 10-FLOOR DUNGEON PROGRESSION ---
if (!variable_global_exists("dungeon_chapter"))    global.dungeon_chapter    = 1; // 1 = Caesar, 2 = Vigenere, 3 = Atbash
if (!variable_global_exists("chapter_floor"))      global.chapter_floor      = 1; // 1..10 within current chapter
if (!variable_global_exists("vigenere_unlocked"))  global.vigenere_unlocked  = false;
if (!variable_global_exists("atbash_unlocked"))    global.atbash_unlocked    = false;
if (!variable_global_exists("chapter_best_floor")) global.chapter_best_floor = [1, 1, 1];

// --- WRENCH SCRAPPING, HR PROPERTY LIMIT & SALVAGE TASKS ---
if (!variable_global_exists("has_wrench"))          global.has_wrench          = true;
if (!variable_global_exists("scrap_count"))         global.scrap_count         = 0;     // Current Scrap in Jack's pouch (confiscated if caught by Bot!)
if (!variable_global_exists("rare_cores"))          global.rare_cores          = 0;     // High-tier cores from Security Bots & Encrypted Decoy Servers
if (!variable_global_exists("legal_fund"))          global.legal_fund          = 0;     // Cash earned from Salvage Quotas (for lawyer/intern bills)
if (!variable_global_exists("hr_scrap_count"))      global.hr_scrap_count      = 0;     // Company properties scrapped on current floor
if (!variable_global_exists("hr_scrap_limit"))      global.hr_scrap_limit      = 3;     // Max safe HR write-off limit per floor (4+ flags Intern Duty!)
if (!variable_global_exists("intern_duty_flagged")) global.intern_duty_flagged = false; // Flagged when hr_scrap_count > hr_scrap_limit
if (!variable_global_exists("interns_alive"))       global.interns_alive       = 10;
if (!variable_global_exists("interns_lost"))        global.interns_lost        = 0;
if (!variable_global_exists("held_intern_inst"))    global.held_intern_inst    = noone;
if (!variable_global_exists("breaker_repaired"))    global.breaker_repaired    = false; // Costs 2 Scrap to repair the Power Breaker relay per floor
if (!variable_global_exists("scrap_ui_open"))       global.scrap_ui_open       = false; // Mainframe Sever Encryption UI state
if (!variable_global_exists("bot_grapple_active"))  global.bot_grapple_active  = false; // True while mashing [E] to apprehend a Security Bot

// --- HOMEROOM STATUES, PAYCHECK & MECHANIC (WALL TELEPHONE) ---
if (!variable_global_exists("player_cash"))       global.player_cash       = 250;                    // Banked paycheck money ($)
if (!variable_global_exists("statues_owned"))     global.statues_owned     = [false, false, false];  // Delivered to the Homeroom
if (!variable_global_exists("statues_pending"))   global.statues_pending   = [false, false, false];  // Ordered by phone; delivered after 1 floor (1 workday)
if (!variable_global_exists("equipped_statues"))  global.equipped_statues  = [-1, -1, -1];           // Statue ID on each of the 3 Homeroom pedestals
if (!variable_global_exists("phone_ui_open"))     global.phone_ui_open     = false;
if (!variable_global_exists("shelf_ui_open"))     global.shelf_ui_open     = false;
if (!variable_global_exists("floor_cipher_fails")) global.floor_cipher_fails = 0;   // Wrong codes + timeouts this floor (Performance Tracker)
if (!variable_global_exists("floor_times_busted")) global.floor_times_busted = 0;   // Times caught by a Security Bot this floor
if (!variable_global_exists("surge_shield_used"))  global.surge_shield_used  = false; // Copper Surge Totem shield spent this floor

// Lock GUI to 640x360 (2x visual scale, matching the main menu) from the first room onward
display_set_gui_size(640, 360);