event_inherited();
depth = -y;

if (room != rm_hallway) { visible = false; exit; }

// Only appear once Kyle's lesson is done
visible = global.kyle_lesson_done;
if (!visible) exit;

// --- RETURNING FROM WIN ---
if (global.last_battle_id == "david_quiz_defeated" && global.battle_result == "win") {
    if (!active_dialogue) {
        active_dialogue = true;
        global.david_defeated      = true;
        global.quest_talk_to_breado = true;
        create_textevent([
            "Not bad, Jack! You really did your homework.",
            "Now go find Breado further down the hall.",
            "He'll run you through the main combat training."
        ], [id, id, id]);
    }
    if (active_dialogue && !instance_exists(obj_textevent)) {
        global.last_battle_id = "none";
        global.battle_result  = "none";
        active_dialogue       = false;
    }
    exit;
}

// --- RETURNING FROM LOSS ---
if (global.david_quiz_attempted && global.battle_result == "lose" && !global.david_defeated
    && !instance_exists(obj_textevent) && !active_dialogue) {
    create_textevent([
        "Hmm. You need to review.",
        "Go back and read Kyle's notes again, then come back!"
    ], [id, id]);
    global.battle_result        = "none";
    global.david_quiz_attempted = false;
    exit;
}

// --- TRANSITION TO BATTLE (pre-battle dialogue done) ---
if (active_dialogue && global.last_battle_id == "david_quiz" && !instance_exists(obj_textevent)) {
    active_dialogue = false;
    room_goto(rm_battle_scramble);
    exit;
}

// --- E KEY INTERACTION ---
if (instance_exists(obj_jack)) {
    var _player = instance_find(obj_jack, 0);
    if (point_distance(x, y, _player.x, _player.y) < 48
        && keyboard_check_pressed(ord("E"))
        && !instance_exists(obj_textevent)
        && !active_dialogue) {
        event_user(0);
    }
}
