// --- 1. SAFETY & SETUP ---
if (!instance_exists(obj_game_controller)) {
    instance_create_depth(0, 0, 0, obj_game_controller);
    gpu_set_texfilter(false); 
}

// Hide Jack
if (instance_exists(obj_jack)) instance_deactivate_object(obj_jack);

// Audio
audio_stop_all();
audio_play_sound(snd_battle_music, 10, true);

// --- 2. BATTLE VARIABLES ---
player_sprite = spr_jack_battle;
enemy_sprite  = spr_virus_idle;
image_speed   = 0.15;

max_hp_player = 100; current_hp_player = 100;
max_hp_enemy = 100;  current_hp_enemy = 100;

shake_magnitude = 0;
enemy_flash_timer = 0;
player_flash_timer = 0;
player_x_offset = 0;
enemy_x_offset = 0;

// --- 3. PUZZLE DATA ---
battle_state = "setup";
timer = 0;
target_word = "";
current_hint = "";
player_guess = "";

questions = [
    { word: "TROJAN",   hint: "Malware disguised as real software." },
    { word: "PHISHING", hint: "Fraudulent emails stealing data." },
    { word: "FIREWALL", hint: "Network traffic monitor." },
    { word: "BOTNET",   hint: "Network of infected computers." },
    { word: "SPYWARE",  hint: "Software that gathers info without consent." }
];

// --- 4. FUNCTION DEFINITIONS (Moved here to prevent Duplicate Error) ---

// Function to Create Buttons (With Orbit Logic)
function create_buttons(_chars_array) {
    var _count = array_length(_chars_array);
    var _angle_step = 360 / _count; 

    for(var i=0; i<_count; i++) {
        var _inst = instance_create_depth(0, 0, -15000, obj_battle_button);
        _inst.my_char = _chars_array[i];
        
        // Custom variables for orbit
        _inst.orbit_angle_offset = i * _angle_step; 
        _inst.image_xscale = 1; 
        _inst.image_yscale = 1;
    }
}

// Function to Load Next Puzzle
function load_next_puzzle() {
    randomize();
    var _pick = questions[irandom(array_length(questions)-1)];
    target_word = _pick.word;
    current_hint = _pick.hint;
    player_guess = "";
    
    var _chars = [];
    for(var i=1; i<=string_length(target_word); i++) array_push(_chars, string_char_at(target_word, i));
    
    // Shuffle
    for (var i = array_length(_chars) - 1; i > 0; i--) {
        var j = irandom(i);
        var temp = _chars[i];
        _chars[i] = _chars[j];
        _chars[j] = temp;
    }
    
    create_buttons(_chars);
    battle_state = "player_input";
}

// --- 5. START DELAY ---
// Trigger the start in 1 frame
alarm[0] = 1;

// --- POSITION SETTINGS ---
// 0.65 = 65% down the screen (The Ground Level)
base_y_level = 360 * 0.65; 

// MANUAL NUDGE: Change this to move the Orbit Circle UP or DOWN
// Positive = Move Circle Down
// Negative = Move Circle Up
orbit_y_nudge = -45;