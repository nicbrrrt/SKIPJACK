if (variable_global_exists("is_paused") && global.is_paused) exit;

if (active) {
    timer -= 1;

    // --- PACKET MINI GAME: alternate background sounds ---
    if (!audio_is_playing(packet1) && !audio_is_playing(packet2)) {
        packet_bg_flip = !packet_bg_flip;
        audio_play_sound(packet_bg_flip ? packet2 : packet1, 5, false);
    }

    // FAIL CONDITION (timer ran out)
    if (timer <= 0) {
        active = false;
        hspeed = 0;
        audio_stop_sound(packet1);
        audio_stop_sound(packet2);
        audio_play_sound(lose1, 10, false);
        if (instance_exists(obj_battle)) {
            with (obj_battle) event_user(2);
        }
        instance_destroy();
    }
    else {
        // INPUT LOGIC
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_down) ||
            keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right)) {

            var pressed_key = keyboard_lastkey;

            if (pressed_key == pattern[index]) {
                // Play arrow sound for the correct key
                if      (pressed_key == vk_up)    audio_play_sound(arrow1, 10, false);
                else if (pressed_key == vk_down)  audio_play_sound(arrow2, 10, false);
                else if (pressed_key == vk_left)  audio_play_sound(arrow3, 10, false);
                else if (pressed_key == vk_right) audio_play_sound(arrow4, 10, false);

                index += 1;

                // WIN CONDITION: STAY IN RM_COMBAT
                if (index >= array_length(pattern)) {
                    active = false;
                    hspeed = 0;
                    audio_stop_sound(packet1);
                    audio_stop_sound(packet2);

                    // Trigger the Decryption phase in the current battle manager
                    if (instance_exists(obj_battle)) {
                        with (obj_battle) event_user(3);
                    }

                    instance_destroy();
                }
            }
            else {
                // WRONG KEY - FAIL
                active = false;
                hspeed = 0;
                audio_stop_sound(packet1);
                audio_stop_sound(packet2);
                audio_play_sound(wrong1, 10, false);
                if (instance_exists(obj_battle)) {
                    with (obj_battle) event_user(2);
                }
                instance_destroy();
            }
        }
    }
}