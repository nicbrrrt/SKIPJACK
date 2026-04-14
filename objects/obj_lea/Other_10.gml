if (instance_exists(obj_textevent)) exit;

// STATE 3: POST-BATTLE
if (global.lea_defeated) {
    create_textevent(["Hmph. Lucky guess on that shift value.", "Don't let it go to your head, Jack. Keep studying."], [id, id]);
} 
// STATE 1: THE LESSON
else if (!global.caesar_learned) {
    create_textevent([
        "I'm Lea. The Caesar Cipher is all about the 'Shift.'",
        "Check your Codex for the rotation rules.",
        "Go study. Don't make me repeat myself."
    ], [id, id, id]);

    if (instance_exists(obj_codex_manager)) {
        obj_codex_manager.add_module("CAESAR CIPHER", "SHIFT: Moving letters by a number (e.g. A+3 = D).\nROTATION: If you go past Z, you wrap back to A.\nOFFSET: Another word for the shift value.");
    }
    global.caesar_learned = true;
    global.quest_lea_done = true;
} 
// STATE 2: THE CHALLENGE
else {
    create_textevent(["Let's see if you can solve a shift under pressure!"], [id]);
    global.puzzle_word_list           = ["CAESAR", "SHIFT", "ROTATE", "ALPHABET"];
    global.puzzle_hint_list = [
        "Roman-era encryption method.",
        "Moving letters by a fixed number.",
        "Letters wrap around the alphabet.",
        "26 characters, A through Z."
    ];
    global.last_battle_id             = "lea_review";
    global.is_jrpg                    = true;
    global.battle_enemy_sprite        = spr_lea_idle; // Lea
    global.battle_enemy_attack_sprite = spr_lea_idle; // No dedicated attack sprite
    room_goto(rm_battle_scramble);
}