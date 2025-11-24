function scr_caesar_decode(text, key) {
    var res = "";
    for (var i = 1; i <= string_length(text); i++) {
        var c = string_char_at(text, i);
        if (c == " ") { 
            res += " "; 
            continue; 
        }
        var idx = ord(c) - ord("A");
        var s = (idx - key) mod 26;
        if (s < 0) s += 26;
        res += chr(s + ord("A"));
    }
    return res;
}