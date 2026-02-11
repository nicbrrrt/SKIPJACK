// --- Step Event of obj_start_combat (Breado) ---

// 1. CHECK FOR RETURN FROM BATTLE
if (global.last_battle_id == battle_id && battle_id != "none") {
    
    // CASE: YOU WON
    if (global.battle_result == "win") {
        if (!active_dialogue) {
            active_dialogue = true;
            global.tutorial_complete = true; 

            // --- THE CODEX INJECTION ---
            // We do this immediately so the data is ready when the player finishes reading
            if (instance_exists(obj_codex_manager)) {
                with(obj_codex_manager) {
                    unlocked = true; 
                    add_module("MALWARE 101", "PHISHING: Fake emails used to steal data.\nBOTNET: A network of hijacked computers.\nSPYWARE: Software that tracks you in secret.");
                }
            }

            // --- RESTORED ORIGINAL DIALOGUE ---
            var _text = [
                "Well that was easy",
                "You're pretty good at decrypting ciphers for someone who's academically challenged",
                "Wait... WHAT DO YOU MEAN ACADEMICALLY CHALLENGED",
                "Anyway, I just got this for you.",
                "It's a Codex. I've uploaded Module 1 into it.",
                "Go review it (Press C). When you're ready, find Greg.",
                "If you can beat him, he'll show you the way out. Good luck!"
            ];
            create_textevent(_text, [obj_jack, id, obj_jack, id, id, id, id]);
            
            // --- FIXED GREG TELEPORT ---
            with (obj_npc1) {
                x = 416;
                y = 976;
                isChallenger = true; 
                battle_id = "greg_fight";
            }
        }
    }
    
    // CASE: YOU LOST
    else if (global.battle_result == "lose") {
        if (!active_dialogue) {
            active_dialogue = true;
            create_textevent(["Ouch... you might want to try that again. Press E to restart the tutorial."], [id]);
        }
    }
    
    // CLEANUP FLAGS
    if (active_dialogue == true && !instance_exists(obj_textevent)) {
        global.last_battle_id = "none"; 
        global.battle_result = "none";
        active_dialogue = false;
    }
    exit; 
}

// 2. NORMAL INTERACTION
if (instance_exists(obj_jack)) {
    var _player = instance_find(obj_jack, 0);

    if (point_distance(x, y, _player.x, _player.y) < 30) {
        if (keyboard_check_pressed(ord("E")) && !instance_exists(obj_textevent)) {
            
            if (global.tutorial_complete) {
                create_textevent(["Get outta here! Greg's waiting for you at the end of the hall."], [id]);
                exit;
            }

            active_dialogue = true;
            // --- RESTORED ORIGINAL START DIALOGUE ---
            var _text = [
                "I heard you needed help with something?",
                "Yeah, it's about the video game we made!",
                "Great! You still remember how to play right?",
                "Ye- no",
                "I figured as much. Let's practice."
            ];
            create_textevent(_text, [obj_jack, id, obj_jack, obj_jack, id]);
        }
    }
}

// 3. TRANSITION TO BATTLE (UPDATED FOR JRPG COMPATIBILITY)
if (active_dialogue == true && !instance_exists(obj_textevent) && global.last_battle_id == "none") {
    active_dialogue = false;
    global.last_battle_id = battle_id; 
    global.return_room = room;
    
    // --- THE FIX: Explicitly tell the game this IS NOT a JRPG fight ---
    global.is_jrpg = false; 
    
    room_goto(rm_combat);
}