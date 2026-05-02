// --- Step Event for obj_codex_manager ---

var _is_combat_room = (room == rm_combat || room == rm_battle_scramble || room == rm_menu || room == rm_settings);

// ── Open / Close ─────────────────────────────────────────────────────────
if (is_open && (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("C")))) {
    is_open = false;
    // Reset button hover frames so menu doesn't stay lit after closing
    with (obj_button_master) { image_index = 0; }
    if (instance_exists(obj_jack)) {
        obj_jack.isInCutscene = false;
        obj_jack.image_speed  = 1;
    }
} else if (!is_open && global.tutorial_complete && !_is_combat_room && keyboard_check_pressed(ord("C"))) {
    is_open = true;
    // Force buttons to idle frame so nothing looks hovered while codex is up
    with (obj_button_master) { image_index = 0; }
    if (instance_exists(obj_jack)) {
        obj_jack.isInCutscene = true;
        obj_jack.image_speed  = 0;
    }
}

// ── Input when codex is open ─────────────────────────────────────────────
if (!is_open) exit;

var _mod_count = array_length(tab_modules[current_tab]);

// ── Mouse: Tab clicking ──────────────────────────────────────────────────
// GUI-space mouse coordinates are needed because Draw_64 renders in GUI layer
var _mx     = device_mouse_x_to_gui(0);
var _my     = device_mouse_y_to_gui(0);
var _tab_x1 = 120;
var _tab_y1 = 60;
var _tab_h  = 28;
var _tab_w  = 100;   // (520 - 120) / 4
var _num    = array_length(tab_names);

if (mouse_check_button_pressed(mb_left)) {
    if (_my >= _tab_y1 && _my <= _tab_y1 + _tab_h) {
        var _hit = floor((_mx - _tab_x1) / _tab_w);
        if (_hit >= 0 && _hit < _num && !tab_locked[_hit] && _hit != current_tab) {
            current_tab    = _hit;
            current_module = 0;
            if (asset_get_type("snd_page_flip") == asset_sound) {
                audio_play_sound(snd_page_flip, 10, false);
            }
        }
    }
}

// ── Mouse: Wheel scrolls through modules in the active tab ───────────────
if (mouse_wheel_up() && current_module > 0) {
    current_module--;
    if (asset_get_type("snd_page_flip") == asset_sound) {
        audio_play_sound(snd_page_flip, 10, false);
    }
}

if (mouse_wheel_down() && current_module < _mod_count - 1) {
    current_module++;
    if (asset_get_type("snd_page_flip") == asset_sound) {
        audio_play_sound(snd_page_flip, 10, false);
    }
}

// ── Keyboard: Arrow keys also navigate modules ───────────────────────────
if (keyboard_check_pressed(vk_right) && current_module < _mod_count - 1) {
    current_module++;
    if (asset_get_type("snd_page_flip") == asset_sound) {
        audio_play_sound(snd_page_flip, 10, false);
    }
}

if (keyboard_check_pressed(vk_left) && current_module > 0) {
    current_module--;
    if (asset_get_type("snd_page_flip") == asset_sound) {
        audio_play_sound(snd_page_flip, 10, false);
    }
}
