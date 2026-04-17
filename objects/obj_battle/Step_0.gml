// DEBUG: F3 skips overworld combat
if (variable_global_exists("DEBUG_MODE") && global.DEBUG_MODE && keyboard_check_pressed(vk_f3)) {
    show_debug_message("[DEBUG] F3 pressed — skipping overworld combat (battle_id: " + string(battle_id) + ")");
    global.battle_result = "win";
    global.battle_active = false;
    if (battle_id == "final_boss_phase1") {
        global.last_battle_id = "final_boss_phase1_defeated";
        room_goto(rm_level_1);
    } else if (room_exists(rm_hallway)) {
        room_goto(rm_hallway);
    } else {
        room_goto(global.return_room);
    }
    exit;
}

// DEBUG: F4 forces overworld combat loss
if (variable_global_exists("DEBUG_MODE") && global.DEBUG_MODE && keyboard_check_pressed(vk_f4)) {
    show_debug_message("[DEBUG] F4 pressed — forcing overworld combat loss (battle_id: " + string(battle_id) + ")");
    global.battle_result = "lose";
    global.battle_active = false;
    room_goto(global.return_room);
    exit;
}

// WATCHER: Moves from Puzzle to Attack
if (cipher_mode == "first" && state == "CIPHER1") {
    if (!instance_exists(obj_cipher) && !instance_exists(obj_tutorial)) {
        state = "ATTACK"; 
        alarm[0] = game_get_speed(gamespeed_fps) * 1; 
    }
}