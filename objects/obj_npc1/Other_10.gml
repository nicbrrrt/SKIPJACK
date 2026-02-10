// --- User Event 0 for obj_npc1 (Greg) ---

// GATEKEEPER: If we are in Level 1, SHUT DOWN immediately. 
// The Step Event handles all Level 1 interactions.
if (room == rm_level_1) {
    exit; 
}

if (instance_exists(obj_textevent) || isInCutscene) exit;

// --- HALLWAY LOGIC ONLY ---
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
} 
else {
    create_textevent(["Go down the hall and go to room 101"], [id]);
}