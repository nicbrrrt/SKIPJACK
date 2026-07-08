// Layout — all coordinates are GUI space (640×360)
display_set_gui_size(640, 360);

if (!variable_global_exists("game_volume")) global.game_volume = 1;
if (!variable_global_exists("return_room"))     global.return_room     = rm_menu;

audio_master_gain(global.game_volume);

panel_x = 48;
panel_y = 56;
panel_w = 544;
panel_h = 248;

row_label_x = 72;
vol_row_y   = 148;
fs_row_y    = 198;

slider_x1 = 248;
slider_x2 = 520;
slider_y  = vol_row_y;
slider_h  = 10;

checkbox_x = 500;
checkbox_y = fs_row_y;

back_x1 = 58;
back_y1 = 78;
back_x2 = 148;
back_y2 = 108;

fullscreen_on = window_get_fullscreen();
dragging_volume = false;
hover_back = false;
hover_fs   = false;
hover_vol  = false;
settings_pause_mode = false;
