// obj_final_boss_placeholder — Step Event
event_inherited(); // par_npc: depth = -y

if (global.boss_spawned && !global.final_boss_defeated) {
    visible = true;
    sprite_index = spr_boss_idle;
    image_speed = 0.15;
} else if (global.final_boss_defeated) {
    visible = true;
    sprite_index = spr_boss_dead;
    image_speed = 0.1;
}
