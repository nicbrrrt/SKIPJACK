// --- User Event 1 of obj_battle ---

if (cipher_mode == "packet") {
    enemy_hp -= 3;
    
    // 1. CHECK FOR VICTORY
    if (enemy_hp <= 0) {
        global.battle_result = "win"; 
        global.battle_active = false;
        
        // Final boss phase 1 returns to level 1 for JRPG transition
        if (battle_id == "final_boss_phase1") {
            global.last_battle_id = "final_boss_phase1_defeated";
            room_goto(rm_level_1);
        } else if (room_exists(rm_hallway)) {
            room_goto(rm_hallway);
        } else {
            room_goto(global.return_room);
        }
    } 
    // 2. CONTINUE FIGHT
    else {
        state = "ATTACK";
        alarm[0] = game_get_speed(gamespeed_fps) * 1;
    }
}