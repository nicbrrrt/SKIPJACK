// --- User Event 1 - Cipher Completed (Victory Check) ---
show_debug_message("BATTLE: Cipher solved!");
show_debug_message("=== cipher_mode = " + string(cipher_mode) + " ===");

if (cipher_mode == "first") {
    // First use: Disable shield
    show_debug_message("BATTLE: Shield disabled! Enemy vulnerable!");
    state = "ATTACK";
    
    // Enemy immediately attacks with corrupted packet
    show_debug_message("BATTLE: Enemy firing corrupted packet!");
    alarm[0] = room_speed * 1;
} 
else if (cipher_mode == "packet") {
    show_debug_message("BATTLE: Packet uncorrupted! Throwing back at enemy!");
    enemy_hp -= 3;
    show_debug_message("BATTLE: Enemy HP: " + string(enemy_hp));
    
    if (enemy_hp <= 0) {
        show_debug_message("BATTLE: VICTORY!");
        
        // --- CRITICAL FIX: SAVE THE RESULT ---
        global.battle_result = "win"; 
        global.battle_active = false;
        // ------------------------------------

        room_goto(global.return_room);
        
    } else {
        state = "ATTACK";
        alarm[0] = room_speed * 1;
    }
}