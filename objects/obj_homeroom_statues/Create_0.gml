/// @description obj_homeroom_statues — Create Event
/// Homeroom Wall Telephone (Mechanic orders), 3-Pedestal Statue Display Table,
/// and the south-door exit back to Chapter Select.

depth = -224; // Sorts with Jack (-y): Jack walks in front of the table when below it

scr_statue_ensure_globals();
global.phone_ui_open = false;
global.shelf_ui_open = false;

// World positions (rm_homeroom floor spans x 496..752, y 192..400)
phone_x       = 694;   // Wall telephone (north wall, between the board decor and the fridge)
phone_y       = 181;
table_cx      = 644;   // Display table center
table_base_y  = 222;   // Front edge of the table top
exit_x        = 624;   // South archway
exit_y        = 384;

near_phone = false;
near_table = false;
near_exit  = false;

if (!instance_exists(obj_music_controller)) {
    instance_create_depth(0, 0, 0, obj_music_controller);
}

// Ensure persistent Jack is positioned inside the homeroom floor
if (instance_exists(obj_jack)) {
    obj_jack.x = 616;
    obj_jack.y = 336;
    obj_jack.visible = true;
    obj_jack.isInCutscene = false;
    obj_jack.bump_timer = 0;
    obj_jack.sprite_index = spr_jack_idle;
}
