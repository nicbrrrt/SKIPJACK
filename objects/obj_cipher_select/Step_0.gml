// Use GUI-space mouse position so coordinates match Draw_64
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Recompute button bounds from current GUI size each step
// (guards against display_set_gui_size being called by persistent objects)
var _cx  = display_get_gui_width() / 2;
btn_x1  = _cx - btn_w / 2;
btn_x2  = _cx + btn_w / 2;
btn1_y  = display_get_gui_height() / 2 + 10;
btn2_y  = btn1_y + btn_h + btn_gap;
btn3_y  = btn2_y + btn_h + btn_gap;

// --- Caesar Cipher button hover ---
caesar_hover = (mx >= btn_x1 && mx <= btn_x2
             && my >= btn1_y  && my <= btn1_y + btn_h);

if (caesar_hover && mouse_check_button_pressed(mb_left))
{
    audio_stop_sound(snd_button_hover);
    audio_play_sound(snd_button_click, 10, false);

    // Replicate original obj_button_play click logic exactly
    if (instance_exists(obj_transition))      instance_destroy(obj_transition);
    if (instance_exists(obj_jack))            instance_destroy(obj_jack);
    if (instance_exists(obj_game_controller)) instance_destroy(obj_game_controller);

    var _t        = instance_create_depth(0, 0, -9999, obj_transition);
    _t.target_room = rm_tutorial_void;
    _t.fade_mode   = "fading_out";
    _t.fade_alpha  = 0;

    if (file_exists(global.save_path)) {
        show_debug_message("CIPHER SELECT: Save found — handing to Save Manager.");
        if (instance_exists(obj_save_manager)) obj_save_manager.load_game();
    } else {
        show_debug_message("CIPHER SELECT: No save — starting fresh intro.");
    }
}

// --- Back button (top-left region) ---
var back_hover = (mx >= 10 && mx <= 70 && my >= 10 && my <= 30);
if (back_hover && mouse_check_button_pressed(mb_left))
{
    audio_play_sound(snd_button_click, 10, false);
    room_goto(rm_menu);
}
