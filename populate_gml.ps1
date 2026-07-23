$basePath = "C:\Users\sewel\GameMakerProjects\SKIPJACK"

function Write-Gml($path, $content) {
    Set-Content -Path (Join-Path $basePath $path) -Value $content -Encoding UTF8
}

$encode = @"
function scr_vigenere_encode(text, key) {
    var res = "";
    key = string_upper(key);
    var key_len = string_length(key);
    var key_idx = 0;
    for (var i = 1; i <= string_length(text); i++) {
        var c = string_char_at(text, i);
        if (c == " ") {
            res += " ";
            continue;
        }
        var char_idx = ord(c) - ord("A");
        var shift = ord(string_char_at(key, (key_idx mod key_len) + 1)) - ord("A");
        var s = (char_idx + shift) mod 26;
        res += chr(s + ord("A"));
        key_idx++;
    }
    return res;
}
"@
Write-Gml "scripts\scr_vigenere_encode\scr_vigenere_encode.gml" $encode

$decode = @"
function scr_vigenere_decode(text, key) {
    var res = "";
    key = string_upper(key);
    var key_len = string_length(key);
    var key_idx = 0;
    for (var i = 1; i <= string_length(text); i++) {
        var c = string_char_at(text, i);
        if (c == " ") {
            res += " ";
            continue;
        }
        var char_idx = ord(c) - ord("A");
        var shift = ord(string_char_at(key, (key_idx mod key_len) + 1)) - ord("A");
        var s = (char_idx - shift) mod 26;
        if (s < 0) s += 26;
        res += chr(s + ord("A"));
        key_idx++;
    }
    return res;
}
"@
Write-Gml "scripts\scr_vigenere_decode\scr_vigenere_decode.gml" $decode

$theory_c = @"
depth = -15000;
if (instance_exists(obj_jack)) obj_jack.isInCutscene = true;
"@
Write-Gml "objects\obj_vigenere_theory_gui\Create_0.gml" $theory_c

$theory_s = @"
if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_escape)) {
    global.vigenere_progress = max(global.vigenere_progress, 1);
    
    if (instance_exists(obj_codex_manager)) {
        with (obj_codex_manager) {
            var _mods = tab_modules[2];
            var _found = false;
            for (var i = 0; i < array_length(_mods); i++) {
                if (_mods[i].title == "VIGENERE THEORY") {
                    _found = true;
                    break;
                }
            }
            if (!_found) {
                array_push(tab_modules[2], {
                    title: "VIGENERE THEORY",
                    content: "The Vigenère cipher uses a repeating keyword to shift each letter of a message differently, making it harder to crack than simple Caesar shifts."
                });
            }
        }
    }
    
    if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
    instance_destroy();
}
"@
Write-Gml "objects\obj_vigenere_theory_gui\Step_0.gml" $theory_s

$theory_d = @"
var _pw = 680;
var _ph = 320;
var _px = (640 - _pw) / 2;
var _py = (360 - _ph) / 2;

draw_set_alpha(0.92);
draw_set_color(make_color_rgb(10, 10, 20));
draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
draw_set_alpha(1.0);

draw_set_color(c_fuchsia);
draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);

draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_color(c_fuchsia);
draw_text(_px + _pw / 2, _py + 10, "[ THE VIGENERE CIPHER ]");

draw_set_color(make_color_rgb(80, 80, 80));
draw_line(_px + 12, _py + 27, _px + _pw - 12, _py + 27);

var _lx = _px + 18;
var _ly = _py + 35;
var _ls = 17;

draw_set_halign(fa_left);
draw_set_color(c_white);
draw_text(_lx, _ly,           "Invented in the 16th century, this cipher was once considered 'le chiffre indéchiffrable'");
draw_text(_lx, _ly + _ls,     "(the indecipherable cipher) due to its strength against frequency analysis.");

draw_set_color(c_fuchsia);
draw_text(_lx, _ly + _ls * 2.6, "HOW IT WORKS:");
draw_set_color(c_white);
draw_text(_lx, _ly + _ls * 3.6, "Instead of a single shift, Vigenère uses a KEYWORD. Each letter of the keyword");
draw_text(_lx, _ly + _ls * 4.6, "provides a different shift amount (A=0, B=1, C=2...) for each letter of the message.");
draw_text(_lx, _ly + _ls * 5.6, "The keyword repeats over the plaintext until the message is fully encrypted.");

draw_set_color(c_fuchsia);
draw_text(_lx, _ly + _ls * 7.1, "EXAMPLE (Keyword: KEY):");
draw_set_color(c_white);
draw_text(_lx, _ly + _ls * 8.1, "Plain:   C  O  D  E");
draw_text(_lx, _ly + _ls * 9.1, "Key:     K  E  Y  K   (K shifts by 10, E by 4, Y by 24)");
draw_text(_lx, _ly + _ls * 10.1, "Cipher:  M  S  B  O");

draw_set_color(c_fuchsia);
draw_text(_lx, _ly + _ls * 11.6, "DECRYPTION:");
draw_set_color(c_white);
draw_text(_lx, _ly + _ls * 12.6, "Line up the keyword again, and shift backward by the keyword's letter value.");

var _bob = sin(get_timer() / 300000) * 2;
draw_set_color(c_lime);
draw_set_halign(fa_center);
draw_text(_px + _pw / 2, _py + _ph - 16 + _bob, "[ E ] or [ ESC ] to close");

draw_set_halign(fa_left);
draw_set_color(c_white);
draw_set_alpha(1.0);
"@
Write-Gml "objects\obj_vigenere_theory_gui\Draw_64.gml" $theory_d

$board_c = @"
depth = -15000;
if (instance_exists(obj_jack)) obj_jack.isInCutscene = true;

keyword_bank = ["KEY", "BAT", "SUN", "DOG", "MAP", "CODE"];
word_bank = ["CAT", "DOG", "FLY", "RED", "BOX", "HAT", "RUN", "JUMP"];

var _kw_idx = irandom(array_length(keyword_bank) - 1);
keyword = keyword_bank[_kw_idx];

var _indices = [];
while (array_length(_indices) < 2) {
    var _r = irandom(array_length(word_bank) - 1);
    var _dup = false;
    for (var i = 0; i < array_length(_indices); i++) {
        if (_indices[i] == _r) { _dup = true; break; }
    }
    if (!_dup) array_push(_indices, _r);
}

words = [word_bank[_indices[0]], word_bank[_indices[1]]];
encrypted = [scr_vigenere_encode(words[0], keyword), scr_vigenere_encode(words[1], keyword)];

current_word = 0;
current_slot = 0;
player_input = array_create(string_length(words[0]), "");
shake_timer = 0;
status_msg  = "";
text_color  = c_white;
success_timer = 0;
anim_timer = 0;
audio_play_sound(ms_start, 10, false);
"@
Write-Gml "objects\obj_vigenere_board_gui\Create_0.gml" $board_c

$board_s = @"
if (variable_global_exists("is_paused") && global.is_paused) exit;

if (variable_global_exists("DEBUG_MODE") && global.DEBUG_MODE && keyboard_check_pressed(vk_f5)) {
    global.vigenere_progress = max(global.vigenere_progress, 2);
    if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
    audio_play_sound(snd_correct_ping, 10, false);
    instance_destroy();
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
            global.vigenere_progress = max(global.vigenere_progress, 2);
            if (instance_exists(obj_codex_manager)) {
                with (obj_codex_manager) {
                    var _mods = tab_modules[2];
                    var _found = false;
                    for (var i = 0; i < array_length(_mods); i++) {
                        if (_mods[i].title == "VIGENERE PRACTICE") { _found = true; break; }
                    }
                    if (!_found) {
                        array_push(tab_modules[2], {
                            title: "VIGENERE PRACTICE",
                            content: "You practiced decoding with Vigenère.\nLine up the keyword with the cipher and shift backwards!"
                        });
                    }
                }
            }
            if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
            instance_destroy();
        }
    }
    exit;
}

if (keyboard_check_pressed(vk_escape)) {
    if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
    instance_destroy();
    exit;
}

var len = string_length(words[current_word]);
if (keyboard_check_pressed(vk_left)) { current_slot = max(0, current_slot - 1); audio_play_sound(snd_moveselect, 10, false); }
else if (keyboard_check_pressed(vk_right)) { current_slot = min(len - 1, current_slot + 1); audio_play_sound(snd_moveselect, 10, false); }

if (keyboard_check_pressed(vk_up)) {
    var cur_char = player_input[current_slot];
    if (cur_char == "") cur_char = "A";
    else { var ascii = ord(cur_char); ascii++; if (ascii > 90) ascii = 65; cur_char = chr(ascii); }
    player_input[current_slot] = cur_char; audio_play_sound(snd_select, 10, false);
} else if (keyboard_check_pressed(vk_down)) {
    var cur_char = player_input[current_slot];
    if (cur_char == "") cur_char = "Z";
    else { var ascii = ord(cur_char); ascii--; if (ascii < 65) ascii = 90; cur_char = chr(ascii); }
    player_input[current_slot] = cur_char; audio_play_sound(snd_select, 10, false);
}

for (var i = 65; i <= 90; i++) {
    if (keyboard_check_pressed(i)) {
        player_input[current_slot] = chr(i); audio_play_sound(snd_select, 10, false);
        if (current_slot < len - 1) current_slot++; break;
    }
}

if (keyboard_check_pressed(vk_enter)) {
    var answer = "";
    for (var i = 0; i < len; i++) {
        if (player_input[i] == "") {
            shake_timer = 10; text_color = c_red; status_msg = "FILL ALL SLOTS"; audio_play_sound(wrong1, 10, false); exit;
        }
        answer += player_input[i];
    }
    if (answer == words[current_word]) {
        text_color = c_lime; status_msg = "CORRECT!"; audio_play_sound(snd_player_packet_win, 10, false); success_timer = 60;
    } else {
        shake_timer = 10; text_color = c_red; status_msg = "TRY AGAIN"; audio_play_sound(wrong1, 10, false);
    }
}
if (shake_timer > 0) shake_timer--;
"@
Write-Gml "objects\obj_vigenere_board_gui\Step_0.gml" $board_s

$board_d = @"
anim_timer++;
var _pw = 500; var _ph = 360;
var _px = (640 - _pw) / 2; var _py = (360 - _ph) / 2;
var _sx = _px + random_range(-shake_timer, shake_timer);
var _sy = _py + random_range(-shake_timer, shake_timer);

draw_set_alpha(0.92); draw_set_color(make_color_rgb(10, 10, 20)); draw_rectangle(_sx, _sy, _sx + _pw, _sy + _ph, false); draw_set_alpha(1.0);
draw_set_color(c_fuchsia); draw_rectangle(_sx, _sy, _sx + _pw, _sy + _ph, true);

draw_set_font(fnt_dialogue); draw_set_halign(fa_center); draw_set_color(c_fuchsia);
draw_text(_sx + _pw / 2, _sy + 10, "VIGENERE DECRYPTION (" + string(current_word + 1) + "/2)");
draw_set_color(c_white); draw_text(_sx + _pw / 2, _sy + 35, "KEYWORD: " + keyword);

var _word_len = string_length(words[current_word]);
var _box_w = 40; var _box_space = 46;
var _total_w = (_word_len * _box_space) - (_box_space - _box_w);
var _start_x = _sx + (_pw - _total_w) / 2;

draw_set_color(c_silver); draw_text(_sx + _pw / 2, _sy + 70, "CIPHERTEXT");
var _cy = _sy + 90;
for (var i = 0; i < _word_len; i++) {
    var _bx = _start_x + (i * _box_space);
    var _char = string_char_at(encrypted[current_word], i + 1);
    
    draw_set_color(c_dkgray); draw_rectangle(_bx, _cy, _bx + _box_w, _cy + _box_w, false);
    draw_set_color(c_red); draw_rectangle(_bx, _cy, _bx + _box_w, _cy + _box_w, true);
    
    draw_set_color(c_white); draw_text(_bx + _box_w / 2, _cy + 8, _char);
    
    var _k_char = string_char_at(keyword, ((i) mod string_length(keyword)) + 1);
    draw_set_color(c_fuchsia); draw_text(_bx + _box_w / 2, _cy - 16, _k_char);
}

var _py_input = _cy + 60;
draw_set_color(c_silver); draw_text(_sx + _pw / 2, _py_input - 20, "DECODED WORD");

for (var i = 0; i < _word_len; i++) {
    var _bx = _start_x + (i * _box_space);
    
    if (i == current_slot) {
        draw_set_color(make_color_rgb(30, 30, 60)); draw_rectangle(_bx, _py_input, _bx + _box_w, _py_input + _box_w, false);
        draw_set_color(c_lime); draw_rectangle(_bx, _py_input, _bx + _box_w, _py_input + _box_w, true);
        var _shift = (anim_timer mod 30 < 15) ? 2 : 0;
        draw_sprite_ext(spr_objective_arrow, 0, _bx + _box_w / 2, _py_input - 6 + _shift, 1, 1, 270, c_white, 1.0);
    } else {
        draw_set_color(c_dkgray); draw_rectangle(_bx, _py_input, _bx + _box_w, _py_input + _box_w, false);
        draw_set_color(c_white); draw_rectangle(_bx, _py_input, _bx + _box_w, _py_input + _box_w, true);
    }
    
    if (player_input[i] != "") { draw_set_color(c_lime); draw_text(_bx + _box_w / 2, _py_input + 8, player_input[i]); }
}

if (status_msg != "") { draw_set_color(text_color); draw_text(_sx + _pw / 2, _sy + _ph - 110, status_msg); }

draw_set_color(c_silver); draw_text(_sx + _pw / 2, _sy + _ph - 70, "Use [ARROWS] to select & shift letters, or [A-Z] to type.");
draw_set_color(c_fuchsia); draw_text(_sx + _pw / 2, _sy + _ph - 50, "Press [ENTER] to submit. [ESC] to quit.");
draw_set_halign(fa_left); draw_set_color(c_white);
"@
Write-Gml "objects\obj_vigenere_board_gui\Draw_64.gml" $board_d

$test_c = @"
depth = -15000;
if (instance_exists(obj_jack)) obj_jack.isInCutscene = true;

keyword_bank = ["HACK", "CODE", "SYSTEM", "SECURE"];
word_bank = ["CIPHER", "DECODE", "BINARY", "SHIELD", "BREACH", "KERNEL"];

var _kw_idx = irandom(array_length(keyword_bank) - 1);
keyword = keyword_bank[_kw_idx];

var _indices = [];
while (array_length(_indices) < 3) {
    var _r = irandom(array_length(word_bank) - 1);
    var _dup = false;
    for (var i = 0; i < array_length(_indices); i++) {
        if (_indices[i] == _r) { _dup = true; break; }
    }
    if (!_dup) array_push(_indices, _r);
}

words = [word_bank[_indices[0]], word_bank[_indices[1]], word_bank[_indices[2]]];
encrypted = [scr_vigenere_encode(words[0], keyword), scr_vigenere_encode(words[1], keyword), scr_vigenere_encode(words[2], keyword)];

current_word = 0;
current_slot = 0;
player_input = array_create(string_length(words[0]), "");
shake_timer = 0;
status_msg  = "";
text_color  = c_white;
success_timer = 0;
anim_timer = 0;
audio_play_sound(ms_start, 10, false);
"@
Write-Gml "objects\obj_vigenere_test_gui\Create_0.gml" $test_c

$test_s = @"
if (variable_global_exists("is_paused") && global.is_paused) exit;

if (variable_global_exists("DEBUG_MODE") && global.DEBUG_MODE && keyboard_check_pressed(vk_f5)) {
    global.vigenere_progress = max(global.vigenere_progress, 3);
    if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
    audio_play_sound(snd_correct_ping, 10, false);
    instance_destroy();
    exit;
}

if (success_timer > 0) {
    success_timer--;
    if (success_timer <= 0) {
        if (current_word < 2) {
            current_word++;
            player_input = array_create(string_length(words[current_word]), "");
            current_slot = 0;
            status_msg = "";
            text_color = c_white;
        } else {
            global.vigenere_progress = max(global.vigenere_progress, 3);
            if (instance_exists(obj_codex_manager)) {
                with (obj_codex_manager) {
                    var _mods = tab_modules[2];
                    var _found = false;
                    for (var i = 0; i < array_length(_mods); i++) {
                        if (_mods[i].title == "VIGENERE EXPERT") { _found = true; break; }
                    }
                    if (!_found) {
                        array_push(tab_modules[2], {
                            title: "VIGENERE EXPERT",
                            content: "Module complete! You mastered the Vigenère cipher."
                        });
                    }
                }
            }
            if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
            instance_destroy();
        }
    }
    exit;
}

if (keyboard_check_pressed(vk_escape)) {
    if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
    instance_destroy();
    exit;
}

var len = string_length(words[current_word]);
if (keyboard_check_pressed(vk_left)) { current_slot = max(0, current_slot - 1); audio_play_sound(snd_moveselect, 10, false); }
else if (keyboard_check_pressed(vk_right)) { current_slot = min(len - 1, current_slot + 1); audio_play_sound(snd_moveselect, 10, false); }

if (keyboard_check_pressed(vk_up)) {
    var cur_char = player_input[current_slot];
    if (cur_char == "") cur_char = "A";
    else { var ascii = ord(cur_char); ascii++; if (ascii > 90) ascii = 65; cur_char = chr(ascii); }
    player_input[current_slot] = cur_char; audio_play_sound(snd_select, 10, false);
} else if (keyboard_check_pressed(vk_down)) {
    var cur_char = player_input[current_slot];
    if (cur_char == "") cur_char = "Z";
    else { var ascii = ord(cur_char); ascii--; if (ascii < 65) ascii = 90; cur_char = chr(ascii); }
    player_input[current_slot] = cur_char; audio_play_sound(snd_select, 10, false);
}

for (var i = 65; i <= 90; i++) {
    if (keyboard_check_pressed(i)) {
        player_input[current_slot] = chr(i); audio_play_sound(snd_select, 10, false);
        if (current_slot < len - 1) current_slot++; break;
    }
}

if (keyboard_check_pressed(vk_enter)) {
    var answer = "";
    for (var i = 0; i < len; i++) {
        if (player_input[i] == "") {
            shake_timer = 10; text_color = c_red; status_msg = "FILL ALL SLOTS"; audio_play_sound(wrong1, 10, false); exit;
        }
        answer += player_input[i];
    }
    if (answer == words[current_word]) {
        text_color = c_lime; status_msg = "CORRECT!"; audio_play_sound(snd_player_packet_win, 10, false); success_timer = 60;
    } else {
        shake_timer = 10; text_color = c_red; status_msg = "TRY AGAIN"; audio_play_sound(wrong1, 10, false);
    }
}
if (shake_timer > 0) shake_timer--;
"@
Write-Gml "objects\obj_vigenere_test_gui\Step_0.gml" $test_s

$test_d = @"
anim_timer++;
var _pw = 500; var _ph = 360;
var _px = (640 - _pw) / 2; var _py = (360 - _ph) / 2;
var _sx = _px + random_range(-shake_timer, shake_timer);
var _sy = _py + random_range(-shake_timer, shake_timer);

draw_set_alpha(0.92); draw_set_color(make_color_rgb(20, 5, 5)); draw_rectangle(_sx, _sy, _sx + _pw, _sy + _ph, false); draw_set_alpha(1.0);
draw_set_color(c_red); draw_rectangle(_sx, _sy, _sx + _pw, _sy + _ph, true);

draw_set_font(fnt_dialogue); draw_set_halign(fa_center); draw_set_color(c_red);
draw_text(_sx + _pw / 2, _sy + 10, "FINAL EVALUATION (" + string(current_word + 1) + "/3)");
draw_set_color(c_white); draw_text(_sx + _pw / 2, _sy + 35, "KEYWORD: " + keyword);

var _word_len = string_length(words[current_word]);
var _box_w = 40; var _box_space = 46;
var _total_w = (_word_len * _box_space) - (_box_space - _box_w);
var _start_x = _sx + (_pw - _total_w) / 2;

draw_set_color(c_silver); draw_text(_sx + _pw / 2, _sy + 70, "CIPHERTEXT");
var _cy = _sy + 90;
for (var i = 0; i < _word_len; i++) {
    var _bx = _start_x + (i * _box_space);
    var _char = string_char_at(encrypted[current_word], i + 1);
    
    draw_set_color(c_dkgray); draw_rectangle(_bx, _cy, _bx + _box_w, _cy + _box_w, false);
    draw_set_color(c_fuchsia); draw_rectangle(_bx, _cy, _bx + _box_w, _cy + _box_w, true);
    draw_set_color(c_white); draw_text(_bx + _box_w / 2, _cy + 8, _char);
}

var _py_input = _cy + 60;
draw_set_color(c_silver); draw_text(_sx + _pw / 2, _py_input - 20, "DECODED WORD");

for (var i = 0; i < _word_len; i++) {
    var _bx = _start_x + (i * _box_space);
    if (i == current_slot) {
        draw_set_color(make_color_rgb(30, 30, 60)); draw_rectangle(_bx, _py_input, _bx + _box_w, _py_input + _box_w, false);
        draw_set_color(c_lime); draw_rectangle(_bx, _py_input, _bx + _box_w, _py_input + _box_w, true);
        var _shift = (anim_timer mod 30 < 15) ? 2 : 0;
        draw_sprite_ext(spr_objective_arrow, 0, _bx + _box_w / 2, _py_input - 6 + _shift, 1, 1, 270, c_white, 1.0);
    } else {
        draw_set_color(c_dkgray); draw_rectangle(_bx, _py_input, _bx + _box_w, _py_input + _box_w, false);
        draw_set_color(c_white); draw_rectangle(_bx, _py_input, _bx + _box_w, _py_input + _box_w, true);
    }
    
    if (player_input[i] != "") { draw_set_color(c_lime); draw_text(_bx + _box_w / 2, _py_input + 8, player_input[i]); }
}

if (status_msg != "") { draw_set_color(text_color); draw_text(_sx + _pw / 2, _sy + _ph - 110, status_msg); }

draw_set_color(c_silver); draw_text(_sx + _pw / 2, _sy + _ph - 70, "Use [ARROWS] to select & shift letters, or [A-Z] to type.");
draw_set_color(c_red); draw_text(_sx + _pw / 2, _sy + _ph - 50, "Press [ENTER] to submit. [ESC] to quit.");
draw_set_halign(fa_left); draw_set_color(c_white);
"@
Write-Gml "objects\obj_vigenere_test_gui\Draw_64.gml" $test_d

$npc_t_c = @"
scr_init_npc_vars("Vigenere", spr_lea_idle, snd_voice2, fnt_dialogue);
interaction_range = 48;
idle_facing = "down";
idle_anim_acc = 0;
isInCutscene = false;
image_speed = 0;
depth = -y;
if (!variable_global_exists("vigenere_progress")) global.vigenere_progress = 0;
"@
Write-Gml "objects\obj_npc_vigenere_theory\Create_0.gml" $npc_t_c

$npc_t_s = @"
event_inherited();
if (variable_global_exists("is_paused") && global.is_paused) exit;
if (!instance_exists(obj_jack)) exit;
if (instance_exists(obj_textevent)) exit;

if (point_distance(x, y, obj_jack.x, obj_jack.y) < interaction_range) {
    if (keyboard_check_pressed(ord("E"))) {
        if (global.vigenere_progress >= 1) {
            create_textevent(["You know the theory! Go try the practice board."], [id]);
        } else {
            var _te = create_textevent(
                [
                    "Welcome! Let's talk about the Vigenère Cipher.",
                    "Unlike Caesar which shifts everything by one number, Vigenère uses a KEYWORD.",
                    "Each letter of the keyword determines how much to shift the plaintext.",
                    "Let me show you a quick guide..."
                ],
                [id, id, id, id]
            );
            _te.destroy_action = method(undefined, function() {
                instance_create_layer(0, 0, "Instances", obj_vigenere_theory_gui);
            });
        }
    }
}
"@
Write-Gml "objects\obj_npc_vigenere_theory\Step_0.gml" $npc_t_s

$npc_m_c = @"
scr_init_npc_vars("Coach", spr_clipper_idle, snd_voice2, fnt_dialogue);
interaction_range = 48;
idle_facing = "down";
idle_anim_acc = 0;
isInCutscene = false;
image_speed = 0;
depth = -y;
if (!variable_global_exists("vigenere_progress")) global.vigenere_progress = 0;
"@
Write-Gml "objects\obj_npc_vigenere_minigame\Create_0.gml" $npc_m_c

$npc_m_s = @"
event_inherited();
if (variable_global_exists("is_paused") && global.is_paused) exit;
if (!instance_exists(obj_jack)) exit;
if (instance_exists(obj_textevent)) exit;

if (point_distance(x, y, obj_jack.x, obj_jack.y) < interaction_range) {
    if (keyboard_check_pressed(ord("E"))) {
        if (global.vigenere_progress < 1) {
            create_textevent(["You need to learn the theory from the first instructor."], [id]);
        } else if (global.vigenere_progress >= 2) {
            create_textevent(["You've already passed practice! Go take the final test."], [id]);
        } else {
            var _te = create_textevent(["Ready to practice? I'll give you a keyword. Shift the letters backwards to decode!"], [id]);
            _te.destroy_action = method(undefined, function() {
                instance_create_layer(0, 0, "Instances", obj_vigenere_board_gui);
            });
        }
    }
}
"@
Write-Gml "objects\obj_npc_vigenere_minigame\Step_0.gml" $npc_m_s

$npc_f_c = @"
scr_init_npc_vars("Examiner", spr_lea_idle, snd_voice2, fnt_dialogue);
interaction_range = 48;
idle_facing = "down";
idle_anim_acc = 0;
isInCutscene = false;
image_speed = 0;
depth = -y;
if (!variable_global_exists("vigenere_progress")) global.vigenere_progress = 0;
"@
Write-Gml "objects\obj_npc_vigenere_test\Create_0.gml" $npc_f_c

$npc_f_s = @"
event_inherited();
if (variable_global_exists("is_paused") && global.is_paused) exit;
if (!instance_exists(obj_jack)) exit;
if (instance_exists(obj_textevent)) exit;

if (point_distance(x, y, obj_jack.x, obj_jack.y) < interaction_range) {
    if (keyboard_check_pressed(ord("E"))) {
        if (global.vigenere_progress < 2) {
            create_textevent(["You aren't ready for the final evaluation yet. Go practice."], [id]);
        } else if (global.vigenere_progress >= 3) {
            create_textevent(["You have mastered the Vigenère cipher. Excellent work!"], [id]);
        } else {
            var _te = create_textevent(["This is the final test. Three words to decode. Let's see what you can do."], [id]);
            _te.destroy_action = method(undefined, function() {
                instance_create_layer(0, 0, "Instances", obj_vigenere_test_gui);
            });
        }
    }
}
"@
Write-Gml "objects\obj_npc_vigenere_test\Step_0.gml" $npc_f_s

Write-Output "Code successfully written!"
