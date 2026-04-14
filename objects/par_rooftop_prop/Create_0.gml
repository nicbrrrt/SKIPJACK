// par_rooftop_prop — Create Event
// Initializes my_building for ALL children (obj_airunit, obj_neonlight_noodles, obj_designbuilding).
// Children that DO have a Create Event will overwrite this with the correct value.

my_building = instance_place(x, y + 5, obj_wall);