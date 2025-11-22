// --- In obj_camera's Step or End Step Event ---

// 1. Get the camera's dimensions
var cam_width = camera_get_view_width(view_camera[0]);
var cam_height = camera_get_view_height(view_camera[0]);
var cam_half_width = cam_width / 2;
var cam_half_height = cam_height / 2;

// 2. Get the room's dimensions
var room_w = room_width;
var room_h = room_height;

// 3. Find the player (your target)
//    (Make sure your player object is named o_player or change this)
if (!instance_exists(obj_player)) {
    exit; // Do nothing if the player doesn't exist
}

// 4. Get the ideal camera position (centered on player)
var target_x = obj_player.x;
var target_y = obj_player.y;


// 5. THIS IS THE FIX: Clamp the target position
//    This stops the camera's CENTER from going too close to the edge
target_x = clamp(target_x, cam_half_width, room_w - cam_half_width);
target_y = clamp(target_y, cam_half_height, room_h - cam_half_height);


// 6. Set the final camera position
//    (We subtract the half-dimensions to set the camera's top-left corner)
var final_cam_x = target_x - cam_half_width;
var final_cam_y = target_y - cam_half_height;

camera_set_view_pos(view_camera[0], final_cam_x, final_cam_y);