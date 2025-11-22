// --- Create Event for obj_roof_sign ---

// Check 5 pixels below me to find the "wall" (building) I'm sitting on
// (We use obj_wall because all buildings are children of it)
my_building = instance_place(x, y + 5, obj_wall);