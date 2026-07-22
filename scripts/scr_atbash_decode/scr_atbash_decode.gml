// v1.0
function scr_atbash_decode(text) {
    var _result = "";
    var _len = string_length(text);
    for (var i = 1; i <= _len; i++) {
        var _c = string_char_at(text, i);
        var _ord = ord(_c);
        if (_ord >= 65 && _ord <= 90) { // A-Z
            _result += chr(65 + (90 - _ord));
        } else {
            _result += _c;
        }
    }
    return _result;
}