// --- Step Event for obj_ui_button ---
if (global.tutorial_complete) {
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _gui_w = display_get_gui_width();
    
    if (mouse_check_button_pressed(mb_left)) {
        // Check if clicking near the top right button
        if (point_distance(_mx, _my, _gui_w - 60, 60) < 40) {
            if (instance_exists(obj_codex_manager)) {
                with(obj_codex_manager) {
                    is_open = !is_open;
                    if (instance_exists(obj_jack)) obj_jack.isInCutscene = is_open;
                }
            }
        }
    }
}