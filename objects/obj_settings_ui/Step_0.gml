var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);
var _held  = mouse_check_button(mb_left);

var _prev_back = hover_back;
var _prev_fs   = hover_fs;

hover_back = point_in_rectangle(_mx, _my, back_x1, back_y1, back_x2, back_y2);
hover_fs   = point_in_rectangle(_mx, _my, checkbox_x - 22, checkbox_y - 18, checkbox_x + 22, checkbox_y + 18);
hover_vol  = point_in_rectangle(_mx, _my, slider_x1 - 8, slider_y - 18, slider_x2 + 8, slider_y + slider_h + 18);

if ((hover_back && !_prev_back) || (hover_fs && !_prev_fs)) {
    if (!audio_is_playing(snd_button_hover)) {
        audio_play_sound(snd_button_hover, 10, false);
    }
}

if (_held && hover_vol) {
    dragging_volume = true;
}
if (!_held) {
    dragging_volume = false;
}

if (dragging_volume) {
    global.game_volume = clamp((_mx - slider_x1) / (slider_x2 - slider_x1), 0, 1);
    audio_master_gain(global.game_volume);
}

if (_click && hover_fs) {
    audio_stop_sound(snd_button_hover);
    audio_play_sound(snd_button_click, 10, false);
    fullscreen_on = !fullscreen_on;
    window_set_fullscreen(fullscreen_on);
}

if (_click && hover_back) {
    audio_stop_sound(snd_button_hover);
    audio_play_sound(snd_button_click, 10, false);
    room_goto(global.return_room);
    if (global.return_room == rm_level_1) {
        global.is_paused = true;
        instance_deactivate_all(true);
        audio_pause_all();
    }
}
