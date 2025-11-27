// --- Step Event of obj_start_combat ---

// 1. CHECK FOR RETURN (Post-Battle Dialogue)
// Only run this if THIS specific computer was the one we just fought
if (global.last_battle_id == battle_id && battle_id != "none") {
    
    // --- VICTORY SCENARIO ---
    if (global.battle_result == "win" && battle_id == "tutorial") {
        if (!active_dialogue) {
            active_dialogue = true;
            var _text = [
                "Well that was easy",
                "You know, for someone who's so academically challenged,",
				"You're pretty good at decrypting ciphers",
                "Well, everyone has their specialti- Wait... WHAT DO YOU MEAN ACADEMICALLY CHALLENGED"
            ];
            // Ensure obj_npc2 exists in the room!
            create_textevent(_text, [obj_jack, obj_npc2, obj_jack]);
        }
    }
    // --- DEFEAT SCENARIO ---
    else if (global.battle_result == "lose" && battle_id == "tutorial") {
        if (!active_dialogue) {
            active_dialogue = true;
            var _text = [
                "Might have made it too challenging",
                "I-I just pressed the wrong key!"
            ];
            create_textevent(_text, [obj_npc2, obj_jack]);
        }
    }
    
    // --- CLEANUP (When text finishes) ---
    if (active_dialogue == true && !instance_exists(obj_textevent)) {
        // Reset everything so we can move on
        global.last_battle_id = "none"; 
        global.battle_result = "none";
        active_dialogue = false;
    }
    
    exit; // Stop running the rest of the code so we don't start the fight again
}


// 2. NORMAL INTERACTION (Starting the Fight)
if (instance_exists(obj_jack)) {
    var _player = instance_find(obj_jack, 0);

    // Distance & Input Check
    if (point_distance(x, y, _player.x, _player.y) < interaction_range) {
        
        if (keyboard_check_pressed(ord("E")) && !instance_exists(obj_textevent)) {
            
            // --- BRANCH: IS THIS A STORY FIGHT? ---
            if (battle_id == "tutorial") {
                // Yes! Play the Intro Dialogue first.
                active_dialogue = true;
                
                var _text = [
                    "I heard you needed help with something?",
                    "Yeah, it's about the video game we made!",
                    "Oh right! The game you made me test last time!",
                    "That's right! We need you to test it for us again! Is that okay?",
                    "Of course!",
                    "Great! You still remember how to play right?",
                    "Ye- no",
                    "I figured as much"
                ];
                var _speakers = [obj_jack, obj_npc2, obj_jack, obj_npc2, obj_jack, obj_npc2, obj_jack, obj_npc2];
                create_textevent(_text, _speakers);
                
            } else {
                // No! This is a generic computer. Just start the fight immediately.
                global.return_room = room;
                global.return_x = _player.x;
                global.return_y = _player.y;
                room_goto(rm_combat);
            }
        }
    }
}

// 3. TRANSITION TO BATTLE (After Intro Text)
if (active_dialogue == true && !instance_exists(obj_textevent) && global.last_battle_id == "none") {
    
    // The intro text finished. NOW we go to battle.
    active_dialogue = false;
    
    // --- IMPORTANT: SAVE THE BATTLE ID ---
    // This tells the game "We are leaving to fight the TUTORIAL".
    if (battle_id != "none") {
        global.last_battle_id = battle_id; 
    }
    
    // Save Ticket
    var _player = instance_find(obj_jack, 0);
    global.return_room = room;
    global.return_x = _player.x;
    global.return_y = _player.y;
    
    // Go to battle
    room_goto(rm_combat);
}