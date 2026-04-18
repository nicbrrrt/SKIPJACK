// obj_level1_tooltips — Step Event

if (keyboard_check_pressed(ord("X"))) {
    global.level1_tooltips_dismissed = true;
    instance_destroy();
}
