/// @description obj_intern ?" Create Event
intern_id       = 0;
state           = INTERN_STATE_WORK;
boredom         = 0;

var _diff       = scr_intern_get_scrap_difficulty();
boredom_rate    = random_range(_diff.boredom_min, _diff.boredom_max); // Scaled to company Scrap looted!
grace_timer     = _diff.initial_grace; // Scaled peaceful initial grace period
home_desk_x     = x;
home_desk_y     = y;
assigned_term   = noone;
target_x        = x;
target_y        = y;
target_room     = ROOM_INTERN_WORK;
waypoints       = [];
current_wp      = 0;
mischief_target = noone;
mischief_timer  = 0;
vent_target     = noone;
door_cooldown   = 0;
vent_cooldown   = 0;
move_speed      = 2.85; // A little faster than Jack walking (2.5), but slower than Jack sprinting (4.2)
is_slipped      = false;
slip_timer      = 0;
slip_cooldown   = 0;
slip_vx         = 0;
slip_vy         = 0;
walk_timer      = 0;
intern_hp      = 100.0;
intern_max_hp  = 100.0;
fuming_timer   = variable_struct_exists(_diff, "fuming_time") ? _diff.fuming_time : 150;
wake_timer     = variable_struct_exists(_diff, "knockout_wake_time") ? _diff.knockout_wake_time : 240;
flail_angle    = 0;
flail_cooldown = 0;

// Struggle and carried state mechanics
struggle_meter    = 0.0;
struggle_rate     = 0.0;
struggle_timer    = 0;
struggle_shake    = 0.0;
held_prev_state   = INTERN_STATE_WORK;
held_prev_boredom = 0.0;
held_prev_fuming  = 0;

knockout_timer  = 1800; // 30 seconds to rescue before suffocation fatality
revive_meter    = 0;
is_cpr_target   = false;
soothe_timer    = 0;
tie_color       = choose(c_red, c_blue, make_color_rgb(255, 120, 40), make_color_rgb(140, 60, 200));
hair_color      = choose(make_color_rgb(50, 35, 20), make_color_rgb(210, 160, 50), make_color_rgb(150, 40, 20), make_color_rgb(30, 30, 30));
face_dir        = 270;
near_player     = false;
depth           = 22;
mask_index      = -1;
intern_variant  = 1;
sprite_index    = intern1;
