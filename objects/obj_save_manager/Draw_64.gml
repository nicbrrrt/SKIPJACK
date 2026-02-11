// --- obj_save_manager Draw GUI ---
// We use the direct string here so it NEVER crashes on boot
if (file_exists(working_directory + "save_v1.json")) {
    draw_set_color(c_green);
    draw_text(10, 10, "SAVE FILE: DETECTED");
} else {
    draw_set_color(c_red);
    draw_text(10, 10, "SAVE FILE: NONE");
}