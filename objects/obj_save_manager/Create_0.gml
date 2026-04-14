// obj_save_manager — Create Event
// Note: global.save_filename and global.save_path are set by obj_game_init.
// Do NOT re-declare them here — it would overwrite them on room reload.

// Helper: read a global with a default if it doesn't exist yet
function _global_or(_name, _default) {
    return variable_global_exists(_name) ? variable_global_get(_name) : _default;
}

// Helper: read a struct field with a default if missing (load-time safety)
function _field_or(_struct, _name, _default) {
    return variable_struct_exists(_struct, _name) ? variable_struct_get(_struct, _name) : _default;
}

// --- THE SAVE FUNCTION ---
function save_game() {
    if (!instance_exists(obj_jack)) return;

    // Snapshot codex modules if the manager exists, otherwise reuse the
    // last loaded snapshot so we don't wipe progress when saving from a
    // room where the manager isn't loaded yet.
    var _codex_snapshot = _global_or("saved_codex_modules", []);
    if (instance_exists(obj_codex_manager)) {
        _codex_snapshot = obj_codex_manager.modules;
    }

    var _save_data = {
        version: 1,
        current_room: room,
        player_x: obj_jack.x,
        player_y: obj_jack.y,

        // Story flags
        tutorial_done:        _global_or("tutorial_complete", false),
        intro_done:           _global_or("level1_intro_done", false),
        greg_dead:            _global_or("greg_defeated", false),
        greg_started:         _global_or("greg_quest_started", false),

        // NPC lesson / defeat flags
        cryptography_learned: _global_or("cryptography_learned", false),
        caesar_learned:       _global_or("caesar_learned",       false),
        clipper_defeated:     _global_or("clipper_defeated",     false),
        lea_defeated:         _global_or("lea_defeated",         false),

        // Quest flags
        clipper_done:         _global_or("quest_clipper_done", false),
        lea_done:             _global_or("quest_lea_done",     false),
        boss_spawned:         _global_or("boss_spawned",       false),
        final_boss_defeated:  _global_or("final_boss_defeated", false),

        // Battle handoff state (so saving mid-battle-setup is safe)
        last_battle_id:       _global_or("last_battle_id",    "none"),
        is_jrpg:              _global_or("is_jrpg",           false),
        puzzle_word_list:     _global_or("puzzle_word_list",  []),

        // Codex content
        codex_modules:        _codex_snapshot
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

    // Set the spawn coordinates for obj_game_controller to use
    global.target_x = _field_or(_data, "player_x", 0);
    global.target_y = _field_or(_data, "player_y", 0);
    global.is_loading_from_save = true;

    // Restore all global flags with safety defaults
    global.tutorial_complete   = _field_or(_data, "tutorial_done",        false);
    global.level1_intro_done   = _field_or(_data, "intro_done",           false);
    global.greg_defeated       = _field_or(_data, "greg_dead",            false);
    global.greg_quest_started  = _field_or(_data, "greg_started",         false);

    global.cryptography_learned = _field_or(_data, "cryptography_learned", false);
    global.caesar_learned       = _field_or(_data, "caesar_learned",       false);
    global.clipper_defeated     = _field_or(_data, "clipper_defeated",     false);
    global.lea_defeated         = _field_or(_data, "lea_defeated",         false);

    global.quest_clipper_done   = _field_or(_data, "clipper_done",         false);
    global.quest_lea_done       = _field_or(_data, "lea_done",             false);
    global.boss_spawned         = _field_or(_data, "boss_spawned",         false);
    global.final_boss_defeated  = _field_or(_data, "final_boss_defeated",  false);

    global.last_battle_id       = _field_or(_data, "last_battle_id", "none");
    global.is_jrpg              = _field_or(_data, "is_jrpg",        false);
    global.puzzle_word_list     = _field_or(_data, "puzzle_word_list", []);

    // Restore codex content. Stash globally so the codex manager can
    // sync from it whenever it (re)spawns; also push directly into the
    // live instance if one already exists.
    global.saved_codex_modules = _field_or(_data, "codex_modules", []);
    if (instance_exists(obj_codex_manager)) {
        obj_codex_manager.modules  = global.saved_codex_modules;
        obj_codex_manager.unlocked = (array_length(global.saved_codex_modules) > 0);
    }

    instance_activate_all();
    room_goto(_field_or(_data, "current_room", room));
    show_debug_message("SYSTEM: Load successful!");
}
