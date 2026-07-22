// --- Create Event for obj_atbash_test_gui ---
// Final unassisted Atbash evaluation — 3 words, no hints

depth = -15000;

if (instance_exists(obj_jack)) {
    obj_jack.isInCutscene = true;
}

// Harder word bank (6-letter cybersecurity words)
word_bank = ["CIPHER", "DECODE", "BINARY", "SHIELD", "BREACH", "SCRIPT", "SYSTEM", "KERNEL"];

// Pick 3 random words
total_questions = 3;
words     = [];
encrypted = [];
var _used = [];
while (array_length(words) < total_questions) {
    var _r = irandom(array_length(word_bank) - 1);
    var _dup = false;
    for (var i = 0; i < array_length(_used); i++) {
        if (_used[i] == _r) { _dup = true; break; }
    }
    if (!_dup) {
        array_push(_used, _r);
        array_push(words, word_bank[_r]);
        array_push(encrypted, scr_atbash_decode(word_bank[_r]));
    }
}

current_question = 0;
current_slot     = 0;
correct_count    = 0;

player_input = array_create(string_length(words[0]), "");

shake_timer   = 0;
status_msg    = "";
text_color    = c_white;
success_timer = 0;

anim_timer = 0;
