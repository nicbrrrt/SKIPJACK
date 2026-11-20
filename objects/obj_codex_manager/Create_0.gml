// --- Create Event of obj_codex_manager ---

persistent = true;

is_open        = false;
current_tab    = 0;
current_module = 0;
current_branch = 0;
current_concept = 0;
content_scroll = 0;
toast_timer    = 0;
toast_msg      = "";

scr_init_cyber_glossary();

// 5 Cybersecurity Branch Tabs
tab_names  = ["SOCIAL ENG.", "IDENTITY & IAM", "MALWARE & ENDPOINT", "NETWORK & PHYSICAL", "CRYPTOGRAPHY"];
tab_locked = [false, false, false, false, false];

// Legacy per-tab module arrays kept for Story Mode NPC compatibility
tab_modules = [[], [], [], [], []];
modules     = [];
unlocked    = true;

function get_branch_terms(_b_idx) {
    scr_init_cyber_glossary();
    var _out = [];
    for (var i = 0; i < array_length(global.cyber_glossary); i++) {
        if (global.cyber_glossary[i].branch_idx == _b_idx) {
            array_push(_out, global.cyber_glossary[i]);
        }
    }
    return _out;
}

// Story Mode NPC compatibility: archives legacy module AND unlocks matching glossary term
function add_module(_title, _content) {
    scr_init_cyber_glossary();
    var _mods = tab_modules[0];
    var _dup = false;
    for (var i = 0; i < array_length(_mods); i++) {
        if (_mods[i].title == _title) { _dup = true; break; }
    }
    if (!_dup) {
        array_push(tab_modules[0], { title: _title, content: _content });
    }
    var _tl = string_lower(_title);
    if (string_pos("caesar", _tl) > 0) {
        global.codex_unlocked_terms[$ "caesar_cipher"] = true;
    } else if (string_pos("crypto", _tl) > 0) {
        global.codex_unlocked_terms[$ "symmetric_asymmetric"] = true;
        global.codex_unlocked_terms[$ "plaintext_ciphertext"] = true;
    }
    show_debug_message("CODEX: Synced '" + _title + "' to Homeroom Codex.");
}
