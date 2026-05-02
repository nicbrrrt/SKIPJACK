/// Create Event - obj_battle
// 1. IDENTITY SETUP
if (variable_global_exists("last_battle_id") && global.last_battle_id != "none") {
    battle_id = global.last_battle_id;
} else {
    battle_id = "tutorial";
}

// ENEMY SPRITE — set by the triggering NPC/object before entering this room
enemy_sprite = global.battle_enemy_sprite;

// 2. SAFETY INITIALIZATION
if (!variable_global_exists("seen_path_tutorial")) {
    global.seen_path_tutorial = false;
    global.seen_cipher_tutorial = false;
    global.seen_qte_tutorial = false;
}

// Tutorial overlays only play during Breado's lesson — skip them for every
// fight after tutorial_complete is set (e.g. Greg's hallway test).
if (variable_global_exists("tutorial_complete") && global.tutorial_complete) {
    global.seen_path_tutorial   = true;
    global.seen_cipher_tutorial = true;
    global.seen_qte_tutorial    = true;
}

// 3. ROOM CHECK
if (room != rm_combat) {
    instance_destroy();
    exit;
}

// Set background for Bread's fight — create a fresh layer (no black tint) in room space
if (battle_id == "tutorial") {
    var _layer = layer_create(1, "battle_bg");
    var _spr_w = sprite_get_width(spr_com_lab_battle_background);
    var _spr_h = sprite_get_height(spr_com_lab_battle_background);
    layer_sprite_create(_layer, (room_width - _spr_w) / 2, (room_height - _spr_h) / 2, spr_com_lab_battle_background);
}

// Set background for Greg's hallway fight
if (battle_id == "greg_fight") {
    var _layer = layer_create(1, "battle_bg");
    var _spr_w = sprite_get_width(spr_battle_hallway_background);
    var _spr_h = sprite_get_height(spr_battle_hallway_background);
    layer_sprite_create(_layer, (room_width - _spr_w) / 2, (room_height - _spr_h) / 2, spr_battle_hallway_background);
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