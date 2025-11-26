// --- SAFETY INITIALIZATION ---
// If these globals don't exist yet, create them right now so the game doesn't crash.
if (!variable_global_exists("last_battle_id")) {
    global.last_battle_id = "none";
    global.battle_result = "none";
}

interaction_range = 48;
active_dialogue = false; 

// DEFAULT: This is a generic fight.
// We will change this variable INSIDE THE ROOM EDITOR for the special computer.
battle_id = "none";