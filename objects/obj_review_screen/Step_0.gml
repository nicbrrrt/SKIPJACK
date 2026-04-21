// --- obj_review_screen Step Event ---

// ESC closes the overlay
if (keyboard_check_pressed(vk_escape)) {
    // Restore button idle frames before destroying
    with (obj_button_master) { image_index = 0; }
    instance_destroy();
    exit;
}

var _tab_cnt   = array_length(tabs);
var _mod_count = array_length(tabs[current_tab].modules);

// ── Mouse: click a tab ────────────────────────────────────────────────────
// Compute the same card/tab geometry used in Draw_64
var _gw     = display_get_gui_width();
var _gh     = display_get_gui_height();
var _card_w = _gw * 0.80;
var _card_x = (_gw - _card_w) / 2;
var _card_y = (_gh - _gh * 0.84) / 2;
var _tab_h  = 42;
var _tab_w  = _card_w / _tab_cnt;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

if (mouse_check_button_pressed(mb_left)) {
    if (_my >= _card_y && _my <= _card_y + _tab_h) {
        var _hit = floor((_mx - _card_x) / _tab_w);
        if (_hit >= 0 && _hit < _tab_cnt && !tabs[_hit].locked && _hit != current_tab) {
            current_tab    = _hit;
            current_module = 0;
            if (asset_get_type("snd_page_flip") == asset_sound)
                audio_play_sound(snd_page_flip, 10, false);
        }
    }
}

// ── Mouse: wheel scrolls modules within the active tab ────────────────────
if (mouse_wheel_up() && current_module > 0) {
    current_module--;
    if (asset_get_type("snd_page_flip") == asset_sound)
        audio_play_sound(snd_page_flip, 10, false);
}

if (mouse_wheel_down() && current_module < _mod_count - 1) {
    current_module++;
    if (asset_get_type("snd_page_flip") == asset_sound)
        audio_play_sound(snd_page_flip, 10, false);
}

// ── Keyboard: Up / Down navigate modules within the active tab ────────────
if (keyboard_check_pressed(vk_up) && current_module > 0) {
    current_module--;
    if (asset_get_type("snd_page_flip") == asset_sound)
        audio_play_sound(snd_page_flip, 10, false);
}

if (keyboard_check_pressed(vk_down) && current_module < _mod_count - 1) {
    current_module++;
    if (asset_get_type("snd_page_flip") == asset_sound)
        audio_play_sound(snd_page_flip, 10, false);
}
