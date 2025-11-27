// --- User Event 2 - QTE Failed (Damage/Loss Check) ---
show_debug_message("BATTLE: QTE FAILED - Player hit by corrupted packet!");
player_hp -= 2;
show_debug_message("BATTLE: Player HP: " + string(player_hp));

if (player_hp <= 0) {
    show_debug_message("BATTLE: GAME OVER!");
    
    // --- CRITICAL FIX: SAVE THE RESULT ---
    global.battle_result = "lose";
    global.battle_active = false;
    // ------------------------------------

    room_goto(global.return_room);

} else {
    state = "ATTACK";
    alarm[0] = room_speed * 1;
}