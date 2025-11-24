draw_set_font(fnt_default);
draw_set_color(c_white);

// RESET TO DEFAULT
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

var center_x = gui_width / 2;
var center_y = gui_height / 2;

// Title
draw_set_halign(fa_center);
draw_text(center_x, 50, "QUICK TIME EVENT - CATCH THE PACKET!");
draw_text(center_x, 80, "Repeat the pattern before time runs out!");
draw_set_halign(fa_left);

// Timer bar
var timer_width = 400;
var timer_x = center_x - (timer_width / 2);
var timer_y = 120;

var timer_percent = timer / (room_speed * 4);

// Timer background
draw_set_color(c_gray);
draw_rectangle(timer_x, timer_y, timer_x + timer_width, timer_y + 20, true);

// Timer fill
if (timer_percent > 0.5) draw_set_color(c_green);
else if (timer_percent > 0.25) draw_set_color(c_yellow);
else draw_set_color(c_red);

draw_rectangle(timer_x, timer_y, timer_x + timer_width * timer_percent, timer_y + 20, true);

// Timer outline
draw_set_color(c_white);
draw_rectangle(timer_x, timer_y, timer_x + timer_width, timer_y + 20, false);
draw_text(timer_x + timer_width + 10, timer_y, string(ceil(timer / room_speed)) + "s");

// ARROWS - REVEAL ONE AT A TIME
var total_arrows_width = (60 * array_length(pattern)) + (20 * (array_length(pattern) - 1));
var arrows_start_x = center_x - (total_arrows_width / 2);
var arrows_y = center_y - 30;

draw_set_halign(fa_center);
draw_text(center_x, arrows_y - 40, "Pattern to input:");
draw_set_halign(fa_left);

for (var i = 0; i < array_length(pattern); i++) {
    var arrow_x = arrows_start_x + (i * 80);
    var arrow_y = arrows_y;
    
    // Only show arrows up to the current index + 1
    if (i <= index) {
        // Determine arrow sprite
        var arrow_sprite = -1;
        if (pattern[i] == vk_up) arrow_sprite = spr_arrow_up;
        else if (pattern[i] == vk_down) arrow_sprite = spr_arrow_down;
        else if (pattern[i] == vk_left) arrow_sprite = spr_arrow_left;
        else if (pattern[i] == vk_right) arrow_sprite = spr_arrow_right;
        
        // Draw background
        if (i < index) {
            draw_set_color(c_green); // Completed - green
            draw_rectangle(arrow_x - 25, arrow_y - 25, arrow_x + 25, arrow_y + 25, true);
        } else if (i == index) {
            draw_set_color(c_yellow); // Current - yellow
            draw_rectangle(arrow_x - 25, arrow_y - 25, arrow_x + 25, arrow_y + 25, true);
        } else {
            draw_set_color(c_white); // Next - white outline
            draw_rectangle(arrow_x - 25, arrow_y - 25, arrow_x + 25, arrow_y + 25, false);
        }
        
        // DRAW THE ARROW SPRITE
        if (arrow_sprite != -1) {
            draw_sprite(arrow_sprite, 0, arrow_x, arrow_y);
        }
        
        draw_set_color(c_white);
    } else {
        // Future arrows - show as "?" or hidden
        draw_set_color(c_gray);
        draw_rectangle(arrow_x - 25, arrow_y - 25, arrow_x + 25, arrow_y + 25, false);
        draw_text(arrow_x - 4, arrow_y - 8, "?");
        draw_set_color(c_white);
    }
}

// Progress
draw_set_halign(fa_center);
draw_text(center_x, arrows_y + 60, "Progress: " + string(index) + "/" + string(pattern_length));
draw_text(center_x, gui_height - 30, "Press arrows in the exact sequence!");
draw_set_halign(fa_left);