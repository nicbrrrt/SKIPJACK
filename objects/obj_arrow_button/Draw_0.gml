// --- Draw Event for obj_arrow_button ---

// 1. THE ROOM GUARD: If we aren't in the combat room, hide these buttons
if (room != rm_combat) exit;

// --- 1. Choose button color ---
var _color = c_gray; 

if (mouse_is_over && mouse_check_button(mb_left))
{
    _color = c_yellow; 
}
else if (mouse_is_over)
{
    _color = c_ltgray; 
}

// --- 2. Draw the button box ---
draw_set_color(_color);
draw_rectangle(x, y, x + box_width, y + box_height, false);

// --- 3. Draw the text (e.g., "<" or ">") ---
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Only draw if display_text has a value
if (variable_instance_exists(id, "display_text")) {
    draw_text(x + box_width / 2, y + box_height / 2, display_text);
}

// Reset for other objects
draw_set_halign(fa_left);
draw_set_valign(fa_top);