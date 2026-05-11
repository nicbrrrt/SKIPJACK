// obj_hallway_paper — Create Event

depth = -y; // use placement y as sort key (bbox_bottom over-extends tall sprites)

is_open         = false;      // is the popup window currently showing
has_been_opened = global.paper_opened; // restored from global — survives room reloads
player_nearby   = false;      // is Jack within interaction range
interact_radius = 80;

// X-button screen bounds (written each Draw GUI frame for click detection)
close_btn_x1 = 0;
close_btn_y1 = 0;
close_btn_x2 = 0;
close_btn_y2 = 0;
