// --- User Event 0 for obj_npc1 (Greg) ---

// 1. SAFETY CHECKS
if (instance_exists(obj_textevent)) exit;
if (variable_instance_exists(id, "isInCutscene") && isInCutscene) exit;

// 2. HALLWAY LOGIC (Intro/Tutorial)
if (room == rm_hallway) {
    if (global.battle_result == "win") {
        create_textevent(["Woah! You're actually decent...", "Follow me!"], [id, id]);
        challenge_won = true;  
    }   
    else {
        global.last_battle_id = "greg_fight";  
        global.battle_result = "none";
        create_textevent(["Breado said you were 'academically challenged'...", "Ready?"], [id, id]);
    }
    exit; // Exit here so hallway logic doesn't trigger Level 1 logic below
}

// 3. LEVEL 1 / STREETS LOGIC
if (room == rm_level_1) {
    
    // STATE A: Before the first boss fight
    if (!global.greg_defeated) {
        if (!variable_instance_exists(id, "preparing_to_fight")) preparing_to_fight = false;

        if (!preparing_to_fight) {
            // First interaction: Just talk
            create_textevent(["Ready to test your skills, Jack? Let's see what you've got."], [id]);
            preparing_to_fight = true; 
        } else {
            // Second interaction: FIGHT
            global.last_battle_id = "greg_boss";
            global.is_jrpg = true;
            room_goto(rm_battle_scramble);
            preparing_to_fight = false; // Reset for later
        }
    } 
    
    // STATE B: Quest is active (Talked to Greg after fight)
    else if (global.greg_quest_started && (!global.quest_clipper_done || !global.quest_lea_done)) {
        create_textevent(["Find Clipper and Lea. They're waiting for you out there."], [id]);
    } 
    
    // STATE C: Both quests finished
    else if (global.quest_clipper_done && global.quest_lea_done) {
        create_textevent(["You've learned well. The anomaly is manifesting nearby. Be careful."], [id]);
    }
    
    // STATE D: Default fallback
    else {
        create_textevent(["Stay sharp, Jack. This sector is dangerous."], [id]);
    }
}