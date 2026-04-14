// obj_battle_scramble — Create Event
// FIXED: Removed double load_next_puzzle() call.
// FIXED: Removed redundant my_words / word_array duplicates (use word_array only).

// --- 1. SAFETY & SETUP ---
if (!instance_exists(obj_game_controller)) {
    instance_create_depth(0, 0, 0, obj_game_controller);
    gpu_set_texfilter(false);
}

if (instance_exists(obj_jack)) instance_deactivate_object(obj_jack);

audio_stop_all();
audio_play_sound(snd_battle_music, 10, true);

// --- 2. BATTLE VARIABLES ---
player_sprite = spr_jack_battle;
image_speed   = 0.15;

max_hp_player     = 100;
current_hp_player = 100;

// ENEMY SPRITES — set by the triggering NPC/object before entering this room
enemy_sprite        = global.battle_enemy_sprite;
enemy_attack_sprite = global.battle_enemy_attack_sprite;

if (global.last_battle_id == "greg_boss") {
    max_hp_enemy     = 200;
    current_hp_enemy = 200;
} else if (global.last_battle_id == "final_boss_jrpg") {
    max_hp_enemy     = 140;
    current_hp_enemy = 140;
} else {
    max_hp_enemy     = 100;
    current_hp_enemy = 100;
}

shake_magnitude   = 0;
enemy_flash_timer = 0;
player_flash_timer = 0;
player_x_offset   = 0;
enemy_x_offset    = 0;

// --- 3. PUZZLE DATA ---
battle_state  = "setup";
timer         = 0;
target_word   = "";
current_hint  = "";
player_guess  = "";

questions = [
    { word: "TROJAN",   hint: "Malware disguised as real software." },
    { word: "PHISHING", hint: "Fraudulent emails stealing data." },
    { word: "FIREWALL", hint: "Network traffic monitor." },
    { word: "BOTNET",   hint: "Network of infected computers." },
    { word: "SPYWARE",  hint: "Software that gathers info without consent." }
];

// SINGLE word_array — removed duplicate my_words variable
if (variable_global_exists("puzzle_word_list") && is_array(global.puzzle_word_list) && array_length(global.puzzle_word_list) > 0) {
    word_array = global.puzzle_word_list;
} else {
    word_array = ["VIRUS", "DATA", "HACK", "ERROR"];
}

// --- 4. FUNCTION DEFINITIONS ---
function create_buttons(_chars_array) {
    var _count      = array_length(_chars_array);
    var _angle_step = 360 / _count;
    for (var i = 0; i < _count; i++) {
        var _inst = instance_create_depth(0, 0, -15000, obj_battle_button);
        _inst.my_char             = _chars_array[i];
        _inst.orbit_angle_offset  = i * _angle_step;
        _inst.image_xscale        = 1;
        _inst.image_yscale        = 1;
    }
}

function load_next_puzzle() {
    randomize();
    if (variable_global_exists("puzzle_word_list") && is_array(global.puzzle_word_list) && array_length(global.puzzle_word_list) > 0) {
        var _idx     = irandom(array_length(global.puzzle_word_list) - 1);
        target_word  = global.puzzle_word_list[_idx];
        current_hint = (variable_global_exists("puzzle_hint_list")
                        && is_array(global.puzzle_hint_list)
                        && array_length(global.puzzle_hint_list) > _idx)
                       ? global.puzzle_hint_list[_idx]
                       : "QUEST TOPIC: Decode the keyword!";
    } else {
        var _pick    = questions[irandom(array_length(questions) - 1)];
        target_word  = _pick.word;
        current_hint = _pick.hint;
    }

    player_guess = "";
    with (obj_battle_button) instance_destroy(); // Clear old buttons

    var _chars = [];
    for (var i = 1; i <= string_length(target_word); i++) {
        array_push(_chars, string_char_at(target_word, i));
    }
    // Fisher-Yates shuffle
    for (var i = array_length(_chars) - 1; i > 0; i--) {
        var j    = irandom(i);
        var temp = _chars[i];
        _chars[i] = _chars[j];
        _chars[j] = temp;
    }
    create_buttons(_chars);
    battle_state = "player_input";
}

// --- 5. POSITIONING ---
base_y_level  = 360 * 0.65;
orbit_y_nudge = -45;

// --- 6. START: single alarm call — load_next_puzzle() runs ONCE via Alarm 0 ---
alarm[0] = 1;