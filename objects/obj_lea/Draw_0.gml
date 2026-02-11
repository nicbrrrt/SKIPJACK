// Draw the character itself
draw_self();

// Only show the "!" if the quest hasn't been completed yet
var _is_done = (object_index == obj_clipper) ? global.quest_clipper_done : global.quest_lea_done;

if (!_is_done && visible) {
    var _bob = sin(get_timer() / 250000) * 5; // Simple floating math
    
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    // Draw "!" 40 pixels above the sprite
    draw_text(x, y - 40 + _bob, "!"); 
    draw_set_halign(fa_left); // Reset
}