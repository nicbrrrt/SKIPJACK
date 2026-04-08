// par_rooftop_prop — Step Event
// Shared depth logic for all props that sit on rooftops.
// Children: obj_airunit, obj_neonlight_noodles, obj_designbuilding
if (instance_exists(my_building)) {
    depth = my_building.depth - 1;
} else {
    depth = -y;
}