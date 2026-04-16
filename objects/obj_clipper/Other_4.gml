// --- Room Start Event for obj_clipper ---

// If the player just lost to Clipper, auto-show the retry taunt
if (room == rm_level_1 && global.battle_result == "lose" && global.jrpg_opponent == "clipper_review") {
    global.battle_result = "none";
    global.jrpg_opponent = "none";
    create_textevent(["Pathetic. Your encryption logic is full of holes. Try again."], [id]);
}
