
// --- SAFETY INITIALIZATION ---
// Only set these to "none" if they don't exist yet.
// This prevents the game from forgetting you won the battle when you reload the room.

if (!variable_global_exists("last_battle_id")) {
    global.last_battle_id = "none";
}

if (!variable_global_exists("battle_result")) {
    global.battle_result = "none";
}

// ... your other globals ...
global.return_room = -1;
global.return_x = 0;
global.return_y = 0;

// Tutorial Flags (False = haven't seen it yet)
global.seen_path_tutorial = false;
global.seen_cipher_tutorial = false;
global.seen_qte_tutorial = false;

global.last_battle_id = "none";     // Which battle did we just finish?
global.battle_result = "none";      // Did we win or lose?