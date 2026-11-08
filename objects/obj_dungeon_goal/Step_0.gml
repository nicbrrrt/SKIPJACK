/// @description obj_dungeon_goal — Step Event
/// Detects when Jack reaches the End room Extraction Elevator cab.
/// Requires Lockdown Override + Power Restored before extraction can proceed.

anim_timer++;
if (warn_cd > 0) warn_cd--;

if (!instance_exists(obj_jack) || instance_exists(obj_dungeon_victory)) exit;

var _dist     = point_distance(x, y, obj_jack.x, obj_jack.y);
var _touching = (place_meeting(x, y, obj_jack) || _dist < 14);

// Reset overlap warning once Jack steps away from the cab
if (_dist > 28) {
    warned_this_overlap = false;
}

if (!triggered && _touching) {
    var _overridden = (variable_global_exists("lockdown_overridden") && global.lockdown_overridden);
    var _powered    = (variable_global_exists("power_restored")      && global.power_restored);

    // Player reached the elevator room! Flag as found
    global.elevator_room_found = true;

    if (!_overridden || !_powered) {
        if (!warned_this_overlap && warn_cd <= 0 && !instance_exists(obj_textevent) && !instance_exists(obj_textbox)) {
            warned_this_overlap = true;
            warn_cd = 120;
            audio_play_sound(wrong1, 10, false);

            // Nudge Jack slightly backward toward the entrance so he doesn't stand inside the cab collider
            var _push_dir = point_direction(x, y, obj_jack.x, obj_jack.y);
            if (_dist < 2) _push_dir = 90;
            obj_jack.x += lengthdir_x(14, _push_dir);
            obj_jack.y += lengthdir_y(14, _push_dir);

            if (!_overridden) {
                create_textevent([
                    "I found the Extraction Elevator, but the cab is locked down!",
                    "I need to search the other Encrypted Doors to find the Security Control Room and hit the Red Lockdown Override Button first!"
                ], [obj_jack.id, obj_jack.id]);
            } else {
                create_textevent([
                    "I found the Extraction Elevator, but the cab has no power!",
                    "I need to head to the unsealed Cyan Power Breaker Room and flip the fuses to bring the Elevator online!"
                ], [obj_jack.id, obj_jack.id]);
            }
        }
        exit;
    }

    triggered              = true;
    global.lockdown_lifted = true;
    global.dungeons_cleared++;

    audio_play_sound(snd_objective_complete, 10, false);
    instance_create_layer(0, 0, "Instances", obj_dungeon_victory);
}
