// --- Draw Event of obj_start_combat ---
if (visible) {
    // This draws the NPC 2 sprite assigned to this object
    draw_self(); 
    
    // Check distance to Jack
    var _player = instance_find(obj_jack, 0);
    if (_player != noone && point_distance(x, y, _player.x, _player.y) < interaction_range) {
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        
        // Draw "Press E to Talk" above the NPC's head (adjust -40 if needed)
        draw_text(x, y - 48, "Press E to Talk"); 
        
        draw_set_halign(fa_left);
    }
}