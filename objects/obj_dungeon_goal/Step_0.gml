/// @description obj_dungeon_goal — Step Event
/// Detects when Jack reaches the End room goal beacon.

anim_timer++;

if (!triggered && instance_exists(obj_jack) && !instance_exists(obj_dungeon_victory)) {
    if (place_meeting(x, y, obj_jack) || point_distance(x, y, obj_jack.x, obj_jack.y) < 14) {
        triggered = true;
        global.dungeons_cleared++;

        audio_play_sound(snd_objective_complete, 10, false);
        instance_create_layer(0, 0, "Instances", obj_dungeon_victory);
    }
}
