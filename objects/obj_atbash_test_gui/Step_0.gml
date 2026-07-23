if (variable_global_exists("is_paused") && global.is_paused) exit;

if (variable_global_exists("DEBUG_MODE") && global.DEBUG_MODE && keyboard_check_pressed(vk_f5)) {
    if (!variable_global_exists("atbash_boss_defeated")) global.atbash_boss_defeated = false;
    global.atbash_boss_defeated = true;
    
    if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
    audio_play_sound(snd_correct_ping, 10, false);
    instance_create_depth(0, 0, -15000, obj_atbash_complete);
    instance_destroy();
    exit;
}

if (success_timer > 0) {
    success_timer--;
    if (success_timer <= 0) {
        correct_count++;
        current_question++;
        if (current_question >= total_questions) {
            if (!variable_global_exists("atbash_boss_defeated")) global.atbash_boss_defeated = false;
            global.atbash_boss_defeated = true;
            
            if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
            instance_create_depth(0, 0, -15000, obj_atbash_complete);
            instance_destroy();
            exit;
        } else {
            player_input = array_create(string_length(words[current_question]), "");
            current_slot = 0;
            status_msg = "";
            text_color = c_white;
        }
    }
    exit;
}

if (keyboard_check_pressed(vk_escape)) {
    if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
    instance_destroy();
    exit;
}

var _len = string_length(words[current_question]);

if (keyboard_check_pressed(vk_left)) {
    current_slot = max(0, current_slot - 1);
    audio_play_sound(snd_moveselect, 10, false);
} else if (keyboard_check_pressed(vk_right)) {
    current_slot = min(_len - 1, current_slot + 1);
    audio_play_sound(snd_moveselect, 10, false);
}

if (keyboard_check_pressed(vk_up)) {
    var _char = player_input[current_slot];
    if (_char == "") _char = "A";
    else {
        var _val = ord(_char) + 1;
        if (_val > 90) _val = 65;
        _char = chr(_val);
    }
    player_input[current_slot] = _char;
    audio_play_sound(snd_select, 10, false);
} else if (keyboard_check_pressed(vk_down)) {
    var _char = player_input[current_slot];
    if (_char == "") _char = "Z";
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
        if (current_slot < _len - 1) current_slot++;
        break;
    }
}

if (keyboard_check_pressed(vk_enter)) {
    var _ans = "";
    for (var i = 0; i < _len; i++) {
        if (player_input[i] == "") {
            shake_timer = 10;
            text_color = c_red;
            status_msg = "FILL ALL SLOTS";
            audio_play_sound(wrong1, 10, false);
            exit;
        }
        _ans += player_input[i];
    }
    if (_ans == words[current_question]) {
        text_color = c_lime;
        status_msg = "CORRECT!";
        audio_play_sound(snd_player_packet_win, 10, false);
        success_timer = 60;
    } else {
        shake_timer = 10;
        text_color = c_red;
        status_msg = "TRY AGAIN";
        audio_play_sound(wrong1, 10, false);
    }
}

if (shake_timer > 0) shake_timer--;
anim_timer++;
