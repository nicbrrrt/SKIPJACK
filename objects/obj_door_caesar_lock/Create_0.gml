/// @description obj_door_caesar_lock — Create Event
/// Encrypted / Lockdown-sealed Door tile guarding ROOM_CAESAR_LOCKED, ROOM_POWER, ROOM_HOLDING, and ROOM_END.

depth            = 25; // Draws above floor/doorway (40..50) and below room fog (10)
locked           = true;
is_elevator_door = false;
is_holding_door  = false;
is_breaker_door  = false;
unseal_anim_t    = 0;
unseal_flash     = 0;
draw_x           = x;
draw_y           = y;
anim_t           = 0;
