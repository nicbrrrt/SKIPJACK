// obj_game_controller — Draw GUI Event
// FIXED: Settings state no longer references undefined hover_exit/_y3 variables.

// --- DEBUG OVERLAY ---
if (global.DEBUG_MODE) {
    draw_set_font(-1);
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_set_alpha(0.55);
    draw_rectangle(640 - 175, 0, 640, 50, false);
    draw_set_alpha(1.0);
    draw_set_color(c_lime);
    draw_text(640 - 6, 5,  "[ DEBUG MODE ON ]");
    draw_set_color(c_yellow);
    draw_text(640 - 6, 20, "F2: toggle  F3/F4: combat  F5: instant win");
    draw_set_halign(fa_left);
}

// --- QUEST TRACKER: HALLWAY STAGE ---
var _qk_active = global.quest_talk_to_kyle   && !global.kyle_lesson_done;
var _qd_active = global.quest_talk_to_david  && !global.david_defeated;
var _qb_active = global.quest_talk_to_breado && !global.tutorial_complete;
var _qg_active = global.tutorial_complete    && !global.quest_find_greg_done;

if (room != rm_combat && room != rm_battle_scramble && room != rm_menu && room != rm_level_1
    && (_qk_active || _qd_active || _qb_active || _qg_active)) {

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var _qx      = 16;
    var _qy      = 16;
    var _scale   = 1.2;
    var _spacing = 22;

    // Dynamic box width — measure every visible item at scale
    var _max_w = string_width("OBJECTIVES:") * _scale;
    if (_qk_active) _max_w = max(_max_w, (string_width("> Talk to Kyle") + 5) * _scale);
    if (_qd_active) _max_w = max(_max_w, (string_width("> Find David and take his quiz") + 5) * _scale);
    if (_qb_active) _max_w = max(_max_w, (string_width("> Find Breado for combat training") + 5) * _scale);
    if (_qg_active) _max_w = max(_max_w, (string_width("> Find Greg at end of hall") + 5) * _scale);
    var _rows   = (_qk_active ? 1 : 0) + (_qd_active ? 1 : 0) + (_qb_active ? 1 : 0) + (_qg_active ? 1 : 0);
    var _box_w  = _max_w + 20;
    var _box_h  = _spacing * (_rows + 1) + 8;

    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(_qx - 5, _qy - 5, _qx + _box_w, _qy + _box_h, false);
    draw_set_alpha(1.0);

    draw_set_color(c_yellow);
    draw_text_transformed(_qx, _qy, "OBJECTIVES:", _scale, _scale, 0);

    var _row = 1;
    draw_set_color(c_white);
    if (_qk_active) { draw_text_transformed(_qx + 5, _qy + (_spacing * _row), "> Talk to Kyle", _scale, _scale, 0); _row++; }
    if (_qd_active) { draw_text_transformed(_qx + 5, _qy + (_spacing * _row), "> Find David and take his quiz", _scale, _scale, 0); _row++; }
    if (_qb_active) { draw_text_transformed(_qx + 5, _qy + (_spacing * _row), "> Find Breado for combat training", _scale, _scale, 0); _row++; }
    if (_qg_active) { draw_text_transformed(_qx + 5, _qy + (_spacing * _row), "> Find Greg at end of hall", _scale, _scale, 0); }

    // ── Secondary objective: inspect all hallway objects ─────────────────────
    if (_qd_active) {
        var _all_done = global.all_objects_inspected;
        var _obj_str  = _all_done ? "Completed." : "> Explore and inspect all the objects";

        var _sec_max_w = max(string_width("SECONDARY:"), string_width(_obj_str) + 5) * _scale;
        var _sec_w     = _sec_max_w + 20;
        var _sec_h     = _spacing * 2 + 8;
        var _sec_y     = _qy - 5 + _box_h + 8;   // 8 px gap below main box

        // Rapid white/black flash when newly completed
        var _fl_bg    = c_black;
        var _fl_alpha = 0.6;
        if (inspect_flash_timer > 0 && inspect_flash_timer mod 6 < 3) {
            _fl_bg    = c_white;
            _fl_alpha = 0.85;
        }
        draw_set_color(_fl_bg);
        draw_set_alpha(_fl_alpha);
        draw_rectangle(_qx - 5, _sec_y, _qx + _sec_w, _sec_y + _sec_h, false);
        draw_set_alpha(1);

        // "SECONDARY:" header
        draw_set_color(c_lime);
        draw_text_transformed(_qx, _sec_y + 5, "SECONDARY:", _scale, _scale, 0);

        // Objective text — dark green once done, white while active
        var _done_col = make_color_rgb(0, 140, 0);
        draw_set_color(_all_done ? _done_col : c_white);
        draw_text_transformed(_qx + 5, _sec_y + _spacing + 5, _obj_str, _scale, _scale, 0);

        // Strikethrough line over "Completed."
        if (_all_done) {
            var _tw = string_width(_obj_str) * _scale;
            var _th = string_height("Ag")   * _scale;
            draw_set_color(_done_col);
            draw_line(_qx + 5,       _sec_y + _spacing + 5 + _th * 0.5,
                      _qx + 5 + _tw, _sec_y + _spacing + 5 + _th * 0.5);
        }
    }
}

// --- QUEST TRACKER: LEVEL 1 (Find Greg) ---
if (room == rm_level_1 && global.quest_find_greg_done && !global.quest_greg_level1_done) {
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var _qx      = 16;
    var _qy      = 16;
    var _scale   = 1.2;
    var _spacing = 22;

    var _item   = "> Find Greg";
    var _box_w  = max(string_width("OBJECTIVES:"), string_width(_item) + 5) * _scale + 20;
    var _box_h  = _spacing * 2 + 8;

    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(_qx - 5, _qy - 5, _qx + _box_w, _qy + _box_h, false);
    draw_set_alpha(1.0);

    draw_set_color(c_yellow);
    draw_text_transformed(_qx, _qy, "OBJECTIVES:", _scale, _scale, 0);
    draw_set_color(c_white);
    draw_text_transformed(_qx + 5, _qy + _spacing, _item, _scale, _scale, 0);
}

// --- QUEST TRACKER: LEVEL 1 (Clipper + Lea) ---
if (room == rm_level_1 && global.greg_quest_started) {
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var _qx      = 16;
    var _qy      = 16;
    var _scale   = 1.2;
    var _spacing = 22;

    var _item1  = "> Find Clipper";
    var _item2  = "> Find Lea";
    var _box_w  = max(max(string_width("OBJECTIVES:"), string_width(_item1) + 5), string_width(_item2) + 5) * _scale + 20;
    var _box_h  = _spacing * 3 + 8;

    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(_qx - 5, _qy - 5, _qx + _box_w, _qy + _box_h, false);
    draw_set_alpha(1.0);

    draw_set_color(c_yellow);
    draw_text_transformed(_qx, _qy, "OBJECTIVES:", _scale, _scale, 0);

    draw_set_color(global.quest_clipper_done ? c_green : c_white);
    draw_text_transformed(_qx + 5, _qy + _spacing, _item1, _scale, _scale, 0);

    draw_set_color(global.quest_lea_done ? c_green : c_white);
    draw_text_transformed(_qx + 5, _qy + (_spacing * 2), _item2, _scale, _scale, 0);
}

// --- QUEST TRACKER: TUTORIAL VOID (Phase 2) ---
if (room == rm_tutorial_void && instance_exists(obj_tutorial_controller)
    && obj_tutorial_controller.tutorial_phase == 2) {

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var _qx      = 16;
    var _qy      = 16;
    var _scale   = 1.2;
    var _spacing = 22;

    var _item   = "> Walk to Greg and press E";
    var _box_w  = max(string_width("OBJECTIVES:"), string_width(_item) + 5) * _scale + 20;
    var _box_h  = _spacing * 2 + 8;

    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(_qx - 5, _qy - 5, _qx + _box_w, _qy + _box_h, false);
    draw_set_alpha(1.0);

    draw_set_color(c_yellow);
    draw_text_transformed(_qx, _qy, "OBJECTIVES:", _scale, _scale, 0);
    draw_set_color(c_white);
    draw_text_transformed(_qx + 5, _qy + _spacing, _item, _scale, _scale, 0);
}

// --- TOOLTIP (all gameplay rooms) ───────────────────────────────────────────
var _tip_in_gameplay = (room == rm_hallway   || room == rm_level_1
                     || room == rm_level_2   || room == rm_cutscene_lab);
if (_tip_in_gameplay && tip_state != "idle" && tip_alpha > 0 && tip_current_text != "") {

    var _tip    = tip_current_text;
    var _scale  = 1.2;

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    var _tw  = string_width(_tip)  * _scale;
    var _th  = string_height(_tip) * _scale;
    var _cx  = 320;       // center of 640-wide GUI
    var _ty  = 310;       // near bottom of 360-high GUI
    var _pad = 8;

    // Black semi-transparent background box
    draw_set_color(c_black);
    draw_set_alpha(tip_alpha * 0.6);
    draw_rectangle(_cx - _tw / 2 - _pad, _ty - _pad,
                   _cx + _tw / 2 + _pad, _ty + _th + _pad, false);

    // White tip text
    draw_set_alpha(tip_alpha);
    draw_set_color(c_white);
    draw_text_transformed(_cx, _ty, _tip, _scale, _scale, 0);

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Only draw pause menu when paused
if (!global.is_paused) exit;

if (pause_menu_state == "settings_ui") {
    if (!instance_exists(obj_settings_ui)) pause_menu_state = "main";
    else exit;
}

var _screen_w = display_get_gui_width();
var _screen_h = display_get_gui_height();
var _mx       = device_mouse_x_to_gui(0);
var _my       = device_mouse_y_to_gui(0);
var _clicked  = mouse_check_button_pressed(mb_left) && !mouse_locked_until_release;

// Dim background
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(0, 0, _screen_w, _screen_h, false);
draw_set_alpha(1.0);
draw_set_color(c_white);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var _x = _screen_w / 2;

// ============================================================
// STATE: MAIN PAUSE MENU
// ============================================================
if (pause_menu_state == "main") {

    draw_set_font(fnt_title);
    draw_text(_screen_w / 2, _screen_h * 0.25, "PAUSED");
    draw_set_font(fnt_button);

    var _y1 = _screen_h * 0.5;
    var _y2 = _y1 + 50;
    var _y3 = _y2 + 50;

    var hover_continue = point_in_rectangle(_mx, _my, _x - 100, _y1 - 20, _x + 100, _y1 + 20);
    var hover_settings = point_in_rectangle(_mx, _my, _x - 100, _y2 - 20, _x + 100, _y2 + 20);
    var hover_exit     = point_in_rectangle(_mx, _my, _x - 100, _y3 - 20, _x + 100, _y3 + 20);

    // Hover sound
    var current_hover = noone;
    if (hover_continue)      current_hover = "continue";
    else if (hover_settings) current_hover = "settings";
    else if (hover_exit)     current_hover = "exit";

    if (current_hover != hovered_button && current_hover != noone) {
        audio_play_sound(snd_button_hover, 10, false);
        hovered_button = current_hover;
    } else if (current_hover == noone) {
        hovered_button = noone;
    }

    // CONTINUE
    draw_set_color(hover_continue ? c_yellow : c_white);
    draw_text(_x, _y1, "CONTINUE");
    if (hover_continue && _clicked) {
        audio_play_sound(snd_button_click, 10, false);
        unpause_game();
        pause_menu_state          = "main";
        hovered_button            = noone;
        mouse_locked_until_release = true;
    }

    // SETTINGS
    draw_set_color(hover_settings ? c_yellow : c_white);
    draw_text(_x, _y2, "SETTINGS");
    if (hover_settings && _clicked) {
        audio_play_sound(snd_button_click, 10, false);
        open_pause_settings();
        hovered_button            = noone;
    }

    // EXIT
    draw_set_color(hover_exit ? c_yellow : c_white);
    draw_text(_x, _y3, "EXIT THE GAME");
    if (hover_exit && _clicked) {
        audio_play_sound(snd_button_click, 10, false);
        audio_stop_all();
        instance_activate_all();
        global.is_paused = false;
        if (instance_exists(obj_jack))           instance_destroy(obj_jack);
        if (instance_exists(obj_transition))      instance_destroy(obj_transition);
        if (instance_exists(obj_warp))            instance_destroy(obj_warp);
        if (instance_exists(obj_textevent))       instance_destroy(obj_textevent);
        if (instance_exists(obj_battle_scramble)) instance_destroy(obj_battle_scramble);
        pause_menu_state          = "main";
        hovered_button            = noone;
        mouse_locked_until_release = true;
        room_goto(rm_menu);
    }
}

// Reset draw state
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);