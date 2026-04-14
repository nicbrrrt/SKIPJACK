/// Step Event - obj_game_controller

// --- JRPG ROOM TRANSITION HANDLER ---
if (room == rm_level_1 && global.last_battle_id == "greg_boss") {
    if (!instance_exists(obj_textevent)) {
        // Reset the ID so it doesn't loop, then TELEPORT
        global.last_battle_id             = "none";
        global.is_jrpg                    = true;
        global.battle_enemy_sprite        = spr_npc1_idle; // Greg
        global.battle_enemy_attack_sprite = spr_npc1_idle; // No dedicated attack sprite
        room_goto(rm_battle_scramble);
        show_debug_message("CONTROLLER: Teleporting to JRPG Battle.");
    }
}

// --- FINAL BOSS SPAWN (both Lea + Clipper defeated) ---
if (room == rm_level_1
    && variable_global_exists("clipper_defeated") && global.clipper_defeated
    && variable_global_exists("lea_defeated")     && global.lea_defeated
    && !global.boss_spawned
    && !instance_exists(obj_final_boss_placeholder)) {
    global.boss_spawned = true;
    var _boss = instance_create_layer(640, 380, "Instances", obj_final_boss_placeholder);
    _boss.visible = true;
    if (instance_exists(obj_save_manager)) obj_save_manager.save_game();
    show_debug_message("CONTROLLER: Final boss spawned.");
    if (!instance_exists(obj_textevent)) {
        create_textevent(["WARNING: Anomaly signal detected. Threat level: CRITICAL."], [_boss]);
    }
}

// Restore boss after loading save (spawned but fight not done)
if (room == rm_level_1
    && global.boss_spawned
    && !global.final_boss_defeated
    && !instance_exists(obj_final_boss_placeholder)) {
    var _boss = instance_create_layer(640, 380, "Instances", obj_final_boss_placeholder);
    _boss.visible = true;
    show_debug_message("CONTROLLER: Final boss restored from save.");
}

// --- FINAL BOSS PHASE 1 DEFEATED (overworld → JRPG transition) ---
if (room == rm_level_1 && global.last_battle_id == "final_boss_phase1_defeated") {
    global.last_battle_id = "none";
    boss_pending_jrpg = true;
    var _boss = instance_find(obj_final_boss_placeholder, 0);
    if (_boss != noone) {
        with (_boss) {
            if (!instance_exists(obj_textevent)) {
                create_textevent([
                    "Impressive... You've breached the outer layer.",
                    "But I am MORE than code and firewalls.",
                    "The CORE awaits you."
                ], [id, id, id]);
            }
        }
    }
}

// Auto-fire JRPG once the taunt dialogue closes
if (room == rm_level_1 && boss_pending_jrpg && !instance_exists(obj_textevent)) {
    boss_pending_jrpg = false;
    global.puzzle_word_list           = ["ANOMALY", "PROTOCOL", "ENCRYPT", "EXPLOIT", "PAYLOAD", "CIPHER"];
    global.last_battle_id             = "final_boss_jrpg";
    global.is_jrpg                    = true;
    global.battle_enemy_sprite        = spr_boss_idle;   // The Anomaly
    global.battle_enemy_attack_sprite = spr_boss_attack; // Boss attack animation
    room_goto(rm_battle_scramble);
    show_debug_message("CONTROLLER: Transitioning to final boss JRPG phase.");
}

// --- FINAL BOSS JRPG DEFEATED (victory) ---
if (room == rm_level_1 && global.last_battle_id == "final_boss_jrpg_defeated") {
    global.last_battle_id      = "none";
    global.final_boss_defeated = true;
    if (instance_exists(obj_save_manager)) obj_save_manager.save_game();
    var _boss = instance_find(obj_final_boss_placeholder, 0);
    if (_boss != noone) {
        with (_boss) {
            if (!instance_exists(obj_textevent)) {
                create_textevent([
                    "Impossible... I am... the SKIPJACK protocol...",
                    "You have... corrupted... my core...",
                    "...SYSTEM TERMINATED."
                ], [id, id, id]);
            }
            visible = false;
        }
    }
}

// --- GREG POST-BATTLE TRIGGER ---
if (room == rm_level_1 && global.last_battle_id == "greg_boss_defeated") {
    global.greg_quest_started = true;
    
    var _greg = instance_find(obj_npc1, 0);
    if (_greg != noone) {
        with (_greg) {
            // We force this dialogue to appear immediately
            create_textevent([
                "Impressive work, Jack.",
                "Go find Clipper and Lea. I've updated your HUD."
            ], [id, id]);
        }
    }
    
    global.last_battle_id = "none";
    if (instance_exists(obj_save_manager)) obj_save_manager.save_game();
}
// 1. MOUSE LOCK LOGIC
if (mouse_locked_until_release)
{
    if (!mouse_check_button(mb_left))
    {
        mouse_locked_until_release = false;
    }
    else
    {
        exit; 
    }
}

// 2. ESCAPE KEY TOGGLE
if (keyboard_check_pressed(vk_escape))
{
    if (global.is_paused)
    {
        // --- UNPAUSE ---
        global.is_paused = false;
        instance_activate_all();
        audio_resume_all();
    }
    else
    {
        // --- PAUSE CONDITION FIX ---
        // Allow pause if Jack exists OR if we are in a battle (even if Jack is hidden)
        if (instance_exists(obj_jack) || instance_exists(obj_battle_scramble))
        {
            global.is_paused = true;
            
            // 1. Freeze everyone
            instance_deactivate_all(true); 
            
            // 2. Wake controller up
            instance_activate_object(id); 

            audio_pause_all();
            pause_menu_state = "main";
            mouse_locked_until_release = true;
        }
    }
}

// --- THAT'S IT! NO BUTTON LOGIC HERE ---
// The button clicks are now handled entirely inside the Draw GUI event.

// --- EMERGENCY PRESENTATION OVERRIDE (debug only) ---
if (global.DEBUG_MODE && keyboard_check_pressed(vk_f1)) {
    global.greg_quest_started = true;
    if (instance_exists(obj_save_manager)) obj_save_manager.save_game();
    show_debug_message("!!! QUESTS MANUALLY STARTED & SAVED !!!");
}

// F2: toggle debug mode (always available)
if (keyboard_check_pressed(vk_f2)) {
    global.DEBUG_MODE = !global.DEBUG_MODE;
    show_debug_message("[DEBUG] Debug mode " + (global.DEBUG_MODE ? "ENABLED" : "DISABLED"));
}