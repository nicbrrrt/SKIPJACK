// --- Step Event of obj_ui_button ---

// TAB — toggle the controls reminder panel
if (variable_global_exists("controls_hint_unlocked") && global.controls_hint_unlocked) {
    if (keyboard_check_pressed(vk_tab) && !instance_exists(obj_textevent)) {
        global.controls_hint_visible = !global.controls_hint_visible;
    }
}

// CODEX BUTTON — only after full tutorial, not in combat/quiz rooms
if (room == rm_combat || room == rm_battle_scramble) exit;

if (global.tutorial_complete) {
    var gui_w = display_get_gui_width();
    var button_x = gui_w - 60;
    var button_y = 60;
    var range = 40;

    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    if (mouse_check_button_pressed(mb_left)) {
        if (point_distance(_mx, _my, button_x, button_y) < range) {
            if (instance_exists(obj_codex_manager) && !instance_exists(obj_textevent)) {
                with (obj_codex_manager) {
                    is_open = !is_open;
                    if (instance_exists(obj_jack)) {
                        obj_jack.isInCutscene = is_open;
                        obj_jack.image_speed = 0;
                    }
                }
            }
        }
    }
}
