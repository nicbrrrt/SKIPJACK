function scr_caesar_encode(text, key) {
    var res = "";
    for (var i = 1; i <= string_length(text); i++) {
        var c = string_char_at(text, i);
        if (c == " ") { 
            res += " "; 
            continue; 
        }
        var idx = ord(c) - ord("A");
        
        // --- UPDATED MATH FOR NEGATIVE KEYS ---
        var s = (idx + key) mod 26;
        if (s < 0) s += 26; // This ensures -1 wraps to 25 (Z)
        // --------------------------------------
        
        res += chr(s + ord("A"));
    }
    return res;
}