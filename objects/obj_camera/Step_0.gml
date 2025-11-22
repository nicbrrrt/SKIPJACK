// --- Step Event for obj_camera ---

// 1. Set the camera's size (our "zoom")
// view_camera[0] is the main game camera
camera_set_view_size(view_camera[0], global.cam_width, global.cam_height);

// 2. Follow the player
// We check if the player *exists* first, to avoid a crash
if (instance_exists(obj_jack))
{
    // Get the top-left corner for the camera
    // This centers the player (obj_player.x) in the middle of the camera's width
    var _cam_x = obj_jack.x - (global.cam_width / 2);
    var _cam_y = obj_jack.y - (global.cam_height / 2);

    // Set the camera's position
    camera_set_view_pos(view_camera[0], _cam_x, _cam_y);
}