// FORCE RESOLUTION: 640 x 360
// This makes the coordinate math simple and consistent.

view_enabled = true;
view_visible[0] = true;

// 1. Set Camera Size
camera_set_view_size(view_camera[0], 640, 360);

// 2. Set GUI Size (Must match Camera!)
display_set_gui_size(640, 360);

// 3. Center Camera
var _x = (room_width - 640) / 2;
var _y = (room_height - 360) / 2;
camera_set_view_pos(view_camera[0], _x, _y);

// 4. Force Window Size (Optional)
window_set_size(1280, 720);