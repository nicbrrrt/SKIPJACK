// obj_lea — Step Event
event_inherited(); // Runs par_npc's depth = -y

if (variable_global_exists("greg_quest_started") && global.greg_quest_started == true) {
    visible = true;
} else {
    visible = false;
}