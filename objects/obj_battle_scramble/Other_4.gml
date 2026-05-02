// FORCE RESOLUTION: 640 x 360
// This makes the coordinate math simple and consistent.

view_enabled = true;
view_visible[0] = true;

// 1. Set Camera Size
camera_set_view_size(view_camera[0], 640, 360);

// 2. Set GUI Size (Must match Camera!)
display_set_gui_size(640, 360);

// 3. Center Camera
var _x = (room_width - 640) / 2;
var _y = (room_height - 360) / 2;
camera_set_view_pos(view_camera[0], _x, _y);

// 4. Force Window Size (Optional)
window_set_size(1280, 720);

// Background for David's fight
if (variable_global_exists("last_battle_id") && global.last_battle_id == "david_quiz") {
    // Hide the room's built-in background so it never bleeds through during shake
    var _bg_layer = layer_get_id("Background");
    if (layer_exists(_bg_layer)) layer_set_visible(_bg_layer, false);

    var _scale = 0.35;
    var _layer = layer_create(1, "battle_bg");
    var _spr_w = sprite_get_width(spr_battle_hallway_background);
    var _spr_h = sprite_get_height(spr_battle_hallway_background);
    var _elem  = layer_sprite_create(_layer, (room_width - _spr_w * _scale) / 2, (room_height - _spr_h * _scale) / 2, spr_battle_hallway_background);
    layer_sprite_xscale(_elem, _scale);
    layer_sprite_yscale(_elem, _scale);
}


