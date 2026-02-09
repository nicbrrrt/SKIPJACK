if (is_open && array_length(modules) > 0) {
    var _w = display_get_gui_width();
    var _h = display_get_gui_height();
    
    // Background Overlay
    draw_set_color(c_black); draw_set_alpha(0.85);
    draw_rectangle(0, 0, _w, _h, false); draw_set_alpha(1);
    
    // Tablet UI
    draw_set_color(c_lime);
    draw_rectangle(150, 80, _w - 150, _h - 80, true);
    
    // Module Text
    var _mod = modules[0];
    draw_set_halign(fa_center);
    draw_text_transformed(_w/2, 120, _mod.title, 1.5, 1.5, 0);
    draw_set_halign(fa_left);
    draw_text_ext(200, 180, _mod.content, 30, _w - 400);
    
    draw_set_halign(fa_center);
    draw_text(_w/2, _h - 120, "Press 'C' to Close");
}