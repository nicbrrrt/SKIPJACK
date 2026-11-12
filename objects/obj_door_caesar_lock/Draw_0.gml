/// @description obj_door_caesar_lock — Draw Event
/// Security barrier collision & interaction logic handled in Step Event.
/// Door panel visuals (sprites & sliding animation) are rendered cleanly by obj_doorway without square overlays.

if (unseal_flash > 0) {
    var _chunk_c = draw_x div 144;
    var _chunk_r = draw_y div 144;
    var _fog = 0.0;

    if (instance_exists(obj_dungeon_generator) && variable_instance_exists(obj_dungeon_generator, "room_fog_alpha")) {
        if (_chunk_c >= 0 && _chunk_c < LOGIC_GRID_W && _chunk_r >= 0 && _chunk_r < LOGIC_GRID_H) {
            if (is_array(obj_dungeon_generator.room_fog_alpha) && array_length(obj_dungeon_generator.room_fog_alpha) > _chunk_c) {
                _fog = obj_dungeon_generator.room_fog_alpha[_chunk_c][_chunk_r];
            }
        }
    }

    var _vis = clamp((0.85 - _fog) / 0.85, 0.0, 1.0);
    if (_vis > 0.01) {
        var _uf = unseal_flash / 90;
        var _ur = (1 - _uf) * 22 + 4;
        draw_set_alpha(_uf * 0.85 * _vis);
        draw_set_color(c_lime);
        draw_circle(draw_x + 8, draw_y + 8, _ur, true);
        draw_set_color(c_white);
        draw_set_alpha(1.0);
    }
}
