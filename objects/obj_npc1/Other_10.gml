// --- User Event 0 for obj_npc1 (Greg) ---
if (instance_exists(obj_textevent) || isInCutscene) exit;

if (isChallenger) {
    if (global.battle_result == "win") {
        create_textevent([
            "Woah! You're actually decent at this.", 
            "Tell you what, I'm starving. Let's go grab a snack outside.", 
            "Follow me!"
        ], [id, id, id]);
        
        // This flag tells the Step Event to warp you once the text is closed
        challenge_won = true; 
    } 
    else {
        create_textevent([
            "Breado said you were 'academically challenged,' but let's see.", 
            "Ready?"
        ], [id, id]);
        global.last_battle_id = "greg_fight"; 
        global.battle_result = "none"; 
    }
} else {
    create_textevent(["Go down the hall and go to room 101"], [id]);
}