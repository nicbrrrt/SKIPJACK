// 1. Randomize the Starting Frame
// irandom(x) gives a random integer between 0 and x.
// image_number - 1 gives us the last frame of the sprite.
image_index = irandom(image_number - 1);

// 2. Randomize the Speed (Optional)
// This makes some computers slightly faster or slower (e.g., 0.8x to 1.2x speed)
image_speed = random_range(0.8, 1.2);

// 3. Set Depth (Keep this!)
depth = -y;