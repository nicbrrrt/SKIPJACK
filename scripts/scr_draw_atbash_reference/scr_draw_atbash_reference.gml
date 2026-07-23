/// @description Draws the Atbash reference alphabet at the specified Y coordinate
function scr_draw_atbash_reference(_y_offset) {
    var alpha_top = ["A","B","C","D","E","F","G","H","I","J","K","L","M"];
    var alpha_bottom = ["Z","Y","X","W","V","U","T","S","R","Q","P","O","N"];
    
    var start_x = 320 - (13 * 20) / 2 + 10;
    var spacing = 20;

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_dialogue);

    for (var i = 0; i < 13; i++) {
        var xx = start_x + (i * spacing);
        
        draw_set_color(c_lime);
        draw_text_transformed(xx, _y_offset, alpha_top[i], 0.8, 0.8, 0);
        
        draw_set_color(c_yellow);
        draw_text_transformed(xx, _y_offset + 20, alpha_bottom[i], 0.8, 0.8, 0);
        
        draw_set_alpha(0.3);
        draw_set_color(c_gray);
        draw_line(xx, _y_offset + 6, xx, _y_offset + 14);
        draw_set_alpha(1.0);
    }
}
