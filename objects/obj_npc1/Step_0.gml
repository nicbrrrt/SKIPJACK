// --- 1. VISUALS & DEPTH ---
depth = -y;

// Hide Greg if we are in the combat room
if (room == rm_combat) { 
    visible = false; 
    exit; 
} else {
    visible = true;
}

// Simple idle animation logic
if (sprite_index != spr_npc1_idle) { sprite_index = spr_npc1_idle; }
image_speed = 0.2;


// --- 2. HALLWAY LOGIC (The Tutorial Fight) ---
if (isChallenger && room == rm_hallway) {
    
    // Start the hallway fight
    if (global.last_battle_id == "greg_fight" && global.battle_result == "none") {
        if (!instance_exists(obj_textevent)) {
            global.return_room = room;
            global.return_x = obj_jack.x;
            global.return_y = obj_jack.y;
            room_goto(rm_combat); 
            exit; 
        }
    }
    
    // Trigger dialogue after returning from a win
    if (global.battle_result == "win" && global.last_battle_id == "greg_fight" && !challenge_won) {
        if (!instance_exists(obj_textevent)) {
            event_user(0); // This should set challenge_won = true at the end
        }
    }
    
    // TELEPORT TRIGGER (Transition to Level 1)
    if (challenge_won && !instance_exists(obj_textevent)) {
        // 1. Set the global targets for BOTH Jack and Greg immediately
        global.target_x = 896; 
        global.target_y = 416;
        global.greg_target_x = 936;
        global.greg_target_y = 40;
        
        // 2. Clear battle flags
        global.last_battle_id = "none";
        global.battle_result = "none";
        challenge_won = false;
        
        // 3. Create the transition
        if (room_exists(rm_level_1) && !instance_exists(obj_transition)) {
            var _inst = instance_create_depth(0, 0, -16000, obj_transition);
            _inst.target_room = rm_level_1;
            _inst.target_x = global.target_x;
            _inst.target_y = global.target_y;
            _inst.fade_mode = "fading_out"; 
        }
        exit;
    }
}


// --- 3. LEVEL 1 LOGIC (Auto-Welcome & Final Boss) ---
// --- 3. LEVEL 1 LOGIC (Auto-Welcome & Final Boss) ---
if (room == rm_level_1) {
    
    // SAFETY SNAP: If Greg isn't at his target yet, snap him there
    if (global.greg_target_x != -1) {
        x = global.greg_target_x;
        y = global.greg_target_y;
        global.greg_target_x = -1; 
        global.greg_target_y = -1;
    }

    // AUTO-WELCOME: Fires once when you arrive
    if (!global.level1_intro_done && !instance_exists(obj_transition)) {
        global.level1_intro_done = true;
        if (instance_exists(obj_jack)) obj_jack.isInCutscene = true;

        var _intro_text = [
            "Welcome to the streets, Jack.",
            "The system out here is crawling with malware. It's dangerous.",
            "I've updated your Codex with definitions for Phishing, Spyware, Firewalls, and Botnets.",
            "Take a look at them now. Come find me when you're ready to clear the sector."
        ];
        create_textevent(_intro_text, [id, id, id, id]);
    }

    // FINAL BOSS INTERACTION
    if (global.level1_intro_done && !instance_exists(obj_textevent)) {
        var _player = instance_nearest(x, y, obj_jack);
        
        if (point_distance(x, y, _player.x, _player.y) < 32) {
            if (keyboard_check_pressed(ord("E"))) {
                
                // --- THE FIX: Check if we've talked before ---
                if (!global.greg_boss_talked) {
                    // FIRST TIME CHALLENGE
                    global.greg_boss_talked = true;
                    var _boss_text = [
                        "Ready to review what you've learned?",
                        "This isn't a tutorial anymore. Let's see if you can handle the real thing.",
                        "INITIATING COMBAT PROTOCOL..."
                    ];
                    create_textevent(_boss_text, [id, id, id]);
                } else {
                    // RETRY CHALLENGE (Shortened)
                    var _retry_text = [
                        "Back for more? Let's see if you've improved.",
                        "RE-INITIATING COMBAT PROTOCOL..."
                    ];
                    create_textevent(_retry_text, [id, id]);
                }
                
                global.last_battle_id = "greg_boss";
                global.return_room = room;
            }
        }
    }

    // --- ACTUALLY START JRPG COMBAT ---
    // --- Bottom of obj_npc1 Step Event ---
	if (global.last_battle_id == "greg_boss" && !instance_exists(obj_textevent)) {
	    global.battle_active = true; 
	    global.is_jrpg = true; // <--- THE KEY: Tell the controller this is JRPG
	    room_goto(rm_combat);
	}
}