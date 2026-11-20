// --- Step Event for obj_codex_manager ---

scr_init_cyber_glossary();
if (toast_timer > 0) toast_timer--;

var _in_homeroom = (room == rm_homeroom);
var _ui_busy = instance_exists(obj_textbox)
            || instance_exists(obj_textevent)
            || instance_exists(obj_dungeon_quiz)
            || instance_exists(obj_dungeon_victory)
            || (variable_global_exists("is_paused") && global.is_paused)
            || (variable_global_exists("pc_screen_open") && global.pc_screen_open)
            || (variable_global_exists("active_term_popup") && global.active_term_popup != undefined);

// ── Open / Close (Homeroom-Only!) ────────────────────────────────────────
if (is_open && (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("C")))) {
    if (keyboard_check_pressed(vk_escape)) {
        global.esc_block_frames = 2;
        keyboard_clear(vk_escape);
    }
    is_open = false;
    with (obj_button_master) { image_index = 0; }
    if (instance_exists(obj_jack)) {
        obj_jack.isInCutscene = false;
        obj_jack.image_speed  = 1;
    }
} else if (!is_open && !_ui_busy && keyboard_check_pressed(ord("C"))) {
    if (_in_homeroom) {
        is_open        = true;
        global.codex_new_count = 0;
        content_scroll = 0;
        with (obj_button_master) { image_index = 0; }
        if (instance_exists(obj_jack)) {
            obj_jack.isInCutscene = true;
            obj_jack.image_speed  = 0;
        }
    } else if (instance_exists(obj_dungeon_generator)) {
        toast_timer = 150;
        toast_msg   = "Homeroom Codex only opens in your HOMEROOM! Click [? Terms] during missions to archive them.";
    }
}

// Demo shortcut inside Homeroom: Ctrl + U unlocks all 27 Codex entries
if (_in_homeroom && keyboard_check(vk_control) && keyboard_check_pressed(ord("U"))) {
    for (var _gi = 0; _gi < array_length(global.cyber_glossary); _gi++) {
        global.codex_unlocked_terms[$ global.cyber_glossary[_gi].id] = true;
    }
    toast_timer = 120;
    toast_msg   = "DEMO: All 27 Cybersecurity Codex entries unlocked!";
    if (asset_get_type("snd_correct_ping") == asset_sound) audio_play_sound(snd_correct_ping, 8, false);
}

if (!is_open) exit;

var _branch_terms = get_branch_terms(current_branch);
var _term_count   = array_length(_branch_terms);
current_concept   = clamp(current_concept, 0, max(0, _term_count - 1));

// Keyboard navigation: Left/Right or A/D switches Branch Tab; Up/Down or W/S switches Concept
var _num_tabs = array_length(tab_names);
if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
    current_branch  = (current_branch + 1) mod _num_tabs;
    current_concept = 0;
    content_scroll  = 0;
    if (asset_get_type("snd_page_flip") == asset_sound) audio_play_sound(snd_page_flip, 10, false);
}
if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) {
    current_branch  = (current_branch + _num_tabs - 1) mod _num_tabs;
    current_concept = 0;
    content_scroll  = 0;
    if (asset_get_type("snd_page_flip") == asset_sound) audio_play_sound(snd_page_flip, 10, false);
}

if (_term_count > 0) {
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
        current_concept = (current_concept + 1) mod _term_count;
        content_scroll  = 0;
        if (asset_get_type("snd_button_hover") == asset_sound) audio_play_sound(snd_button_hover, 6, false);
    }
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
        current_concept = (current_concept + _term_count - 1) mod _term_count;
        content_scroll  = 0;
        if (asset_get_type("snd_button_hover") == asset_sound) audio_play_sound(snd_button_hover, 6, false);
    }
}

if (mouse_wheel_up())   content_scroll = max(0, content_scroll - 24);
if (mouse_wheel_down()) content_scroll = min(max_scroll_h, content_scroll + 24);
