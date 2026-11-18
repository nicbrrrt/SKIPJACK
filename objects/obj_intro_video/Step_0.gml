/// @description obj_intro_video — Step Event

if (video_failed) {
    room_goto(rm_menu);
    instance_destroy();
    exit;
}

// Check skip hotkeys: Space, Enter, or Escape
var _key_skip = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_escape);

// Check mouse click on skip button (Bottom-right corner in GUI coords: 640x360)
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _btn_x1 = 520;
var _btn_y1 = 318;
var _btn_x2 = 620;
var _btn_y2 = 346;

skip_hover = (_mx >= _btn_x1 && _mx <= _btn_x2 && _my >= _btn_y1 && _my <= _btn_y2);
var _mouse_skip = (skip_hover && mouse_check_button_pressed(mb_left));

// Check video playback status
var _status = video_get_status();

// Mark that the video actually reached playing state
if (_status == video_status_playing) {
    video_has_played = true;
}

// Video has finished if it was playing and is now closed or paused at the end
var _ended = false;
if (video_has_played) {
    if (_status == video_status_closed || _status == video_status_paused) {
        _ended = true;
    }
}

// If skipped or video finished, trigger fade out
if ((_key_skip || _mouse_skip || _ended) && !fade_out) {
    fade_out = true;
}

if (fade_out) {
    fade_alpha += 0.1;
    if (fade_alpha >= 1.0) {
        try {
            video_close();
        } catch (_ex) {}
        room_goto(rm_menu);
        instance_destroy();
    }
}
