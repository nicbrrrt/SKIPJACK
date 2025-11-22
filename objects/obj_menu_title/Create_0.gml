// --- Create Event for obj_menu_title ---

// This variable will control your game's volume
// We only want to set this ONCE at the very start
if (!variable_global_exists("game_volume"))
{
    global.game_volume = 1; // 1 = 100% volume
    audio_master_gain(global.game_volume);
}

// (If you have your fade-in code here, just leave it)
image_alpha = 0;