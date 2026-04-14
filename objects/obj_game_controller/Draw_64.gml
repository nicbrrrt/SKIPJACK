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
    draw_text(640 - 6, 20, "F2: toggle debug  F3: skip combat");
    draw_set_halign(fa_left);
}

// --- QUEST TRACKER ---
if (room == rm_level_1 && global.greg_quest_started) {
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var _qx      = 15;
    var _qy      = 15;
    var _spacing = 18;

    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(_qx - 5, _qy - 5, _qx + 160, _qy + 60, false);
    draw_set_alpha(1.0);

    draw_set_color(c_yellow);
    draw_text(_qx, _qy, "OBJECTIVES:");

    var _c_color = global.quest_clipper_done ? c_green : c_white;
    draw_text_color(_qx + 5, _qy + _spacing, "> Find Clipper", _c_color, _c_color, _c_color, _c_color, 1);

    var _l_color = global.quest_lea_done ? c_green : c_white;
    draw_text_color(_qx + 5, _qy + (_spacing * 2), "> Find Lea", _l_color, _l_color, _l_color, _l_color, 1);
}

// Only draw pause menu when paused
if (!global.is_paused) exit;

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
        instance_activate_all();
        audio_resume_all();
        global.is_paused          = false;
        pause_menu_state          = "main";
        hovered_button            = noone;
        mouse_locked_until_release = true;
    }

    // SETTINGS
    draw_set_color(hover_settings ? c_yellow : c_white);
    draw_text(_x, _y2, "SETTINGS");
    if (hover_settings && _clicked) {
        audio_play_sound(snd_button_click, 10, false);
        pause_menu_state          = "settings";
        hovered_button            = noone;
        mouse_locked_until_release = true;
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

// ============================================================
// STATE: SETTINGS MENU
// FIXED: This block is now self-contained. No longer references
//        hover_exit or _y3 from the main state block.
// ============================================================
else if (pause_menu_state == "settings") {

    draw_set_font(fnt_title);
    draw_text(_screen_w / 2, _screen_h * 0.25, "SETTINGS");

    draw_set_font(fnt_button);
    draw_text(_screen_w / 2, _screen_h * 0.5, "Volume, Fullscreen, etc...");

    // BACK button — defined locally in this state
    var _y_back     = _screen_h * 0.8;
    var hover_back  = point_in_rectangle(_mx, _my, _x - 100, _y_back - 20, _x + 100, _y_back + 20);

    if (hover_back && hovered_button != "back") {
        audio_play_sound(snd_button_hover, 10, false);
        hovered_button = "back";
    } else if (!hover_back) {
        hovered_button = noone;
    }

    draw_set_color(hover_back ? c_yellow : c_white);
    draw_text(_x, _y_back, "< BACK");
    if (hover_back && _clicked) {
        audio_play_sound(snd_button_click, 10, false);
        pause_menu_state          = "main";
        hovered_button            = noone;
        mouse_locked_until_release = true;
    }
}

// Reset draw state
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);