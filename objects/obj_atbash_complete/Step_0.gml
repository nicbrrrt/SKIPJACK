// --- Step Event for obj_atbash_complete ---
if (variable_global_exists("is_paused") && global.is_paused) exit;

anim_timer++;
phase_timer++;

switch (phase) {
    // --- FADE IN (transition to congrats) ---
    case "fade_in":
        screen_alpha = 1;
        if (phase_timer >= 30) {
            phase = "title";
            phase_timer = 0;
        }
        break;

    // --- TITLE (congratulations text) ---
    case "title":
        if (phase_timer >= 180) { // ~3 seconds
            phase = "credits";
            phase_timer = 0;
            credit_index = 0;
            credit_timer = 0;
            credit_alpha = 0;
        }
        break;

    // --- CREDITS (cycle through NPCs) ---
    case "credits":
        credit_timer++;
        // Each credit: 20 frames fade in, 40 frames hold, 20 frames fade out = 80 total
        if (credit_timer <= 20) {
            credit_alpha = credit_timer / 20;
        } else if (credit_timer <= 60) {
            credit_alpha = 1;
        } else if (credit_timer <= 80) {
            credit_alpha = 1 - ((credit_timer - 60) / 20);
        }
        if (credit_timer >= 80) {
            credit_index++;
            credit_timer = 0;
            credit_alpha = 0;
            if (credit_index >= array_length(credits)) {
                phase = "unlock";
                phase_timer = 0;
            }
        }
        break;

    // --- UNLOCK REVEAL (Atbash announcement) ---
    case "unlock":
        // Scale up the unlock text
        if (phase_timer <= 30) {
            unlock_scale = lerp(0, 1.2, phase_timer / 30);
        } else if (phase_timer <= 40) {
            unlock_scale = lerp(1.2, 1.0, (phase_timer - 30) / 10);
        } else {
            unlock_scale = 1.0;
        }
        // Flash on reveal
        if (phase_timer == 1) {
            unlock_flash = 1;
        }
        if (unlock_flash > 0) unlock_flash -= 0.02;

        // Wait for E or Enter to continue (after animation settles)
        if (phase_timer >= 60) {
            if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("E"))
                || keyboard_check_pressed(vk_escape)) {
                phase = "fade_out";
                phase_timer = 0;
                audio_play_sound(snd_button_click, 10, false);
            }
        }
        break;

    // --- FADE OUT (transition to menu) ---
    case "fade_out":
        screen_alpha = max(0, 1 - (phase_timer / 60));
        if (phase_timer >= 70) {
            if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
            // Transition to cipher select menu
            global.newly_unlocked = "vigenere";
            var _t = instance_create_depth(0, 0, -9999, obj_transition);
            _t.target_room = rm_cipher_select;
            _t.fade_mode   = "fading_out";
            _t.fade_alpha  = 0;
            instance_destroy();
        }
        break;
}
