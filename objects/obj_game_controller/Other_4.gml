// --- Room Start Event for obj_game_controller ---

if (room == rm_combat) {
    // If Greg set this to true, spawn the puzzle system
    if (global.is_jrpg == true) {
        if (!instance_exists(obj_battle_scramble)) {
            instance_create_depth(0, 0, -10000, obj_battle_scramble);
            show_debug_message("SYSTEM: JRPG Scramble System Initialized for Greg.");
        }
    } 
    // If false (Breado's case), the controller does nothing and stays in normal mode
}