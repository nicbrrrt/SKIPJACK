// --- User Event 1 of obj_battle ---

if (cipher_mode == "packet") {
    enemy_hp -= 3;
    
    // 1. CHECK FOR VICTORY
    if (enemy_hp <= 0) {
        global.battle_result = "win"; 
        global.battle_active = false;
        
        // Return to the hallway for the final cutscene
        if (room_exists(rm_hallway)) {
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