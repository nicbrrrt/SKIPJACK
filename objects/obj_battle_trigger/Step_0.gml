// Step Event of obj_battle_trigger
if (!instance_exists(obj_textevent)) {
    global.is_jrpg = true;
    global.last_battle_id             = "greg_boss";
    global.battle_enemy_sprite        = spr_npc1_idle; // Greg
    global.battle_enemy_attack_sprite = spr_npc1_idle; // No dedicated attack sprite
    room_goto(rm_battle_scramble);
    instance_destroy(); // Destroy self so it doesn't loop
}