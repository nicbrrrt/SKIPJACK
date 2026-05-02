if (mouse_check_button_pressed(mb_left) && !instance_exists(obj_transition))
{
    // Check if mouse is touching the button
    if (position_meeting(mouse_x, mouse_y, id))
    {
        show_debug_message("CLICK DETECTED! Forcing Game Start...");

        // 1. NUKE EVERYTHING (Don't check IF they exist, just try to destroy them)
        // This ensures the slate is clean for the new game.
        if (instance_exists(obj_jack)) instance_destroy(obj_jack);
        if (instance_exists(obj_game_controller)) instance_destroy(obj_game_controller);

        // Reset all story globals so new game starts clean
        global.tutorial_complete       = false;
        global.level1_intro_done       = false;
        global.greg_defeated           = false;
        global.greg_quest_started      = false;
        global.quest_room101_active    = false;
        global.quest_room101_done      = false;
        global.quest_find_greg_done    = false;
        global.quest_greg_level1_done  = false;
        global.quest_clipper_done      = false;
        global.quest_lea_done          = false;
        global.cryptography_learned    = false;
        global.caesar_learned          = false;
        global.clipper_defeated        = false;
        global.lea_defeated            = false;
        global.boss_spawned            = false;
        global.final_boss_defeated     = false;
        global.seen_path_tutorial      = false;
        global.seen_cipher_tutorial    = false;
        global.seen_qte_tutorial       = false;
        global.battle_result           = "none";
        global.last_battle_id          = "none";
        global.saved_codex_modules     = [];
        if (instance_exists(obj_codex_manager)) {
            obj_codex_manager.modules  = [];
            obj_codex_manager.unlocked = false;
            obj_codex_manager.is_open  = false;
        }
        if (instance_exists(obj_ui_button)) instance_destroy(obj_ui_button);

        // 2. CREATE A FRESH TRANSITION
        var _new_trans = instance_create_depth(0, 0, -9999, obj_transition);
        
        // 3. SET THE DESTINATION (CRITICAL STEP!)
        // Make sure "rm_cutscene_intro" is the EXACT name of your room resource.
        _new_trans.target_room = rm_cipher_select;
        
        // 4. START THE FADE
        _new_trans.fade_mode = "fading_out";
        _new_trans.fade_alpha = 0; // Ensure it starts invisible
    }
}