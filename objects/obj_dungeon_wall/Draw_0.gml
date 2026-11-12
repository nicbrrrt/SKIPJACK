/// @description obj_dungeon_wall — Draw Event
/// Renders clean symmetrical white corporate walls with caps, corners, and baseboards.
/// Automatically dims under room shadow when the room or hallway is unlit.

if (wall_style == 1) {
    // Structural building void: seamlessly blends into pure black background
    draw_set_alpha(1.0);
    draw_set_color(c_black);
    draw_rectangle(x, y, x + 15, y + 15, false);
    exit;
}

if (!variable_instance_exists(id, "wall_type_init") || !wall_type_init) {
    wall_type_init = true;

    var _w_top = instance_position(x + 8, y - 8, obj_dungeon_wall);
    has_wall_top = (_w_top != noone && variable_instance_exists(_w_top, "wall_style") && _w_top.wall_style != 1);

    var _w_bot = instance_position(x + 8, y + 24, obj_dungeon_wall);
    has_wall_bot = (_w_bot != noone && variable_instance_exists(_w_bot, "wall_style") && _w_bot.wall_style != 1);

    var _w_left = instance_position(x - 8, y + 8, obj_dungeon_wall);
    has_wall_left = (_w_left != noone && variable_instance_exists(_w_left, "wall_style") && _w_left.wall_style != 1);

    var _w_right = instance_position(x + 24, y + 8, obj_dungeon_wall);
    has_wall_right = (_w_right != noone && variable_instance_exists(_w_right, "wall_style") && _w_right.wall_style != 1);

    var _floor_north = instance_position(x + 8, y - 8, obj_floor);
    var _floor_south = instance_position(x + 8, y + 24, obj_floor);
    is_south_wall    = (_floor_north != noone) && (_floor_south == noone);

    if (is_south_wall && wall_style != 1) {
        depth = 18; // In front of props (depth 24) to overlap them, but behind lighting/shadow overlay (depth 10)
    }
}

// ---------------------------------------------------------------------------
// Room Illumination & Fog Dimming:
// Check chunk fog alpha so walls in unlit rooms/hallways stay completely dimmed!
// ---------------------------------------------------------------------------
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

// Inactive / unlit rooms and hallways have _fog = 0.88.
// When _fog >= 0.15, this room/hallway is not highlighted: completely shroud under dark shadow!
var _vis = clamp((0.85 - _fog) / 0.85, 0.0, 1.0);

if (_vis <= 0.01) {
    // Unlit room / hallway: completely shrouded under dark shadow (no white outlines!)
    draw_set_alpha(1.0);
    draw_set_color(c_black);
    draw_rectangle(x, y, x + 15, y + 15, false);
    exit;
}

// ---------------------------------------------------------------------------
// Render Wall: using spr_dungeon_wall tileset directly
// ---------------------------------------------------------------------------
draw_set_alpha(_vis);

// [EXPERIMENTAL] Toggle to use tiles directly from user-imported spr_dungeon_wall
// (Easily reversible: set to false to fall back to procedural drawing)
var _use_spr_dungeon_wall = true;

if (_use_spr_dungeon_wall && sprite_exists(spr_dungeon_wall)) {
    // 1. Base clean wall face (Row 0, Col 5 in spr_dungeon_wall)
    draw_sprite_part_ext(spr_dungeon_wall, 0, 5 * 16, 0 * 16, 16, 16, x, y, 1.0, 1.0, c_white, _vis);

    // 2. Top Wall Cap (flat top ledge on any wall facing down into the room)
    if (!has_wall_top) {
        var _cap_col = 8; // Center top cap
        if (!has_wall_left && !has_wall_right) {
            _cap_col = 3; // Pillar
        } else if (!has_wall_left) {
            _cap_col = 7; // Top-left corner
        } else if (!has_wall_right) {
            _cap_col = 9; // Top-right corner
        }
        draw_sprite_part_ext(spr_dungeon_wall, 0, _cap_col * 16, 0 * 16, 16, 7, x, y, 1.0, 1.0, c_white, _vis);
    }

    // 3. Bottom Baseboard (clean floor contact line where wall meets ground)
    if (!has_wall_bot) {
        var _base_col = 8; // Center baseboard
        if (!has_wall_left && !has_wall_right) {
            _base_col = 3; // Pillar base
        } else if (!has_wall_left) {
            _base_col = 7; // Bottom-left corner
        } else if (!has_wall_right) {
            _base_col = 9; // Bottom-right corner
        }
        draw_sprite_part_ext(spr_dungeon_wall, 0, _base_col * 16, 1 * 16 + 13, 16, 3, x, y + 13, 1.0, 1.0, c_white, _vis);
    }

    // 4. Outer Borders & Vertical Walls (Dark structural borders, never white)
    var _col_border = make_color_rgb(48, 52, 68);
    draw_set_color(_col_border);
    if (!has_wall_left) {
        draw_line(x, y, x, y + 15);
    }
    if (!has_wall_right) {
        draw_line(x + 15, y, x + 15, y + 15);
    }
} else {
    // ---------------------------------------------------------------------------
    // Fallback Procedural White Wall Palette
    // ---------------------------------------------------------------------------
    var _col_border = make_color_rgb(48, 52, 68);    // Clean dark structural outline
    var _col_white  = make_color_rgb(255, 255, 255); // Pure white wall cap
    var _col_shadow = make_color_rgb(216, 220, 226); // Subtle soft depth shadow under cap
    var _col_trim   = make_color_rgb(220, 224, 230); // Baseboard bevel trim

    // 1. Base clean white wall face
    draw_sprite_ext(sprite_index, image_index, x, y, 1.0, 1.0, 0, c_white, _vis);

    // 2. Symmetrical Top Wall Cap
    if (!has_wall_top) {
        draw_set_color(_col_border);
        draw_line(x, y, x + 15, y);
        draw_set_color(_col_white);
        draw_rectangle(x, y + 1, x + 15, y + 4, false);
        draw_set_color(_col_border);
        draw_line(x, y + 5, x + 15, y + 5);
        draw_set_color(_col_shadow);
        draw_line(x, y + 6, x + 15, y + 6);
    }

    // 3. Symmetrical Bottom Baseboard
    if (!has_wall_bot) {
        draw_set_color(_col_trim);
        draw_line(x, y + 14, x + 15, y + 14);
        draw_set_color(_col_border);
        draw_line(x, y + 15, x + 15, y + 15);
    }

    // 4. Outer Borders & Corners
    if (!has_wall_left) {
        draw_set_color(_col_border);
        draw_line(x, y, x, y + 15);
    }
    if (!has_wall_right) {
        draw_set_color(_col_border);
        draw_line(x + 15, y, x + 15, y + 15);
    }
}

// 5. Mounted Corporate Monitor / Briefing Screen on wall (wall_style == 2)
if (wall_style == 2) {
    if (board_prop_spr == -1) {
        var _prop_choices = [
            spr_dungeon_wall_prop,
            spr_dungeon_wall_prop_1,
            spr_dungeon_wall_prop_2,
            spr_dungeon_wall_prop_3,
            spr_dungeon_wall_prop_4
        ];
        var _r_idx = irandom(array_length(_prop_choices) - 1);
        board_prop_spr = _prop_choices[_r_idx];
    }

    if (sprite_exists(board_prop_spr)) {
        draw_sprite_ext(board_prop_spr, 0, x, y, 1.0, 1.0, 0, c_white, _vis);
    } else {
        var _lifted = (variable_global_exists("lockdown_lifted") && global.lockdown_lifted);
        draw_set_alpha(_vis);
        draw_set_color(make_color_rgb(12, 18, 28));
        draw_rectangle(x + 1, y + 3, x + 14, y + 12, false);
        draw_set_color(_lifted ? c_lime : make_color_rgb(255, 60, 75));
        draw_rectangle(x + 1, y + 3, x + 14, y + 12, true);
        draw_set_alpha(_vis * 0.8);
        draw_line(x + 3, y + 6, x + 12, y + 6);
        draw_set_color(c_aqua);
        draw_line(x + 3, y + 9, x + 10, y + 9);
    }
}

draw_set_color(c_white);
draw_set_alpha(1.0);
