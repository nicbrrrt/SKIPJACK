// --- Draw GUI Event of obj_cutscene_intro ---

var _is_waiting_step = (sequence_step == 2 || sequence_step == 4 || sequence_step == 6 || sequence_step == 8);

if (_is_waiting_step && instance_exists(obj_textevent)) {
    
    // 1. Setup Position (Top Right)
    var _gui_w = display_get_gui_width();
    var _x_pos = _gui_w - 40; 
    var _y_pos = 40;          

    // 2. Pulse Effect (Scale between 1.5 and 1.6)
    var _pulse_scale = 1.5 + (sin(current_time / 200) * 0.1);

    // 3. DRAW BACKGROUND BOX (Guarantees visibility!)
    draw_set_color(c_white);
    draw_set_alpha(0.8); // Slightly transparent
    // Draw a rectangle behind where the text will be
    draw_rectangle(_x_pos - 150, _y_pos - 10, _x_pos + 10, _y_pos + 40, false);
    draw_set_alpha(1); // Reset alpha immediately

    // 4. DRAW TEXT (COLOR BLACK)
    draw_set_font(fnt_default); 
    draw_set_halign(fa_right);  
    draw_set_valign(fa_top);
    
    // Draw the text in BLACK so it pops on the white box
    draw_set_color(c_black);
    draw_text_transformed(_x_pos, _y_pos, "PRESS [E]", _pulse_scale, _pulse_scale, 0);

    // 5. Cleanup
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white); // Reset global color
}