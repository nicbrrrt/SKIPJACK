// --- New Code for Scaling ---

// --- This part is the same ---
var _title_x = room_width / 2;
var _title_y = room_height * 0.25; 

// --- THIS IS THE NEW PART ---
var _scale = 1.25; // 1 = 100% (normal size), 1.25 = 125%, 2 = 200%

draw_sprite_ext(
    spr_title_logo, // Sprite
    0,              // Frame
    _title_x,       // X
    _title_y,       // Y
    _scale,         // X Scale (how wide)
    _scale,         // Y Scale (how tall)
    0,              // Rotation (0 = no rotation)
    c_white,        // Color (c_white = no change)
    1               // Alpha (1 = 100% visible)
);