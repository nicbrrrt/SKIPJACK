function scr_random_letters(length) {
    var res = "";
    for (var i = 0; i < length; i++) {
        var r = irandom_range(0, 25);
        res += chr(ord("A") + r);
    }
    return res;
}