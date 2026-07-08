// obj_battle_scramble — Create Event
// FIXED: Removed double load_next_puzzle() call.
// FIXED: Removed redundant my_words / word_array duplicates (use word_array only).

// --- 1. SAFETY & SETUP ---
if (!instance_exists(obj_game_controller)) {
    instance_create_depth(0, 0, 0, obj_game_controller);
}

if (instance_exists(obj_jack)) instance_deactivate_object(obj_jack);

audio_stop_all();
if (global.last_battle_id == "final_boss_jrpg") {
    audio_play_sound(snd_quiz_battle_boss_music, 10, true);
} else {
    audio_play_sound(snd_battle_music, 10, true);
}

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
quiz_lose_snd     = -1; // tracks the snd_enemy_lose_quiz instance for fading

// Directional idle + battle layout
enemy_x_pct       = 0.25;
enemy_draw_xscale = 3.5;
enemy_draw_yscale = 3.5;
enemy_idle_facing = "right";   // enemy on left faces right toward player
enemy_idle_acc    = 0;
player_idle_facing = "left";
player_idle_acc    = 0;
player_draw_xscale = -3.5;
player_draw_yscale =  3.5;
player_idle_subimg = 0;

if (global.last_battle_id == "david_quiz") {
    enemy_x_pct       = 0.30;
    enemy_idle_facing = "right";
    enemy_idle_acc    = 0;
    image_index       = scr_dir_idle_start(enemy_sprite, enemy_idle_facing);
}

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
last_puzzle_idx = -1; // tracks the index used last; excluded from next random pick

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
        var _list_len = array_length(global.puzzle_word_list);
        var _idx;
        if (_list_len > 1) {
            // Pick any index except the one just used
            do { _idx = irandom(_list_len - 1); }
            until (_idx != last_puzzle_idx);
        } else {
            _idx = 0;
        }
        last_puzzle_idx = _idx;
        target_word  = global.puzzle_word_list[_idx];
        current_hint = (variable_global_exists("puzzle_hint_list")
                        && is_array(global.puzzle_hint_list)
                        && array_length(global.puzzle_hint_list) > _idx)
                       ? global.puzzle_hint_list[_idx]
                       : "QUEST TOPIC: Decode the keyword!";
    } else {
        var _q_len = array_length(questions);
        var _idx;
        if (_q_len > 1) {
            do { _idx = irandom(_q_len - 1); }
            until (_idx != last_puzzle_idx);
        } else {
            _idx = 0;
        }
        last_puzzle_idx = _idx;
        var _pick    = questions[_idx];
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
    hint_slots = array_create(string_length(target_word), false);
    orbit_countdown = orbit_countdown_max;
    battle_state = "player_input";
}

function reveal_random_hint_letter() {
    var _len = string_length(target_word);
    if (_len <= 0) return;
    var _pool = [];
    for (var i = 0; i < _len; i++) {
        if (i >= string_length(player_guess) && !hint_slots[i])
            array_push(_pool, i);
    }
    if (array_length(_pool) > 0) {
        var _pick = _pool[irandom(array_length(_pool) - 1)];
        hint_slots[_pick] = true;
    }
}

function apply_block_damage() {
    if (scramble_tutorial && tutorial_phase == 5) {
        player_sprite = spr_jack_hurt;
        player_flash_timer = 10;
        shake_magnitude = 3;
        reveal_random_hint_letter();
        tutorial_msg = "Too slow! Press [E] on the block to parry — try again!";
        battle_state = "player_input";
        orbit_countdown = orbit_countdown_max;
        alarm[1] = 75;
        return;
    }
    audio_play_sound(snd_hurt, 10, false);
    player_sprite = spr_jack_hurt;
    player_flash_timer = 10;
    shake_magnitude = 5;
    current_hp_player -= 10;
    reveal_random_hint_letter();
    var _txt = instance_create_depth(display_get_gui_width() * 0.75, display_get_gui_height() * 0.6 - 50, -16000, obj_damage_text);
    _txt.damage_amount = "-10";
    _txt.color = c_red;
    if (current_hp_player <= 0) battle_state = "lose";
}

function launch_block_attack(_forced_char = "", _tutorial_parry = false) {
    if (instance_exists(obj_battle_block)) return;
    var _w = 640;
    var _chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var _ch = (_forced_char != "")
        ? string_upper(_forced_char)
        : string_char_at(_chars, irandom(string_length(_chars) - 1) + 1);
    var _blk = instance_create_depth(0, 0, -15500, obj_battle_block);
    _blk.block_char = _ch;
    _blk.tutorial_parry = _tutorial_parry;
    var _es = scr_battle_sprite_feet_y(enemy_sprite, enemy_draw_yscale, base_y_level);
    var _ex = (_w * enemy_x_pct) + enemy_x_offset;
    var _ec = scr_battle_sprite_chest_xy(enemy_sprite, enemy_draw_yscale, _ex, _es);
    _blk.gui_x = _ec[0];
    _blk.gui_y = _ec[1];
    _blk.target_gui_x = (_w * 0.75) + player_x_offset;
    _blk.target_gui_y = scr_battle_sprite_feet_y(spr_jack_battle, player_draw_yscale, base_y_level);
    block_slowmo_timer = block_slowmo_max;
    battle_state = "block_attack";
}

function tutorial_skip_showcase() {
    if (instance_exists(obj_textevent)) with (obj_textevent) instance_destroy();
    if (instance_exists(obj_textbox)) with (obj_textbox) instance_destroy();
    with (obj_battle_button) instance_destroy();
    with (obj_battle_block) instance_destroy();
    tutorial_dialogue_pending = false;
    block_slowmo_timer = 0;
    alarm[1] = -1;
    player_guess = "";

    if (tutorial_phase >= 7) {
        current_hp_enemy = 0;
        battle_state = "win";
        timer = 0;
        return;
    }

    tutorial_phase = 7;
    tutorial_timer = 0;
    tutorial_sub = "";
    tutorial_msg = "Showcase skipped — spell TRAIN to finish!";
    setup_tutorial_puzzle("TRAIN", "Practice word — spell TRAIN!");
    current_hp_enemy = 35;
    current_hp_player = max_hp_player;
    orbit_countdown = orbit_countdown_max;
    battle_state = "player_input";
}

function tutorial_start_dialogue(_lines) {
    if (!is_array(_lines)) _lines = [_lines];
    var _speakers = array_create(array_length(_lines), id);
    create_textevent(_lines, _speakers);
    tutorial_dialogue_pending = true;
    battle_state = "tutorial";
    tutorial_sub = "wait_dialogue";
}

function tutorial_dialogue_finished() {
    tutorial_timer = 0;
    switch (tutorial_phase) {
        case 0:
            tutorial_phase = 1;
            setup_tutorial_puzzle("ALPHABET", "26 characters, A through Z.");
            tutorial_msg = "Watch — hint: A through Z. Answer: ALPHABET";
            tutorial_sub = "auto_type";
            tutorial_auto_idx = 0;
            battle_state = "tutorial";
            break;
        case 2:
            tutorial_phase = 3;
            setup_tutorial_puzzle("SHIFT", "Moving each letter by a fixed number.");
            tutorial_msg = "Another example — spell SHIFT to damage the enemy!";
            tutorial_sub = "auto_type";
            tutorial_auto_idx = 0;
            battle_state = "tutorial";
            break;
        case 4:
            tutorial_phase = 5;
            setup_tutorial_puzzle("ALPHABET", "26 characters, A through Z.");
            tutorial_msg = "HURRY! The ring counts down — then a block attacks!";
            tutorial_sub = "wait_block";
            orbit_countdown = room_speed * 4;
            battle_state = "player_input";
            break;
        case 6:
            tutorial_phase = 7;
            tutorial_msg = "Now try it yourself — spell TRAIN!";
            setup_tutorial_puzzle("TRAIN", "Practice word — spell TRAIN!");
            current_hp_enemy = 35;
            orbit_countdown = orbit_countdown_max;
            battle_state = "player_input";
            tutorial_sub = "";
            break;
    }
}

function setup_tutorial_puzzle(_word, _hint) {
    target_word = _word;
    current_hint = _hint;
    player_guess = "";
    with (obj_battle_button) instance_destroy();
    var _chars = [];
    for (var i = 1; i <= string_length(_word); i++)
        array_push(_chars, string_char_at(_word, i));
    for (var i = array_length(_chars) - 1; i > 0; i--) {
        var j = irandom(i);
        var temp = _chars[i];
        _chars[i] = _chars[j];
        _chars[j] = temp;
    }
    create_buttons(_chars);
    hint_slots = array_create(string_length(target_word), false);
    orbit_countdown = orbit_countdown_max;
}

// --- 5. POSITIONING ---
base_y_level  = 360 * 0.65;
orbit_y_nudge = -45;

// Dialogue speaker for in-battle tutorial (David — create_dialogue needs myPortrait etc.)
myName     = "David";
myPortrait = spr_david_portrait;
myVoice    = snd_voice2;
myFont     = fnt_dialogue;

// --- 5b. TOOLTIP FLAGS (active for all word-scramble fights) ---
show_tooltips = true;
tooltip_index = 0;

// --- 5c. ORBIT COUNTDOWN + HINT SLOTS ---
orbit_countdown_max = room_speed * 10;
orbit_countdown     = orbit_countdown_max;
hint_slots          = [];

// Block attack slow-motion window (~2 seconds)
block_slowmo_max   = room_speed * 1;
block_slowmo_timer = 0;

// --- 5d. SCRAMBLE TUTORIAL SIMULATION ---
scramble_tutorial = (global.last_battle_id == "scramble_tutorial");
tutorial_phase    = 0;
tutorial_timer    = 0;
tutorial_auto_idx = 0;
tutorial_sub      = "";
tutorial_msg      = "";
tutorial_dialogue_pending = false;
tutorial_auto_interval = 35;

if (scramble_tutorial) {
    show_tooltips = false;
    battle_state  = "tutorial";
    max_hp_player = 100;
    current_hp_player = 100;
    max_hp_enemy = 50;
    current_hp_enemy = 50;
    enemy_sprite = spr_npc1_idle;
    enemy_attack_sprite = spr_npc1_idle;
    tutorial_start_dialogue([
        "Welcome to Quiz Combat training!",
        "Always read the CODEX or look for hints — they help you answer quickly.",
        "I'll walk you through combat step by step. Press E to continue."
    ]);
    alarm[0] = -1;
} else {
    // --- 6. START: single alarm call — load_next_puzzle() runs ONCE via Alarm 0 ---
    alarm[0] = 1;
}