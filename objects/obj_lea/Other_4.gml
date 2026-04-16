// --- Room Start Event for obj_lea ---

// If the player just lost to Lea, auto-show the retry taunt
if (room == rm_level_1 && global.battle_result == "lose" && global.jrpg_opponent == "lea_review") {
    global.battle_result = "none";
    global.jrpg_opponent = "none";
    create_textevent(["You couldn't handle a simple shift cipher? Disappointing. Come back when you're ready."], [id]);
}
