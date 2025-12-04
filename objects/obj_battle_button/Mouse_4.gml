audio_play_sound(snd_button_click, 10, false);

if (instance_exists(obj_battle_scramble)) 
{
    // Send letter to manager
    obj_battle_scramble.player_guess += my_char;
    
    // Check Answer Logic
    with (obj_battle_scramble) 
    {
        if (string_length(player_guess) >= string_length(target_word)) 
        {
            if (player_guess == target_word) {
                // WIN ROUND
                audio_play_sound(snd_correct_ping, 10, false);
                battle_state = "player_attack"; 
                timer = 0; 
                with(obj_battle_button) instance_destroy();
            } else {
                // WRONG ANSWER
                audio_play_sound(snd_error, 10, false);
                battle_state = "enemy_turn"; 
                timer = 0;
                with(obj_battle_button) instance_destroy();
            }
        }
    }
}
instance_destroy(); // Destroy this button