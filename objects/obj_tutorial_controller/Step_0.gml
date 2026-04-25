// obj_tutorial_controller — Step Event
// Drives the four-phase tutorial state machine.

if (tutorial_done) exit;
if (instance_exists(obj_transition)) exit;

switch (tutorial_phase) {

    // ------------------------------------------------------------------
    // PHASE 0 — Intro greeting: wait for the player to press E to dismiss
    // ------------------------------------------------------------------
    case 0:
        if (!first_dialogue_shown) exit;        // Alarm hasn't fired yet
        if (instance_exists(obj_textevent)) exit; // Player still reading

        // Greeting dismissed — now show WASD movement instructions
        tutorial_phase = 1;
        if (instance_exists(obj_npc1)) {
            var _greg = instance_find(obj_npc1, 0);
            create_textevent(
                ["Now let's get you moving.",
                 "Try pressing W, A, S, and D to walk around!"],
                [_greg, _greg]
            );
        }
        break;

    // ------------------------------------------------------------------
    // PHASE 1 — WASD tracking: register each key press once
    // ------------------------------------------------------------------
    case 1:
        if (instance_exists(obj_textevent)) exit; // Wait for instruction dialogue to close

        if (keyboard_check_pressed(ord("W"))) w_pressed = true;
        if (keyboard_check_pressed(ord("A"))) a_pressed = true;
        if (keyboard_check_pressed(ord("S"))) s_pressed = true;
        if (keyboard_check_pressed(ord("D"))) d_pressed = true;

        if (w_pressed && a_pressed && s_pressed && d_pressed) {
            tutorial_phase = 2;
            if (instance_exists(obj_npc1)) {
                var _greg = instance_find(obj_npc1, 0);
                create_textevent(
                    ["Nice! You've got movement down.",
                     "Now walk over to me and press E!"],
                    [_greg, _greg]
                );
            }
        }
        break;

    // ------------------------------------------------------------------
    // PHASE 2 — Walk to Greg: detect proximity + E press
    // ------------------------------------------------------------------
    case 2:
        if (instance_exists(obj_textevent)) exit; // Wait for "walk to me" dialogue to close

        if (instance_exists(obj_jack) && instance_exists(obj_npc1)) {
            var _greg = instance_find(obj_npc1, 0);
            if (point_distance(obj_jack.x, obj_jack.y, _greg.x, _greg.y) < 48
                && keyboard_check_pressed(ord("E"))) {

                tutorial_phase = 3;
                create_textevent(
                    ["There you go — you're a natural!",
                     "Welcome to SkipJack.",
                     "This game is all about cryptography.",
                     "Cryptography is the art of hiding and revealing secret messages.",
                     "You'll decode enemy transmissions and crack ciphers.",
                     "Use what you learn to fight back!",
                     "Ready to begin? Let's move out!"],
                    [_greg, _greg, _greg, _greg, _greg, _greg, _greg]
                );
            }
        }
        break;

    // ------------------------------------------------------------------
    // PHASE 3 — Congratulations dialogue closed → fade to next level
    // ------------------------------------------------------------------
    case 3:
        if (instance_exists(obj_textevent)) exit;

        tutorial_done  = true;
        var _t         = instance_create_depth(0, 0, -9999, obj_transition);
        _t.target_room = rm_cutscene_lab;
        _t.fade_mode   = "fading_out";
        _t.fade_alpha  = 0;
        break;
}
