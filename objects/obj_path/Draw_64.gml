draw_set_font(fnt_default);
draw_set_color(c_white);

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

// Grid position
origin_x = gui_width / 2 - (grid_w * cell) / 2;
origin_y = gui_height / 2 - (grid_h * cell) / 2;

// --- DRAW DARK BACKGROUND PANEL ---
// This makes the text pop and hides the sprites behind the grid
draw_set_alpha(0.8);
draw_set_color(c_black);
draw_rectangle(0, origin_y - 60, gui_width, origin_y + (grid_h * cell) + 20, false);
draw_set_alpha(1);
draw_set_color(c_white);

// Instructions (Moved DOWN to Y=80 to avoid overlapping HP text)
draw_set_halign(fa_center);
draw_text(gui_width / 2, origin_y - 50, "PATHFINDING: Connect S to G");
draw_text(gui_width / 2, origin_y - 25, "ARROWS: Draw | BACKSPACE: Undo | ENTER: Submit");
draw_set_halign(fa_left);


// Draw grid
for (var gx = 0; gx < grid_w; gx++) {
    for (var gy = 0; gy < grid_h; gy++) {
        var draw_x = origin_x + gx * cell;
        var draw_y = origin_y + gy * cell;
        
        draw_set_color(c_white);
        draw_rectangle(draw_x, draw_y, draw_x + cell, draw_y + cell, false);
        
        var is_obstacle = false;
        for (var i = 0; i < array_length(obstacles); i++) {
            var obs = obstacles[i];
            if (obs[0] == gx && obs[1] == gy) {
                is_obstacle = true;
                break;
            }
        }
        
        if (is_obstacle) {
            draw_sprite(spr_wall, 0, draw_x + cell/2, draw_y + cell/2);
        }
    }
}

// Start position
var start_draw_x = origin_x + start[0] * cell + cell/2;
var start_draw_y = origin_y + start[1] * cell + cell/2;
draw_sprite(spr_start74, 0, start_draw_x, start_draw_y);
draw_text(start_draw_x - 10, start_draw_y - 10, "S");

// Target position
var target_draw_x = origin_x + target[0] * cell + cell/2;
var target_draw_y = origin_y + target[1] * cell + cell/2;
draw_sprite(spr_goal, 0, target_draw_x, target_draw_y);
draw_text(target_draw_x - 10, target_draw_y - 10, "G");

// Player path
for (var i = 0; i < array_length(path_nodes); i++) {
    var node = path_nodes[i];
    var node_draw_x = origin_x + node[0] * cell + cell/2;
    var node_draw_y = origin_y + node[1] * cell + cell/2;
    draw_sprite(spr_path, 0, node_draw_x, node_draw_y);
}

// Cursor
if (current_time mod 1000 < 500) {
    var cursor_draw_x = origin_x + cursor_x * cell + cell/2;
    var cursor_draw_y = origin_y + cursor_y * cell + cell/2;
    draw_set_color(c_blue);
    draw_rectangle(cursor_draw_x - 12, cursor_draw_y - 12, cursor_draw_x + 12, cursor_draw_y + 12, false);
}

draw_set_color(c_white);