// --- obj_codex_manager Draw GUI ---

if (is_open) {
    var _len = array_length(modules);
    
    // 1. SAFETY: If the array is empty, don't try to draw a page!
    if (_len <= 0) {
        draw_set_color(c_black); draw_set_alpha(0.8);
        draw_rectangle(0, 0, 640, 360, false); draw_set_alpha(1);
        draw_set_color(c_red);
        draw_set_halign(fa_center);
        draw_text(320, 180, "CODEX OFFLINE: NO MODULES LOADED");
        exit;
    }

    // 2. SAFETY: Force current_page into valid range
    current_page = clamp(current_page, 0, _len - 1);

    var _w = 640;
    var _h = 360;
    
    // 3. Background Overlay
    draw_set_color(c_black); draw_set_alpha(0.85);
    draw_rectangle(0, 0, _w, _h, false); draw_set_alpha(1);
    
    // 4. Tablet Frame
    draw_set_color(c_lime);
    draw_rectangle(120, 60, _w - 120, _h - 60, true);
    
    // 5. DRAW CONTENT
    var _mod = modules[current_page];
    
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_color(c_lime);
    draw_text_transformed(_w/2, 90, "--- " + _mod.title + " ---", 1.2, 1.2, 0);
    
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text_ext(160, 140, _mod.content, 30, _w - 320);
    
    // 6. Navigation
    draw_set_halign(fa_center);
    draw_text(_w/2, _h - 90, "Page " + string(current_page + 1) + " of " + string(_len) + " | Arrows to Flip");
}