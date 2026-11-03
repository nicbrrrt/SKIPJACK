/// @description obj_dungeon_prop — Create Event
/// Renders corporate office / server room props inside dungeon rooms:
///   TILE_PROP_PC    (7)  = Corporate computer workstation (spr_computer)
///   TILE_PROP_CHAIR (8)  = Office chair (spr_class_chair)
///   TILE_PROP_PAPER (10) = Scattered lockdown documents (spr_paper)

depth     = 24; // Below room fog (10) and Jack (-y), above floor (50)
prop_type = TILE_PROP_PC;
sub_img   = irandom(11);
rot_angle = choose(-12, 0, 8, 15);
