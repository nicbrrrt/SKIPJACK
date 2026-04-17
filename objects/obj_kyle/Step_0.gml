event_inherited();
depth = -y;

if (room != rm_hallway) { visible = false; exit; }
visible = true;

// --- GUI CLOSE (E or ESC while panel is open) ---
if (gui_open) {
    if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_escape)) {
        gui_open                   = false;
        global.kyle_lesson_done    = true;
        global.quest_talk_to_david = true;
        if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
    }
    exit;
}

// After intro dialogue finishes → open the cipher info panel
if (showed_intro && !instance_exists(obj_textevent) && !global.kyle_lesson_done) {
    gui_open = true;
    if (instance_exists(obj_jack)) obj_jack.isInCutscene = true;
}

// E-key interaction
if (instance_exists(obj_jack)) {
    var _player = instance_find(obj_jack, 0);
    if (point_distance(x, y, _player.x, _player.y) < 48
        && keyboard_check_pressed(ord("E"))
        && !instance_exists(obj_textevent)) {
        event_user(0);
    }
}
