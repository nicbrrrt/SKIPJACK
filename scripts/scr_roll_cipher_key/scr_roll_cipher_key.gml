/// @func scr_roll_cipher_key()
/// Returns a Caesar shift key tailored to the current floor's curriculum stage:
///   - Floor 1 (Tutorial 1): Small positive shift (+1 to +3)
///   - Floor 2 (Tutorial 2): Small negative shift (-1 to -3)
///   - Floor 3 (Tutorial 3): Small shift in [-3..+3] (non-zero)
///   - Floors 4–10 (Practice / Mastery / Exam): Shift in [-5..+5] (non-zero)
function scr_roll_cipher_key() {
    var _flr = variable_global_exists("chapter_floor") ? global.chapter_floor : 4;
    var _k   = 0;

    if (_flr == 1) {
        _k = irandom_range(1, 3);
    } else if (_flr == 2) {
        _k = -irandom_range(1, 3);
    } else if (_flr == 3) {
        while (_k == 0) {
            _k = irandom_range(-3, 3);
        }
    } else {
        while (_k == 0) {
            _k = irandom_range(-5, 5);
        }
    }
    return _k;
}

/// @func scr_roll_vigenere_keyword(_floor_num)
/// Rolls a Vigenere keyword using small, countable shifts (A=+0 .. F=+5)
/// scaled to the floor's learning stage.
function scr_roll_vigenere_keyword(_floor_num) {
    if (_floor_num == 1) {
        return choose("BC", "BD", "CD", "CE");
    } else if (_floor_num <= 3) {
        return choose("CAB", "BED", "BCD", "CAD");
    } else if (_floor_num <= 9) {
        return choose("CAB", "ACE", "BED", "FAD", "DEC", "BAD", "FED");
    } else {
        return choose("CAFE", "FACE", "DEAF", "FEED", "BEAD");
    }
}
