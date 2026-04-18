// --- obj_review_screen Step Event ---
// Handles keyboard shortcuts, mouse interaction, and scrolling.

// ── ESC always closes ─────────────────────────────────────────────────────────
if (keyboard_check_pressed(vk_escape)) {
    instance_destroy();
    exit;
}

// ── Mouse position in GUI space ───────────────────────────────────────────────
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _card_w = _gw * 0.80;
var _card_h = _gh * 0.84;
var _card_x = (_gw - _card_w) / 2;
var _card_y = (_gh - _card_h) / 2;
var _pad    = 28;

// ─────────────────────────────────────────────────────────────────────────────
// VIEW MODE: "tabs"  — main tab selection list
// ─────────────────────────────────────────────────────────────────────────────
if (view_mode == "tabs") {

    var _tab_cnt   = array_length(main_tabs);
    var _tab_h_px  = 54;
    var _tab_gap   = 10;
    var _tab_w_px  = _card_w - _pad * 2;
    var _tab_start_y = _card_y + 60;

    hovered_tab = -1;
    for (var i = 0; i < _tab_cnt; i++) {
        var _ty = _tab_start_y + i * (_tab_h_px + _tab_gap);
        if (_mx >= _card_x + _pad && _mx <= _card_x + _pad + _tab_w_px
         && _my >= _ty            && _my <= _ty + _tab_h_px) {
            hovered_tab = i;
        }
    }

    // Click → enter content mode for that tab
    if (mouse_check_button_pressed(mb_left) && hovered_tab >= 0) {
        selected_tab = hovered_tab;
        current_sub  = 0;
        scroll_y     = 0;
        view_mode    = "content";
        if (asset_get_type("snd_button_click") == asset_sound)
            audio_play_sound(snd_button_click, 10, false);
    }

    // Keyboard fallback (arrow keys + Enter)
    if (keyboard_check_pressed(vk_down))  selected_tab = min(selected_tab + 1, _tab_cnt - 1);
    if (keyboard_check_pressed(vk_up))    selected_tab = max(selected_tab - 1, 0);
    if (keyboard_check_pressed(vk_enter)) {
        current_sub = 0;
        scroll_y    = 0;
        view_mode   = "content";
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// VIEW MODE: "content"  — sub-tab strip + body + Back button
// ─────────────────────────────────────────────────────────────────────────────
else if (view_mode == "content") {

    var _sub_cnt = array_length(main_tabs[selected_tab].sub_tabs);
    var _sub_h   = 36;
    var _sub_w   = (_card_w - _pad * 2) / _sub_cnt;
    var _sub_y   = _card_y + 42;

    // Back button region (top-left inside card)
    var _back_x1 = _card_x + _pad;
    var _back_x2 = _card_x + _pad + 70;
    var _back_y1 = _card_y + 8;
    var _back_y2 = _card_y + 32;

    hover_back = (_mx >= _back_x1 && _mx <= _back_x2
               && _my >= _back_y1 && _my <= _back_y2);

    // Click Back
    if (mouse_check_button_pressed(mb_left) && hover_back) {
        view_mode = "tabs";
        scroll_y  = 0;
        if (asset_get_type("snd_button_click") == asset_sound)
            audio_play_sound(snd_button_click, 10, false);
    }

    // Sub-tab hover
    hovered_sub = -1;
    for (var i = 0; i < _sub_cnt; i++) {
        var _sx = _card_x + _pad + i * _sub_w;
        if (_mx >= _sx && _mx <= _sx + _sub_w
         && _my >= _sub_y && _my <= _sub_y + _sub_h) {
            hovered_sub = i;
        }
    }

    // Click sub-tab
    if (mouse_check_button_pressed(mb_left) && hovered_sub >= 0 && !hover_back) {
        current_sub = hovered_sub;
        scroll_y    = 0;
        if (asset_get_type("snd_page_flip") == asset_sound)
            audio_play_sound(snd_page_flip, 10, false);
    }

    // Keyboard arrow-left/right to switch sub-tabs
    if (keyboard_check_pressed(vk_right)) {
        current_sub = min(current_sub + 1, _sub_cnt - 1);
        scroll_y    = 0;
        if (asset_get_type("snd_page_flip") == asset_sound)
            audio_play_sound(snd_page_flip, 10, false);
    }
    if (keyboard_check_pressed(vk_left)) {
        current_sub = max(current_sub - 1, 0);
        scroll_y    = 0;
        if (asset_get_type("snd_page_flip") == asset_sound)
            audio_play_sound(snd_page_flip, 10, false);
    }

    // Backspace / B → back to main tabs
    if (keyboard_check_pressed(vk_backspace) || keyboard_check_pressed(ord("B"))) {
        view_mode = "tabs";
        scroll_y  = 0;
    }

    // Mouse-wheel scrolling
    var _wheel = mouse_wheel_up() ? -1 : (mouse_wheel_down() ? 1 : 0);
    scroll_y += _wheel * 20;
    if (scroll_y < 0) scroll_y = 0;
}
