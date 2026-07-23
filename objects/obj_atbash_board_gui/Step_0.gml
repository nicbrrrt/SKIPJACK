if (variable_global_exists("is_paused") && global.is_paused) exit;

if (variable_global_exists("DEBUG_MODE") && global.DEBUG_MODE && keyboard_check_pressed(vk_f5)) {
    global.atbash_progress = max(global.atbash_progress, 2);
    if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
    audio_play_sound(snd_correct_ping, 10, false);
    if (!instance_exists(obj_jack)) instance_activate_object(obj_jack); instance_destroy();
    exit;
}

if (tutorial_active) {
    if (keyboard_check_pressed(vk_tab) || keyboard_check_pressed(ord("X"))) {
        if (instance_exists(obj_textevent)) with (obj_textevent) instance_destroy();
        tutorial_active = false;
        global.atbash_tutorial_done = true;
        current_word = 1;
        player_input = array_create(string_length(words[1]), "");
        current_slot = 0;
        status_msg = "";
        text_color = c_white;
        exit;
    }
    
    if (instance_exists(obj_textevent)) exit;
    
    if (tutorial_dialogue_pending) {
        tutorial_dialogue_pending = false;
        tutorial_timer = 0;
        
        if (tutorial_phase == 0) {
            tutorial_phase = 1;
            tutorial_auto_idx = 0;
            current_slot = 0;
        } else if (tutorial_phase == 2) {
            tutorial_active = false;
            global.atbash_tutorial_done = true;
            current_word = 1;
            player_input = array_create(string_length(words[1]), "");
            current_slot = 0;
            status_msg = "";
            text_color = c_white;
            exit;
        }
    }
    
    if (tutorial_phase == 0) {
        tutorial_dialogue_pending = true;
        create_textevent(
            ["Atbash is a simple substitution cipher.",
             "It mirrors the alphabet. A becomes Z, B becomes Y, and so on.",
             "Let's decode the word 'MAP' together."],
            id
        );
        exit;
    }
    
    if (tutorial_phase == 1) {
        tutorial_timer++;
        if (tutorial_timer mod 30 == 0 && tutorial_auto_idx < string_length(words[0])) {
            var _target_char = string_char_at(words[0], tutorial_auto_idx + 1);
            player_input[tutorial_auto_idx] = _target_char;
            audio_play_sound(snd_select, 10, false);
            tutorial_auto_idx++;
            if (tutorial_auto_idx < string_length(words[0])) {
                current_slot = tutorial_auto_idx;
            } else {
                text_color = c_lime;
                status_msg = "CORRECT!";
                audio_play_sound(snd_player_packet_win, 10, false);
                tutorial_phase = 2;
                tutorial_dialogue_pending = true;
                create_textevent(
                    ["Perfect! The same rule applies to both encoding and decoding.",
                     "Now try the next one yourself."],
                    id
                );
            }
        }
        exit;
    }
    exit;
}

if (success_timer > 0) {
    success_timer--;
    if (success_timer <= 0) {
        if (current_word == 0) {
            current_word = 1;
            player_input = array_create(string_length(words[1]), "");
            current_slot = 0;
            status_msg = "";
            text_color = c_white;
        } else {
            global.atbash_progress = max(global.atbash_progress, 2);
            if (instance_exists(obj_codex_manager)) {
                with (obj_codex_manager) {
                    var _mods = tab_modules[2];
                    var _found = false;
                    for (var i = 0; i < array_length(_mods); i++) {
                        if (_mods[i].title == "ATBASH PRACTICE") {
                            _found = true;
                            break;
                        }
                    }
                    if (!_found) {
                        array_push(tab_modules[2], {
                            title: "ATBASH PRACTICE",
                            content: "You practiced decoding words with the Atbash mirror.\nRemember: A=Z, B=Y, C=X ... M=N.\nThe same operation encodes AND decodes."
                        });
                    }
                }
            }
            if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
            if (!instance_exists(obj_jack)) instance_activate_object(obj_jack); instance_destroy();
        }
    }
    exit;
}

if (keyboard_check_pressed(vk_escape)) {
    if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
    if (!instance_exists(obj_jack)) instance_activate_object(obj_jack); instance_destroy();
    exit;
}

var len = string_length(words[current_word]);

if (keyboard_check_pressed(vk_left)) {
    current_slot = max(0, current_slot - 1);
    audio_play_sound(snd_moveselect, 10, false);
} else if (keyboard_check_pressed(vk_right)) {
    current_slot = min(len - 1, current_slot + 1);
    audio_play_sound(snd_moveselect, 10, false);
}

if (keyboard_check_pressed(vk_up)) {
    var cur_char = player_input[current_slot];
    if (cur_char == "") cur_char = "A";
    else {
        var ascii = ord(cur_char);
        ascii++;
        if (ascii > 90) ascii = 65;
        cur_char = chr(ascii);
    }
    player_input[current_slot] = cur_char;
    audio_play_sound(snd_select, 10, false);
} else if (keyboard_check_pressed(vk_down)) {
    var cur_char = player_input[current_slot];
    if (cur_char == "") cur_char = "Z";
    else {
        var ascii = ord(cur_char);
        ascii--;
        if (ascii < 65) ascii = 90;
        cur_char = chr(ascii);
    }
    player_input[current_slot] = cur_char;
    audio_play_sound(snd_select, 10, false);
}

for (var i = 65; i <= 90; i++) {
    if (keyboard_check_pressed(i)) {
        player_input[current_slot] = chr(i);
        audio_play_sound(snd_select, 10, false);
        if (current_slot < len - 1) current_slot++;
        break;
    }
}

if (keyboard_check_pressed(vk_enter)) {
    var answer = "";
    for (var i = 0; i < len; i++) {
        if (player_input[i] == "") {
            shake_timer = 10;
            text_color = c_red;
            status_msg = "FILL ALL SLOTS";
            audio_play_sound(wrong1, 10, false);
            exit;
        }
        answer += player_input[i];
    }
    
    if (answer == words[current_word]) {
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
