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

// Camera pan state safety guards (in case camera is initialized before or without obj_game_init)
if (!variable_global_exists("cam_pan_phase"))   global.cam_pan_phase   = "off";
if (!variable_global_exists("cam_pan_timer"))   global.cam_pan_timer   = 0;
if (!variable_global_exists("cam_pan_from_x"))  global.cam_pan_from_x  = 0;
if (!variable_global_exists("cam_pan_from_y"))  global.cam_pan_from_y  = 0;
if (!variable_global_exists("cam_pan_to_x"))    global.cam_pan_to_x    = 0;
if (!variable_global_exists("cam_pan_to_y"))    global.cam_pan_to_y    = 0;
if (!variable_global_exists("cam_shake_timer")) global.cam_shake_timer = 0;
if (!variable_global_exists("cam_shake_mag"))   global.cam_shake_mag   = 0;

// GUI size is managed globally by obj_game_controller's Room Start event

