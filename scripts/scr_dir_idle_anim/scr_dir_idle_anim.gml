/// @func scr_dir_idle_frames_per_dir(_sprite)
function scr_dir_idle_frames_per_dir(_sprite) {
    var _n = sprite_get_number(_sprite);
    // Kyle / David sheets: 4 frames × 6 directions (RPG Maker row order)
    if (_sprite == spr_kyle_idle || _sprite == spr_david_idle) return 4;
    if (_n >= 24) return 6;
    if (_n >= 16) return 4;
    return _n;
}

/// @func scr_dir_idle_start(_sprite, _facing)
function scr_dir_idle_start(_sprite, _facing) {
    var _n = sprite_get_number(_sprite);
    if (_n < 16) return 0;
    var _fpf = scr_dir_idle_frames_per_dir(_sprite);

    // Kyle / David: rows are down, left, right, up (front, face-left, face-right, back)
    if (_sprite == spr_kyle_idle || _sprite == spr_david_idle) {
        switch (_facing) {
            case "left":  return _fpf;
            case "right": return _fpf * 2;
            case "up":    return _fpf * 3;
            default:      return 0;
        }
    }

    // Jack / NPC sheets: down, right, up, left
    switch (_facing) {
        case "right": return _fpf;
        case "up":    return _fpf * 2;
        case "left":  return _fpf * 3;
        default:      return 0;
    }
}

/// @func scr_dir_idle_anim(_sprite, _facing, _accum, _speed)
/// @returns [frame_index, new_accum]
function scr_dir_idle_anim(_sprite, _facing, _accum, _speed = 0.12) {
    var _fpf   = scr_dir_idle_frames_per_dir(_sprite);
    var _start = scr_dir_idle_start(_sprite, _facing);
    var _acc   = _accum + _speed;
    var _frame = _start + (floor(_acc) mod _fpf);
    return [_frame, _acc];
}

/// @func scr_battle_sprite_feet_y(_sprite, _scale, _feet_y)
/// Returns draw Y so sprite feet sit on _feet_y regardless of sprite origin.
function scr_battle_sprite_feet_y(_sprite, _scale, _feet_y) {
    return _feet_y - (sprite_get_bbox_bottom(_sprite) - sprite_get_yoffset(_sprite)) * _scale;
}

/// @func scr_battle_sprite_chest_xy(_sprite, _scale, _draw_x, _draw_y)
/// @returns [chest_x, chest_y] for orbit rings / block spawn anchors
function scr_battle_sprite_chest_xy(_sprite, _scale, _draw_x, _draw_y) {
    var _cx = _draw_x + sprite_get_width(_sprite) * _scale * 0.5;
    var _cy = _draw_y + (sprite_get_bbox_bottom(_sprite) - sprite_get_yoffset(_sprite)) * _scale * 0.42;
    return [_cx, _cy];
}
