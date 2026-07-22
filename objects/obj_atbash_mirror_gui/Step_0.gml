if (variable_global_exists("is_paused") && global.is_paused) exit;

if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_escape)) {
    if (global.atbash_progress == 0) {
        global.atbash_progress = 1;
    }
    
    if (instance_exists(obj_codex_manager)) {
        with (obj_codex_manager) {
            tab_locked[2] = false;
            array_push(tab_modules[2], {
                title: "ATBASH CIPHER",
                content: "The Atbash cipher is a substitution cipher that reverses the alphabet.\nA=Z, B=Y, C=X ... M=N.\nEncoding and decoding use the same operation.\nOriginally used with the Hebrew alphabet."
            });
        }
    }
    
    if (instance_exists(obj_jack)) {
        obj_jack.isInCutscene = false;
    }
    
    instance_destroy();
}
