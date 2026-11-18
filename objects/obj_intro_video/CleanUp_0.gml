/// @description obj_intro_video — CleanUp Event
try {
    video_close();
} catch (_ex) {
    // Ignore close error if already closed
}
