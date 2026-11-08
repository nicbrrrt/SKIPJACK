/// @description obj_dungeon_victory — Step Event
/// Advances to the next floor (1..10), or advances to the next Chapter after Floor 10 Final Exam.

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

        if (phase_timer >= 20) {
            // Page 0 -> Paystub; Page 1 -> confirm next floor / next chapter: E, Enter, or Space
            if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
                audio_play_sound(snd_button_click, 10, false);
                if (page == 0) {
                    page        = 1;
                    phase_timer = 0; // brief lockout so the paystub isn't skipped by a double-press
                } else {
                    next_action = "next_dungeon";
                    phase        = "fade_out";
                    phase_timer  = 0;
                }
            }
            // Visit the Homeroom (Wall Telephone & Statue Display Table) between workdays
            else if (page == 1 && keyboard_check_pressed(ord("H"))) {
                next_action = "homeroom";
                phase       = "fade_out";
                phase_timer = 0;
                audio_play_sound(snd_button_click, 10, false);
            }
            // Return to Chapter Select Screen: Escape
            else if (keyboard_check_pressed(vk_escape)) {
                global.esc_block_frames = 2;
                keyboard_clear(vk_escape);
                next_action = "chapter_select";
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
                if (is_final_exam) {
                    if (chapter_num < CHAPTER_ATBASH) {
                        // Advance directly to Floor 1 of the next Chapter!
                        global.dungeon_chapter  = chapter_num + 1;
                        global.chapter_floor    = 1;
                        global.dungeons_cleared = 0;
                        room_restart();
                    } else {
                        // Completed all 3 Chapters (Floor 10 of Atbash)! Return to Chapter Select
                        room_goto(rm_cipher_select);
                    }
                } else {
                    // Advance to the next floor (1..10) within the current Chapter
                    global.chapter_floor    = min(CHAPTER_MAX_FLOORS, cleared_floor + 1);
                    global.dungeons_cleared = global.chapter_floor - 1;
                    room_restart();
                }
            } else if (next_action == "homeroom") {
                // Advance the floor / chapter exactly like "next_dungeon", then rest in the Homeroom
                if (is_final_exam) {
                    if (chapter_num < CHAPTER_ATBASH) {
                        global.dungeon_chapter  = chapter_num + 1;
                        global.chapter_floor    = 1;
                        global.dungeons_cleared = 0;
                    }
                } else {
                    global.chapter_floor    = min(CHAPTER_MAX_FLOORS, cleared_floor + 1);
                    global.dungeons_cleared = global.chapter_floor - 1;
                }
                room_goto(rm_homeroom);
            } else {
                room_goto(rm_cipher_select);
            }
            instance_destroy();
        }
        break;
}
