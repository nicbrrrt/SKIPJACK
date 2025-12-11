// --- LEFT PRESSED EVENT ---

// Only click if we are visible and the game is ready for input
if (visible && instance_exists(obj_battle_scramble) && obj_battle_scramble.battle_state == "player_input") 
{
    audio_play_sound(snd_button_click, 10, false);

    // 1. Tell the manager we selected this letter
    obj_battle_scramble.player_guess += my_char;
    
    // 2. Hide this button (Don't destroy it!)
    visible = false;
    
    // 3. Trigger the Check (We do this in the controller now)
    with (obj_battle_scramble) event_user(0); 
}