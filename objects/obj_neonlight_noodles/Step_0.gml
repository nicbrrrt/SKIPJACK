// --- Step Event for obj_roof_sign ---

// Check if the building we found in the Create event actually exists
if (instance_exists(my_building))
{
    // If it exists, set my depth to be 1 "layer"
    // in front of the building's depth.
    depth = my_building.depth - 1;
}
else
{
    // If I'm not on a building, just sort normally
    // (This is a good failsafe)
    depth = -y;
}