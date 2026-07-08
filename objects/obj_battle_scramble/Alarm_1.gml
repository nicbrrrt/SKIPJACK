// Tutorial parry retry — relaunch block after a failed parry attempt
if (variable_global_exists("is_paused") && global.is_paused) exit;

if (scramble_tutorial && tutorial_phase == 5 && battle_state == "player_input") {
    launch_block_attack("E", true);
}
