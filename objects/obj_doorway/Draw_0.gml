/// @description obj_doorway — Draw Event
/// Renders a Corporate Automatic Sliding Door matching facility security protocols.
/// Uses specific panel sprites (breaker, lockdown, locked, unlocked) with smooth biparting sliding animation.

// Check chunk fog alpha so doorways in unlit rooms/hallways stay completely dimmed under shadow!
var _chunk_c = x div 144;
var _chunk_r = y div 144;
var _fog = 0.0;

if (instance_exists(obj_dungeon_generator) && variable_instance_exists(obj_dungeon_generator, "room_fog_alpha")) {
    if (_chunk_c >= 0 && _chunk_c < LOGIC_GRID_W && _chunk_r >= 0 && _chunk_r < LOGIC_GRID_H) {
        if (is_array(obj_dungeon_generator.room_fog_alpha) && array_length(obj_dungeon_generator.room_fog_alpha) > _chunk_c) {
            _fog = obj_dungeon_generator.room_fog_alpha[_chunk_c][_chunk_r];
        }
    }
}

var _vis = clamp((0.85 - _fog) / 0.85, 0.0, 1.0);
if (_vis <= 0.01) {
    exit;
}

var _x1 = x;
var _y1 = y;
var _x2 = _x1 + 15;
var _y2 = _y1 + 15;

// 1. Brushed steel threshold plate beneath the door
draw_set_alpha(0.55 * _vis);
draw_set_color(make_color_rgb(24, 34, 48));
draw_rectangle(_x1, _y1, _x2, _y2, false);
draw_set_alpha(0.45 * _vis);
draw_set_color(make_color_rgb(65, 95, 130));
draw_rectangle(_x1, _y1, _x2, _y2, true);

// 2. Select door panel sprite according to door function and lock state
var _panel_spr = spr_door_panel;

if (door_type == "breaker") {
    // Breaker room door: uses spr_door_panel_breaker_room both locked and unlocked
    _panel_spr = sprite_exists(spr_door_panel_breaker_room) ? spr_door_panel_breaker_room : spr_door_panel;
} else if (door_type == "lockdown") {
    // Lockdown room door: uses spr_door_panel_lockdown both locked and unlocked
    _panel_spr = sprite_exists(spr_door_panel_lockdown) ? spr_door_panel_lockdown : spr_door_panel;
} else if (starts_locked) {
    // Doors that start locked (Quiz / Cipher): spr_door_panel_locked when locked, spr_door_panel_unlocked when unlocked
    if (is_locked) {
        _panel_spr = sprite_exists(spr_door_panel_locked) ? spr_door_panel_locked : spr_door_panel;
    } else {
        _panel_spr = sprite_exists(spr_door_panel_unlocked) ? spr_door_panel_unlocked : spr_door_panel;
    }
} else {
    // Doors that are already unlocked at the start of the room: use standard spr_door_panel
    _panel_spr = spr_door_panel;
}

// 3. Detect Door Orientation: Horizontal (Left-to-Right slide) vs Vertical (Top-to-Bottom slide)
var _has_door_vert = position_meeting(x + 8, y - 8, obj_doorway) || position_meeting(x + 8, y + 24, obj_doorway);
var _has_door_horz = position_meeting(x - 8, y + 8, obj_doorway) || position_meeting(x + 24, y + 8, obj_doorway);
var _is_vert = _has_door_vert;
if (!_has_door_vert && !_has_door_horz) {
    // Single-tile doorway: orient based on surrounding walls
    var _has_wall_vert = position_meeting(x + 8, y - 8, obj_dungeon_wall) && position_meeting(x + 8, y + 24, obj_dungeon_wall);
    _is_vert = _has_wall_vert;
}

if (_is_vert) {
    // =========================================================
    // VERTICAL DOOR: Whole tile slides from top to bottom
    // =========================================================
    var _slide_y = round(open_amt * 16);
    var _draw_h  = 16 - _slide_y;

    if (sprite_exists(_panel_spr)) {
        if (_draw_h > 0) {
            // Slide whole tile from top to bottom without any center seam
            draw_sprite_part_ext(_panel_spr, 0, 0, 0, 16, _draw_h, _x1, _y1 + _slide_y, 1.0, 1.0, c_white, _vis);
        } else {
            // Fully open doorway: subtle sensor side jambs
            draw_set_alpha(0.45 * _vis);
            draw_set_color(make_color_rgb(75, 240, 155));
            draw_rectangle(_x1, _y1, _x2, _y1 + 1, false);
            draw_rectangle(_x1, _y2 - 1, _x2, _y2, false);
        }
    } else {
        // Procedural Fallback
        if (_draw_h > 0) {
            draw_set_alpha(0.90 * _vis);
            draw_set_color(make_color_rgb(22, 36, 54));
            draw_rectangle(_x1 + 1, _y1 + _slide_y, _x2 - 1, _y2, false);
            draw_set_alpha(0.85 * _vis);
            draw_set_color(make_color_rgb(75, 165, 215));
            draw_rectangle(_x1, _y1 + _slide_y, _x2, _y2, true);
        } else {
            draw_set_alpha(0.45 * _vis);
            draw_set_color(make_color_rgb(75, 240, 155));
            draw_rectangle(_x1, _y1, _x2, _y1 + 1, false);
            draw_rectangle(_x1, _y2 - 1, _x2, _y2, false);
        }
    }
} else {
    // =========================================================
    // HORIZONTAL DOOR: Whole tile slides from left to right
    // =========================================================
    var _slide_x = round(open_amt * 16);
    var _draw_w  = 16 - _slide_x;

    if (sprite_exists(_panel_spr)) {
        if (_draw_w > 0) {
            // Slide whole tile from left to right without any center seam
            draw_sprite_part_ext(_panel_spr, 0, 0, 0, _draw_w, 16, _x1 + _slide_x, _y1, 1.0, 1.0, c_white, _vis);
        } else {
            // Fully open doorway: subtle sensor side jambs
            draw_set_alpha(0.45 * _vis);
            draw_set_color(make_color_rgb(75, 240, 155));
            draw_rectangle(_x1, _y1, _x1 + 1, _y2, false);
            draw_rectangle(_x2 - 1, _y1, _x2, _y2, false);
        }
    } else {
        // Procedural Fallback
        if (_draw_w > 0) {
            draw_set_alpha(0.90 * _vis);
            draw_set_color(make_color_rgb(22, 36, 54));
            draw_rectangle(_x1 + _slide_x, _y1 + 1, _x2, _y2 - 1, false);
            draw_set_alpha(0.85 * _vis);
            draw_set_color(make_color_rgb(75, 165, 215));
            draw_rectangle(_x1 + _slide_x, _y1, _x2, _y2, true);
        } else {
            draw_set_alpha(0.45 * _vis);
            draw_set_color(make_color_rgb(75, 240, 155));
            draw_rectangle(_x1, _y1, _x1 + 1, _y2, false);
            draw_rectangle(_x2 - 1, _y1, _x2, _y2, false);
        }
    }
}

draw_set_color(c_white);
draw_set_alpha(1.0);
