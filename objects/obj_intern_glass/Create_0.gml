/// @description obj_intern_glass — Create Event
is_north_wall = true;

var _diff = scr_intern_get_scrap_difficulty();
max_hp    = variable_struct_exists(_diff, "glass_max_hp") ? _diff.glass_max_hp : 30;
glass_hp  = max_hp;

hit_cooldown  = 0;
hit_anim      = 0;
is_shattered  = false;
near_player      = false;
is_repair_target = false;
hold_timer       = 0;
hold_max         = 120; // 2.0 seconds at 60 fps!
repair_spark_t   = 0;
mask_index       = spr_wall_tile;
depth         = 28;
