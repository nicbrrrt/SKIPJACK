// obj_hallway_poster — Create Event

depth = -bbox_bottom; // sort by sprite bottom edge, matching Jack's feet

is_open         = false;      // is the popup window currently showing
has_been_opened = global.poster_opened; // restored from global — survives room reloads
player_nearby   = false;      // is Jack within interaction range
interact_radius = 80;         // px — how close Jack must be to interact

// X-button screen bounds (written each Draw GUI frame for click detection)
close_btn_x1 = 0;
close_btn_y1 = 0;
close_btn_x2 = 0;
close_btn_y2 = 0;
