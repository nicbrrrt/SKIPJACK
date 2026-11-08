/// @description obj_cipher_select — Step Event
/// Handles Chapter Selection (Caesar, Vigenere, Atbash), Floor/Phase Selection (1..10),
/// and transitions directly into the main Dungeon Crawler (dungeon_test).

var mx  = device_mouse_x_to_gui(0);
var my  = device_mouse_y_to_gui(0);
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

cx     = _gw * 0.5;
btn_x1 = cx - btn_w * 0.5;
btn_x2 = cx + btn_w * 0.5;
btn1_y = 88;
btn2_y = btn1_y + btn_h + btn_gap;
btn3_y = btn2_y + btn_h + btn_gap;

// Allow ESC to return to Main Menu
if (keyboard_check_pressed(vk_escape) && !instance_exists(obj_transition)) {
    audio_play_sound(snd_button_click, 10, false);
    room_goto(rm_menu);
    exit;
}

if (unlock_anim_timer > 0) {
    unlock_anim_timer--;
    if (unlock_anim_timer == 45) {
        audio_play_sound(snd_correct_ping, 10, false);
    }
    caesar_hover   = false;
    vigenere_hover = false;
    atbash_hover   = false;
    exit;
}

// --- 1. Back Button (Top-Left) & Homeroom Preview Button ---
var back_hover = (mx >= 12 && mx <= 84 && my >= 12 && my <= 34);
if (back_hover && mouse_check_button_pressed(mb_left) && !instance_exists(obj_transition)) {
    audio_play_sound(snd_button_click, 10, false);
    room_goto(rm_menu);
    exit;
}

var home_hover = (mx >= 92 && mx <= 198 && my >= 12 && my <= 34);
if ((home_hover && mouse_check_button_pressed(mb_left)) || keyboard_check_pressed(ord("H"))) {
    if (!instance_exists(obj_transition)) {
        audio_play_sound(snd_button_click, 10, false);
        global.cam_pan_phase   = "off";
        global.cam_pan_mode    = "";
        global.cam_pan_timer   = 0;
        global.cam_pan_targets = [];
        room_goto(rm_homeroom);
        exit;
    }
}

// --- 2. Panelist Demo Unlock Toggle (Top-Right) ---
demo_unlock_hover = (mx >= _gw - 156 && mx <= _gw - 12 && my >= 12 && my <= 34);
if ((demo_unlock_hover && mouse_check_button_pressed(mb_left)) || keyboard_check_pressed(ord("U"))) {
    var _cur_unlock = (variable_global_exists("unlock_all_ciphers") && global.unlock_all_ciphers);
    global.unlock_all_ciphers = !_cur_unlock;
    global.vigenere_unlocked  = global.unlock_all_ciphers;
    global.atbash_unlocked    = global.unlock_all_ciphers;
    if (instance_exists(obj_codex_manager)) {
        obj_codex_manager.tab_locked[2] = !global.unlock_all_ciphers;
        obj_codex_manager.tab_locked[3] = !global.unlock_all_ciphers;
    }
    audio_play_sound(snd_correct_ping, 10, false);
}

// --- 3. Floor / Phase Selector Controls (Bottom Panel) ---
var _sel_y = 268;
floor_prev_hover = point_in_rectangle(mx, my, cx - 130, _sel_y - 13, cx - 94, _sel_y + 13);
floor_next_hover = point_in_rectangle(mx, my, cx + 94,  _sel_y - 13, cx + 130, _sel_y + 13);

if ((floor_prev_hover && mouse_check_button_pressed(mb_left)) || keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) {
    selected_floor = (selected_floor <= 1) ? CHAPTER_MAX_FLOORS : (selected_floor - 1);
    audio_play_sound(select1, 10, false);
}
if ((floor_next_hover && mouse_check_button_pressed(mb_left)) || keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
    selected_floor = (selected_floor >= CHAPTER_MAX_FLOORS) ? 1 : (selected_floor + 1);
    audio_play_sound(select1, 10, false);
}

// Phase Quick-Jump Pills: [Floor 1: Tutorial] [Floor 4: Practice] [Floor 10: Final Exam]
var _pill_y = 304;
preset_tut_hover = point_in_rectangle(mx, my, cx - 196, _pill_y - 12, cx - 72,  _pill_y + 12);
preset_prc_hover = point_in_rectangle(mx, my, cx - 62,  _pill_y - 12, cx + 62,  _pill_y + 12);
preset_exm_hover = point_in_rectangle(mx, my, cx + 72,  _pill_y - 12, cx + 196, _pill_y + 12);

if (preset_tut_hover && mouse_check_button_pressed(mb_left)) {
    selected_floor = 1;
    audio_play_sound(snd_button_click, 10, false);
}
if (preset_prc_hover && mouse_check_button_pressed(mb_left)) {
    selected_floor = 4;
    audio_play_sound(snd_button_click, 10, false);
}
if (preset_exm_hover && mouse_check_button_pressed(mb_left)) {
    selected_floor = 10;
    audio_play_sound(snd_button_click, 10, false);
}

// --- 4. Chapter Launch Helper ---
var _vig_unlocked = (variable_global_exists("vigenere_unlocked") && global.vigenere_unlocked)
                 || (variable_global_exists("final_boss_defeated") && global.final_boss_defeated)
                 || (variable_global_exists("unlock_all_ciphers") && global.unlock_all_ciphers);

var _atb_unlocked = (variable_global_exists("atbash_unlocked") && global.atbash_unlocked)
                 || (variable_global_exists("atbash_boss_defeated") && global.atbash_boss_defeated)
                 || (variable_global_exists("unlock_all_ciphers") && global.unlock_all_ciphers);

caesar_hover   = (mx >= btn_x1 && mx <= btn_x2 && my >= btn1_y && my <= btn1_y + btn_h);
vigenere_hover = _vig_unlocked && (mx >= btn_x1 && mx <= btn_x2 && my >= btn2_y && my <= btn2_y + btn_h);
atbash_hover   = _atb_unlocked && (mx >= btn_x1 && mx <= btn_x2 && my >= btn3_y && my <= btn3_y + btn_h);

var _launch_chapter = 0;
if (caesar_hover && mouse_check_button_pressed(mb_left) && !instance_exists(obj_transition)) {
    _launch_chapter = CHAPTER_CAESAR;
} else if (vigenere_hover && mouse_check_button_pressed(mb_left) && !instance_exists(obj_transition)) {
    _launch_chapter = CHAPTER_VIGENERE;
} else if (atbash_hover && mouse_check_button_pressed(mb_left) && !instance_exists(obj_transition)) {
    _launch_chapter = CHAPTER_ATBASH;
}

if (_launch_chapter > 0) {
    audio_stop_sound(snd_button_hover);
    audio_play_sound(snd_button_click, 10, false);

    // Set Chapter & Floor globals for the Dungeon Generator
    global.dungeon_chapter  = _launch_chapter;
    global.chapter_floor    = clamp(selected_floor, 1, CHAPTER_MAX_FLOORS);
    global.dungeons_cleared = global.chapter_floor - 1;
    global.case_start_offset = (_launch_chapter - 1) * 3;

    // Clean up any leftover overworld instances before entering dungeon_test
    if (instance_exists(obj_jack))            instance_destroy(obj_jack);
    if (instance_exists(obj_game_controller)) instance_destroy(obj_game_controller);

    var _t         = instance_create_depth(0, 0, -9999, obj_transition);
    _t.target_room = dungeon_test;
    _t.target_x    = 72;
    _t.target_y    = 784;
    _t.fade_mode   = "fading_out";
    _t.fade_alpha  = 0;
}
