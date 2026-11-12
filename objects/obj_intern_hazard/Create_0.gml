/// @description obj_intern_hazard ?" Create Event
hazard_type     = HAZARD_SHELF; // HAZARD_SHELF, HAZARD_LOCKER, HAZARD_WATER
is_wobbling     = false;
wobble_timer    = 0;
var _diff       = scr_intern_get_scrap_difficulty();
wobble_max      = _diff.hazard_wobble; // Scaled: 4.0s (240 frames) down to 2.2s (132 frames) based on Scrap!
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
depth           = 35 - (y div 16); // Y-sorted: lower/front hazards draw on top of hazards behind them
mask_index      = spr_wall_tile;
