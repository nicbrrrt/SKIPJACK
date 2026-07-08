if (variable_global_exists("is_paused") && global.is_paused) exit;

if (variable_global_exists("DEBUG_MODE") && global.DEBUG_MODE && keyboard_check_pressed(vk_f3)) {
    show_debug_message("[DEBUG] F3 pressed — skipping overworld combat (battle_id: " + string(battle_id) + ")");
    global.battle_result = "win";
    global.battle_active = false;
    if (battle_id == "final_boss_phase1") {
        global.last_battle_id = "final_boss_phase1_defeated";
        room_goto(rm_level_1);
    } else if (room_exists(rm_hallway)) {
        room_goto(rm_hallway);
    } else {
        room_goto(global.return_room);
    }
    exit;
}

// DEBUG: F4 forces overworld combat loss
if (variable_global_exists("DEBUG_MODE") && global.DEBUG_MODE && keyboard_check_pressed(vk_f4)) {
    show_debug_message("[DEBUG] F4 pressed — forcing overworld combat loss (battle_id: " + string(battle_id) + ")");
    global.battle_result = "lose";
    global.battle_active = false;
    room_goto(global.return_room);
    exit;
}

// DEBUG: F5 instant victory (overworld cipher combat — any NPC)
if (variable_global_exists("DEBUG_MODE") && global.DEBUG_MODE && keyboard_check_pressed(vk_f5)) {
    show_debug_message("[DEBUG] F5 pressed — instant win (battle_id: " + string(battle_id) + ")");
    global.battle_result = "win";
    global.battle_active = false;
    if (battle_id == "final_boss_phase1") {
        global.last_battle_id = "final_boss_phase1_defeated";
        room_goto(rm_level_1);
    } else if (room_exists(rm_hallway)) {
        room_goto(rm_hallway);
    } else {
        room_goto(global.return_room);
    }
    exit;
}

// WATCHER: Moves from Puzzle to Attack
if (cipher_mode == "first" && state == "CIPHER1") {
    if (!instance_exists(obj_cipher) && !instance_exists(obj_tutorial) && fight_anim == "idle") {
        state = "ATTACK"; 
        alarm[0] = game_get_speed(gamespeed_fps) * 1; 
    }
}

// --- PACKET-BATTLE FIGHT ANIMATIONS ---
if (enemy_flash_timer > 0) enemy_flash_timer--;
if (player_hurt_timer > 0)  player_hurt_timer--;

if (fight_anim == "idle") {
    player_lunge = lerp(player_lunge, 0, 0.2);
    enemy_lunge  = lerp(enemy_lunge, 0, 0.2);
    if (player_hurt_timer <= 0) {
        var _pr = scr_dir_idle_anim(player_draw_spr, "right", player_idle_acc, 0.12);
        player_draw_sub = _pr[0];
        player_idle_acc = _pr[1];
    }
    var _er = scr_dir_idle_anim(enemy_sprite, "left", enemy_idle_acc, 0.12);
    enemy_draw_sub = _er[0];
    enemy_idle_acc = _er[1];
}
else if (fight_anim == "player_attack") {
    fight_timer++;
    enemy_lunge = lerp(enemy_lunge, 0, 0.2);
    if (fight_timer < 14) {
        player_lunge = lerp(player_lunge, 36, 0.22);
        player_draw_spr = spr_jack_idle;
        var _pr = scr_dir_idle_anim(player_draw_spr, "right", player_idle_acc, 0.12);
        player_draw_sub = _pr[0];
        player_idle_acc = _pr[1];
    } else if (fight_timer == 14) {
        player_draw_spr = spr_jack_hit;
        player_draw_sub = 0;
        enemy_lunge = -28;
        enemy_flash_timer = 12;
        audio_play_sound(snd_attack_impact, 10, false);
        audio_play_sound(snd_hurt, 10, false);
    } else if (fight_timer < 14 + sprite_get_number(spr_jack_hit)) {
        player_draw_spr = spr_jack_hit;
        player_draw_sub = min(fight_timer - 14, sprite_get_number(spr_jack_hit) - 1);
        enemy_lunge = lerp(enemy_lunge, 0, 0.18);
    } else if (fight_timer < 52) {
        player_draw_spr = spr_jack_idle;
        player_lunge = lerp(player_lunge, 0, 0.15);
        var _pr2 = scr_dir_idle_anim(player_draw_spr, "right", player_idle_acc, 0.12);
        player_draw_sub = _pr2[0];
        player_idle_acc = _pr2[1];
    } else {
        fight_anim = "idle";
        fight_timer = 0;
        var _done = fight_pending;
        fight_pending = "";
        if (_done == "cipher_ok_packet") {
            event_user(1);
        }
    }
}
else if (fight_anim == "enemy_attack") {
    fight_timer++;
    player_lunge = lerp(player_lunge, 0, 0.2);
    if (fight_timer < 16) {
        enemy_lunge = lerp(enemy_lunge, -40, 0.22);
        var _er2 = scr_dir_idle_anim(enemy_sprite, "left", enemy_idle_acc, 0.18);
        enemy_draw_sub = _er2[0];
        enemy_idle_acc = _er2[1];
    } else if (fight_timer == 16) {
        player_draw_spr = spr_jack_hurt;
        player_draw_sub = 0;
        player_hurt_timer = 24;
        player_hp -= 1;
        audio_play_sound(snd_hurt, 10, false);
    } else if (fight_timer < 16 + max(3, sprite_get_number(enemy_attack_spr))) {
        enemy_lunge = lerp(enemy_lunge, 0, 0.15);
        if (enemy_attack_spr != enemy_sprite && sprite_exists(enemy_attack_spr)) {
            enemy_draw_sub = min(fight_timer - 16, sprite_get_number(enemy_attack_spr) - 1);
        } else {
            var _er3 = scr_dir_idle_anim(enemy_sprite, "left", enemy_idle_acc, 0.35);
            enemy_draw_sub = _er3[0];
            enemy_idle_acc = _er3[1];
        }
    } else if (fight_timer < 48) {
        enemy_lunge = lerp(enemy_lunge, 0, 0.12);
        player_draw_spr = spr_jack_idle;
    } else {
        fight_anim = "idle";
        fight_timer = 0;
        player_draw_spr = spr_jack_idle;
        player_hurt_timer = 0;
    }
}