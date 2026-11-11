/// @description obj_dungeon_victory — Create Event
/// Extraction Elevator Incident Debrief Report Card shown when completing a dungeon floor.
/// Tracks Chapter (1..3) and Floor (1..10) progression and unlocks the next Chapter on Floor 10!

depth = -15000;

if (instance_exists(obj_jack)) {
    obj_jack.isInCutscene = true;
}

phase        = "fade_in"; // "fade_in" | "display" | "fade_out"
phase_timer  = 0;
anim_timer   = 0;
screen_alpha = 0;
next_action  = "next_dungeon"; // "next_dungeon" | "chapter_select" | "menu"

chapter_num   = variable_global_exists("dungeon_chapter") ? global.dungeon_chapter : CHAPTER_CAESAR;
cleared_floor = variable_global_exists("chapter_floor")   ? global.chapter_floor   : 1;
is_final_exam = (cleared_floor >= CHAPTER_MAX_FLOORS);

clues_total = variable_global_exists("clues_found")          ? global.clues_found          : 0;
clues_req   = variable_global_exists("clues_needed")         ? global.clues_needed         : 2;
case_wrong  = variable_global_exists("case_wrong_accusations") ? global.case_wrong_accusations : 0;
case_ev     = variable_global_exists("evidence_found")       ? global.evidence_found       : 0;
case_ev_req = variable_global_exists("evidence_needed")      ? global.evidence_needed      : 0;
floor_key   = variable_global_exists("dungeon_cipher_key")   ? global.dungeon_cipher_key   : 3;
vig_key     = variable_global_exists("dungeon_vigenere_key") ? global.dungeon_vigenere_key : "CAB";

// Evaluate Floor Salvage Compliance Status (4..6 Scrap = GREEN / Compliant)
hr_scrapped   = variable_global_exists("hr_scrap_count") ? global.hr_scrap_count : 0;
hr_limit      = 6;
is_compliant  = (hr_scrapped >= 4 && hr_scrapped <= 6);
hr_violation  = !is_compliant;
global.intern_duty_flagged = hr_violation;
task1_done    = is_compliant;
task2_done    = ((variable_global_exists("task_bots_scrapped") && global.task_bots_scrapped > 0)
              || (variable_global_exists("task_servers_scrapped") && global.task_servers_scrapped > 0));
bonus_scrap   = (task1_done ? 3 : 0) + (task2_done ? 2 : 0);
bonus_cash    = 0; // Salvage payouts are now part of the itemized Corporate Paycheck below

if (bonus_scrap > 0) global.scrap_count += bonus_scrap;

// Corporate Paycheck (Performance Tracker) + 1-workday statue deliveries from the Homeroom Mechanic
scr_statue_ensure_globals();
paycheck           = scr_calc_floor_paycheck(task1_done, task2_done, hr_violation);
global.player_cash += paycheck.total;
delivered_statues  = scr_deliver_pending_statues();
page               = 0; // 0 = Incident Debrief, 1 = Paystub & Deliveries

// Unlock next Chapter if Floor 10 Final Exam was just passed!
if (is_final_exam) {
    if (chapter_num == CHAPTER_CAESAR) {
        global.vigenere_unlocked  = true;
        global.final_boss_defeated = true;
        global.newly_unlocked     = "vigenere";
        if (instance_exists(obj_codex_manager)) {
            obj_codex_manager.tab_locked[3] = false;
        }
    } else if (chapter_num == CHAPTER_VIGENERE) {
        global.atbash_unlocked      = true;
        global.atbash_boss_defeated = true;
        global.newly_unlocked       = "atbash";
        if (instance_exists(obj_codex_manager)) {
            obj_codex_manager.tab_locked[2] = false;
        }
    }
}

var _case = variable_global_exists("floor_case")
    ? global.floor_case
    : scr_get_floor_incident_case(0);

case_word     = _case.word;
case_title    = _case.title;
case_hint     = _case.hint;
case_takeaway = _case.takeaway;

// Chapter-specific Cryptography / Cryptanalysis facts for the debrief card
var _caesar_facts = [
    "CAESAR FACT: Because a Caesar Cipher has only 25 possible shift keys, a modern computer can brute-force all 25 keys in less than a microsecond!",
    "CAESAR FACT: Matching one Encrypted letter to one known Plaintext letter immediately reveals the entire Caesar Shift Key!",
    "CAESAR FACT: Negative Caesar keys (-K) shift backward toward 'A' and wrap around to 'Z' (modulo 26 arithmetic)!",
    "CAESAR FACT: Frequency Analysis cracks Caesar ciphers by checking which encrypted letter appears most often (usually 'E' in English)!"
];
var _vig_facts = [
    "VIGENERE FACT: Invented in the 1500s, the Vigenere Cipher was called 'le chiffre indechiffrable' (the unbreakable cipher) for 300 years!",
    "VIGENERE FACT: Each letter in the Keyword applies its own Caesar shift (A=+0, B=+1, C=+2...), defeating simple letter-frequency analysis!",
    "VIGENERE FACT: When the Keyword is shorter than the message, it repeats over and over until every letter is encrypted!",
    "VIGENERE FACT: If a Vigenere keyword is completely random, as long as the message, and used only once, it becomes a 'One-Time Pad'—mathematically unbreakable!"
];
var _atb_facts = [
    "ATBASH FACT: Atbash is an ancient Hebrew substitution cipher that folds the alphabet in half like a mirror (A<->Z, B<->Y, M<->N)!",
    "ATBASH FACT: Because Atbash is a symmetric reflection, encrypting and decrypting use the exact same mirror rule!",
    "ATBASH FACT: In mathematical terms, if A=0 and Z=25, the Atbash mirror formula is simply: Decoded = 25 - Encrypted!",
    "ATBASH FACT: Because Atbash has no variable secret key, its security relies on hiding the method—which modern cryptography replaces with secret keys!"
];

if (chapter_num == CHAPTER_VIGENERE) {
    crypto_fact = _vig_facts[(cleared_floor - 1) mod array_length(_vig_facts)];
} else if (chapter_num == CHAPTER_ATBASH) {
    crypto_fact = _atb_facts[(cleared_floor - 1) mod array_length(_atb_facts)];
} else {
    crypto_fact = _caesar_facts[(cleared_floor - 1) mod array_length(_caesar_facts)];
}

// Decorative background particles
stars = [];
for (var i = 0; i < 24; i++) {
    array_push(stars, {
        sx:  irandom(640),
        sy:  irandom(360),
        spd: 0.3 + random(0.7),
        sz:  1 + random(2),
        ang: random(360)
    });
}
