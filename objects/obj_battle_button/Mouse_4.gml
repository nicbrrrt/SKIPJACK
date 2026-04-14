// --- LEFT PRESSED EVENT ---

// Only accept if not yet revealed and the game is ready for input
if (!revealed && instance_exists(obj_battle_scramble) && obj_battle_scramble.battle_state == "player_input")
{
    audio_play_sound(snd_button_click, 10, false);

    // 1. Mark as revealed (show actual letter, don't hide button)
    revealed = true;

    // 2. Tell the manager we selected this letter
    obj_battle_scramble.player_guess += my_char;

    // 3. Trigger the Check
    with (obj_battle_scramble) event_user(0);
}
