// --- obj_save_manager Create Event ---
global.save_filename = "save_v1.json";
global.save_path = working_directory + global.save_filename;

// --- THE SAVE FUNCTION ---
function save_game() {
    if (!instance_exists(obj_jack)) return;

    // 1. Gather all data into ONE single struct
    var _save_data = {
        current_room: room,
        player_x: obj_jack.x,
        player_y: obj_jack.y,
        
        // Story Flags
        tutorial_done:  variable_global_exists("tutorial_complete") ? global.tutorial_complete : false,
        greg_dead:      variable_global_exists("greg_defeated") ? global.greg_defeated : false,
        greg_started:   variable_global_exists("greg_quest_started") ? global.greg_quest_started : false,
        
        // Quest Flags
        clipper_done:   variable_global_exists("quest_clipper_done") ? global.quest_clipper_done : false,
        lea_done:       variable_global_exists("quest_lea_done") ? global.quest_lea_done : false,
        boss_spawned:   variable_global_exists("boss_spawned") ? global.boss_spawned : false
    };

    // 2. Write to file
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
    var _json = file_text_read_string(_file);
    file_text_close(_file);

    var _data = json_parse(_json);

    // 1. Set the spawn coordinates for obj_game_controller to use
    global.target_x = _data.player_x;
    global.target_y = _data.player_y;
    global.is_loading_from_save = true;

    // 2. Restore all global flags with safety defaults
    global.tutorial_complete   = _data.tutorial_done;
    global.greg_defeated       = _data.greg_dead;
    global.greg_quest_started  = variable_struct_exists(_data, "greg_started") ? _data.greg_started : false;
    global.quest_clipper_done  = variable_struct_exists(_data, "clipper_done") ? _data.clipper_done : false;
    global.quest_lea_done      = variable_struct_exists(_data, "lea_done") ? _data.lea_done : false;
    global.boss_spawned        = variable_struct_exists(_data, "boss_spawned") ? _data.boss_spawned : false;

    // 3. Move to the room
    instance_activate_all(); 
    room_goto(_data.current_room);
    
    show_debug_message("SYSTEM: Load successful!");
}