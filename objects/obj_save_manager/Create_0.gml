// --- obj_save_manager Create Event ---
global.save_filename = "save_v1.json";
global.save_path = working_directory + global.save_filename;

// --- THE SAVE FUNCTION ---
function save_game() {
    if (!instance_exists(obj_jack)) return;

    // Use "variable_global_exists" to prevent crashes
    var _greg_status = variable_global_exists("greg_defeated") ? global.greg_defeated : false;
    var _tutor_status = variable_global_exists("tutorial_complete") ? global.tutorial_complete : false;

    var _save_data = {
        current_room: room,
        player_x: obj_jack.x,
        player_y: obj_jack.y,
        tutorial_done: _tutor_status,
        greg_dead: _greg_status
    };

    var _json = json_stringify(_save_data);
    var _file = file_text_open_write(global.save_path);
    file_text_write_string(_file, _json);
    file_text_close(_file);
	
	var _save_data = {
    // ... previous data ...
    clipper_done: global.quest_clipper_done,
    lea_done: global.quest_lea_done,
    boss_spawned: global.boss_spawned
	};
    
    show_debug_message("SYSTEM: Save successful!");
}

// --- THE LOAD FUNCTION ---
function load_game() {
    if (!file_exists(global.save_path)) return;

    var _file = file_text_open_read(global.save_path);
    var _json = file_text_read_string(_file);
    file_text_close(_file);

    var _data = json_parse(_json);

    // Set the globals Jack needs to spawn
    global.target_x = _data.player_x;
    global.target_y = _data.player_y;
    global.is_loading_from_save = true;
	
	// ... previous data ...
	global.quest_clipper_done = _data.clipper_done;
	global.quest_lea_done = _data.lea_done;
	global.boss_spawned = _data.boss_spawned;
    
    // FORCE ACTIVATE everything before moving rooms
    instance_activate_all(); 
    
    room_goto(_data.current_room);
}