// --- Create Event for obj_atbash_board_gui ---
// Interactive Atbash practice board with guided hints

depth = -10000;

if (instance_exists(obj_jack)) {
    instance_deactivate_object(obj_jack);
}

// Word bank for practice (plaintext words)
word_bank = ["CAT", "KEY", "DOG", "SUN", "MAP", "RED", "FLY", "BOX"];

// Pick 2 random words
var _indices = [];
while (array_length(_indices) < 2) {
    var _r = irandom(array_length(word_bank) - 1);
    var _dup = false;
    for (var i = 0; i < array_length(_indices); i++) {
        if (_indices[i] == _r) { _dup = true; break; }
    }
    if (!_dup) array_push(_indices, _r);
}

words      = [word_bank[_indices[0]], word_bank[_indices[1]]];
encrypted  = [scr_atbash_decode(words[0]), scr_atbash_decode(words[1])];

current_word = 0;
current_slot = 0;

// Player input for current word
player_input = array_create(string_length(words[0]), "");

// Feedback state
shake_timer = 0;
status_msg  = "";
text_color  = c_white;
success_timer = 0;

// Reference rows
alpha_top    = ["A","B","C","D","E","F","G","H","I","J","K","L","M"];
alpha_bottom = ["Z","Y","X","W","V","U","T","S","R","Q","P","O","N"];

anim_timer = 0;

// Tutorial state
tutorial_active = false;
tutorial_phase = 0;
tutorial_timer = 0;
tutorial_auto_idx = 0;
tutorial_dialogue_pending = false;

if (variable_global_exists("atbash_tutorial_done") && !global.atbash_tutorial_done) {
    tutorial_active = true;
    myName = "Lea";
    myPortrait = spr_lea_portrait;
    myVoice = snd_voice1;
    myFont = fnt_dialogue;
    
    // Auto-setup first word for tutorial
    words[0] = "MAP";
    encrypted[0] = scr_atbash_decode("MAP");
}

audio_play_sound(ms_start, 10, false);
