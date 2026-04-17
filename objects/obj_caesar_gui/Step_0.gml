if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_escape)) {
    global.kyle_lesson_done    = true;
    global.quest_talk_to_david = true;
    if (instance_exists(obj_jack)) obj_jack.isInCutscene = false;
    instance_destroy();
}
