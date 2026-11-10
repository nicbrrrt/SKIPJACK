/// @description obj_intern_hazard ?" Create Event
hazard_type     = HAZARD_SHELF; // HAZARD_SHELF, HAZARD_LOCKER, HAZARD_WATER
is_wobbling     = false;
wobble_timer    = 0;
wobble_max      = 240; // 4.0 seconds snappy reaction window!
wobble_angle    = 0;
wobble_fix_meter = 0.0; // Spam [E] to fix/steady!
is_fallen       = false;
is_trapped      = false;
trapped_intern  = noone;
trapped_timer   = 1200; // 20s claustrophobia timer
struggle_meter  = 0;    // for prying open locker / lifting shelf
near_player        = false;
is_interact_target = false;
mischief_intern    = noone;
depth           = 25;
mask_index      = spr_wall_tile;
