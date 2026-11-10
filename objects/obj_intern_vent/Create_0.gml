/// @description obj_intern_vent — Create Event
room_assigned      = ROOM_INTERN_WORK;
vent_label         = "Office Air Vent";
is_clogged         = false;
stuck_intern       = noone;
struggle_pull      = 0.0;
near_player        = false;
is_interact_target = false;
fan_rot            = 0;
clog_timer         = 0;
cooldown           = 0; // Vent cannot be clogged while on cooldown
breeze_timer       = irandom(60);
depth              = 26;
