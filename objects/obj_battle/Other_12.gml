show_debug_message("BATTLE: QTE FAILED - Player hit by corrupted packet!");
player_hp -= 2;
show_debug_message("BATTLE: Player HP: " + string(player_hp));

if (player_hp <= 0) {
    show_debug_message("BATTLE: GAME OVER!");
    // Show game over and restart button
    with (obj_start_combat) {
        visible = true; // Show start button again
		// Add this line in both victory and defeat sections
		global.battle_active = false;
    }
} else {
    state = "ATTACK";
    alarm[0] = room_speed * 1;
}