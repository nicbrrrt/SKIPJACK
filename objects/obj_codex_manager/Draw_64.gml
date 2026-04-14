// --- obj_codex_manager Draw GUI ---

if (is_open) {
    var _len = array_length(modules);

    // 1. SAFETY: If the array is empty, don't try to draw a page!
    if (_len <= 0) {
        var _gw = display_get_gui_width();
        var _gh = display_get_gui_height();
        draw_set_color(c_black); draw_set_alpha(0.8);
        draw_rectangle(0, 0, _gw, _gh, false); draw_set_alpha(1);
        draw_set_color(c_red);
        draw_set_halign(fa_center);
        draw_text(_gw / 2, _gh / 2, "CODEX OFFLINE: NO MODULES LOADED");
        exit;
    }

    // 2. SAFETY: Force current_page into valid range
    current_page = clamp(current_page, 0, _len - 1);

    // 3. Dynamic scaling — always proportional to actual GUI size
    var _gw    = display_get_gui_width();
    var _gh    = display_get_gui_height();
    var _scale = min(_gw / 640, _gh / 360);
    var _w     = 640 * _scale;
    var _h     = 360 * _scale;
    var _ox    = (_gw - _w) / 2; // horizontal offset to centre
    var _oy    = (_gh - _h) / 2; // vertical offset to centre

    // 4. Background Overlay
    draw_set_color(c_black); draw_set_alpha(0.85);
    draw_rectangle(0, 0, _gw, _gh, false); draw_set_alpha(1);

    // 5. Tablet Frame
    draw_set_color(c_lime);
    draw_rectangle(_ox + 120 * _scale, _oy + 60 * _scale, _ox + _w - 120 * _scale, _oy + _h - 60 * _scale, true);

    // 6. DRAW CONTENT
    var _mod = modules[current_page];

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_color(c_lime);
    draw_text_transformed(_ox + _w / 2, _oy + 90 * _scale, "--- " + _mod.title + " ---", 1.2 * _scale, 1.2 * _scale, 0);

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text_ext(_ox + 160 * _scale, _oy + 140 * _scale, _mod.content, 30, _w - 320 * _scale);

    // 7. Navigation
    draw_set_halign(fa_center);
    draw_text(_ox + _w / 2, _oy + _h - 105 * _scale, "Page " + string(current_page + 1) + " of " + string(_len) + " | Arrow Keys to Flip");
    draw_text(_ox + _w / 2, _oy + _h - 80 * _scale, "C or ESC to Close");
}
