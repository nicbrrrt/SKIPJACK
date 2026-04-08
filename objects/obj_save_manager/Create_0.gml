// obj_save_manager — Create Event
// Note: global.save_filename and global.save_path are set by obj_game_init.
// Do NOT re-declare them here — it would overwrite them on room reload.

// --- THE SAVE FUNCTION ---
function save_game() {
    if (!instance_exists(obj_jack)) return;

    var _save_data = {
        current_room:  room,
        player_x:      obj_jack.x,
        player_y:      obj_jack.y,
        tutorial_done: global.tutorial_complete,
        greg_dead:     global.greg_defeated,
        greg_started:  global.greg_quest_started,
        clipper_done:  global.quest_clipper_done,
        lea_done:      global.quest_lea_done,
        boss_spawned:       global.boss_spawned,
        final_boss_defeated: global.final_boss_defeated
    };

    var _json = json_stringify(_save_data);
    var _file = file_text_open_write(global.save_path);
    file_text_write_string(_file, _json);
    file_text_close(_file);
    show_debug_message("SYSTEM: Save successful! " + _json);
}

// --- THE LOAD FUNCTION ---
function load_game() {
    if (!file_exists(global.save_path)) return;

    var _file = file_text_open_read(global.save_path);
    var _json  = file_text_read_string(_file);
    file_text_close(_file);

    var _data = json_parse(_json);

    global.target_x             = _data.player_x;
    global.target_y             = _data.player_y;
    global.is_loading_from_save = true;

    global.tutorial_complete  = _data.tutorial_done;
    global.greg_defeated      = _data.greg_dead;
    global.greg_quest_started = variable_struct_exists(_data, "greg_started")  ? _data.greg_started  : false;
    global.quest_clipper_done = variable_struct_exists(_data, "clipper_done")  ? _data.clipper_done  : false;
    global.quest_lea_done     = variable_struct_exists(_data, "lea_done")      ? _data.lea_done      : false;
    global.boss_spawned        = variable_struct_exists(_data, "boss_spawned")        ? _data.boss_spawned        : false;
    global.final_boss_defeated = variable_struct_exists(_data, "final_boss_defeated") ? _data.final_boss_defeated : false;

    instance_activate_all();
    room_goto(_data.current_room);
    show_debug_message("SYSTEM: Load successful!");
}