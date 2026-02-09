// --- Step Event for obj_npc1 (Greg) ---

// 1. VISUAL FIX: Hide Greg in combat
if (room == rm_combat) { 
    visible = false; 
    exit; 
} else {
    visible = true;
}

// 2. DEPTH & ANIMATION
depth = -y;
if (sprite_index != spr_npc1_idle) { sprite_index = spr_npc1_idle; }
image_speed = 0.2;

// 3. LOGIC FOR CHALLENGER GREG
if (isChallenger) {
    
    // START FIGHT
    if (global.last_battle_id == "greg_fight" && global.battle_result == "none") {
        if (!instance_exists(obj_textevent)) {
            global.return_room = room;
            global.return_x = obj_jack.x;
            global.return_y = obj_jack.y;
            room_goto(rm_combat); 
            exit; 
        }
    }
    
    // AUTO-TALK (After returning from win)
    if (global.battle_result == "win" && global.last_battle_id == "greg_fight" && !challenge_won) {
        if (!instance_exists(obj_textevent)) {
            event_user(0); 
        }
    }
    
    // TELEPORT TRIGGER
    if (challenge_won && !instance_exists(obj_textevent)) {
        global.last_battle_id = "none";
        global.battle_result = "none";
        challenge_won = false;
        persistent = false; 
        
        if (room_exists(rm_level_1)) {
            // Set the target coordinates for obj_jack to pick up
            global.target_x = 896;
            global.target_y = 416;
            room_goto(rm_level_1);
        }
        exit;
    }
}