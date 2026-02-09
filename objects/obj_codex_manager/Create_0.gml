// --- Create Event of obj_codex_manager ---
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
    array_push(modules, _new_mod);
    unlocked = true; // Automatically allow opening once they get one
}