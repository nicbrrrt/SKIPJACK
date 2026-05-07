// obj_computer — Create Event
// UPDATED: depth moved here from Step. randomize frame & speed preserved.
image_index = irandom(image_number - 1);
image_speed = random_range(0.8, 1.2);
depth = -(y + sprite_get_height(spr_computer)); // Sort by sprite base for accurate Y-sort
// (Delete the Step Event entirely)