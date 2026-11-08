/// @description obj_homeroom_statues — Step Event
/// Proximity + [E] interaction for the Wall Telephone, Display Table and south exit.

near_phone = false;
near_table = false;
near_exit  = false;

if (variable_global_exists("is_paused") && global.is_paused) exit;
if (global.phone_ui_open || global.shelf_ui_open) exit;
if (instance_exists(obj_textevent) || instance_exists(obj_textbox)) exit;
if (!instance_exists(obj_jack)) exit;

var _jx = obj_jack.x;
var _jy = obj_jack.y - 6;

var _d_phone = point_distance(_jx, _jy, phone_x, phone_y + 24);
var _d_table = point_distance(_jx, _jy, table_cx, table_base_y + 10);
var _d_exit  = point_distance(_jx, obj_jack.y, exit_x, exit_y);

// Only the closest station is "near"
var _best = 9999;
if (_d_phone < 34 && _d_phone < _best) { _best = _d_phone; near_phone = true; near_table = false; near_exit = false; }
if (_d_table < 52 && _d_table < _best) { _best = _d_table; near_table = true; near_phone = false; near_exit = false; }
if (_d_exit  < 30 && _d_exit  < _best) { _best = _d_exit;  near_exit  = true; near_phone = false; near_table = false; }

if (keyboard_check_pressed(ord("E"))) {
    if (near_phone) {
        global.phone_ui_open = true;
        global.phone_sel     = 0;
        global.phone_msg     = "";
        global.phone_col     = c_white;
        audio_play_sound(snd_select, 10, false);
    } else if (near_table) {
        global.shelf_ui_open = true;
        global.shelf_slot    = 0;
        audio_play_sound(snd_select, 10, false);
    } else if (near_exit) {
        audio_play_sound(snd_button_click, 10, false);
        room_goto(rm_cipher_select);
    }
}
