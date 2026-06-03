// rm_settings — ensure GUI scale and volume match saved settings
display_set_gui_size(640, 360);

if (!variable_global_exists("game_volume")) global.game_volume = 1;
audio_master_gain(global.game_volume);
