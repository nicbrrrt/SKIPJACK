// --- Step Event for obj_atbash_combat_gui ---

if (variable_global_exists("is_paused") && global.is_paused) exit;

if (success_timer > 0) {
    success_timer--;
    if (success_timer <= 0) {
        if (result_pending == "enemy_hit") {
            enemy_hp -= 5;
            if (enemy_hp <= 0) {
                global.atbash_progress = max(global.atbash_progress, 3);
                if (instance_exists(obj_codex_manager)) {
                    with(obj_codex_manager) {
                        var _mods = tab_modules[2];
                        var _found = false;
                        for (var i = 0; i < array_length(_mods); i++) {
                            if (_mods[i].title == "ATBASH COMBAT") {
                                _found = true;
                                break;
                            }
                        }
                        if (!_found) {
                            array_push(tab_modules[2], { title: "ATBASH COMBAT", content: "You defeated an Atbash-encrypted enemy!\nYou can now decode Atbash in real-time under pressure." });
                        }
                    }
                }
                if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
                instance_destroy();
                exit;
            } else {
                generate_round();
                if (phase == "shield") phase = "attack";
                else phase = "shield";
            }
        } else if (result_pending == "player_hit") {
            if (player_hp <= 0) {
                if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
                instance_destroy();
                exit;
            } else {
                generate_round();
            }
        }
        result_pending = "";
    }
    exit;
}

if (fight_anim != "idle") {
    if (fight_anim == "player_attack") {
        fight_timer++;
        if (fight_timer <= 14) {
            player_lunge = lerp(player_lunge, 40, 0.3);
        }
        if (fight_timer == 14) {
            enemy_lunge = -30;
            enemy_flash_timer = 12;
        }
        if (fight_timer > 50) {
            fight_anim = "idle";
            fight_timer = 0;
        }
    } else if (fight_anim == "enemy_attack") {
        fight_timer++;
        if (fight_timer <= 16) {
            enemy_lunge = lerp(enemy_lunge, -40, 0.3);
        }
        if (fight_timer == 16) {
            player_hurt_timer = 24;
        }
        if (fight_timer > 48) {
            fight_anim = "idle";
            fight_timer = 0;
        }
    }
    exit;
}

// Idle animation: lerp lunges back to 0
player_lunge = lerp(player_lunge, 0, 0.2);
enemy_lunge = lerp(enemy_lunge, 0, 0.2);

if (enemy_flash_timer > 0) enemy_flash_timer--;
if (player_hurt_timer > 0) player_hurt_timer--;

// Input
var _left = keyboard_check_pressed(vk_left);
var _right = keyboard_check_pressed(vk_right);
var _up = keyboard_check_pressed(vk_up);
var _down = keyboard_check_pressed(vk_down);
var _enter = keyboard_check_pressed(vk_enter);

if (_left) {
    current_slot--;
    if (current_slot < 0) current_slot = letters_len - 1;
    audio_play_sound(snd_moveselect, 10, false);
}
if (_right) {
    current_slot++;
    if (current_slot >= letters_len) current_slot = 0;
    audio_play_sound(snd_moveselect, 10, false);
}

if (_up) {
    var _char = player_input[current_slot];
    if (_char == "" || _char == "?") _char = "A";
    else {
        var _val = ord(_char) + 1;
        if (_val > 90) _val = 65;
        _char = chr(_val);
    }
    player_input[current_slot] = _char;
    audio_play_sound(snd_select, 10, false);
}
if (_down) {
    var _char = player_input[current_slot];
    if (_char == "" || _char == "?") _char = "Z";
    else {
        var _val = ord(_char) - 1;
        if (_val < 65) _val = 90;
        _char = chr(_val);
    }
    player_input[current_slot] = _char;
    audio_play_sound(snd_select, 10, false);
}

// Direct typing
for (var i = 65; i <= 90; i++) {
    if (keyboard_check_pressed(i)) {
        player_input[current_slot] = chr(i);
        audio_play_sound(snd_select, 10, false);
        current_slot++;
        if (current_slot >= letters_len) current_slot = 0;
        break;
    }
}

if (_enter) {
    var _ans = "";
    for (var i = 0; i < letters_len; i++) {
        _ans += player_input[i];
    }
    if (_ans == plaintext) {
        if (success_timer == 0) {
            text_color = c_lime;
            status_msg = "DECRYPTED!";
            audio_play_sound(snd_player_packet_win, 10, false);
            success_timer = 50;
            result_pending = "enemy_hit";
            fight_anim = "player_attack";
            fight_timer = 0;
        }
    } else {
        shake_timer = 10;
        text_color = c_red;
        status_msg = "DECRYPTION FAILED";
        audio_play_sound(wrong1, 10, false);
        player_hp -= 2;
        fight_anim = "enemy_attack";
        fight_timer = 0;
        if (player_hp <= 0) {
            success_timer = 50;
            result_pending = "player_hit";
        }
    }
}

if (shake_timer > 0) shake_timer--;
anim_timer++;
