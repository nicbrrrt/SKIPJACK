depth = -y;

if (!variable_instance_exists(id, "idle_facing"))    idle_facing = "down";
if (!variable_instance_exists(id, "idle_anim_acc"))  idle_anim_acc = 0;
if (!variable_instance_exists(id, "isInCutscene"))     isInCutscene = false;

if (!isInCutscene && !instance_exists(obj_textevent) && sprite_index != -1) {
    image_speed = 0;
    var _r = scr_dir_idle_anim(sprite_index, idle_facing, idle_anim_acc, 0.1);
    image_index = _r[0];
    idle_anim_acc = _r[1];
}
