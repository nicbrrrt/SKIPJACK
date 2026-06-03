// Debug-only save indicator (hidden from players during normal play)
if (!variable_global_exists("DEBUG_MODE") || !global.DEBUG_MODE) exit;

if (file_exists(working_directory + "save_v1.json")) {
    draw_set_color(c_green);
    draw_text(10, 10, "SAVE FILE: DETECTED");
} else {
    draw_set_color(c_red);
    draw_text(10, 10, "SAVE FILE: NONE");
}
