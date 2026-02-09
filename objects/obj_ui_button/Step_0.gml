// --- Step Event of obj_ui_button ---

if (global.tutorial_complete) {
    var gui_w = display_get_gui_width();
    var button_x = gui_w - 60;
    var button_y = 60;
    var range = 40; 

    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    if (mouse_check_button_pressed(mb_left)) {
        if (point_distance(_mx, _my, button_x, button_y) < range) {
            // Open Codex if nothing else is open
            if (!instance_exists(obj_codex_menu) && !instance_exists(obj_textevent)) {
                instance_create_depth(0, 0, -15001, obj_codex_menu);
                if (instance_exists(obj_jack)) obj_jack.isInCutscene = true;
                show_debug_message("CODEX: Opened via Mouse");
            }
        }
    }
}