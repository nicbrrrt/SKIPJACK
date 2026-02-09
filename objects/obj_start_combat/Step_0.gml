// --- Step Event of obj_start_combat ---

// --- Top of Step Event for obj_start_combat ---
if (room == rm_combat) {
    visible = false;
} else {
    visible = true;
}
// ----------------------------------------------

// 1. CHECK FOR RETURN FROM BATTLE
if (global.last_battle_id == battle_id && battle_id != "none") {
    if (global.battle_result == "win" && battle_id == "tutorial") {
        if (!active_dialogue) {
            active_dialogue = true;
            global.tutorial_complete = true; 

            // ORIGINAL VICTORY DIALOGUE
            var _text = [
                "Well that was easy",
                "You're pretty good at decrypting ciphers for someone who's academically challenged",
                "Well, everyone has their specialti- Wait... WHAT DO YOU MEAN ACADEMICALLY CHALLENGED",
                "Anyway, I just got this for you.",
                "It's a Codex. I've uploaded Module 1 into it. It contains everything we just went over.",
                "Go review it. When you're ready, find Greg at the end of the hall.",
                "If you can beat him, he'll show you the way out. Good luck!"
            ];
            create_textevent(_text, [obj_jack, id, obj_jack, id, id, id, id]);
            
            // TELEPORT GREG
            if (instance_exists(obj_npc1)) {
                var _greg = instance_find(obj_npc1, 0);
                _greg.x = 416;
                _greg.y = 976;
                _greg.isChallenger = true; 
                _greg.battle_id = "greg_fight";
            }
        }
    }
    
    // Cleanup flags
    if (active_dialogue == true && !instance_exists(obj_textevent)) {
        global.last_battle_id = "none"; 
        global.battle_result = "none";
        active_dialogue = false;
    }
    exit; 
}

// 2. NORMAL INTERACTION (YOUR ORIGINAL DIALOGUE)
if (instance_exists(obj_jack)) {
    var _player = instance_find(obj_jack, 0);

    if (point_distance(x, y, _player.x, _player.y) < interaction_range) {
        if (keyboard_check_pressed(ord("E")) && !instance_exists(obj_textevent)) {
            
            // If the tutorial is already done, don't repeat the start
            if (global.tutorial_complete) {
                create_textevent(["Get outta here! Greg's waiting for you at the end of the hall."], [id]);
                exit;
            }

            if (battle_id == "tutorial") {
                active_dialogue = true;
                var _text = [
                    "I heard you needed help with something?",
                    "Yeah, it's about the video game we made!",
                    "Oh right! The game you made me test last time!",
                    "That's right! We need you to test it for us again!",
                    "Of course!",
                    "Great! You still remember how to play right?",
                    "Ye- no",
                    "I figured as much"
                ];
                var _speakers = [obj_jack, id, obj_jack, id, obj_jack, id, obj_jack, id];
                create_textevent(_text, _speakers);
            }
        }
    }
}

// 3. TRANSITION TO BATTLE
if (active_dialogue == true && !instance_exists(obj_textevent) && global.last_battle_id == "none") {
    active_dialogue = false;
    global.last_battle_id = battle_id; 
    global.return_room = room;
    global.return_x = obj_jack.x;
    global.return_y = obj_jack.y;
    room_goto(rm_combat);
}