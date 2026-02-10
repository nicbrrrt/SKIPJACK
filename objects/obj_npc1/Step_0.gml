// --- 1. VISUALS & DEPTH ---
depth = -y;

// Visibility: Hide Greg in combat rooms
if (room == rm_combat || room == rm_battle_scramble) { 
    visible = false; 
    exit; 
} else {
    visible = true;
}

// Simple idle animation
if (sprite_index != spr_npc1_idle) { sprite_index = spr_npc1_idle; }
image_speed = 0.2;


// --- 2. ROOM-SPECIFIC INTERACTION ---
if (instance_exists(obj_jack)) {
    var _player = instance_nearest(x, y, obj_jack);
    
    // Check for "E" interaction
    if (point_distance(x, y, _player.x, _player.y) < 32 && keyboard_check_pressed(ord("E")) && !instance_exists(obj_textevent)) {
        
        // --- LOGIC FOR LEVEL 1 (BOSS MODE) ---
        if (room == rm_level_1) {
            // Force reset battle status for the JRPG
            global.last_battle_id = "greg_boss";
            global.battle_result = "none";
            global.is_jrpg = true;

            if (!global.greg_boss_talked) {
                global.greg_boss_talked = true;
                create_textevent(["Ready to review?", "This isn't a tutorial anymore.", "INITIATING COMBAT..."], [id, id, id]);
            } else {
                create_textevent(["Ready for a rematch?", "RE-INITIATING COMBAT..."], [id, id]);
            }
        }
        
        // --- LOGIC FOR HALLWAY (TUTORIAL MODE) ---
        // We only allow this if NOT in Level 1
        else if (room == rm_hallway && isChallenger) {
            global.last_battle_id = "greg_fight";
            global.battle_result = "none";
            global.is_jrpg = false;
            
            // This is the dialogue you were hearing by mistake
            create_textevent(["Breado told me you were academically challenged...", "Let's see if he was right!"], [id, id]);
        }
    }
}


// --- 3. ROOM-SPECIFIC TRANSITIONS ---

// --- A. LEVEL 1 LOGIC ---
// --- 3. LEVEL 1 LOGIC ---
if (room == rm_level_1) {
    var _player = instance_nearest(x, y, obj_jack);
    if (_player != noone && point_distance(x, y, _player.x, _player.y) < 32) {
        if (keyboard_check_pressed(ord("E")) && !instance_exists(obj_textevent)) {
            
            // Just set these two and let the Controller do the rest
            global.last_battle_id = "greg_boss";
            global.is_jrpg = true;

            if (!global.greg_boss_talked) {
                global.greg_boss_talked = true;
                create_textevent(["Ready to review?", "INITIATING COMBAT..."], [id, id]);
            } else {
                create_textevent(["Back for more?", "RE-INITIATING COMBAT..."], [id, id]);
            }
        }
    }
    exit; 
}
// --- B. HALLWAY LOGIC ---
else if (room == rm_hallway) {
    // Normal Combat Transition
    if (global.last_battle_id == "greg_fight" && global.battle_result == "none" && !instance_exists(obj_textevent)) {
        global.return_room = room;
        global.return_x = obj_jack.x;
        global.return_y = obj_jack.y;
        room_goto(rm_combat); 
    }
    
    // Post-Fight Win Logic
// --- Post-Fight Win Logic ---
    if (global.battle_result == "win" && global.last_battle_id == "greg_fight" && !challenge_won) {
        if (!instance_exists(obj_textevent)) {
            event_user(0); // This plays the "Follow me!" dialogue
        }
    }
    
    // Teleport to Level 1
    if (challenge_won && !instance_exists(obj_textevent)) {
        global.last_battle_id = "none";
        global.battle_result = "none";
        challenge_won = false;
        
        if (!instance_exists(obj_transition)) {
            var _inst = instance_create_depth(0, 0, -16000, obj_transition);
            _inst.target_room = rm_level_1;
            _inst.target_x = 896; 
            _inst.target_y = 416;
            _inst.fade_mode = "fading_out"; 
            global.greg_target_x = 936;
            global.greg_target_y = 40;
        }
    }
}