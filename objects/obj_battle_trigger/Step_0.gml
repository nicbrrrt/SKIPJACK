// Step Event of obj_battle_trigger
if (!instance_exists(obj_textevent)) {
    global.is_jrpg = true;
    global.last_battle_id = "greg_boss";
    room_goto(rm_battle_scramble);
    instance_destroy(); // Destroy self so it doesn't loop
}