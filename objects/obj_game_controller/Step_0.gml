/// Step Event - obj_game_controller

// --- JRPG ROOM TRANSITION HANDLER ---
if (room == rm_level_1 && global.last_battle_id == "greg_boss") {
    if (!instance_exists(obj_textevent)) {
        // Reset the ID so it doesn't loop, then TELEPORT
        global.last_battle_id = "none"; 
        global.is_jrpg = true;
        room_goto(rm_battle_scramble);
        show_debug_message("CONTROLLER: Teleporting to JRPG Battle.");
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

// --- EMERGENCY PRESENTATION OVERRIDE ---
if (keyboard_check_pressed(vk_f1)) {
    global.greg_quest_started = true;
    if (instance_exists(obj_save_manager)) obj_save_manager.save_game();
    show_debug_message("!!! QUESTS MANUALLY STARTED & SAVED !!!");
}