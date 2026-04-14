// obj_final_boss_placeholder — User Event 0 (Interact)
if (instance_exists(obj_textevent)) exit;

// Already defeated — brief terminal response
if (global.final_boss_defeated) {
    create_textevent(["...TERMINATED."], [id]);
    exit;
}

// PHASE 1: Overworld combat (taunt first, then fight)
if (!preparing_to_fight) {
    create_textevent([
        "I am the Anomaly. Your training ends here, Jack.",
        "Ciphers and encryption won't save you.",
        "Face me."
    ], [id, id, id]);
    preparing_to_fight = true;
} else {
    global.last_battle_id      = "final_boss_phase1";
    global.is_jrpg             = false;
    global.return_room         = rm_level_1;
    global.battle_enemy_sprite = spr_boss_idle; // The Anomaly (final boss)
    room_goto(rm_combat);
}
