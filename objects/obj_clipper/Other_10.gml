if (instance_exists(obj_textevent)) exit;

// NEW: Post-Battle Dialogue
if (global.last_battle_id == "clipper_review_defeated") {
    create_textevent(["You got lucky, kid. Your encryption logic was... adequate.", "The sector's stabilizing. Good work."], [id, id]);
    
	global.last_battle_id = "none";
	
	exit;
}

if (!global.cryptography_learned) {
    // Phase 1: Lesson
    create_textevent(["I've updated your tablet.", "Go fuck off and study (Press C)."], [id, id]);
    
    // This now works because the manager is persistent!
    if (instance_exists(obj_codex_manager)) {
        obj_codex_manager.add_module("CRYPTOGRAPHY", "SYMMETRIC: One key.\nASYMMETRIC: Public/Private keys.");
    }
    global.cryptography_learned = true;
    global.quest_clipper_done = true;
} else {
    // Phase 2: Battle
    global.puzzle_word_list = ["SYMMETRIC", "ENCRYPT", "DECRYPT", "PRIVATE"];
    global.last_battle_id = "clipper_review";
    global.is_jrpg = true;
    room_goto(rm_battle_scramble);
}