// They only show up if the quest flag is true
if (variable_global_exists("greg_quest_started") && global.greg_quest_started == true) {
    visible = true;
} else {
    visible = false;
}