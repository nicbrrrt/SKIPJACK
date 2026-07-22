// --- Create Event for obj_atbash_board_gui ---
// Interactive Atbash practice board with guided hints

depth = -15000;

if (instance_exists(obj_jack)) {
    obj_jack.isInCutscene = true;
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

audio_play_sound(ms_start, 10, false);
