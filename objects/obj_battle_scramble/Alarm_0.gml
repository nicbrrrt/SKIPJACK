// --- ALARM 0 ---
// Starts the battle puzzle. If Breado's intro hasn't been shown yet,
// spawn obj_battle_intro first and keep re-checking until it's done.

if (!global.breado_intro_done) {
    if (!instance_exists(obj_battle_intro)) {
        instance_create_depth(0, 0, -20000, obj_battle_intro);
    }
    alarm[0] = 10; // Check again in 10 frames
} else {
    load_next_puzzle();
}
