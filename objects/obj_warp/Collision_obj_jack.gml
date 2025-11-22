// 1. Check if we already have a transition
if (instance_exists(obj_transition)) 
{
    // If one exists, GRAB it and reset it
    var _trans = instance_find(obj_transition, 0);
    
    // Only take control if it's currently idle or finished
    if (_trans.fade_mode == "idle" || _trans.fade_alpha <= 0)
    {
        _trans.target_room = rm_hallway;
        _trans.target_x = target_x;
        _trans.target_y = target_y;
        _trans.fade_mode = "fading_out"; // Restart the fade!
        _trans.fade_timer = _trans.fade_timer_max; // Reset timer
    }
}
else 
{
    // 2. If NONE exists, create a new one (Standard logic)
    var _trans = instance_create_depth(0, 0, -9999, obj_transition);
    
    _trans.target_room = rm_hallway;
    _trans.target_x = target_x;
    _trans.target_y = target_y;
    _trans.fade_mode = "fading_out";
    _trans.fade_alpha = 0;
}