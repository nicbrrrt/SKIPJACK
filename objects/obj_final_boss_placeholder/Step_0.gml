// obj_final_boss_placeholder — Step Event
event_inherited(); // par_npc: depth = -y

if (global.boss_spawned && !global.final_boss_defeated) {
    visible = true;
}
