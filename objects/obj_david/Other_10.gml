// User Event 0 — David's interaction handler
if (instance_exists(obj_textevent) || active_dialogue) exit;

// STATE: Already beaten — post-challenge chat
if (global.david_defeated) {
    create_textevent([
        "You beat my quiz fair and square, Jack.",
        "Now get moving!"
    ], [id, id]);
    exit;
}

// STATE: First interaction — intro dialogue, no battle yet
if (!showed_intro) {
    create_textevent([
        "I'm David. Kyle tells me you've been studying.",
        "I'll quiz you on the Caesar Cipher in a battle.",
        "Think carefully about those shifts!"
    ], [id, id, id]);
    showed_intro = true;
    exit;
}

// STATE: Second interaction — tutorial first, then real quiz battle
if (!variable_global_exists("scramble_tutorial_done") || !global.scramble_tutorial_done) {
    global.last_battle_id             = "scramble_tutorial";
    global.jrpg_opponent              = "scramble_tutorial";
    global.is_jrpg                    = true;
    global.battle_enemy_sprite        = spr_david_idle;
    global.battle_enemy_attack_sprite = spr_david_idle;
    global.return_room                = room;
    global.return_x                   = instance_exists(obj_jack) ? obj_jack.x : x;
    global.return_y                   = instance_exists(obj_jack) ? obj_jack.y : y;
    create_textevent([
        "Before the real quiz, let me show you how quiz combat works.",
        "Watch closely — then you'll try it yourself!"
    ], [id, id]);
    active_dialogue = true;
    exit;
}

global.puzzle_word_list = ["CAESAR", "SHIFT", "ROTATE", "ALPHABET", "OFFSET", "CIPHER",
                           "PLAINTEXT", "SUBSTITUTION", "CIPHERTEXT"];
global.puzzle_hint_list = [
    "Roman-era encryption method.",
    "Moving each letter by a fixed number.",
    "Letters wrap around after Z.",
    "26 characters, A through Z.",
    "Another name for the shift value.",
    "A system used to encode messages.",
    "Normal, readable text before it is encrypted.",
    "A type of cipher.",
    "Encrypted, unreadable text produced by applying a cryptographic algorithm."
];
global.last_battle_id             = "david_quiz";
global.jrpg_opponent              = "david_quiz";
global.is_jrpg                    = true;
global.battle_enemy_sprite        = spr_david_idle;
global.battle_enemy_attack_sprite = spr_david_idle;
global.return_room                = room;
global.return_x                   = instance_exists(obj_jack) ? obj_jack.x : x;
global.return_y                   = instance_exists(obj_jack) ? obj_jack.y : y;
global.david_quiz_attempted       = true;

create_textevent(["Ready to test your knowledge? Let's go!"], [id]);
active_dialogue = true;
