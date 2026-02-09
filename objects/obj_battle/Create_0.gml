/// Create Event - obj_battle
// 1. IDENTITY SETUP
if (variable_global_exists("last_battle_id") && global.last_battle_id != "none") {
    battle_id = global.last_battle_id;
} else {
    battle_id = "tutorial";
}

// 2. SAFETY INITIALIZATION
if (!variable_global_exists("seen_path_tutorial")) {
    global.seen_path_tutorial = false;
    global.seen_cipher_tutorial = false;
    global.seen_qte_tutorial = false;
}

// 3. ROOM CHECK
if (room != rm_combat) { 
    instance_destroy();
    exit; 
}

// 4. BATTLE STATS
global.battle_active = true;
state = "PATH"; 
cipher_key = 0;
player_hp = 10;
enemy_hp = 10;
cipher_mode = "first";

// 5. START FIRST PHASE
if (!instance_exists(obj_path)) {
    if (global.seen_path_tutorial == false) {
        var tut = instance_create_layer(0, 0, "Instances", obj_tutorial);
        tut.text_title = "PATHFINDING PROTOCOL";
        tut.text_body = "Connect START (S) to GOAL (G).\nAvoid firewalls!";
        tut.next_object = obj_path;
        global.seen_path_tutorial = true;
    } else {
        instance_create_layer(0, 0, "Instances", obj_path);
    }
}