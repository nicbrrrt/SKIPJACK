// --- Create Event for obj_camera ---
// This one line is the magic fix.
// It tells your graphics card: "Stop blurring. Use sharp pixels."
gpu_set_tex_filter(false);
// Set a nice 16:9 window size. 1280x720 is 2x our 640x360 camera.
// This is the actual window on your desktop.
window_set_size(1280, 720);

// This centers the game window on your monitor
window_center();

// This is our "zoom" level. We want to *see* a 640x360 area.
global.cam_width = 640;
global.cam_height = 360;

// GUI size is managed globally by obj_game_controller's Room Start event

