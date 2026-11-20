/// @description obj_dungeon_victory — Step Event
/// Advances to the next floor (1..10), or advances to the next Chapter after Floor 10 Final Exam.

if (variable_global_exists("is_paused") && global.is_paused) exit;
if (scr_handle_term_popup_input()) exit;

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
        if (safety_quiz_shake > 0) safety_quiz_shake--;

        if (phase_timer >= 20) {
            if (page == 0) {
                // Page 0 (Incident Debrief) -> Page 1 (Interactive Cyber Safety Check)
                if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
                    audio_play_sound(snd_button_click, 10, false);
                    page        = 1;
                    phase_timer = 0;
                }
            } else if (page == 1) {
                // Page 1: Interactive "What Would You Do?" Cyber Safety Check
                if (!safety_quiz_solved) {
                    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
                        safety_quiz_sel = (safety_quiz_sel + 2) mod 3;
                        audio_play_sound(snd_button_hover, 6, false);
                    }
                    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
                        safety_quiz_sel = (safety_quiz_sel + 1) mod 3;
                        audio_play_sound(snd_button_hover, 6, false);
                    }

                    var _sq_submit = false;
                    if (keyboard_check_pressed(ord("1"))) { safety_quiz_sel = 0; _sq_submit = true; }
                    if (keyboard_check_pressed(ord("2"))) { safety_quiz_sel = 1; _sq_submit = true; }
                    if (keyboard_check_pressed(ord("3"))) { safety_quiz_sel = 2; _sq_submit = true; }
                    if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
                        _sq_submit = true;
                    }

                    // Mouse click support on the 3 option cards
                    var _gw  = display_get_gui_width();
                    var _gh  = display_get_gui_height();
                    var _cx  = _gw * 0.5;
                    var _cy  = _gh * 0.5;
                    var _pw  = 580;
                    var _ph  = 324;
                    var _x1  = _cx - _pw * 0.5;
                    var _y1  = _cy - _ph * 0.5;
                    var _x2  = _cx + _pw * 0.5;
                    var _gmx = device_mouse_x_to_gui(0);
                    var _gmy = device_mouse_y_to_gui(0);

                    for (var _qi = 0; _qi < 3; _qi++) {
                        var _qy1 = _y1 + 108 + (_qi * 40);
                        var _qy2 = _qy1 + 34;
                        if (point_in_rectangle(_gmx, _gmy, _x1 + 20, _qy1, _x2 - 20, _qy2)) {
                            if (mouse_check_button_pressed(mb_left)) {
                                safety_quiz_sel = _qi;
                                _sq_submit      = true;
                            }
                        }
                    }

                    if (_sq_submit) {
                        if (safety_quiz_sel == safety_quiz_correct_idx) {
                            safety_quiz_solved = true;
                            phase_timer        = 12; // brief guard before advancing to paystub
                            if (safety_quiz_first_try) {
                                safety_quiz_bonus   = 50;
                                paycheck.total     += 50;
                                global.player_cash += 50;
                                safety_quiz_feedback = "FIRST-TRY MASTERY (+$50 BONUS)! " + safety_quiz_feedback_ok;
                            } else {
                                safety_quiz_bonus    = 0;
                                safety_quiz_feedback = safety_quiz_feedback_ok;
                            }
                            safety_quiz_feedback_col = c_lime;
                            audio_play_sound(snd_correct_ping, 10, false);
                        } else {
                            safety_quiz_first_try                  = false;
                            safety_quiz_eliminated[safety_quiz_sel] = true;
                            safety_quiz_shake                      = 10;
                            safety_quiz_feedback                   = "UNSAFE CHOICE — Think about what happened on this floor and pick the safe habit!";
                            safety_quiz_feedback_col               = make_color_rgb(255, 110, 95);
                            audio_play_sound(wrong1, 10, false);
                        }
                    }
                } else {
                    // Once solved, pressing E / Enter / Space / Click advances to Page 2 (Corporate Paystub)
                    if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left)) {
                        audio_play_sound(snd_button_click, 10, false);
                        page        = 2;
                        phase_timer = 0;
                    }
                }
            } else {
                // Page 2 (Corporate Paystub) -> confirm next floor / next chapter: E, Enter, or Space
                if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
                    audio_play_sound(snd_button_click, 10, false);
                    next_action = "next_dungeon";
                    phase       = "fade_out";
                    phase_timer = 0;
                }
                // Visit the Homeroom (Wall Telephone & Statue Display Table) between workdays — disabled when Intern Duty is flagged!
                else if (!(variable_global_exists("intern_duty_flagged") && global.intern_duty_flagged) && keyboard_check_pressed(ord("H"))) {
                    next_action = "homeroom";
                    phase       = "fade_out";
                    phase_timer = 0;
                    audio_play_sound(snd_button_click, 10, false);
                }
            }

            // Return to Chapter Select Screen: Escape
            if (keyboard_check_pressed(vk_escape)) {
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
                global.cam_pan_phase   = "off";
                global.cam_pan_mode    = "";
                global.cam_pan_timer   = 0;
                global.cam_pan_targets = [];
                room_goto(rm_homeroom);
            } else {
                room_goto(rm_cipher_select);
            }
            instance_destroy();
        }
        break;
}
