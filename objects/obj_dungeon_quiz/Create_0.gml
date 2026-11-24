/// @description obj_dungeon_quiz — Create Event
/// Interactive Key Vault "Spot the Cyber Red Flag" Challenge UI.
/// Presents a captured security artifact from the floor's incident (email header,
/// network log, download prompt, or device scan) and asks the player to identify
/// the security red flag / threat action.

depth = -15000;

target_door_x = x;
target_door_y = y;

var _case = variable_global_exists("floor_case")
    ? global.floor_case
    : scr_get_floor_incident_case(0);

target_word      = _case.word;
case_title       = _case.title;
current_scenario = _case.scenario;
current_hint     = _case.hint;
current_takeaway = _case.takeaway;

var _vc = variable_struct_exists(_case, "vault_challenge") ? _case.vault_challenge : {
    artifact_header: "CAPTURED SECURITY LOG:  Threat Signature = " + _case.word,
    artifact_body:   _case.scenario,
    plain_summary:   "PLAIN ENGLISH: " + _case.scenario + " (" + _case.hint + ")",
    scanner_note:    "FORENSIC SCAN: " + _case.hint,
    prompt:          "Identify the cybersecurity red flag in this captured log:",
    options: [
        _case.word + " — " + _case.title + " (" + _case.hint + ")",
        "Routine scheduled system maintenance check",
        "Normal encrypted internal file backup"
    ],
    correct_idx: 0,
    explain_win: "SPOT ON! " + _case.takeaway
};

artifact_header = _vc.artifact_header;
artifact_body   = _vc.artifact_body;
plain_summary   = variable_struct_exists(_vc, "plain_summary")
    ? _vc.plain_summary
    : ("PLAIN ENGLISH: " + _case.scenario + " (" + _case.hint + ")");
scanner_note    = _vc.scanner_note;
prompt_text     = _vc.prompt;
explain_win     = _vc.explain_win;

// Shuffle the 3 options while tracking which index is the correct red flag
var _src_opts = _vc.options;
var _src_corr = _vc.correct_idx;
var _order    = [0, 1, 2];
for (var _i = 2; _i > 0; _i--) {
    var _j   = irandom(_i);
    var _tmp = _order[_i];
    _order[_i] = _order[_j];
    _order[_j] = _tmp;
}

quiz_options        = [];
option_eliminated   = [false, false, false];
correct_option_idx  = 0;
for (var _k = 0; _k < 3; _k++) {
    array_push(quiz_options, _src_opts[_order[_k]]);
    if (_order[_k] == _src_corr) correct_option_idx = _k;
}

selected_option    = 0;
shake_timer        = 0;
status_msg         = "";
status_col         = c_white;
success_timer      = 0;
kyle_hint_unlocked = false;

scr_auto_collect_floor_terms([artifact_header, artifact_body, plain_summary, scanner_note, prompt_text, current_takeaway]);

audio_play_sound(snd_select, 10, false);
show_debug_message("[obj_dungeon_quiz] Spot-the-Red-Flag Challenge started. Topic: " + target_word);
