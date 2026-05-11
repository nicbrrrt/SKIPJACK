// obj_hallway_computer_2 — Create Event

depth = -bbox_bottom; // sort by sprite bottom edge, matching Jack's feet

is_open         = false;
has_been_opened = global.computer2_opened; // restored from global — survives room reloads
player_nearby   = false;
interact_radius = 80;

close_btn_x1 = 0;
close_btn_y1 = 0;
close_btn_x2 = 0;
close_btn_y2 = 0;
