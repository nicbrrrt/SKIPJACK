// --- Create Event of obj_codex_manager ---

persistent = true;

is_open        = false;
current_tab    = 0;
current_module = 0;

// Tab definitions — 4 subject tabs; last two are locked until unlocked by story
tab_names  = ["CYBERSECURITY", "CAESAR CIPHER", "ATBASH CIPHER", "VIGENERE CIPHER"];
tab_locked = [false, false, true, true];

// Per-tab module arrays — start empty; NPCs populate Tab 0 during gameplay.
// Tab 1/2/3 unlock and receive content as story progresses.
tab_modules = [
    [],   // Tab 0: Cybersecurity   — populated by Kyle/Greg, Lea, Clipper via add_module()
    [],   // Tab 1: Caesar Cipher   — locked; reserved for future story content
    [],   // Tab 2: Atbash Cipher   — locked; reserved for future story content
    []    // Tab 3: Vigenere Cipher — locked; reserved for future story content
];

// Legacy flat array — kept so save/load code does not break
modules  = [];
unlocked = true;

// add_module kept for NPC dialogue system compatibility
// Adds to Tab 0 (Cybersecurity) and avoids duplicates
function add_module(_title, _content) {
    var _mods = tab_modules[0];
    for (var i = 0; i < array_length(_mods); i++) {
        if (_mods[i].title == _title) return;
    }
    array_push(tab_modules[0], { title: _title, content: _content });
    show_debug_message("CODEX: Added '" + _title + "' to Cybersecurity tab.");
}
