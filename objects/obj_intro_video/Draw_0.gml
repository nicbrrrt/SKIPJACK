/// @description obj_intro_video — Draw Event

// 1. Paint black background over room bounds (1280x720)
draw_set_alpha(1.0);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);

// 2. Fetch and draw video frame
var _results = video_draw();
var _status  = _results[0];

if (_status == 0) {
    var _surf = _results[1];
    if (surface_exists(_surf)) {
        // Draw stretched to fit the room viewport perfectly
        draw_surface_stretched(_surf, 0, 0, room_width, room_height);
    }
}

// Telemetry in debug output once per second (every 60 frames)
if ((video_debug_timer++) % 60 == 0) {
    var _fmt = "unknown";
    try {
        _fmt = (video_get_format() == video_format_rgba) ? "RGBA" : "YUV";
    } catch (_e) {}
    show_debug_message("[INTRO VIDEO] Draw_0 status: " + string(_status) + ", surf: " + string(_results[1]) + ", format: " + _fmt + ", vstatus: " + string(video_get_status()));
}
