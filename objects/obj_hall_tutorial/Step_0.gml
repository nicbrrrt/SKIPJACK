// obj_hall_tutorial — Step Event

switch (phase) {

    // ── Phase 0: Init ────────────────────────────────────────────────────────
    case 0:
        if (!instance_exists(obj_jack) || !instance_exists(obj_npc1)) break;

        // Lock the player
        obj_jack.isInCutscene = true;

        // Position Greg just below Jack for the greeting
        obj_npc1.x = obj_jack.x;
        obj_npc1.y = obj_jack.y + 80;

        phase = 1;
        break;

    // ── Phase 1: Start greeting dialogue ─────────────────────────────────────
    case 1:
        if (!instance_exists(obj_textevent)) {
            create_textevent([
                "Hey! Over here, Jack.",
                "Welcome to SkipJack — your cybersecurity training program.",
                "I'm Greg. I'll be your guide through the digital battleground.",
                "In SkipJack you'll face real cyber threats: malware, ciphers, and more.",
                "Your mission is to learn the skills to stop them before they stop you.",
                "By the way — whenever you see a speech box like this, press  [ E ]  to continue."
            ], [obj_npc1, obj_npc1, obj_npc1, obj_npc1, obj_npc1, obj_npc1]);
            phase = 2;
        }
        break;

    // ── Phase 2: Wait for greeting dialogue ──────────────────────────────────
    case 2:
        e_pulse = (e_pulse + 4) mod 360;
        if (!instance_exists(obj_textevent)) {
            // Unlock Jack for WASD practice
            if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
            phase = 3;
        }
        break;

    // ── Phase 3: WASD tutorial — must press all four keys ────────────────────
    case 3:
        if (keyboard_check_pressed(ord("W"))) w_pressed = true;
        if (keyboard_check_pressed(ord("A"))) a_pressed = true;
        if (keyboard_check_pressed(ord("S"))) s_pressed = true;
        if (keyboard_check_pressed(ord("D"))) d_pressed = true;

        if (w_pressed && a_pressed && s_pressed && d_pressed) {
            if (instance_exists(obj_jack)) obj_jack.isInCutscene = true;
            phase = 4;
        }
        break;

    // ── Phase 4: Move Greg, start "find me" instructions ─────────────────────
    case 4:
        if (!instance_exists(obj_textevent)) {
            // Move Greg down the hallway
            if (instance_exists(obj_npc1)) {
                obj_npc1.x = 416;
                obj_npc1.y = 700;
            }
            create_textevent([
                "Excellent! Movement sorted.",
                "I'm going to head down the hall — follow me.",
                "Walk over and press  [ E ]  to have a proper conversation. Give it a go!"
            ], [obj_npc1, obj_npc1, obj_npc1]);
            phase = 5;
        }
        break;

    // ── Phase 5: Wait for "find me" dialogue, then unlock Jack ───────────────
    case 5:
        if (!instance_exists(obj_textevent)) {
            if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
            phase = 6;
        }
        break;

    // ── Phase 6: Wait for player to reach Greg and press E ───────────────────
    case 6:
        // Greg's own Step_0 detects E pressed within range and fires
        // the "hall_tutorial_done == false" congratulations dialogue.
        // We just watch for a new textevent to appear.
        if (instance_exists(obj_textevent)) {
            phase = 7;
        }
        break;

    // ── Phase 7: Wait for congratulations dialogue ───────────────────────────
    case 7:
        if (!instance_exists(obj_textevent)) {
            phase = 8;
        }
        break;

    // ── Phase 8: Transition to rm_level_1 ────────────────────────────────────
    case 8:
        if (!transition_started) {
            transition_started = true;
            global.hall_tutorial_done = true;
            if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
            if (!instance_exists(obj_transition)) {
                var _t        = instance_create_depth(0, 0, -16000, obj_transition);
                _t.target_room = rm_level_1;
                _t.fade_mode   = "fading_out";
            }
        }
        break;
}
