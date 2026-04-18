// obj_battle_intro — Step Event

switch (phase) {

    // ── Phase 0: Breado's explanation dialogue ────────────────────────────────
    case 0:
        if (!instance_exists(obj_textevent)) {
            if (!variable_instance_exists(id, "dialogue_created")) {
                dialogue_created = true;
                // Use self (obj_battle_intro) as the speaker — it has Breado's
                // myName/myPortrait/myVoice/myFont set in Create_0.
                create_textevent([
                    "Woah, hold up! Before you dive in, let me explain.",
                    "I'm Breado. Think of me as your tactical advisor.",
                    "See those two bars on screen? Those are HP — Hit Points.",
                    "HP is your health. Yours is on the right; the enemy's on the left.",
                    "Your goal: bring the enemy's HP to zero before they bring yours down.",
                    "To attack, spell the correct word using the letter buttons.",
                    "Get it right and you deal damage. Get it wrong and the enemy hits back!",
                    "I've opened your Codex to the Battle Basics page — read up.",
                    "Press  [ C ]  or  [ ESC ]  to close the Codex when you're ready to fight!"
                ], [id, id, id, id, id, id, id, id, id]);
            }
        }
        // Once dialogue is done, open the codex and move on
        if (variable_instance_exists(id, "dialogue_created") && !instance_exists(obj_textevent)) {
            if (instance_exists(obj_codex_manager)) {
                with (obj_codex_manager) {
                    // Jump to the Battle Basics page
                    var _len = array_length(modules);
                    for (var i = 0; i < _len; i++) {
                        if (modules[i].title == "BATTLE BASICS") {
                            current_page = i;
                            break;
                        }
                    }
                    is_open = true;
                }
            }
            phase = 1;
        }
        break;

    // ── Phase 1: Codex is open — wait for player to close it ─────────────────
    case 1:
        // Allow C or ESC to close (obj_codex_manager handles its own close logic,
        // but in a battle room the C key is blocked, so we intercept it here).
        if (keyboard_check_pressed(ord("C")) || keyboard_check_pressed(vk_escape)) {
            if (instance_exists(obj_codex_manager)) {
                obj_codex_manager.is_open = false;
            }
            phase = 2;
        }
        // Also catch the case where codex was closed by its own logic
        if (instance_exists(obj_codex_manager) && !obj_codex_manager.is_open) {
            phase = 2;
        }
        break;

    // ── Phase 2: Done — signal the battle to start ────────────────────────────
    case 2:
        global.breado_intro_done = true;
        instance_destroy();
        break;
}
