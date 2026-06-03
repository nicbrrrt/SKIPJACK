// obj_tutorial_controller — Step Event
// Drives the four-phase tutorial state machine.

if (tutorial_done) exit;
if (instance_exists(obj_transition)) exit;

switch (tutorial_phase) {

    // ------------------------------------------------------------------
    // PHASE 0 — Welcome intro: wait for the player to finish reading
    // ------------------------------------------------------------------
    case 0:
        if (!first_dialogue_shown) exit;
        if (instance_exists(obj_textevent)) exit;

        tutorial_phase = 1;
        if (instance_exists(obj_npc1)) {
            var _greg = instance_find(obj_npc1, 0);
            create_textevent(
                [
                    "Let's start with movement.",
                    "Use W, A, S, and D to walk around.",
                    "Try each key — they'll light up in the corner once you've pressed them all!"
                ],
                [_greg, _greg, _greg]
            );
        }
        break;

    // ------------------------------------------------------------------
    // PHASE 1 — WASD tracking: register each key press once
    // ------------------------------------------------------------------
    case 1:
        if (instance_exists(obj_textevent)) exit;

        if (keyboard_check_pressed(ord("W"))) w_pressed = true;
        if (keyboard_check_pressed(ord("A"))) a_pressed = true;
        if (keyboard_check_pressed(ord("S"))) s_pressed = true;
        if (keyboard_check_pressed(ord("D"))) d_pressed = true;

        if (w_pressed && a_pressed && s_pressed && d_pressed) {
            tutorial_phase = 2;
            if (instance_exists(obj_npc1)) {
                var _greg = instance_find(obj_npc1, 0);
                create_textevent(
                    [
                        "Nice work — you've got movement down!",
                        "Walk over to me and press E to interact.",
                        "E is also how you advance any conversation in the game."
                    ],
                    [_greg, _greg, _greg]
                );
            }
        }
        break;

    // ------------------------------------------------------------------
    // PHASE 2 — Walk to Greg: detect proximity + E press
    // ------------------------------------------------------------------
    case 2:
        if (instance_exists(obj_textevent)) exit;

        if (instance_exists(obj_jack) && instance_exists(obj_npc1)) {
            var _greg = instance_find(obj_npc1, 0);
            if (point_distance(obj_jack.x, obj_jack.y, _greg.x, _greg.y) < 48
                && keyboard_check_pressed(ord("E"))) {

                tutorial_phase = 3;
                create_textevent(
                    [
                        "There you go! You're already getting the hang of it.",
                        "Remember: WASD to move, E to talk and continue.",
                        "Press TAB anytime if you forget — a small reminder can stay on your screen.",
                        "Alright, let's head out!"
                    ],
                    [_greg, _greg, _greg, _greg]
                );
            }
        }
        break;

    // ------------------------------------------------------------------
    // PHASE 3 — Wrap-up → unlock controls hint → fade to next level
    // ------------------------------------------------------------------
    case 3:
        if (instance_exists(obj_textevent)) exit;

        tutorial_done = true;
        global.controls_hint_unlocked = true;
        global.controls_hint_visible  = true;

        if (!instance_exists(obj_ui_button)) {
            instance_create_depth(0, 0, -15000, obj_ui_button);
        }

        var _t = instance_create_depth(0, 0, -9999, obj_transition);
        _t.target_room = rm_cutscene_lab;
        _t.target_x    = 554;
        _t.target_y    = 223;
        _t.fade_mode   = "fading_out";
        _t.fade_alpha  = 0;
        break;
}
