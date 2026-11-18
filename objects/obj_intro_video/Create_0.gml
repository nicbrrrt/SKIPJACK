/// @description obj_intro_video — Create Event
/// Introduction Video Player with Skip Button

depth = -16000;

// Set GUI size so coords and mouse mapping are locked right away
display_set_gui_size(640, 360);

video_file = "Skipjack_Intro_Video.mp4";
video_started = false;
video_failed  = false;
video_has_played = false;
video_debug_timer = 0;
fade_alpha    = 0.0;
fade_out      = false;
skip_hover    = false;

// Silence any audio that might be running
audio_stop_all();

// Resolve video file location
var _path = video_file;
if (!file_exists(_path)) {
    if (file_exists(working_directory + video_file)) {
        _path = working_directory + video_file;
    } else if (file_exists("datafiles/" + video_file)) {
        _path = "datafiles/" + video_file;
    } else if (file_exists("D:/Games/Skipjack Assets/Skipjack_Intro_Video.mp4")) {
        _path = "D:/Games/Skipjack Assets/Skipjack_Intro_Video.mp4";
    }
}

// Open and play video
try {
    video_open(_path);
    video_enable_loop(false);
    video_started = true;
    show_debug_message("[INTRO VIDEO] Successfully opened video: " + string(_path));
} catch (_ex) {
    show_debug_message("[INTRO VIDEO] Error opening video: " + string(_ex));
    video_failed = true;
    room_goto(rm_menu);
}
