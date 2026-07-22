if (variable_global_exists("is_paused") && global.is_paused) exit;

draw_set_alpha(0.92);
draw_set_color(c_black);
draw_rectangle(0, 0, 640, 360, false);

draw_set_alpha(1.0);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_dialogue);

draw_set_color(c_lime);
draw_text(320, 25, "[ THE ATBASH MIRROR ]");

draw_set_color(c_gray);
draw_line(100, 35, 540, 35);

draw_set_color(c_white);
draw_text(320, 50, "The alphabet folds in half. Each letter maps to its mirror opposite.");

var start_x = 320 - (13 * 30) / 2 + 15;
var spacing = 30;

for (var i = 0; i < 13; i++) {
    var xx = start_x + (i * spacing);
    
    draw_set_color(c_lime);
    draw_roundrect_ext(xx - 12, 100 - 14, xx + 12, 100 + 14, 4, 4, true);
    draw_set_color(c_white);
    draw_text(xx, 100, alpha_top[i]);
    
    draw_set_color(c_yellow);
    draw_roundrect_ext(xx - 12, 160 - 14, xx + 12, 160 + 14, 4, 4, true);
    draw_set_color(c_white);
    draw_text(xx, 160, alpha_bottom[i]);
    
    draw_set_alpha(0.3);
    draw_set_color(c_gray);
    draw_line(xx, 114, xx, 146);
    draw_set_alpha(1.0);
}

draw_set_color(c_yellow);
draw_line(50, 140, 250, 140);
draw_line(390, 140, 590, 140);
draw_text(320, 140, "< MIRROR FOLD >");

draw_set_color(c_white);
draw_text(320, 200, "EXAMPLE:");

var ex_str1 = "HELLO";
var ex_str2 = "SVOOL";
var ex_x_start = 320 - (5 * 40) / 2 + 20;

for (var i = 0; i < 5; i++) {
    var ex_x = ex_x_start + (i * 40);
    draw_set_color(c_lime);
    draw_text(ex_x - 10, 230, string_char_at(ex_str1, i + 1));
    
    draw_set_color(c_gray);
    draw_text(ex_x, 230, "->");
    
    draw_set_color(c_yellow);
    draw_text(ex_x + 15, 230, string_char_at(ex_str2, i + 1));
}

var bob = sin(anim_timer * 0.1) * 3;
draw_set_color(c_lime);
draw_text(320, 310 + bob, "[ E ] or [ ESC ] to close");

anim_timer++;

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
