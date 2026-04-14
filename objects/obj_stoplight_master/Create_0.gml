// obj_stoplight_master — Create Event
image_speed = 0;
image_index = 0;
alarm[0]    = room_speed * 5;
depth       = -y; // Stoplight doesn't move. Set once.
// (Delete the Step Event entirely)