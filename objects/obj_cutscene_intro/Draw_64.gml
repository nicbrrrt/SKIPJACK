// --- Draw GUI Event of obj_cutscene_intro ---

var _is_reading = (sequence_step == 2 || sequence_step == 4 || sequence_step == 6 || sequence_step == 8);

if (_is_reading && instance_exists(obj_textevent)) {
    
    // 1. Setup Position (Bottom Right)
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _x_pos = _gui_w - 60; 
    var _y_pos = _gui_h - 50;          

    // 2. Pulse Effect
    var _alpha_pulse = 0.6 + (sin(current_time / 200) * 0.4);

    // 3. DRAW THE TEXT
    draw_set_font(fnt_default); 
    draw_set_halign(fa_center);  
    draw_set_valign(fa_middle);
    
    // --- CHANGED TO YELLOW HERE ---
    draw_set_color(c_yellow); 
    draw_set_alpha(_alpha_pulse);

    draw_text_transformed(_x_pos, _y_pos, "Press [E]", 0.75, 0.75, 0);

    // 4. Cleanup
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(c_white); 
}