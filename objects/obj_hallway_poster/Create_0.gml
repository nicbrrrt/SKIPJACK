// rm_hallway_poster — Create Event

is_open         = false;      // is the popup window currently showing
has_been_opened = false;      // true after first interaction — marker turns white
player_nearby   = false;      // is Jack within interaction range
interact_radius = 80;         // px — how close Jack must be to interact

// X-button screen bounds (written each Draw GUI frame for click detection)
close_btn_x1 = 0;
close_btn_y1 = 0;
close_btn_x2 = 0;
close_btn_y2 = 0;

// No world sprite — depth stays at default 0 (Jack's -y always renders him in front)
