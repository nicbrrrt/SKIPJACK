// --- obj_review_screen Step Event ---

review_refresh_layout();

if (keyboard_check_pressed(vk_escape)) {
    with (obj_button_master) { image_index = 0; }
    instance_destroy();
    exit;
}

var _mod_count = review_active_mod_count();
var _locked    = tabs[current_tab].locked;
var _mod       = review_active_mod();
var _max_scroll = _locked ? 0 : review_max_scroll(_mod.content);

// ── Mouse: click a tab ────────────────────────────────────────────────────
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

if (mouse_check_button_pressed(mb_left)) {
    if (_my >= tab_strip_y && _my <= tab_strip_y + tab_h) {
        var _hit = floor((_mx - card_x) / tab_w);
        if (_hit >= 0 && _hit < tab_cnt && !tabs[_hit].locked && _hit != current_tab) {
            current_tab    = _hit;
            current_module = 0;
            content_scroll = 0;
            if (asset_get_type("snd_page_flip") == asset_sound)
                audio_play_sound(snd_page_flip, 10, false);
        }
    }
}

if (_locked) exit;

// ── Scroll: wheel moves text first, then modules ────────────────────────
if (mouse_wheel_up()) {
    if (content_scroll > 0) {
        content_scroll = max(0, content_scroll - 24);
    } else if (current_module > 0) {
        current_module--;
        _mod = review_active_mod();
        content_scroll = review_max_scroll(_mod.content);
        if (asset_get_type("snd_page_flip") == asset_sound)
            audio_play_sound(snd_page_flip, 10, false);
    }
}

if (mouse_wheel_down()) {
    if (content_scroll < _max_scroll) {
        content_scroll = min(_max_scroll, content_scroll + 24);
    } else if (current_module < _mod_count - 1) {
        current_module++;
        content_scroll = 0;
        if (asset_get_type("snd_page_flip") == asset_sound)
            audio_play_sound(snd_page_flip, 10, false);
    }
}

// ── Keyboard: Up / Down navigate modules or scroll ───────────────────────
if (keyboard_check_pressed(vk_up)) {
    if (content_scroll > 0) {
        content_scroll = max(0, content_scroll - 24);
    } else if (current_module > 0) {
        current_module--;
        _mod = review_active_mod();
        content_scroll = review_max_scroll(_mod.content);
        if (asset_get_type("snd_page_flip") == asset_sound)
            audio_play_sound(snd_page_flip, 10, false);
    }
}

if (keyboard_check_pressed(vk_down)) {
    if (content_scroll < _max_scroll) {
        content_scroll = min(_max_scroll, content_scroll + 24);
    } else if (current_module < _mod_count - 1) {
        current_module++;
        content_scroll = 0;
        if (asset_get_type("snd_page_flip") == asset_sound)
            audio_play_sound(snd_page_flip, 10, false);
    }
}
