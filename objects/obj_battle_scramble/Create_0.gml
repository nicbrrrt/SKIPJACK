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

// --- 4. START DELAY ---
// We trigger the start in 1 frame to let the Camera setup finish first.
alarm[0] = 1;

// --- 5. FUNCTION: CREATE BUTTONS (Fixed Coordinates) ---
function create_buttons(_chars_array) {
   // Get the Camera Size (Since we forced it in Room Start)
    var _cam_x = camera_get_view_x(view_camera[0]);
    var _cam_y = camera_get_view_y(view_camera[0]);
    var _cam_w = camera_get_view_width(view_camera[0]);
    var _cam_h = camera_get_view_height(view_camera[0]);
    
    var _spacing = 80; 
    var _total_width = array_length(_chars_array) * _spacing;
    
    // Center Buttons in the Camera View
    var _start_x = _cam_x + (_cam_w / 2) - (_total_width / 2);
    var _y_pos = _cam_y + _cam_h - 100; // 100 pixels from bottom

    for(var i=0; i<array_length(_chars_array); i++) {
        // Create at depth -15000 so they are ON TOP of the black UI box
        var _inst = instance_create_depth(_start_x + (i*_spacing), _y_pos, -15000, obj_battle_button);
        _inst.my_char = _chars_array[i];
        
        // Ensure they have a size
        _inst.image_xscale = 1; 
        _inst.image_yscale = 1;
    }
}

// --- 6. FUNCTION: LOAD NEXT ---
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

load_next_puzzle();