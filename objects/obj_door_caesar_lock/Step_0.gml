/// @description obj_door_caesar_lock — Step Event
/// Press E when adjacent to open the Cipher Decoding UI (obj_cipher).
/// - Breaker Room door (is_breaker_door): Sealed under lockdown; automatically unlocks
///   the moment the player completes the Lockdown Override Console (global.lockdown_overridden)!
/// - Extraction Elevator door (is_elevator_door): Requires Key + Lockdown Override + Power Restored.

anim_t++;
if (unseal_flash > 0) unseal_flash--;

// Unseal the Power Breaker Room door on camera right after the Lockdown Override Console closes!
if (locked && is_breaker_door && variable_global_exists("lockdown_overridden") && global.lockdown_overridden) {
    var _ui_still_open = (variable_global_exists("override_ui_open") && global.override_ui_open);
    if (!_ui_still_open) {
        unseal_anim_t++;
        if (unseal_anim_t >= 20) {
            locked       = false;
            unseal_flash = 90;
            x            = -10000;
            y            = -10000;
            var _snd = audio_play_sound(snd_button_click, 8, false);
            audio_sound_pitch(_snd, 1.35);
            exit;
        }
    }
}

if (!variable_instance_exists(id, "text_cooldown")) text_cooldown = 0;
if (instance_exists(obj_textevent)
    || (variable_global_exists("override_ui_open") && global.override_ui_open)
    || (variable_global_exists("breaker_ui_open")  && global.breaker_ui_open))
{
    text_cooldown = 5;
    exit;
}
if (text_cooldown > 0) {
    text_cooldown--;
    exit;
}

if (locked && instance_exists(obj_jack)) {
    if (!instance_exists(obj_dungeon_quiz) && !instance_exists(obj_cipher) && !instance_exists(obj_dungeon_victory)) {
        if (point_distance(obj_jack.x, obj_jack.y - 8, draw_x + 8, draw_y + 8) < 28) {
            if (keyboard_check_pressed(ord("E"))) {
                var _has_key    = (variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key);
                var _overridden = (variable_global_exists("lockdown_overridden")    && global.lockdown_overridden);
                var _powered    = (variable_global_exists("power_restored")         && global.power_restored);

                // 1. Power Breaker Room Door (Locked until Lockdown Override is pressed)
                if (is_breaker_door) {
                    audio_play_sound(wrong1, 10, false);
                    global.e_dialogue_intro_shown = true;
                    create_textevent([
                        "SEALED BY LOCKDOWN! The Power Breaker Room is locked down.",
                        "I need to unlock the Security Control Room and hit the Red Lockdown Override Button to unseal this door!"
                    ], [obj_jack.id, obj_jack.id]);
                    exit;
                }

                // 2. All Encrypted Doors in the hallway require the Floor Cipher Key first!
                //    (Only exception: if a drone caught Jack and he is currently trapped INSIDE ROOM_HOLDING,
                //    where he uses the Brig's whiteboard math equation to escape.)
                var _trapped_in_brig = (is_holding_door
                    && instance_exists(obj_dungeon_generator)
                    && obj_dungeon_generator.logic_map[obj_dungeon_generator.active_col][obj_dungeon_generator.active_row] == ROOM_HOLDING);

                if (!_trapped_in_brig && !_has_key) {
                    audio_play_sound(wrong1, 10, false);
                    global.e_dialogue_intro_shown = true;
                    create_textevent([
                        "ENCRYPTED DOOR LOCKED — CIPHER KEY REQUIRED!",
                        "I can't try to solve this encrypted door without the Floor Key! I need to find the Cyber Clues and unlock the Gold Key Vault first."
                    ], [obj_jack.id, obj_jack.id]);
                    exit;
                }

                // 3. Once the player has the Floor Key, ANY Encrypted Door can be decoded to discover what room is behind its 100% opaque fog!
                instance_create_depth(draw_x, draw_y, -15000, obj_cipher);
            }
        }
    }
}
