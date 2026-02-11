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


// --- 2. INTERACTION LOGIC (Consolidated) ---
if (instance_exists(obj_jack)) {
    var _player = instance_nearest(x, y, obj_jack);
    
    // Check for "E" interaction distance (Set to 48 for easier interaction)
    if (point_distance(x, y, _player.x, _player.y) < 48 && keyboard_check_pressed(ord("E")) && !instance_exists(obj_textevent)) {
        
        // --- LEVEL 1 BEHAVIOR ---
        if (room == rm_level_1) {
            // This calls User Event 0 which handles "Talk first, then Fight"
            event_user(0); 
        }
        
        // --- HALLWAY BEHAVIOR (Tutorial Mode) ---
        else if (room == rm_hallway && isChallenger) {
            global.last_battle_id = "greg_fight";
            global.battle_result = "none";
            global.is_jrpg = false;
            
            create_textevent(["Breado told me you were academically challenged...", "Let's see if he was right!"], [id, id]);
        }
    }
}


// --- 3. ROOM-SPECIFIC TRANSITIONS ---

// --- A. HALLWAY TRANSITION LOGIC ---
if (room == rm_hallway) {
    // Normal Combat Transition to rm_combat
    if (global.last_battle_id == "greg_fight" && global.battle_result == "none" && !instance_exists(obj_textevent)) {
        global.return_room = room;
        global.return_x = obj_jack.x;
        global.return_y = obj_jack.y;
        room_goto(rm_combat); 
    }
    
    // Post-Fight Win Logic (Triggers "Follow me!")
    if (global.battle_result == "win" && global.last_battle_id == "greg_fight" && !challenge_won) {
        if (!instance_exists(obj_textevent)) {
            event_user(0); 
        }
    }
    
    // Teleport to Level 1 after the win dialogue
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