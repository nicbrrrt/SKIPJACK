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
