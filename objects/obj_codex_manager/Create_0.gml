// --- Create Event of obj_codex_manager ---

persistent = true; // CRUCIAL: This keeps your lessons saved!

is_open = false;
current_page = 0;

// This controls if the player can even open the book
unlocked = false; 

// The actual content
// We use an array of structs to make it easy to expand later
modules = [];

// Helper function to add content (so you can call this from any NPC)
function add_module(_title, _content) {
    var _new_mod = {
        title: _title,
        content: _content
    };
    
    // Only add it if it's not already there (prevents duplicates)
    var _exists = false;
    for (var i = 0; i < array_length(modules); i++) {
        if (modules[i].title == _title) _exists = true;
    }
    
    if (!_exists) {
        array_push(modules, _new_mod);
        show_debug_message("CODEX: Added " + _title);
    }
    unlocked = true;
}