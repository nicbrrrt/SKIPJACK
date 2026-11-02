/// @description obj_dungeon_victory — Step Event

if (variable_global_exists("is_paused") && global.is_paused) exit;

anim_timer++;
phase_timer++;

switch (phase) {
    case "fade_in":
        screen_alpha = min(1, phase_timer / 25);
        if (phase_timer >= 25) {
            screen_alpha = 1;
            phase        = "display";
            phase_timer  = 0;
        }
        break;

    case "display":
        screen_alpha = 1;

        // Wait a brief moment before accepting input so accidental double-taps don't skip
        if (phase_timer >= 20) {
            // Confirm next dungeon: E, Enter, or Space
            if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
                next_action = "next_dungeon";
                phase       = "fade_out";
                phase_timer = 0;
                audio_play_sound(snd_button_click, 10, false);
            }
            // Optional return to main menu: Escape
            else if (keyboard_check_pressed(vk_escape)) {
                next_action = "menu";
                phase       = "fade_out";
                phase_timer = 0;
                audio_play_sound(snd_button_click, 10, false);
            }
        }
        break;

    case "fade_out":
        if (phase_timer >= 25) {
            if (instance_exists(obj_jack)) {
                obj_jack.isInCutscene = false;
            }

            if (next_action == "next_dungeon") {
                // Restart the room to trigger obj_dungeon_generator to build a fresh dungeon
                room_restart();
            } else {
                room_goto(rm_menu);
            }
            instance_destroy();
        }
        break;
}
