// --- Draw GUI Event of obj_qte ---

draw_set_font(fnt_default);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// 1. DRAW THE PROJECTILE (The Corrupted Packet)
// We use 'spr_slot' as the packet because it looks like a digital box.
// Rotating it adds a nice effect!
var rotation = (current_time / 10) mod 360; 
draw_sprite_ext(spr_slot, 0, x, y, 1, 1, rotation, c_red, 1);

// 2. DRAW THE ARROWS (Following the Projectile)
// We draw them slightly above the packet (y - 50)
var arrow_spacing = 30; // Much tighter spacing
var total_width = (arrow_spacing * pattern_length);
var start_draw_x = x - (total_width / 2) + (arrow_spacing / 2);
var draw_y = y - 50;

for (var i = 0; i < pattern_length; i++) {
    var check_x = start_draw_x + (i * arrow_spacing);
    
    if (i <= index) {
        var spr = -1;
        // Map keys to sprites
        if (pattern[i] == vk_up) spr = spr_arrow_up;
        if (pattern[i] == vk_down) spr = spr_arrow_down;
        if (pattern[i] == vk_left) spr = spr_arrow_left;
        if (pattern[i] == vk_right) spr = spr_arrow_right;

        // Draw Arrow (Scaled down to 0.5)
        if (i < index) {
            // Completed (Green Tint)
            if (spr != -1) draw_sprite_ext(spr, 0, check_x, draw_y, 0.5, 0.5, 0, c_lime, 1);
        } 
        else if (i == index) {
            // Current Target (Normal + Pulsing size)
            var pulse = 0.5 + (sin(current_time / 100) * 0.1);
            if (spr != -1) draw_sprite_ext(spr, 0, check_x, draw_y, pulse, pulse, 0, c_yellow, 1);
        } 
        else {
            // Next in line (White)
            if (spr != -1) draw_sprite_ext(spr, 0, check_x, draw_y, 0.5, 0.5, 0, c_white, 1);
        }
    } else {
        // Hidden/Future arrows (Small dots)
        draw_set_color(c_gray);
        draw_circle(check_x, draw_y, 4, false);
        draw_set_color(c_white);
    }
}

// 3. DRAW TIMER (Small Bar under the packet)
var bar_w = 60;
var bar_h = 6;
var bar_x = x - (bar_w / 2);
var bar_y = y + 40;
var pct = timer / (room_speed * 4);

draw_set_color(c_red);
draw_rectangle(bar_x, bar_y, bar_x + (bar_w * pct), bar_y + bar_h, false);
draw_set_color(c_white); // Reset

// Reset Alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);