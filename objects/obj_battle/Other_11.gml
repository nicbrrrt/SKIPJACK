// User Event 1 - Cipher completed (handles BOTH shield and packet)
show_debug_message("BATTLE: Cipher solved!");
show_debug_message("=== BATTLE: Cipher User Event 1 triggered ===");
show_debug_message("=== cipher_mode = " + string(cipher_mode) + " ===");

if (cipher_mode == "first") {
    // First use: Disable shield
    show_debug_message("BATTLE: Shield disabled! Enemy vulnerable!");
    state = "ATTACK";
    // Enemy immediately attacks with corrupted packet
    show_debug_message("BATTLE: Enemy firing corrupted packet!");
    alarm[0] = room_speed * 1;
} else if (cipher_mode == "packet") {
    show_debug_message("BATTLE: Packet uncorrupted! Throwing back at enemy!");
    enemy_hp -= 3;
    show_debug_message("BATTLE: Enemy HP: " + string(enemy_hp));
    
    if (enemy_hp <= 0) {
        show_debug_message("BATTLE: VICTORY!");
		room_goto(global.return_room);
        // Show victory message and restart button
        with (obj_start_combat) {
            visible = true; // Show start button again
			// Add this line in both victory and defeat sections
			global.battle_active = false;
        }
    } else {
        state = "ATTACK";
        alarm[0] = room_speed * 1;
    }
}