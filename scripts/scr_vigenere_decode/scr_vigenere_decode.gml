function scr_vigenere_decode(text, key) {
    var res = "";
    key = string_upper(key);
    var key_len = string_length(key);
    var key_idx = 0;
    for (var i = 1; i <= string_length(text); i++) {
        var c = string_char_at(text, i);
        if (c == " ") {
            res += " ";
            continue;
        }
        var char_idx = ord(c) - ord("A");
        var shift = ord(string_char_at(key, (key_idx mod key_len) + 1)) - ord("A");
        var s = (char_idx - shift) mod 26;
        if (s < 0) s += 26;
        res += chr(s + ord("A"));
        key_idx++;
    }
    return res;
}
