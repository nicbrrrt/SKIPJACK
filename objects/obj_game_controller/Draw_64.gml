/// Draw GUI Event - obj_game_controller

// Only draw while paused
if (!global.is_paused) exit;

var _screen_w = display_get_gui_width();
var _screen_h = display_get_gui_height();
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// Use pressed state here but consume with mouse_locked_until_release to avoid carry-over
var _clicked = mouse_check_button_pressed(mb_left) && !mouse_locked_until_release;

// Dim background
draw_set_alpha(0.7);
draw_rectangle_color(0, 0, _screen_w, _screen_h, c_black, c_black, c_black, c_black, false);
draw_set_alpha(1.0);

draw_set_font(fnt_button);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Helper: reset hovered when switching states
// (we will reset hovered when we actually switch, too)
var _x = _screen_w / 2;

if (pause_menu_state == "main")
{
    draw_set_font(fnt_title);
    draw_text(_screen_w/2, _screen_h*0.25, "PAUSED");
    draw_set_font(fnt_button);

    var _y1 = _screen_h * 0.5;      // Continue
    var _y2 = _y1 + 50;            // Settings
    var _y3 = _y2 + 50;            // Exit

    var hover_continue = point_in_rectangle(_mx, _my, _x - 100, _y1 - 20, _x + 100, _y1 + 20);
    var hover_settings = point_in_rectangle(_mx, _my, _x - 100, _y2 - 20, _x + 100, _y2 + 20);
    var hover_exit     = point_in_rectangle(_mx, _my, _x - 100, _y3 - 20, _x + 100, _y3 + 20);

    // Hover sound only when hovered changes and button exists in this state
    var current_hover = noone;
    if (hover_continue) current_hover = "continue";
    else if (hover_settings) current_hover = "settings";
    else if (hover_exit) current_hover = "exit";

    if (current_hover != hovered_button && current_hover != noone)
    {
        audio_play_sound(snd_button_hover, 10, false);
        hovered_button = current_hover;
    }
    else if (current_hover == noone)
    {
        hovered_button = noone;
    }

    // CONTINUE
    draw_set_color(hover_continue ? c_yellow : c_white);
    draw_text(_x, _y1, "CONTINUE");
    if (hover_continue && _clicked)
    {
        audio_play_sound(snd_button_click, 10, false);
        instance_activate_all();
        audio_resume_all();
        global.is_paused = false;
        pause_menu_state = "main";
        hovered_button = noone;
        mouse_locked_until_release = true;
    }

    // SETTINGS
    draw_set_color(hover_settings ? c_yellow : c_white);
    draw_text(_x, _y2, "SETTINGS");
    if (hover_settings && _clicked)
    {
        audio_play_sound(snd_button_click, 10, false);
        pause_menu_state = "settings";
        hovered_button = noone;         // RESET hover so old button doesn't stay active
        mouse_locked_until_release = true; // prevent carry-over of the same click
    }

    // EXIT
    draw_set_color(hover_exit ? c_yellow : c_white);
    draw_text(_x, _y3, "EXIT THE GAME");
    if (hover_exit && _clicked)
    {
        audio_play_sound(snd_button_click, 10, false);
        instance_activate_all();
        audio_resume_all();
        global.is_paused = false;
        pause_menu_state = "main";
        hovered_button = noone;
        mouse_locked_until_release = true;
        room_goto(rm_menu);
    }
}
else if (pause_menu_state == "settings")
{
    draw_set_font(fnt_title);
    draw_text(_screen_w/2, _screen_h*0.25, "SETTINGS");

    draw_set_font(fnt_button);
    draw_text(_screen_w/2, _screen_h*0.5, "Volume, Fullscreen, etc...");

    var _y_back = _screen_h * 0.8;
    var hover_back = point_in_rectangle(_mx, _my, _x - 100, _y_back - 20, _x + 100, _y_back + 20);

    // Hover sound (only for BACK, because only BACK is active in settings)
    if (hover_back && hovered_button != "back")
    {
        audio_play_sound(snd_button_hover, 10, false);
        hovered_button = "back";
    }
    else if (!hover_back)
    {
        hovered_button = noone;
    }

    draw_set_color(hover_back ? c_yellow : c_white);
    draw_text(_x, _y_back, "BACK");

    if (hover_back && _clicked)
    {
        audio_play_sound(snd_button_click, 10, false);
        pause_menu_state = "main";  // return to main pause menu (not to rm_menu)
        hovered_button = noone;     // reset
        mouse_locked_until_release = true; // lock until release so we don't click the main menu immediately
    }
}

// Reset draw state
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
