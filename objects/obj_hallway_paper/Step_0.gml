// obj_hallway_paper — Step Event

player_nearby = instance_exists(obj_jack)
             && point_distance(x, y, obj_jack.x, obj_jack.y) < interact_radius;

// Open popup — E key while nearby, Kyle's lesson done, no dialogue active
if (player_nearby && keyboard_check_pressed(ord("E")) && !is_open
    && !instance_exists(obj_textevent) && global.kyle_lesson_done) {
    is_open             = true;
    has_been_opened     = true;
    global.paper_opened = true; // persist across room reloads
}

// Close popup — X key
if (is_open && keyboard_check_pressed(ord("X"))) {
    is_open = false;
}

// Close popup — clicking the X button
if (is_open && mouse_check_button_pressed(mb_left)) {
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    if (point_in_rectangle(_mx, _my, close_btn_x1, close_btn_y1, close_btn_x2, close_btn_y2)) {
        is_open = false;
    }
}
