/// @func scr_roll_cipher_key()
/// Returns a random Caesar shift in [-5, 5], never 0.
function scr_roll_cipher_key() {
    var _k = 0;
    while (_k == 0) {
        _k = irandom_range(-5, 5);
    }
    return _k;
}
