// WATCHER: Moves from Puzzle to Attack
if (cipher_mode == "first" && state == "CIPHER1") {
    if (!instance_exists(obj_cipher) && !instance_exists(obj_tutorial)) {
        state = "ATTACK"; 
        alarm[0] = game_get_speed(gamespeed_fps) * 1; 
    }
}