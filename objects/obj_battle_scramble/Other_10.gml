// --- CHECK WIN CONDITION ---

// Only check if the guess is the same length as the target
if (string_length(player_guess) >= string_length(target_word)) 
{
    if (player_guess == target_word) {
        // --- WIN ROUND ---
        audio_play_sound(snd_correct_ping, 10, false);
        battle_state = "player_attack"; 
        timer = 0; 
        
        // Now we can destroy buttons since the round is over
        with(obj_battle_button) instance_destroy();
        
    } else {
        // --- WRONG ANSWER ---
        audio_play_sound(snd_error, 10, false);
        battle_state = "enemy_turn"; 
        timer = 0;
        
        with(obj_battle_button) instance_destroy();
    }
}