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

if (!instance_exists(obj_game_controller)) {
    instance_create_depth(0, 0, 0, obj_game_controller);
}

// 3.5. BATTLE MUSIC — boss track for ANOMALY, random for everyone else
audio_stop_all();
if (battle_id == "final_boss_phase1") {
    audio_play_sound(snd_packet_battle_boss_music, 10, true);
} else {
    var _packet_tracks = [snd_packet_battle_normal_music,
                          snd_packet_battle_normal_music_2,
                          snd_packet_battle_normal_music_3];
    audio_play_sound(_packet_tracks[irandom(2)], 10, true);
}

// --- PACKET BATTLE BACKGROUNDS ---
// rm_combat has views disabled: the room (2752x1536) is scaled to fit the window.
// Place sprite at (0,0) and scale to fill the full room so it always covers the screen.
var _bg_spr = -1;
if (battle_id == "tutorial")         _bg_spr = spr_com_lab_battle_background;
if (battle_id == "greg_fight")       _bg_spr = spr_battle_hallway_background;
if (battle_id == "final_boss_phase1") _bg_spr = spr_city_street_battle_background;

if (_bg_spr != -1) {
    var _layer = layer_create(1, "battle_bg"); // depth 1: behind instances (0), in front of black Background (200)
    var _spr_w = sprite_get_width(_bg_spr);
    var _spr_h = sprite_get_height(_bg_spr);
    var _elem  = layer_sprite_create(_layer, 0, 0, _bg_spr);
    layer_sprite_xscale(_elem, room_width  / _spr_w);
    layer_sprite_yscale(_elem, room_height / _spr_h);
}

// 4. BATTLE STATS
global.battle_active = true;
state = "PATH"; 
cipher_key = scr_roll_cipher_key();
player_hp = 10;
enemy_hp = 10;
cipher_mode = "first";

// Packet-battle draw / animation state
fight_anim         = "idle";
fight_timer        = 0;
fight_pending      = "";
player_draw_spr    = spr_jack_idle;
player_draw_sub    = scr_dir_idle_start(spr_jack_idle, "right");
enemy_draw_sub     = scr_dir_idle_start(enemy_sprite, "left");
player_idle_acc    = 0;
enemy_idle_acc     = 0;
player_lunge       = 0;
enemy_lunge        = 0;
enemy_flash_timer  = 0;
player_hurt_timer  = 0;
enemy_attack_spr   = (variable_global_exists("battle_enemy_attack_sprite")
                      && sprite_exists(global.battle_enemy_attack_sprite))
                     ? global.battle_enemy_attack_sprite : spr_normalvirus_attack;

// 5. START FIRST PHASE
if (!instance_exists(obj_path)) {
    if (global.seen_path_tutorial == false) {
        var tut = instance_create_layer(0, 0, "Instances", obj_tutorial);
        tut.text_title     = "PATHFINDING PROTOCOL";
        tut.text_body      = "Connect START (S) to GOAL (G).\nAvoid firewalls!";
        tut.next_object    = obj_path;
        tut.tutorial_image      = spr_tutorial_img_1;
        tut.tutorial_image_body = "Use ARROW KEYS to move around the maze.\nPress ENTER when you've reached the goal.";
        global.seen_path_tutorial = true;
    } else {
        instance_create_layer(0, 0, "Instances", obj_path);
    }
}