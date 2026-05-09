// rm_hallway_poster — Step Event

// Proximity check
player_nearby = instance_exists(obj_jack)
             && point_distance(x, y, obj_jack.x, obj_jack.y) < interact_radius;

// Open popup — E key while nearby, no NPC dialogue active (gated on Kyle lesson)
if (player_nearby && keyboard_check_pressed(ord("E")) && !is_open
    && !instance_exists(obj_textevent) && global.kyle_lesson_done) {
    is_open         = true;
    has_been_opened = true;   // marker permanently turns white after first open
}

// Close popup — X key
if (is_open && keyboard_check_pressed(ord("X"))) {
    is_open = false;
}

// Close popup — clicking the X button (uses coords written each frame by Draw GUI)
if (is_open && mouse_check_button_pressed(mb_left)) {
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    if (point_in_rectangle(_mx, _my, close_btn_x1, close_btn_y1, close_btn_x2, close_btn_y2)) {
        is_open = false;
    }
}
