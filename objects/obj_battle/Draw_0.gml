// Draw background in room space — always behind all GUI elements (Draw_64 events)
if (sprite_exists(battle_background)) {
    draw_sprite_stretched(battle_background, 0, 0, 0, room_width, room_height);
}
