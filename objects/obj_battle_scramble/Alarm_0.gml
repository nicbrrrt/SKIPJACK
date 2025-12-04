// --- FUNCTIONS ---

// Function to Create Buttons
function create_buttons(_chars_array) {
    // HARDCODED PLACEMENT for 640x360 Resolution
    // This ensures they are ALWAYS on screen.
    var _start_x = 320 - ((array_length(_chars_array) * 80) / 2);
    var _y_pos = 280; // Fixed Y position near bottom

    for(var i=0; i<array_length(_chars_array); i++) {
        var _inst = instance_create_depth(_start_x + (i*80), _y_pos, -15000, obj_battle_button);
        _inst.my_char = _chars_array[i];
        _inst.image_xscale = 1; 
        _inst.image_yscale = 1;
    }
}

// Function to Load Puzzle
function load_next_puzzle() {
    randomize();
    var _pick = questions[irandom(array_length(questions)-1)];
    target_word = _pick.word;
    current_hint = _pick.hint;
    player_guess = "";
    
    var _chars = [];
    for(var i=1; i<=string_length(target_word); i++) array_push(_chars, string_char_at(target_word, i));
    
    for (var i = array_length(_chars) - 1; i > 0; i--) {
        var j = irandom(i);
        var temp = _chars[i];
        _chars[i] = _chars[j];
        _chars[j] = temp;
    }
    
    create_buttons(_chars);
    battle_state = "player_input";
}

// --- START ---
load_next_puzzle();