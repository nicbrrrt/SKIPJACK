if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_escape)) {
    global.vigenere_progress = max(global.vigenere_progress, 1);
    
    if (instance_exists(obj_codex_manager)) {
        with (obj_codex_manager) {
            var _mods = tab_modules[2];
            var _found = false;
            for (var i = 0; i < array_length(_mods); i++) {
                if (_mods[i].title == "VIGENERE THEORY") {
                    _found = true;
                    break;
                }
            }
            if (!_found) {
                array_push(tab_modules[2], {
                    title: "VIGENERE THEORY",
                    content: "The VigenÃ¨re cipher uses a repeating keyword to shift each letter of a message differently, making it harder to crack than simple Caesar shifts."
                });
            }
        }
    }
    
    if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
    instance_destroy();
}
