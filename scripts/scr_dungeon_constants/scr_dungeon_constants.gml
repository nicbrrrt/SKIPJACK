/// @description Dungeon Generation & 3-Chapter x 10-Floor Curriculum — Global Constants
/// All dungeon system constants, chapter identifiers, 10-floor curriculum rules,
/// and the 10 Cybersecurity Incident Cases are defined here.

// ---------------------------------------------------------------------------
// Chapter & Floor Progression Constants
// ---------------------------------------------------------------------------
#macro CHAPTER_CAESAR      1   // Chapter 1: Caesar Shift Cipher (Floors 1-10)
#macro CHAPTER_VIGENERE    2   // Chapter 2: Vigenere Keyword Cipher (Floors 1-10)
#macro CHAPTER_ATBASH      3   // Chapter 3: Atbash Mirror Cipher (Floors 1-10)
#macro CHAPTER_MAX_FLOORS 10   // 10 Floors per Chapter (1-3 Tutorial, 4-9 Practice, 10 Final Exam)

// ---------------------------------------------------------------------------
// Tile type identifiers (used inside 9x9 room template arrays)
// ---------------------------------------------------------------------------
#macro TILE_VOID          -1   // Structural building void / outer wall mass
#macro TILE_FLOOR          0   // Standard corporate floor tile
#macro TILE_WALL           1   // Corporate interior wall cell
#macro TILE_DOOR           2   // Open doorway / threshold tile
#macro TILE_LOCK_QUIZ      3   // Doorway locked by a Cybersecurity Question
#macro TILE_LOCK_CAESAR    4   // Doorway locked by the Chapter Cipher (Caesar / Vigenere / Atbash)
#macro TILE_CARPET         5   // Corporate hallway runner / accent carpet tile
#macro TILE_ELEVATOR_FLOOR 6   // Brushed steel elevator cab floor tile
#macro TILE_PROP_PC        7   // Corporate computer desk terminal (solid prop)
#macro TILE_PROP_CHAIR     8   // Office chair prop on floor
#macro TILE_PROP_BOARD     9   // Corporate whiteboard / monitor on top wall
#macro TILE_PROP_PAPER    10   // Scattered lockdown papers on floor
#macro TILE_HALL_OPEN     11   // Seamless open corridor connection between two hallway chunks
#macro TILE_PROP_NPC      12   // Stranded corporate coworker / IT staff NPC
#macro TILE_PROP_DRONE    13   // Roaming rogue security / virus drone
#macro TILE_PROP_LOCKER   14   // Corporate hallway locker that Jack can hide inside
#macro TILE_PROP_OVERRIDE 15   // Red Lockdown Override Console (in ROOM_CAESAR_LOCKED)
#macro TILE_PROP_BREAKER  16   // High-Voltage Power Breaker Panel (in ROOM_POWER)
#macro TILE_ROOM_MERGE    17   // Seamless wide interior merge between two chunks of a long multi-chunk room

// ---------------------------------------------------------------------------
// Logic-map room type identifiers (used in obj_dungeon_generator's grid)
// ---------------------------------------------------------------------------
#macro ROOM_NONE          -1   // Slot is unoccupied (default)
#macro ROOM_START          1   // Security Reception / Starting Lobby
#macro ROOM_NORMAL         2   // Office / Apartment Room branching off the hallway
#macro ROOM_END            3   // Corporate Extraction Elevator Room
#macro ROOM_CAESAR_KEY     4   // Locked IT Key Vault containing the Chapter Cipher Key
#macro ROOM_CAESAR_LOCKED  5   // Security Control Room containing the Lockdown Override Console
#macro ROOM_HALLWAY        6   // Central building hallway spine connecting all rooms
#macro ROOM_HOLDING        7   // Security Detention / Holding Room where drones send Jack if caught
#macro ROOM_POWER          8   // Control Break / Electrical Breaker Room containing the Breaker Panel

// ---------------------------------------------------------------------------
// Intern Babysitting Ward Constants (Triggered when global.intern_duty_flagged == true)
// ---------------------------------------------------------------------------
#macro ROOM_INTERN_NONE      0
#macro ROOM_INTERN_WORK      1   // Terminal Work Room (10 computer desks)
#macro ROOM_INTERN_HALL      2   // Connecting Hallway Corridor (fresh air zone)
#macro ROOM_INTERN_STORAGE   3   // Storage Room (shelves, lockers, water cooler)
#macro ROOM_INTERN_GLASS     4   // Panoramic Observation Room (2 walls of glass)
#macro ROOM_INTERN_GREEN     5   // Green Room (Wellness / Soothing Lounge, max 4 interns)

#macro INTERN_STATE_WORK       0 // Seated at computer, working
#macro INTERN_STATE_BORED      1 // Bored / roaming out to explore
#macro INTERN_STATE_SEEK_ROOM  2 // Navigating toward target room (avoids hallway)
#macro INTERN_STATE_MISCHIEF   3 // Interacting with hazard (shaking shelf, cracking glass, etc.)
#macro INTERN_STATE_TANTRUM    4 // Throwing tantrum (screaming, burning 2x oxygen)
#macro INTERN_STATE_HELD       5 // Being carried by Jack
#macro INTERN_STATE_KNOCKED_OUT 6 // Asphyxiated / crushed (needs CPR/revival)
#macro INTERN_STATE_DEAD       7 // Fallen from glass or suffocated (fatality)
#macro INTERN_STATE_SOOTHED    8 // Relaxing in Green Room (takes 10-20s, resets boredom)
#macro INTERN_STATE_TRAPPED    9 // Locked inside locker (hidden, awaiting player struggle pry)
#macro INTERN_STATE_VENT_STUCK 10 // Stuck in air vent shaft (blocks room airflow)
#macro INTERN_STATE_FUMING     11 // Pre-tantrum fuming/whining (safe grabbable window before full tantrum)

#macro HAZARD_SHELF          0   // Heavy supply shelf (wobbles and tips over)
#macro HAZARD_LOCKER         1   // Metal locker (rattles, traps intern)
#macro HAZARD_WATER          2   // Water cooler dispenser (wobbles, splashes)

// ---------------------------------------------------------------------------
// Spatial configuration
// ---------------------------------------------------------------------------
#macro CHUNK_SIZE   9   // Tiles per room chunk (width AND height)
#macro TILE_SIZE    16  // Pixels per tile (16x16)

// ---------------------------------------------------------------------------
// Logic grid dimensions (number of room slots, not pixels)
// ---------------------------------------------------------------------------
#macro LOGIC_GRID_W 14  // Logic map width  in room-slots (14 * 144 = 2016 px)
#macro LOGIC_GRID_H 12  // Logic map height in room-slots (12 * 144 = 1728 px)

// ---------------------------------------------------------------------------
// Path-length constraints
// ---------------------------------------------------------------------------
#macro MIN_PATH_LEN 5   // Minimum Normal rooms before End is allowed to place
#macro MAX_PATH_LEN 12  // Maximum Normal rooms; End is forced after this count

// ---------------------------------------------------------------------------
// Safety: maximum walker iterations before a generation retry is triggered
// ---------------------------------------------------------------------------
#macro GEN_MAX_ITER 10000

// ---------------------------------------------------------------------------
/// @function scr_get_chapter_name(_chapter)
/// @description Returns the display name of the given chapter (1..3).
// ---------------------------------------------------------------------------
function scr_get_chapter_name(_chapter) {
    switch (_chapter) {
        case CHAPTER_CAESAR:   return "CAESAR CIPHER";
        case CHAPTER_VIGENERE: return "VIGENERE CIPHER";
        case CHAPTER_ATBASH:   return "ATBASH CIPHER";
        default:               return "CAESAR CIPHER";
    }
}

// ---------------------------------------------------------------------------
/// @function scr_get_floor_curriculum(_chapter, _floor_num)
/// @description Returns the structured pedagogical & procedural configuration
///              for the specified Chapter (1..3) and Floor (1..10).
///              - Floors 1-3: Guided Hand-Holding Tutorials
///              - Floors 4-6: Core Duolingo-Style Practice
///              - Floors 7-9: Autonomous Mastery Practice (Training Wheels Off)
///              - Floor 10:   Chapter Final Exam
// ---------------------------------------------------------------------------
function scr_get_floor_curriculum(_chapter, _floor_num) {
    var _flr = clamp(_floor_num, 1, CHAPTER_MAX_FLOORS);
    var _ch  = clamp(_chapter, 1, 3);

    var _phase_name       = "PRACTICE";
    var _phase_badge      = "[PRACTICE]";
    var _hall_min         = 7;
    var _hall_max         = 9;
    var _side_rooms       = 10;
    var _encrypted_decoys = 2;
    var _room_extensions  = 4;
    var _spawn_drone      = true;
    var _drone_speed      = 0.92;
    var _clues_needed     = 1;
    var _guided_ui        = false;
    var _hide_shift_match = false;
    var _is_final_exam    = false;
    var _objective_title  = "";
    var _mentor_intro     = [];

    // 1. Determine Phase & Layout Parameters (Longer hallways, more filler & encrypted decoy rooms)
    if (_flr == 1) {
        _phase_name       = "TUTORIAL";
        _phase_badge      = "[TUTORIAL 1/3]";
        _hall_min         = 6;
        _hall_max         = 7;
        _side_rooms       = 9;
        _encrypted_decoys = 2; // 2 extra encrypted rooms so player explores all encrypted doors to find Elevator!
        _room_extensions  = 4; // Multi-chunk long rooms & annex filler rooms
        _spawn_drone      = true;  // Slow patrol bot so player can practice sneaking behind & apprehending!
        _drone_speed      = 0.65;
        _clues_needed     = 1;
        _guided_ui        = true;
    } else if (_flr == 2) {
        _phase_name       = "TUTORIAL";
        _phase_badge      = "[TUTORIAL 2/3]";
        _hall_min         = 6;
        _hall_max         = 8;
        _side_rooms       = 9;
        _encrypted_decoys = 2;
        _room_extensions  = 4;
        _spawn_drone      = true;
        _drone_speed      = 0.68;
        _clues_needed     = 1;
        _guided_ui        = true;
    } else if (_flr == 3) {
        _phase_name       = "TUTORIAL";
        _phase_badge      = "[TUTORIAL 3/3]";
        _hall_min         = 7;
        _hall_max         = 8;
        _side_rooms       = 10;
        _encrypted_decoys = 2;
        _room_extensions  = 4;
        _spawn_drone      = true;  // Introduce hallway drone & hiding lockers!
        _drone_speed      = 0.72;
        _clues_needed     = 1;
        _guided_ui        = true;
    } else if (_flr <= 6) {
        _phase_name       = "PRACTICE";
        _phase_badge      = "[PRACTICE " + string(_flr) + "/10]";
        _hall_min         = 8;
        _hall_max         = 10;
        _side_rooms       = 11;
        _encrypted_decoys = 3;
        _room_extensions  = 5;
        _spawn_drone      = true;
        _drone_speed      = 0.92;
        _clues_needed     = 1;
        _guided_ui        = false;
    } else if (_flr <= 9) {
        _phase_name       = "MASTERY";
        _phase_badge      = "[MASTERY " + string(_flr) + "/10]";
        _hall_min         = 9;
        _hall_max         = 11;
        _side_rooms       = 12;
        _encrypted_decoys = 3;
        _room_extensions  = 6;
        _spawn_drone      = true;
        _drone_speed      = 1.05;
        _clues_needed     = 1;
        _guided_ui        = false;
        _hide_shift_match = true; // Training wheels off!
    } else {
        _phase_name       = "FINAL EXAM";
        _phase_badge      = "[FINAL EXAM 10/10]";
        _hall_min         = 10;
        _hall_max         = 12;
        _side_rooms       = 13;
        _encrypted_decoys = 3;
        _room_extensions  = 6;
        _spawn_drone      = true;
        _drone_speed      = 1.08;
        _clues_needed     = 1;
        _guided_ui        = false;
        _hide_shift_match = true;
        _is_final_exam    = true;
    }

    // 2. Chapter-Specific Lesson Titles & Onboarding Dialogue
    if (_ch == CHAPTER_CAESAR) {
        if (_flr == 1) {
            _objective_title = "Guided Lesson: Forward Alphabet Shifts (+1 to +3)";
            _mentor_intro = [
                "Welcome to Chapter 1 (Caesar Cipher)! On Floors 1 to 3, I'll guide you through every mechanic—from unlocking the Key Vault to solving the detective case and managing your Scrap quota!"
            ];
        } else if (_flr == 2) {
            _objective_title = "Guided Lesson: Reverse Alphabet Shifts (-1 to -3)";
            _mentor_intro = [
                "Tutorial Floor 2/3! Caesar keys can also be NEGATIVE (-1 to -3), shifting letters backward toward 'A'. Follow your top-left Quest Tracker as we investigate this floor!"
            ];
        } else if (_flr == 3) {
            _objective_title = "Guided Lesson: Security Drones, Lockers & Brig Math";
            _mentor_intro = [
                "Tutorial Floor 3/3! Watch out—a rogue Security Drone is patrolling the hallway! Press [E] on blue Lockers to hide, or sneak behind it and press [RMB] / [E] to apprehend and scrap it!"
            ];
        } else if (_flr <= 6) {
            _objective_title = "Caesar Practice: Decode Locks Using the A-Z Ruler";
        } else if (_flr <= 9) {
            _objective_title = "Caesar Mastery: Count Shifts Without Slot Previews";
        } else {
            _objective_title = "CHAPTER 1 FINAL EXAM: Caesar Cipher & Cyber Mastery";
            _mentor_intro = [
                "This is Floor 10 — the CHAPTER 1 FINAL EXAM! All training wheels and ruler hints are off.",
                "Solve the breach case on [TAB], keep your Scrap in the 4-6 Green Zone, and crack the 5-letter Exam Lock on the Extraction Elevator!"
            ];
        }
    }
    else if (_ch == CHAPTER_VIGENERE) {
        if (_flr == 1) {
            _objective_title = "Guided Lesson: 2-Letter Keyword Shifts (B=+1, C=+2...)";
            _mentor_intro = [
                "Welcome to Chapter 2 (Vigenere Cipher)! Instead of one shift number, Vigenere uses a repeating KEYWORD where A=+0, B=+1, C=+2, D=+3, E=+4, F=+5."
            ];
        } else if (_flr == 2) {
            _objective_title = "Guided Lesson: Repeating 3-Letter Keywords (CAB / BED)";
            _mentor_intro = [
                "Tutorial Floor 2/3! When a 3-letter keyword like 'CAB' encrypts a 4-letter word, the keyword repeats (C-A-B-C). Watch the purple Keyword badge above each slot!"
            ];
        } else if (_flr == 3) {
            _objective_title = "Guided Lesson: Vigenere Field Stealth & Lockers";
            _mentor_intro = [
                "Tutorial Floor 3/3! Security drones are on patrol—use Hallway Lockers [E] to hide, or sneak behind a bot and press [RMB] / [E] to apprehend it for bonus Scrap!"
            ];
        } else if (_flr <= 6) {
            _objective_title = "Vigenere Practice: Apply Repeating Keyword Shifts";
        } else if (_flr <= 9) {
            _objective_title = "Vigenere Mastery: Independent Polyalphabetic Decoding";
        } else {
            _objective_title = "CHAPTER 2 FINAL EXAM: 4-Letter Keyword Mastery";
            _mentor_intro = [
                "Welcome to Floor 10 — the CHAPTER 2 FINAL EXAM! You'll face a 4-letter Vigenere Keyword with no slot hints.",
                "Identify Patient Zero on [TAB], stay in the 4-6 Scrap Green Zone, and clear this sector to unlock Chapter 3 (Atbash)!"
            ];
        }
    }
    else {
        if (_flr == 1) {
            _objective_title = "Guided Lesson: The Atbash Mirror Alphabet (A <-> Z)";
            _mentor_intro = [
                "Welcome to Chapter 3 (Atbash Cipher)! Atbash folds the alphabet in half like a mirror: 'A' swaps with 'Z', 'B' swaps with 'Y', all the way to 'M' <-> 'N'!"
            ];
        } else if (_flr == 2) {
            _objective_title = "Guided Lesson: Inner Mirror Pairs (G <-> T to M <-> N)";
            _mentor_intro = [
                "Tutorial Floor 2/3! Every letter on the top row (A..M) maps directly to the letter below it (Z..N) on the 2-row Mirror Bar."
            ];
        } else if (_flr == 3) {
            _objective_title = "Guided Lesson: Mirror Decoding Under Drone Patrol";
            _mentor_intro = [
                "Tutorial Floor 3/3! Drones are patrolling the corridor—use Lockers [E] to dodge their beams, solve the case on [TAB], and keep your Scrap in the 4-6 Green Zone!"
            ];
        } else if (_flr <= 6) {
            _objective_title = "Atbash Practice: Decode Using the 2-Row Mirror Bar";
        } else if (_flr <= 9) {
            _objective_title = "Atbash Mastery: Partial Mirror Bar (Recall Opposite Pairs)";
        } else {
            _objective_title = "CHAPTER 3 FINAL EXAM: Pure Atbash Mirror Mastery";
            _mentor_intro = [
                "This is Floor 10 — the CHAPTER 3 FINAL EXAM! The bottom row of the Mirror Bar is hidden.",
                "Use pure Atbash recall (A<->Z, M<->N) to solve the sector and beat the game!"
            ];
        }
    }

    return {
        chapter:          _ch,
        floor_num:        _flr,
        phase_name:       _phase_name,
        phase_badge:      _phase_badge,
        objective_title:  _objective_title,
        mentor_intro:     _mentor_intro,
        hall_min:         _hall_min,
        hall_max:         _hall_max,
        side_rooms:       _side_rooms,
        encrypted_decoys: _encrypted_decoys,
        room_extensions:  _room_extensions,
        spawn_drone:      _spawn_drone,
        drone_speed:      _drone_speed,
        clues_needed:     _clues_needed,
        guided_ui:        _guided_ui,
        hide_shift_match: _hide_shift_match,
        is_final_exam:    _is_final_exam
    };
}

// ---------------------------------------------------------------------------
/// @function scr_get_floor_incident_case(_case_idx)
/// @description Returns a complete Cybersecurity Incident Case struct for the floor.
///              Contains 10 distinct cases so all 10 floors in a chapter teach a
///              unique concept (with Case 9 adapting to the active Chapter's Cipher).
// ---------------------------------------------------------------------------
function scr_get_floor_incident_case(_case_idx) {
    var _ch = variable_global_exists("dungeon_chapter") ? global.dungeon_chapter : CHAPTER_CAESAR;

    // Case 0 dynamically reinforces the active chapter's cipher!
    var _cipher_case = {
        word:     "CAESAR",
        title:    "Alphabet Shift Cipher",
        scenario: "Classical cipher that shifts every letter in the alphabet by a fixed key:",
        hint:     "Named after Roman leader Julius Caesar.",
        takeaway: "TIP: Caesar ciphers only have 25 keys—easy for computers to crack!",
        victim_name: "David (Security Lead)",
        victim_dept: "Cybersecurity Ops",
        suspects: ["David (Sec Lead)", "Alice (Legal)", "Toby (Sales)"],
        vectors:  ["Forgot VPN on Public Wi-Fi", "Phishing Email", "Unknown USB Drive"],
        correct_suspect_idx: 0,
        correct_vector_idx:  0,
        desktop_items: [
            { label: "Mistake: Used Coffee-Shop Wi-Fi Without VPN", is_breach: true,  desc: "David forgot to turn on his VPN on free public Wi-Fi, so hackers on the same network saw our secret Caesar shift number!" },
            { label: "Memo: Scheduled Key Rotation for Q3",          is_breach: false, desc: "Normal security policy reminder to rotate employee keys." },
            { label: "Report: Firewall Packet Inspection Log",       is_breach: false, desc: "Normal inbound traffic inspection." }
        ],
        kyle_debrief: "David forgot to turn on his VPN on public Wi-Fi! Always use a VPN on public Wi-Fi so hackers can't snoop on your connection.",
        lesson_story: "David (Security Lead) worked from a coffee shop on free public Wi-Fi and accidentally forgot to turn on his VPN. Because public Wi-Fi isn't encrypted, hackers sitting nearby intercepted his connection and saw the floor's secret Caesar shift number!",
        prevention_rule: "HOW TO PREVENT IT: Always turn on a VPN (Virtual Private Network) before working on public Wi-Fi so your data is scrambled and invisible to snoops!",
        npc_clues: [
            "The hackers encrypted the doors with a 2,000-year-old Roman cipher that shifts every letter in the alphabet!",
            "If the shift key is +3, then 'A' becomes 'D'—and you shift 3 steps forward to decrypt it!",
            "The Key Vault is asking for the name of the Roman general who invented this alphabet-shift cipher!"
        ],
        jack_reply: "Shifting every letter by a fixed number down the alphabet... that's the CAESAR cipher!",
        pc_logs: [
            "ALERT: Door lock shifts each letter by a fixed number.\n\nCIPHER KEYWORD:   CAESAR",
            "DETECTED: Roman alphabet-shift encryption.\n\nCIPHER KEYWORD:   CAESAR",
            "NOTE: Named after Julius Caesar (shifts A-Z by key).\n\nCIPHER KEYWORD:   CAESAR"
        ],
        memo_notes: [
            "[STICKY NOTE]: 'The Roman alphabet-shift cipher = CAESAR!'",
            "[IT MEMO]: 'Key Vault Word: C-A-E-S-A-R.'"
        ],
        vault_challenge: {
            artifact_header: "CAPTURED NETWORK LOG:  Wi-Fi = 'Free_Cafe_Guest' (OPEN / NO PASSWORD)",
            artifact_body:   "VPN TUNNEL: OFF  |  OUTBOUND: Sent plain-text Caesar Shift Key (+K) over public Wi-Fi!",
            scanner_note:    "FORENSIC SCAN: Public Wi-Fi is unencrypted! Sending a Caesar Shift Key with VPN OFF lets anyone nearby snoop it.",
            prompt:          "Spot the red flag in this network log that exposed the floor's Caesar Cipher Key:",
            options: [
                "Public Wi-Fi used with VPN OFF — anyone on the cafe network could read the Caesar Shift Key",
                "The coffee shop Wi-Fi signal strength was too weak to load emails quickly",
                "The Caesar Cipher shifts letters by a fixed number instead of mirroring A to Z"
            ],
            correct_idx: 0,
            explain_win: "SPOT ON! Always turn on an encrypted VPN on public Wi-Fi so snoops can't read your connection!"
        },
        fixes: [
            "Always turn on an encrypted VPN before working on public Wi-Fi",
            "Disable the computer's Firewall to boost public Wi-Fi speed",
            "Write the Caesar shift number on a sticky note taped to the monitor"
        ],
        correct_fix_idx: 0,
        debrief_quiz: {
            question: "REAL-LIFE CHECK: You're at a coffee shop on free public Wi-Fi and need to log into your school or work account. What should you do first?",
            options: [
                "Turn on a trusted VPN (or use your phone's personal hotspot) so your connection is encrypted",
                "Turn off your Firewall so the coffee shop Wi-Fi connects faster",
                "Log in right away—public Wi-Fi automatically hides your data from other guests"
            ],
            correct_idx: 0,
            feedback_ok: "CORRECT! Public Wi-Fi is open to snoops—a VPN scrambles your traffic so nobody nearby can intercept it!"
        }
    };

    if (_ch == CHAPTER_VIGENERE) {
        _cipher_case = {
            word:     "VIGENERE",
            title:    "Polyalphabetic Keyword Cipher",
            scenario: "Cipher that uses a repeating KEYWORD to shift each letter by a different amount:",
            hint:     "Uses a repeating keyword (A=0, B=1, C=2...) instead of a single shift.",
            takeaway: "TIP: Vigenere resists simple frequency analysis by using multiple shifts!",
            victim_name: "David (Security Lead)",
            victim_dept: "Cybersecurity Ops",
            suspects: ["David (Sec Lead)", "Alice (Legal)", "Toby (Sales)"],
            vectors:  ["Saved Keyword in Public Folder", "Phishing Email", "Unknown USB Drive"],
            correct_suspect_idx: 0,
            correct_vector_idx:  0,
            desktop_items: [
                { label: "Mistake: Saved Keyword in Shared Public Note", is_breach: true,  desc: "David was afraid of forgetting the Vigenere keyword, so he typed it into an unlocked public folder where hackers found it!" },
                { label: "Memo: Vigenere Table Matrix Reference",  is_breach: false, desc: "26x26 Caesar shift grid for manual decryption." },
                { label: "Notice: Password Hygiene Guidelines",     is_breach: false, desc: "Standard company password security memo." }
            ],
            kyle_debrief: "David saved the secret keyword in an unlocked public folder! Always store passwords and keys inside an encrypted Password Manager.",
            lesson_story: "David (Security Lead) was worried he might forget the floor's repeating Vigenere keyword, so he saved it inside an unlocked shared folder. Hackers found the plain-text note and used the keyword to lock down the floor!",
            prevention_rule: "HOW TO PREVENT IT: Never write passwords or secret keys in plain-text notes or public folders—use an encrypted Password Manager instead!",
            npc_clues: [
                "Instead of shifting every letter by the same number, this lock uses a repeating keyword where A=0, B=1, C=2!",
                "Because each letter in the keyword applies a different Caesar shift, it's called a polyalphabetic cipher!",
                "The Key Vault wants the name of this famous 16th-century keyword cipher: V-I-G-E-N-E-R-E!"
            ],
            jack_reply: "A polyalphabetic cipher that shifts letters using a repeating keyword... that's VIGENERE!",
            pc_logs: [
                "ALERT: Lock uses a repeating keyword to shift letters.\n\nCIPHER KEYWORD:   VIGENERE",
                "DETECTED: Polyalphabetic keyword encryption active.\n\nCIPHER KEYWORD:   VIGENERE",
                "NOTE: Each keyword letter shifts A-Z by its own value.\n\nCIPHER KEYWORD:   VIGENERE"
            ],
            memo_notes: [
                "[STICKY NOTE]: 'The repeating-keyword shift cipher = VIGENERE!'",
                "[IT MEMO]: 'Key Vault Word: V-I-G-E-N-E-R-E.'"
            ],
            vault_challenge: {
                artifact_header: "CAPTURED FILE AUDIT:  /Public_Shared_Drive/vigenere_floor_key.txt",
                artifact_body:   "PERMISSIONS: Everyone (Read/Write)  |  CONTENTS: 'Floor Repeating Vigenere Keyword = CAB'",
                scanner_note:    "FORENSIC SCAN: The secret Vigenere keyword was saved in an unlocked public folder where any intruder can read it!",
                prompt:          "Spot the security mistake in this file audit that leaked the Vigenere Keyword:",
                options: [
                    "Saving a secret Vigenere keyword in an unlocked, plain-text public folder anyone can open",
                    "Using a repeating keyword where A=+0, B=+1, and C=+2 to shift letters",
                    "Backing up encrypted system files to an offline vault"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Never store passwords or cipher keywords in plain-text public folders—use an encrypted Password Manager!"
            },
            fixes: [
                "Store secret keys and passwords in an encrypted Password Manager, never plain-text public folders",
                "Rename the plain-text password file to 'do_not_open.txt' inside the public folder",
                "Use the same 3-letter password for every employee account on the floor"
            ],
            correct_fix_idx: 0,
            debrief_quiz: {
                question: "REAL-LIFE CHECK: You have several complex passwords and keywords you're afraid of forgetting. Where is the safest place to store them?",
                options: [
                    "Inside an encrypted Password Manager protected by a strong master password",
                    "In a plain-text file inside a shared public folder so you can open it anywhere",
                    "In a public social media bio or unencrypted sticky note on your screen"
                ],
                correct_idx: 0,
                feedback_ok: "CORRECT! An encrypted Password Manager locks all your credentials behind strong encryption so plain-text snoops get nothing!"
            }
        };
    } else if (_ch == CHAPTER_ATBASH) {
        _cipher_case = {
            word:     "ATBASH",
            title:    "Alphabet Mirror Cipher",
            scenario: "Ancient substitution cipher that folds the alphabet like a mirror (A<->Z, B<->Y):",
            hint:     "Swaps the first letter (A) with the last (Z), second (B) with second-to-last (Y).",
            takeaway: "TIP: Atbash has no secret key—anyone who knows the mirror rule can decode it!",
            victim_name: "David (Security Lead)",
            victim_dept: "Cybersecurity Ops",
            suspects: ["David (Sec Lead)", "Alice (Legal)", "Toby (Sales)"],
            vectors:  ["Left No-Key Mirror Mode On", "Phishing Email", "Unknown USB Drive"],
            correct_suspect_idx: 0,
            correct_vector_idx:  0,
            desktop_items: [
                { label: "Mistake: Left 'No-Password' Mirror Test Mode On", is_breach: true,  desc: "David tested the doors with an Atbash mirror cipher (A<->Z) and forgot that Atbash has NO secret password—anyone can flip it back!" },
                { label: "Doc: Ancient Hebrew Cipher History",        is_breach: false, desc: "Historical document on Biblical monoalphabetic ciphers." },
                { label: "Memo: Terminal Maintenance Schedule",        is_breach: false, desc: "Routine cleaning and dusting for server racks." }
            ],
            kyle_debrief: "David accidentally left the doors on an Atbash mirror test mode that doesn't require a secret key!",
            lesson_story: "David (Security Lead) switched the security doors to an old Atbash mirror cipher (which just flips A to Z and B to Y) during a morning test and forgot to switch it back. Because Atbash has no secret key, hackers reversed the letters immediately!",
            prevention_rule: "HOW TO PREVENT IT: Never protect important accounts with 'security by obscurity'—always use strong encryption that requires a secret password or key!",
            npc_clues: [
                "The hackers folded the alphabet in half like a mirror—'A' becomes 'Z', 'B' becomes 'Y', and 'M' becomes 'N'!",
                "Because the alphabet is reversed end-to-end, encrypting and decrypting use the exact same mirror rule!",
                "The Key Vault is asking for the name of this ancient mirror-alphabet cipher: A-T-B-A-S-H!"
            ],
            jack_reply: "Reflecting the alphabet like a mirror where A swaps with Z and B swaps with Y... that's ATBASH!",
            pc_logs: [
                "ALERT: Door lock reverses the alphabet (A<->Z, B<->Y).\n\nCIPHER KEYWORD:   ATBASH",
                "DETECTED: Ancient mirror-alphabet substitution cipher.\n\nCIPHER KEYWORD:   ATBASH",
                "NOTE: Top row A..M reflects onto bottom row Z..N.\n\nCIPHER KEYWORD:   ATBASH"
            ],
            memo_notes: [
                "[STICKY NOTE]: 'The mirror-alphabet cipher (A<->Z) = ATBASH!'",
                "[IT MEMO]: 'Key Vault Word: A-T-B-A-S-H.'"
            ],
            vault_challenge: {
                artifact_header: "CAPTURED DOOR CONFIG:  MODE = ATBASH_MIRROR (A<->Z, B<->Y)",
                artifact_body:   "SECRET KEY REQUIRED: NONE  |  WARNING: Fixed mirror rule can be reversed by anyone!",
                scanner_note:    "FORENSIC SCAN: Atbash always flips A<->Z with NO secret key—relying on a fixed rule is 'security by obscurity'!",
                prompt:          "Spot the weakness in this door configuration that let hackers decode it instantly:",
                options: [
                    "Atbash has NO secret key—anyone who knows the A<->Z mirror rule can flip the letters right back",
                    "The Atbash mirror cipher requires a 64-character hardware token",
                    "The door lock timed out because the password was too long"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Because Atbash has no secret key, anyone who knows A<->Z can reverse it. Real encryption requires a secret key!"
            },
            fixes: [
                "Always use strong encryption that requires a secret password or key, not a key-less public rule",
                "Use Atbash twice in a row so A flips to Z and then back to A",
                "Leave the test mode switched on overnight to save time"
            ],
            correct_fix_idx: 0,
            debrief_quiz: {
                question: "REAL-LIFE CHECK: Why isn't a key-less rule like flipping the alphabet backwards (Atbash: A<->Z) safe for protecting real passwords?",
                options: [
                    "Because there is no secret key—once anyone knows the rule, they can reverse every message immediately",
                    "Because computers cannot display the letter Z on modern monitors",
                    "Because Atbash requires too much electricity to calculate"
                ],
                correct_idx: 0,
                feedback_ok: "CORRECT! Real security never relies on hoping people don't know the trick—it relies on strong secret keys!"
            }
        };
    }

    var _cases = [
        _cipher_case,
        {
            word:     "PHISHING",
            title:    "Fake Login Emails",
            scenario: "Fake emails or websites that trick you into giving up passwords:",
            hint:     "Uses fake emails as 'bait' to steal logins.",
            takeaway: "TIP: Always check the sender's address before clicking login links!",
            victim_name: "Dave Miller",
            victim_dept: "Logistics & Shipping",
            suspects: ["Dave Miller", "Karen Jenkins", "Frank Castle"],
            vectors:  ["Phishing Email Link", "Trojan Free Download", "Firewall Turned Off"],
            correct_suspect_idx: 0,
            correct_vector_idx:  0,
            desktop_items: [
                { label: "Mistake: Clicked Fake 'Urgent Invoice' Email", is_breach: true,  desc: "Dave was rushing before lunch and clicked an 'URGENT: Overdue Invoice' link without noticing the sender's email was fake (Phishing)!" },
                { label: "Email: 'Weekly Shipping Schedule'",             is_breach: false, desc: "From dispatch@skipjack.com - standard logistics spreadsheet." },
                { label: "Email: 'Warehouse Coffee Machine Repaired'",    is_breach: false, desc: "Office announcement from building maintenance." }
            ],
            kyle_debrief: "Dave was in a rush and accidentally fell for a fake Phishing email! Always check the sender's address before logging in.",
            lesson_story: "Dave Miller (Logistics) received an email marked 'URGENT: Overdue Invoice' right before lunch. Wanting to resolve it quickly, he clicked the link and typed his password into a fake look-alike website without noticing the sender address was misspelled!",
            prevention_rule: "HOW TO PREVENT IT: Scammers use 'URGENT!' messages to make you panic and click without thinking. Always pause and check the real sender address and website URL!",
            npc_clues: [
                "Someone clicked a fake 'Holiday Bonus' email and typed their login into a bogus page!",
                "I almost fell for that fake IT login email too, until I saw the sender URL was misspelled!",
                "The hackers sent urgent fake emails pretending to be HR just to steal our passwords!"
            ],
            jack_reply: "Fake emails baiting people into handing over their passwords... that's PHISHING!",
            pc_logs: [
                "ALERT: Fake 'Password Reset' email stole staff logins.\n\nTHREAT KEYWORD:   PHISHING",
                "BLOCKED: Bogus login page imitating internal portal.\n\nTHREAT KEYWORD:   PHISHING",
                "NOTE: Fake emails used as 'bait' to steal data.\n\nTHREAT KEYWORD:   PHISHING"
            ],
            memo_notes: [
                "[STICKY NOTE]: 'Urgent fake emails asking for your password = PHISHING!'",
                "[IT MEMO]: 'Key Vault Word: P-H-I-S-H-I-N-G.'"
            ],
            vault_challenge: {
                artifact_header: "CAPTURED EMAIL:  From: support@skipj4ck-login-verify.net  |  Subject: URGENT INVOICE!",
                artifact_body:   "MESSAGE: 'Your account will be locked in 10 minutes! Click http://skipj4ck-login-verify.net to enter your password.'",
                scanner_note:    "FORENSIC SCAN: Look at the domain ('skipj4ck-login-verify.net') and the fake urgency—classic PHISHING bait!",
                prompt:          "Spot the red flag in this captured email that proves it is a Phishing attack:",
                options: [
                    "Misspelled look-alike domain ('skipj4ck') + fake 'URGENT!' panic demanding a password login",
                    "The email was sent during normal weekday lunch hours",
                    "The email mentions an invoice instead of a calendar invite"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Phishing uses fake urgency and look-alike domains ('skipj4ck') as bait to steal your login!"
            },
            fixes: [
                "Always inspect the real sender address/URL and never log in through urgent email links",
                "Reply to the suspicious email with your password so IT can check if it's real",
                "Click the link quickly before the 10-minute countdown timer expires"
            ],
            correct_fix_idx: 0,
            debrief_quiz: {
                question: "REAL-LIFE CHECK: You receive an 'URGENT: Account Suspended!' email with a link asking you to sign in right away. What is the safest move?",
                options: [
                    "Do not click the link—check the sender's real email address and go to the official website directly in your browser",
                    "Click the link and type your password quickly before your account gets deleted",
                    "Forward the link to all your friends so they can test if the website is real"
                ],
                correct_idx: 0,
                feedback_ok: "CORRECT! Never trust login links inside urgent emails—always navigate to the official website yourself!"
            }
        },
        {
            word:     "TROJAN",
            title:    "Disguised Malware App",
            scenario: "Malware disguised as a harmless, useful program:",
            hint:     "Hides inside a normal-looking app (like the Trojan Horse).",
            takeaway: "TIP: Only download apps from official, verified sources!",
            victim_name: "Karen Jenkins",
            victim_dept: "Human Resources",
            suspects: ["Karen Jenkins", "Dave Miller", "Marcus Vance"],
            vectors:  ["Trojan Free Download", "Phishing Email Link", "Unknown USB Drive"],
            correct_suspect_idx: 0,
            correct_vector_idx:  0,
            desktop_items: [
                { label: "Mistake: Installed Unofficial 'Free_PDF_Helper.exe'", is_breach: true,  desc: "Karen downloaded a free PDF tool from a random website to finish her HR forms faster—not realizing a Trojan virus was hiding inside!" },
                { label: "Doc: 'Benefits Enrollment Form 2026.docx'",is_breach: false, desc: "Standard company insurance policy documentation." },
                { label: "Memo: 'Intern Babysitting Shift Rota'",     is_breach: false, desc: "Shift schedule for supervising the intern ward." }
            ],
            kyle_debrief: "Karen only wanted to finish her forms faster, but that unofficial free app hid a Trojan virus inside!",
            lesson_story: "Karen Jenkins (HR) had a pile of paperwork due and downloaded 'Free_PDF_Helper.exe' from a random website to speed up her job. The app looked helpful on the outside, but secretly installed a Trojan virus in the background!",
            prevention_rule: "HOW TO PREVENT IT: A 'Trojan' hides harmful malware inside a normal-looking free program or game mod. Only download software from official, trusted app stores!",
            npc_clues: [
                "Someone in accounting installed 'Free_Spreadsheet_Turbo.exe' and it secretly unlocked the building's backdoors!",
                "That app looked like a harmless desktop tool on the outside, but it hid hacker malware inside!",
                "It didn't spread on its own—it tricked us into installing it by pretending to be useful software!"
            ],
            jack_reply: "Malware hiding inside a harmless-looking program—just like the wooden TROJAN horse!",
            pc_logs: [
                "ALERT: 'Desktop_Clock.exe' opened a hidden backdoor.\n\nTHREAT KEYWORD:   TROJAN",
                "QUARANTINE: Disguised app hiding remote-access code.\n\nTHREAT KEYWORD:   TROJAN",
                "NOTE: Malware disguised as a helpful program.\n\nTHREAT KEYWORD:   TROJAN"
            ],
            memo_notes: [
                "[STICKY NOTE]: 'Malware disguised as a helpful app = TROJAN!'",
                "[IT MEMO]: 'Key Vault Word: T-R-O-J-A-N.'"
            ],
            vault_challenge: {
                artifact_header: "CAPTURED DOWNLOAD LOG:  File = 'Free_PDF_Helper_Pro.exe'  |  Source: mega-free-tools.biz",
                artifact_body:   "PUBLISHER: Unknown (Unverified)  |  HIDDEN ACTION: Unpacked 'remote_backdoor.dll' in background!",
                scanner_note:    "FORENSIC SCAN: An unverified '.exe' pretending to be a helpful PDF tool while hiding malware inside is a TROJAN!",
                prompt:          "Spot the red flag in this download log that reveals a Trojan Horse attack:",
                options: [
                    "An unverified '.exe' from a random site disguised as a helpful PDF tool while secretly installing malware",
                    "Opening a normal '.docx' word document created by Human Resources",
                    "Using an official PDF reader pre-installed by the IT department"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Just like the wooden Trojan Horse, a Trojan disguises malware inside a 'free' useful program!"
            },
            fixes: [
                "Only download software from official, verified publishers or IT-approved app stores",
                "Run unknown '.exe' installers as Administrator so they install faster",
                "Turn off antivirus warnings whenever downloading free tools from random websites"
            ],
            correct_fix_idx: 0,
            debrief_quiz: {
                question: "REAL-LIFE CHECK: You need a free tool or game mod, and a random website offers 'Free_Turbo_Installer.exe' from an unknown publisher. What should you do?",
                options: [
                    "Do not download it—only install apps from official, verified app stores or the trusted developer's real site",
                    "Download and run it right away since the filename says it's free and helpful",
                    "Disable your antivirus first so it doesn't block the free installer"
                ],
                correct_idx: 0,
                feedback_ok: "CORRECT! Trojans hide inside 'free' unofficial installers and game mods—stick to official, verified sources!"
            }
        },
        {
            word:     "FIREWALL",
            title:    "Network Traffic Barrier",
            scenario: "The security barrier that monitors and blocks unauthorized network traffic:",
            hint:     "Blocks suspicious traffic between your network and the internet.",
            takeaway: "TIP: Keep your Firewall enabled to block unauthorized connections!",
            victim_name: "Bob Higgins",
            victim_dept: "Marketing & PR",
            suspects: ["Bob Higgins", "Chloe Rivera", "Alice Cooper"],
            vectors:  ["Firewall Turned Off", "Spyware Pop-Up Ad", "Phishing Email Link"],
            correct_suspect_idx: 0,
            correct_vector_idx:  0,
            desktop_items: [
                { label: "Mistake: Turned Off Firewall & Forgot It", is_breach: true,  desc: "Bob switched off his Firewall for 5 minutes because his video call was lagging, and accidentally forgot to turn it back on!" },
                { label: "Draft: 'New Product Press Release'",             is_breach: false, desc: "Marketing copy for the upcoming Skipjack cipher tool." },
                { label: "Bookmark: 'Social Media Analytics Dashboard'",   is_breach: false, desc: "Official marketing metrics page." }
            ],
            kyle_debrief: "Bob turned off his Firewall to fix a laggy call and forgot to turn it back on! Never leave your Firewall disabled.",
            lesson_story: "Bob Higgins (Marketing) was having trouble with a laggy video stream, so he temporarily turned off his computer's Firewall to test the connection—and completely forgot to turn it back on. Without that digital security barrier, hackers slipped right in!",
            prevention_rule: "HOW TO PREVENT IT: Your Firewall is a 24/7 digital security guard that blocks bad internet traffic. Never turn off your Firewall or Antivirus to fix a slow connection!",
            npc_clues: [
                "Someone turned off our network traffic filter to host a LAN party, and the hackers walked right in!",
                "Without our digital security guard checking incoming data packets, every network port was wide open!",
                "We need to re-enable the security barrier that blocks unauthorized traffic between our LAN and the internet!"
            ],
            jack_reply: "The security barrier that filters network traffic based on rules... our FIREWALL is down!",
            pc_logs: [
                "WARNING: Inbound network packet filter is OFF.\n\nDEFENSE KEYWORD:   FIREWALL",
                "ALERT: Unauthorized ports exposed to the internet.\n\nDEFENSE KEYWORD:   FIREWALL",
                "NOTE: Security barrier that filters network traffic.\n\nDEFENSE KEYWORD:   FIREWALL"
            ],
            memo_notes: [
                "[STICKY NOTE]: 'The barrier that blocks bad network traffic = FIREWALL!'",
                "[IT MEMO]: 'Key Vault Word: F-I-R-E-W-A-L-L.'"
            ],
            vault_challenge: {
                artifact_header: "CAPTURED SECURITY LOG:  Network Packet Shield (FIREWALL) = DISABLED",
                artifact_body:   "OPEN PORTS: All Inbound Traffic Allowed  |  REASON LOGGED: 'Turned off to fix laggy video call'",
                scanner_note:    "FORENSIC SCAN: Turning off the FIREWALL removed the security barrier that blocks unauthorized internet traffic!",
                prompt:          "Spot the security failure in this network log that let hackers connect directly to the PC:",
                options: [
                    "The Firewall was turned OFF, removing the security barrier that blocks unauthorized network traffic",
                    "The user joined a scheduled marketing video call during work hours",
                    "The computer monitor brightness was set too high"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! A Firewall acts as a 24/7 traffic barrier—turning it off leaves your computer's ports wide open!"
            },
            fixes: [
                "Keep your Firewall enabled at all times so unauthorized network traffic is blocked automatically",
                "Turn off your Firewall whenever a game or video stream feels slow",
                "Open every network port on your router so websites load faster"
            ],
            correct_fix_idx: 0,
            debrief_quiz: {
                question: "REAL-LIFE CHECK: Your online game or video call is lagging, and a random comment online tells you to completely turn off your computer's Firewall. What should you do?",
                options: [
                    "Keep your Firewall ON—disabling it exposes your computer to hackers; troubleshoot your Wi-Fi or app settings instead",
                    "Turn off your Firewall permanently so your internet never lags again",
                    "Uninstall all security updates to free up memory"
                ],
                correct_idx: 0,
                feedback_ok: "CORRECT! Never disable your Firewall to fix lag—it's the digital guard keeping outside attackers out of your network!"
            }
        },
        {
            word:     "BOTNET",
            title:    "Hijacked Device Army",
            scenario: "A network of hijacked 'zombie' computers controlled remotely by a hacker:",
            hint:     "'Robot' + 'Network' — an army of infected devices.",
            takeaway: "TIP: Change default passwords on smart devices to stop Botnets!",
            victim_name: "Chloe Rivera",
            victim_dept: "Smart Facilities",
            suspects: ["Chloe Rivera", "Bob Higgins", "Greg Vance"],
            vectors:  ["Default '1234' Password (Botnet)", "Unknown USB Drive", "Reused Password"],
            correct_suspect_idx: 0,
            correct_vector_idx:  0,
            desktop_items: [
                { label: "Mistake: Left Smart Devices on Default '1234' Password", is_breach: true,  desc: "Chloe plugged in the new office smart printers and lights in a rush and forgot to change their factory 'admin / 1234' password!" },
                { label: "Log: 'Breakroom Thermostat Schedule'",                 is_breach: false, desc: "Normal AC settings for the 3rd floor." },
                { label: "Notice: 'Elevator Maintenance Due'",                    is_breach: false, desc: "Routine building service log." }
            ],
            kyle_debrief: "Chloe forgot to change the factory '1234' password on the new smart devices, so hackers hijacked them into a Botnet!",
            lesson_story: "Chloe Rivera (Facilities) set up the floor's new Wi-Fi printers and smart lights in a hurry and forgot to change their factory-default '1234' password. Hackers guessed '1234' automatically and hijacked the devices into a zombie Botnet army!",
            prevention_rule: "HOW TO PREVENT IT: Hackers scan the internet 24/7 for devices still using default passwords like 'admin', '0000', or '1234'. Always set a strong new password as soon as you plug in a new device!",
            npc_clues: [
                "Even the breakroom smart fridge and the office printers got hijacked into a zombie army!",
                "Hundreds of infected office devices are all taking remote orders from the hacker's server at once!",
                "They linked all our hijacked computers together—'Robot' plus 'Network'!"
            ],
            jack_reply: "A whole network of hijacked zombie devices controlled remotely... we're dealing with a BOTNET!",
            pc_logs: [
                "ALERT: 240 office devices taking remote hacker orders.\n\nTHREAT KEYWORD:   BOTNET",
                "DETECTED: Fleet of hijacked zombie PCs ('Bot' + 'Network').\n\nTHREAT KEYWORD:   BOTNET",
                "NOTE: Smart devices linked into a remote army.\n\nTHREAT KEYWORD:   BOTNET"
            ],
            memo_notes: [
                "[STICKY NOTE]: 'An army of hijacked zombie devices = BOTNET!'",
                "[IT MEMO]: 'Key Vault Word: B-O-T-N-E-T.'"
            ],
            vault_challenge: {
                artifact_header: "CAPTURED IOT DEVICE SCAN:  240 Office Smart Printers & Wi-Fi Lights Hijacked",
                artifact_body:   "LOGIN CREDENTIALS: Username = 'admin' | Password = '1234' (Factory Default — Never Changed!)",
                scanner_note:    "FORENSIC SCAN: Automated hacker scripts guessed the factory 'admin / 1234' login and linked the devices into a BOTNET!",
                prompt:          "Spot the red flag that allowed hackers to hijack 240 smart devices into a Botnet army:",
                options: [
                    "The smart devices were left on their factory-default password ('admin / 1234') instead of a strong new password",
                    "The office printers were connected to electrical outlets during the day",
                    "The breakroom thermostat was set to 70 degrees"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Hackers scan automatically for factory passwords like '1234' to hijack smart devices into a Botnet!"
            },
            fixes: [
                "Change factory-default passwords ('admin / 1234') to a strong, unique password immediately upon setup",
                "Keep the factory '1234' password so everyone in the building can remember it easily",
                "Tape the default password on the front of the Wi-Fi router"
            ],
            correct_fix_idx: 0,
            debrief_quiz: {
                question: "REAL-LIFE CHECK: Your family sets up a new Wi-Fi router, smart camera, or printer at home that comes with a default password like 'admin' or '1234'. What should you do first?",
                options: [
                    "Change the factory-default password immediately to a strong, unique password",
                    "Leave it as '1234' so you never forget it—hackers don't target home devices",
                    "Post the device's IP address online to test if it works"
                ],
                correct_idx: 0,
                feedback_ok: "CORRECT! Changing default passwords right away stops automated Botnet scanners from hijacking your smart devices!"
            }
        },
        {
            word:     "SPYWARE",
            title:    "Hidden Keylogger",
            scenario: "Malicious software that secretly watches your screen and records keystrokes:",
            hint:     "Acts like a hidden spy to steal your passwords.",
            takeaway: "TIP: Scan regularly for hidden background keyloggers and Spyware!",
            victim_name: "Greg Vance",
            victim_dept: "Accounting",
            suspects: ["Greg Vance", "Karen Jenkins", "Dave Miller"],
            vectors:  ["Spyware Pop-Up Ad", "Phishing Email Link", "Firewall Turned Off"],
            correct_suspect_idx: 0,
            correct_vector_idx:  0,
            desktop_items: [
                { label: "Mistake: Clicked 'Allow' on a Fake Update Pop-Up", is_breach: true,  desc: "Greg accidentally clicked 'Allow' on a flashing browser pop-up ad, which silently installed Spyware that recorded his keyboard!" },
                { label: "Sheet: 'Q2 Tax Returns.xlsx'",                    is_breach: false, desc: "Quarterly accounting spreadsheet." },
                { label: "Receipt: 'Office Supplies Order #401'",           is_breach: false, desc: "Purchased printer toner and pens." }
            ],
            kyle_debrief: "Greg clicked a fake browser update pop-up that secretly installed Spyware to record his passwords!",
            lesson_story: "Greg Vance (Accounting) saw a flashing pop-up ad while browsing that said 'Your Browser Is Out of Date—Click Here!' Thinking he was being responsible, he clicked it—accidentally installing Spyware that secretly recorded every password he typed!",
            prevention_rule: "HOW TO PREVENT IT: Real browser and system updates never come from flashing website pop-up ads! Close pop-up ads immediately and only update apps through your official Settings menu.",
            npc_clues: [
                "The hackers knew my new password five seconds after I typed it! Something is recording my keyboard!",
                "It didn't lock my screen—it just hid silently in the background watching everything I typed!",
                "Kyle found a hidden keylogger secretly spying on our screens and sending data to the hackers!"
            ],
            jack_reply: "Malware that hides in the background to secretly watch and record your activity... that's SPYWARE!",
            pc_logs: [
                "ALERT: Hidden keylogger recording keyboard input.\n\nTHREAT KEYWORD:   SPYWARE",
                "DETECTED: Background process secretly stealing logins.\n\nTHREAT KEYWORD:   SPYWARE",
                "NOTE: Software that secretly spies on user activity.\n\nTHREAT KEYWORD:   SPYWARE"
            ],
            memo_notes: [
                "[STICKY NOTE]: 'Software that secretly records what you type = SPYWARE!'",
                "[IT MEMO]: 'Key Vault Word: S-P-Y-W-A-R-E.'"
            ],
            vault_challenge: {
                artifact_header: "CAPTURED BROWSER ALERT:  Flashing Pop-Up Ad on 'free-coupons-daily.net'",
                artifact_body:   "POP-UP CLICKED: 'SYSTEM OUT OF DATE! Click ALLOW to run update_patch.exe' -> Installed hidden keylogger!",
                scanner_note:    "FORENSIC SCAN: Clicking a fake website pop-up ad installed SPYWARE (a hidden keylogger recording every keystroke)!",
                prompt:          "Spot the red flag in this browser log that installed Spyware on the computer:",
                options: [
                    "Clicking 'ALLOW' on a flashing website pop-up ad pretending to be a browser update",
                    "Updating the browser through the official Settings -> About menu",
                    "Typing numbers into an offline Excel tax spreadsheet"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Fake update pop-up ads often install Spyware that silently records your screen and keyboard!"
            },
            fixes: [
                "Close flashing website pop-up ads immediately and only update apps via your official Settings menu",
                "Click 'Allow' on every browser pop-up so the alerts disappear faster",
                "Keep typing passwords even when a keylogger alert appears"
            ],
            correct_fix_idx: 0,
            debrief_quiz: {
                question: "REAL-LIFE CHECK: While browsing a website, a loud flashing pop-up banner appears claiming 'Your Browser Is Out of Date — Click Here to Update Now!' What should you do?",
                options: [
                    "Close the tab or pop-up immediately—real updates only happen inside your browser or OS Settings menu",
                    "Click the flashing banner and run the downloaded '.exe' file to stay up to date",
                    "Enter your computer's admin password into the pop-up window"
                ],
                correct_idx: 0,
                feedback_ok: "CORRECT! Legitimate system and browser updates never come from website pop-up ads!"
            }
        },
        {
            word:     "MALWARE",
            title:    "Malicious Software",
            scenario: "The general umbrella term for any 'Malicious Software' built to harm a PC:",
            hint:     "Short for MALicious + softWARE.",
            takeaway: "TIP: Never plug unknown USB drives into your computer!",
            victim_name: "Marcus Vance",
            victim_dept: "Software Engineering",
            suspects: ["Marcus Vance", "Chloe Rivera", "Toby Flend"],
            vectors:  ["Unknown Parking-Lot USB", "Trojan Free Download", "Forgotten Guest Link"],
            correct_suspect_idx: 0,
            correct_vector_idx:  0,
            desktop_items: [
                { label: "Mistake: Plugged In a 'Lost' USB to Return It", is_breach: true,  desc: "Marcus found a lost USB drive outside and plugged it into his work PC just to see whose name was on it—accidentally launching Malware!" },
                { label: "Code: 'skipjack_core.c (Clean Git Commit)'",           is_breach: false, desc: "Normal source code repository checkout." },
                { label: "Doc: 'API Documentation v2.1'",                         is_breach: false, desc: "Internal developer documentation." }
            ],
            kyle_debrief: "Marcus was just trying to return a lost USB drive, but plugging it in automatically launched Malware!",
            lesson_story: "Marcus Vance (Engineering) found a USB flash drive in the parking lot and wanted to be helpful by checking whose files were on it so he could return it. The USB was a hacker trap that automatically installed Malware (Malicious Software) the second he plugged it in!",
            prevention_rule: "HOW TO PREVENT IT: Never plug an unknown USB flash drive or charging cable into your computer—even to see who owns it! Turn lost drives directly over to IT security.",
            npc_clues: [
                "Someone found a USB drive in the parking lot labeled 'Bonus Pay' and plugged it into the server!",
                "As soon as that USB drive went in, hostile software started corrupting files and locking doors!",
                "Whether it's a virus, worm, or trojan, any 'Malicious Software' built to harm a system has one umbrella name!"
            ],
            jack_reply: "MALicious + softWARE... the umbrella term for any hostile program is MALWARE!",
            pc_logs: [
                "ALERT: Unknown USB drive launched hostile code.\n\nTHREAT KEYWORD:   MALWARE",
                "DETECTED: MALicious + softWARE corrupting system files.\n\nTHREAT KEYWORD:   MALWARE",
                "NOTE: Umbrella term for viruses, trojans & spyware.\n\nTHREAT KEYWORD:   MALWARE"
            ],
            memo_notes: [
                "[STICKY NOTE]: 'MALicious + softWARE = MALWARE!'",
                "[IT MEMO]: 'Key Vault Word: M-A-L-W-A-R-E.'"
            ],
            vault_challenge: {
                artifact_header: "CAPTURED USB PORT LOG:  External Drive 'PARKING_LOT_USB' Inserted on Port #2",
                artifact_body:   "AUTORUN EXECUTED: 'owner_contact_info.scr.exe' -> Deployed MALWARE (Malicious Software) payload!",
                scanner_note:    "FORENSIC SCAN: Attackers drop 'lost' USB drives in parking lots hoping someone plugs them in and launches MALWARE!",
                prompt:          "Spot the risky action in this hardware log that infected the workstation with Malware:",
                options: [
                    "Plugging an unknown 'lost' USB drive found outside directly into a work computer",
                    "Saving code documentation to an authorized local folder",
                    "Locking the computer screen before walking to lunch"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! 'USB Drop' attacks count on curiosity or helpfulness—never plug an unknown USB drive into your PC!"
            },
            fixes: [
                "Never plug an unknown USB drive into your computer—turn found drives directly over to IT Security",
                "Plug found USB drives into the main server first to check who owns them",
                "Open all files on a found USB drive as long as the label looks friendly"
            ],
            correct_fix_idx: 0,
            debrief_quiz: {
                question: "REAL-LIFE CHECK: You find a USB flash drive on the ground outside school or work labeled 'Confidential / Photos'. What is the safest thing to do?",
                options: [
                    "Never plug it into your computer—hand it directly to IT security or the front desk",
                    "Plug it into your laptop just for a second to see whose name is inside the folder",
                    "Plug it into a school or office computer so your personal laptop stays safe"
                ],
                correct_idx: 0,
                feedback_ok: "CORRECT! A booby-trapped USB drive can launch Malware the instant it's plugged in—always let IT inspect it on an isolated tool!"
            }
        },
        {
            word:     "SPOOFING",
            title:    "Fake Caller / Sender ID",
            scenario: "Faking a trusted email address, caller ID, or IP address to impersonate someone:",
            hint:     "Disguising an untrusted sender's identity as a trusted one.",
            takeaway: "TIP: Display names and caller IDs can be faked—verify through a second channel!",
            victim_name: "Sarah Connor",
            victim_dept: "Legal & Compliance",
            suspects: ["Sarah Connor", "Bob Higgins", "Marcus Vance"],
            vectors:  ["Spoofed Boss Email", "Reused Password", "Default '1234' Password"],
            correct_suspect_idx: 0,
            correct_vector_idx:  0,
            desktop_items: [
                { label: "Mistake: Trusted a Faked 'From: CEO' Display Name", is_breach: true,  desc: "Sarah replied to an email whose display name said 'Company CEO' without noticing the actual email address was a fake Gmail account (Spoofing)!" },
                { label: "Contract: 'Vendor NDA Agreement'",                           is_breach: false, desc: "Standard mutual non-disclosure contract." },
                { label: "Email: 'Reminder: Compliance Training Friday'",              is_breach: false, desc: "Legitimate HR compliance notification." }
            ],
            kyle_debrief: "Sarah saw 'Company CEO' in the display name and didn't notice the email address was Spoofed (faked)!",
            lesson_story: "Sarah Connor (Legal) got an email whose display name said 'Company CEO' asking for an urgent security code. Wanting to help the boss right away, she sent the code—not noticing the hacker had 'Spoofed' (faked) the display name using an outside email address!",
            prevention_rule: "HOW TO PREVENT IT: Anyone can type a boss's name as their email display name or fake a caller ID (Spoofing). Always click to view the full email address and verify urgent requests with a quick phone call!",
            npc_clues: [
                "The attacker forged our CEO's email header so the message looked like it came from inside the building!",
                "They disguised their untrusted IP address to impersonate our internal security server!",
                "When a hacker fakes their sender identity or caller ID to trick a system, it's called SPOOFING!"
            ],
            jack_reply: "Forging a trusted sender address or IP identity to fool the system... that's SPOOFING!",
            pc_logs: [
                "ALERT: Forged internal IP address detected on port 443.\n\nTHREAT KEYWORD:   SPOOFING",
                "BLOCKED: Attacker faking trusted sender identity.\n\nTHREAT KEYWORD:   SPOOFING",
                "NOTE: Impersonating a trusted ID, email, or IP.\n\nTHREAT KEYWORD:   SPOOFING"
            ],
            memo_notes: [
                "[STICKY NOTE]: 'Faking a trusted sender ID or IP address = SPOOFING!'",
                "[IT MEMO]: 'Key Vault Word: S-P-O-O-F-I-N-G.'"
            ],
            vault_challenge: {
                artifact_header: "CAPTURED EMAIL HEADER:  Display Name = 'Company CEO (Director)'",
                artifact_body:   "ACTUAL SENDER ADDRESS: <ceo.urgent.giftcards99@free-mail-host.org>  |  REQUEST: 'Send floor access code now!'",
                scanner_note:    "FORENSIC SCAN: The attacker SPOOFED (faked) the display name 'Company CEO' while sending from an outside address!",
                prompt:          "Spot the red flag in this email header that proves the sender's identity was Spoofed:",
                options: [
                    "The display name says 'Company CEO', but the actual email address is a random external account",
                    "The email was received by the Legal & Compliance department",
                    "The subject line used capital letters"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Display names and caller IDs are easy to Spoof—always check the real address and verify on a second channel!"
            },
            fixes: [
                "Inspect the full email address behind the display name and verify urgent requests via a known phone number",
                "Trust any email or phone call as long as the display name says 'CEO' or 'IT Support'",
                "Send confidential codes immediately whenever an email says the boss is in a meeting"
            ],
            correct_fix_idx: 0,
            debrief_quiz: {
                question: "REAL-LIFE CHECK: You get a text or email whose display name says 'School Principal / Boss', asking you to send a private code or buy gift cards right now. How do you protect yourself from Spoofing?",
                options: [
                    "Check the actual email address and call or talk to the person directly using a known, trusted number to verify",
                    "Send the code right away because the display name has your boss's real name on it",
                    "Reply to the email asking 'Are you really my boss?'"
                ],
                correct_idx: 0,
                feedback_ok: "CORRECT! Because display names and caller IDs can be Spoofed, verifying through a second trusted channel stops impersonators cold!"
            }
        },
        {
            word:     "RANSOM",
            title:    "Locked Files Extortion",
            scenario: "Attack that encrypts a victim's files and demands payment to unlock them:",
            hint:     "Holds your data hostage until a payment (ransom) is made.",
            takeaway: "TIP: Keep offline backups of critical data so you never have to pay a ransom!",
            victim_name: "Toby Flend",
            victim_dept: "Enterprise Sales",
            suspects: ["Toby Flend", "Sarah Connor", "Dave Miller"],
            vectors:  ["Reused Password (Ransomware)", "Firewall Turned Off", "Spyware Pop-Up Ad"],
            correct_suspect_idx: 0,
            correct_vector_idx:  0,
            desktop_items: [
                { label: "Mistake: Reused the Same Password Across Every Account", is_breach: true,  desc: "Toby used the exact same password ('Toby123!') on his work PC as on an old gaming forum that got hacked, letting attackers lock his files for Ransom!" },
                { label: "Pitch: 'Q3 Enterprise Sales Deck.pptx'", is_breach: false, desc: "Client presentation slides." },
                { label: "Contact: 'Lead List - West Coast'",       is_breach: false, desc: "Normal sales prospect directory." }
            ],
            kyle_debrief: "Toby reused the same password on every website, so when a gaming site leaked it, hackers locked his work PC with Ransomware!",
            lesson_story: "Toby Flend (Sales) used the exact same password for his work computer, his email, and an old gaming forum. When that gaming forum was hacked, criminals tried his leaked password on his work account, logged right in, and locked the company files with Ransomware!",
            prevention_rule: "HOW TO PREVENT IT: Never reuse the same password across multiple accounts! If one website gets hacked, attackers will try that password everywhere. Use unique passwords and keep offline Backups to beat Ransomware!",
            npc_clues: [
                "The hackers encrypted our entire HR database and popped up a countdown timer demanding payment!",
                "They're holding our server files hostage and refusing to hand over the decryption key unless we pay!",
                "Good thing we have offline backups—we never pay a hacker's RANSOM!"
            ],
            jack_reply: "Locking up critical files and demanding payment for the key... they're holding our data for RANSOM!",
            pc_logs: [
                "ALERT: Server files encrypted with payment demand.\n\nTHREAT KEYWORD:   RANSOM",
                "DETECTED: Hostile extortion lock on database.\n\nTHREAT KEYWORD:   RANSOM",
                "NOTE: Offline backups restore data without paying.\n\nTHREAT KEYWORD:   RANSOM"
            ],
            memo_notes: [
                "[STICKY NOTE]: 'Encrypting files and demanding payment = RANSOM!'",
                "[IT MEMO]: 'Key Vault Word: R-A-N-S-O-M.'"
            ],
            vault_challenge: {
                artifact_header: "CAPTURED CREDENTIAL & EXTORTION LOG:  Account = tflend@skipjack.com",
                artifact_body:   "PASSWORD REUSED: 'Toby123!' (Matched 2024 Gaming Forum Leak) -> Files Encrypted for RANSOM Payment!",
                scanner_note:    "FORENSIC SCAN: Reusing a leaked password let attackers log in and lock the server with RANSOMWARE!",
                prompt:          "Spot the mistake that let attackers break into the account and lock the files for Ransom:",
                options: [
                    "Reusing the exact same password ('Toby123!') across a gaming website and a work account",
                    "Keeping an offline backup copy of important sales presentations",
                    "Using a different 14-character password for every website"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! When you reuse one password everywhere, a leak on one site gives hackers the key to all your other accounts!"
            },
            fixes: [
                "Use a unique password for every account and keep offline Backups so Ransomware can never hold your files hostage",
                "Use one easy password on every website and pay the hackers whenever they lock your files",
                "Store your only backup copy on the exact same computer desktop"
            ],
            correct_fix_idx: 0,
            debrief_quiz: {
                question: "REAL-LIFE CHECK: Why is reusing the exact same password on a random gaming forum and your primary email or school account so dangerous?",
                options: [
                    "If the gaming forum gets hacked, criminals automatically test that leaked password on your email, school, and bank accounts",
                    "Typing the same password on two websites wears out your keyboard faster",
                    "Websites don't allow passwords that contain capital letters"
                ],
                correct_idx: 0,
                feedback_ok: "CORRECT! Unique passwords stop one leaked website from compromising your other accounts—and offline backups defeat Ransomware!"
            }
        },
        {
            word:     "BACKDOOR",
            title:    "Secret Bypass Entry",
            scenario: "A hidden entrance left in software that bypasses normal login security:",
            hint:     "Like a secret unlocked 'back door' into a building's system.",
            takeaway: "TIP: Audit code and remove default test accounts to close hidden backdoors!",
            victim_name: "Frank Castle",
            victim_dept: "Server Infrastructure",
            suspects: ["Frank Castle", "Greg Vance", "David (Sec Lead)"],
            vectors:  ["Forgotten Guest Backdoor Link", "Unknown Parking-Lot USB", "Trojan Free Download"],
            correct_suspect_idx: 0,
            correct_vector_idx:  0,
            desktop_items: [
                { label: "Mistake: Forgot to Close a Temporary 'Skip-Password' Link", is_breach: true,  desc: "Frank turned on a temporary 'skip-password' remote link while fixing a server from home and accidentally fell asleep before turning it off!" },
                { label: "Config: 'Nginx Reverse Proxy Config'",               is_breach: false, desc: "Normal web server routing configuration." },
                { label: "Log: 'System Uptime: 412 Days'",                     is_breach: false, desc: "Standard Linux server uptime statistics." }
            ],
            kyle_debrief: "Frank accidentally left a temporary 'skip-password' link open overnight, creating a Backdoor for hackers!",
            lesson_story: "Frank Castle (Infrastructure) created a temporary remote-access shortcut that skipped the password screen so he could finish late-night server maintenance from home—but he fell asleep and forgot to close it, leaving an accidental Backdoor wide open!",
            prevention_rule: "HOW TO PREVENT IT: Never create shortcuts that skip password checks (Backdoors), always lock your screen when stepping away from your desk, and turn on Two-Factor Authentication (2FA)!",
            npc_clues: [
                "The hackers didn't even use the front login page—they slipped in through a hidden developer test port!",
                "Someone left a secret maintenance bypass in the server code that skips password checks completely!",
                "We have to seal that hidden entry point—it's a classic digital BACKDOOR!"
            ],
            jack_reply: "A secret entry point that bypasses normal login security... they planted a BACKDOOR!",
            pc_logs: [
                "ALERT: Unauthorized entry bypassed login screen.\n\nTHREAT KEYWORD:   BACKDOOR",
                "DETECTED: Hidden remote access port left open.\n\nTHREAT KEYWORD:   BACKDOOR",
                "NOTE: Secret pathway that skips authentication.\n\nTHREAT KEYWORD:   BACKDOOR"
            ],
            memo_notes: [
                "[STICKY NOTE]: 'A secret entry that bypasses normal login = BACKDOOR!'",
                "[IT MEMO]: 'Key Vault Word: B-A-C-K-D-O-O-R.'"
            ],
            vault_challenge: {
                artifact_header: "CAPTURED SERVER CONFIG:  Port 8080 Maintenance Shortcut = ACTIVE",
                artifact_body:   "SETTING: 'skip_password_and_2fa = TRUE' (Left open overnight after remote maintenance!)",
                scanner_note:    "FORENSIC SCAN: Leaving a 'skip-password' shortcut active creates an open BACKDOOR that bypasses login security!",
                prompt:          "Spot the dangerous setting in this server config that gave hackers a Backdoor into the building:",
                options: [
                    "A temporary 'skip_password_and_2fa = TRUE' shortcut that was left open overnight",
                    "Requiring Two-Factor Authentication (2FA) for every remote login",
                    "Logging server uptime statistics for 412 days"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Any shortcut that skips password or 2FA checks is a Backdoor that attackers can slip right through!"
            },
            fixes: [
                "Never create shortcuts that skip password checks, always close temporary access links, and enforce Two-Factor Auth (2FA)",
                "Leave a hidden 'skip-password' guest link open so you can log in faster from home",
                "Turn off Two-Factor Authentication (2FA) whenever working late at night"
            ],
            correct_fix_idx: 0,
            debrief_quiz: {
                question: "REAL-LIFE CHECK: You're tired of typing your password and 2FA code every time you log in, so you're tempted to turn off 2FA or leave a 'no-password' guest account open. What is the safe habit?",
                options: [
                    "Keep Two-Factor Authentication (2FA) ON and never leave password-bypass shortcuts or unlocked screens unattended",
                    "Create a hidden 'guest' login with no password so you can get in faster",
                    "Turn off all login passwords overnight when fewer people are online"
                ],
                correct_idx: 0,
                feedback_ok: "CORRECT! Shortcuts that skip passwords act as Backdoors for hackers—keep 2FA on and lock your devices when away!"
            }
        }
    ];

    var _n = array_length(_cases);
    var _safe_idx = ((_case_idx mod _n) + _n) mod _n;
    return _cases[_safe_idx];
}

// ---------------------------------------------------------------------------
/// @function scr_roll_holding_key_and_equation()
/// @description Rolls a separate Caesar Shift Key for the Holding Room door
///              (different from global.dungeon_cipher_key) and generates a
///              math equation clue whose answer is that exact Shift Key.
// ---------------------------------------------------------------------------
function scr_roll_holding_key_and_equation() {
    var _main_k = variable_global_exists("dungeon_cipher_key") ? global.dungeon_cipher_key : 1;
    var _hk     = 0;
    while (_hk == 0 || _hk == _main_k) {
        _hk = irandom_range(-4, 4);
    }
    global.holding_cipher_key = _hk;

    // Build a multi-step arithmetic / algebra equation whose solution is _hk
    var _variant = irandom(2);
    var _eq_str  = "";
    if (_variant == 0) {
        var _a = irandom_range(3, 6);
        var _b = irandom_range(2, 5);
        var _c = (_a * _b) - _hk;
        _eq_str = "SHIFT KEY (X)  =  (" + string(_a) + " * " + string(_b) + ") - " + string(_c);
    } else if (_variant == 1) {
        var _b = irandom_range(3, 5);
        var _q = irandom_range(3, 6);
        var _a = _b * _q;
        var _diff = _hk - _q;
        if (_diff >= 0) {
            _eq_str = "SHIFT KEY (X)  =  (" + string(_a) + " / " + string(_b) + ") + " + string(_diff);
        } else {
            _eq_str = "SHIFT KEY (X)  =  (" + string(_a) + " / " + string(_b) + ") - " + string(abs(_diff));
        }
    } else {
        var _c   = irandom_range(4, 12);
        var _rhs = (2 * _hk) + _c;
        _eq_str = "Solve for Shift Key (X):    2X + " + string(_c) + "  =  " + string(_rhs);
    }

    global.holding_math_clue = _eq_str;
}

// ---------------------------------------------------------------------------
/// @function scr_init_facility_puzzles()
/// @description Initializes / refreshes the floor's Lockdown Override Console
///              (Option A2: 2-letter Reverse-Shift Encryption) and Power Breaker
///              Panel (Option B1: 3-Fuse Shift Verification) whenever a floor
///              generates or its cipher key rotates.
// ---------------------------------------------------------------------------
function scr_init_facility_puzzles() {
    var _ch      = variable_global_exists("dungeon_chapter")      ? global.dungeon_chapter      : CHAPTER_CAESAR;
    var _key     = variable_global_exists("dungeon_cipher_key")   ? global.dungeon_cipher_key   : 3;
    var _vig_key = variable_global_exists("dungeon_vigenere_key") ? global.dungeon_vigenere_key : "CAB";

    // --- 1. LOCKDOWN OVERRIDE CONSOLE (Option A2: Encrypt 2-Letter Signal) ---
    global.override_plain = choose("OK", "GO", "ON", "UP", "NO", "ID");
    global.override_slot  = 0;
    global.override_input = ["", ""];
    global.override_msg   = "";
    global.override_col   = c_white;
    global.override_shake = 0;
    global.override_win_t = 0;

    // Compute the expected 2-letter ENCRYPTED signal (Reverse direction: -Key)
    if (_ch == CHAPTER_VIGENERE) {
        global.override_target = scr_vigenere_decode(global.override_plain, _vig_key);
        global.override_shifts = [
            -(ord(string_char_at(_vig_key, 1)) - ord("A")),
            -(ord(string_char_at(_vig_key, 2)) - ord("A"))
        ];
    } else if (_ch == CHAPTER_ATBASH) {
        global.override_target = scr_atbash_decode(global.override_plain);
        global.override_shifts = [0, 0];
    } else {
        global.override_target = scr_caesar_encode(global.override_plain, -_key);
        global.override_shifts = [-_key, -_key];
    }

    // --- 2. POWER BREAKER PANEL (Option B1: 3-Fuse Shift Verification) ---
    // Generate 3 Fuse Pairs [start_ch, end_ch, is_valid]: 2 valid matches + 1 faulty mismatch
    var _faulty_idx = irandom(2);
    global.breaker_fuses = [];
    global.breaker_state = [false, false, false]; // Player toggle states (OFF / ON)
    global.breaker_slot  = 0;
    global.breaker_msg   = "";
    global.breaker_col   = c_white;
    global.breaker_shake = 0;
    global.breaker_win_t = 0;

    var _base_indices = [irandom_range(5, 8), irandom_range(10, 13), irandom_range(15, 19)];
    for (var _fi = 0; _fi < 3; _fi++) {
        var _is_valid = (_fi != _faulty_idx);
        var _start_ch = chr(ord("A") + _base_indices[_fi]);
        var _end_ch   = "A";
        var _sh_val   = 0;

        if (_ch == CHAPTER_ATBASH) {
            var _atb_start = chr(ord("A") + (_fi * 3 + irandom_range(1, 2)));
            _start_ch = _atb_start;
            if (_is_valid) {
                _end_ch = scr_atbash_decode(_start_ch);
            } else {
                // Faulty mirror pair (off by 2 letters)
                _end_ch = scr_caesar_encode(scr_atbash_decode(_start_ch), choose(-2, 2));
            }
        } else {
            if (_ch == CHAPTER_VIGENERE) {
                var _kw_ch = string_char_at(_vig_key, (_fi mod string_length(_vig_key)) + 1);
                _sh_val = ord(_kw_ch) - ord("A");
            } else {
                _sh_val = _key;
            }

            if (_is_valid) {
                _end_ch = scr_caesar_encode(_start_ch, _sh_val);
            } else {
                // Faulty shift (wrong direction or off by +2/-2)
                var _bad_shift = (_sh_val != 0) ? (-_sh_val) : 2;
                if (_bad_shift == _sh_val) _bad_shift += 2;
                _end_ch = scr_caesar_encode(_start_ch, _bad_shift);
            }
        }

        array_push(global.breaker_fuses, {
            start_ch:   _start_ch,
            end_ch:     _end_ch,
            is_valid:   _is_valid,
            req_shift:  _sh_val
        });
    }
}

// ---------------------------------------------------------------------------
/// @function scr_draw_atbash_mirror_bar(_cx, _y_top, _src_idx, _usr_idx, _target_idx, _show_guide, _usr_col)
/// @description Draws the 2-Row Atbash Mirror Alphabet Bar (A..M on top row,
///              Z..N directly below on bottom row) for Chapter 3 facility puzzles.
// ---------------------------------------------------------------------------
function scr_draw_atbash_mirror_bar(_cx, _y_top, _src_idx, _usr_idx, _target_idx, _show_guide, _usr_col) {
    var _curr    = variable_global_exists("floor_curriculum") ? global.floor_curriculum : scr_get_floor_curriculum(3, 4);
    var _hide_sh = _curr.hide_shift_match;
    var _is_exam = _curr.is_final_exam;

    var _m_y1     = _y_top;
    var _m_y2     = _y_top + 22;
    var _m_cell_w = 36;
    var _m_tot_w  = 13 * _m_cell_w;
    var _m_x1     = _cx - _m_tot_w * 0.5;

    draw_set_color(make_color_rgb(20, 28, 42));
    draw_rectangle(_m_x1 - 6, _m_y1 - 11, _m_x1 + _m_tot_w + 6, _m_y2 + 11, false);
    draw_set_color(make_color_rgb(70, 125, 105));
    draw_rectangle(_m_x1 - 6, _m_y1 - 11, _m_x1 + _m_tot_w + 6, _m_y2 + 11, true);

    for (var _m = 0; _m < 13; _m++) {
        var _mx      = _m_x1 + _m * _m_cell_w + _m_cell_w * 0.5;
        var _top_idx = _m;          // A..M (0..12)
        var _bot_idx = 25 - _m;     // Z..N (25..13)
        var _top_ch  = chr(ord("A") + _top_idx);
        var _bot_ch  = chr(ord("A") + _bot_idx);

        var _mask_bot = false;
        if (_is_exam && _m > 0 && _m < 12) {
            _mask_bot = true;
        } else if (_hide_sh && (_m mod 2 == 1)) {
            _mask_bot = true;
        }

        // Top Row Cell (A..M)
        if (_top_idx == _usr_idx) {
            draw_set_color(_usr_col);
            draw_rectangle(_mx - 11, _m_y1 - 9, _mx + 11, _m_y1 + 9, false);
            draw_set_color(c_black);
            draw_text_transformed(_mx, _m_y1, _top_ch, 0.82, 0.82, 0);
        } else if (_top_idx == _src_idx) {
            draw_set_color(make_color_rgb(255, 190, 40));
            draw_rectangle(_mx - 11, _m_y1 - 9, _mx + 11, _m_y1 + 9, false);
            draw_set_color(c_black);
            draw_text_transformed(_mx, _m_y1, _top_ch, 0.82, 0.82, 0);
        } else if (_show_guide && _top_idx == _target_idx) {
            draw_set_color(c_lime);
            draw_rectangle(_mx - 11, _m_y1 - 9, _mx + 11, _m_y1 + 9, true);
            draw_text_transformed(_mx, _m_y1, _top_ch, 0.82, 0.82, 0);
        } else {
            draw_set_color(make_color_rgb(165, 215, 190));
            draw_text_transformed(_mx, _m_y1, _top_ch, 0.80, 0.80, 0);
        }

        // Bottom Row Cell (Z..N)
        var _bot_disp = _mask_bot ? "?" : _bot_ch;
        if (_bot_idx == _usr_idx && !_mask_bot) {
            draw_set_color(_usr_col);
            draw_rectangle(_mx - 11, _m_y2 - 9, _mx + 11, _m_y2 + 9, false);
            draw_set_color(c_black);
            draw_text_transformed(_mx, _m_y2, _bot_disp, 0.82, 0.82, 0);
        } else if (_bot_idx == _src_idx && !_mask_bot) {
            draw_set_color(make_color_rgb(255, 190, 40));
            draw_rectangle(_mx - 11, _m_y2 - 9, _mx + 11, _m_y2 + 9, false);
            draw_set_color(c_black);
            draw_text_transformed(_mx, _m_y2, _bot_disp, 0.82, 0.82, 0);
        } else if (_show_guide && _bot_idx == _target_idx) {
            draw_set_color(c_lime);
            draw_rectangle(_mx - 11, _m_y2 - 9, _mx + 11, _m_y2 + 9, true);
            draw_text_transformed(_mx, _m_y2, _bot_ch, 0.82, 0.82, 0);
        } else {
            draw_set_color(_mask_bot ? c_gray : make_color_rgb(230, 210, 120));
            draw_text_transformed(_mx, _m_y2, _bot_disp, 0.80, 0.80, 0);
        }

        // On Guided Tutorial Floors (1-3), draw a pulsing vertical Mirror Connector on the active pair column!
        if (_show_guide && (_top_idx == _src_idx || _bot_idx == _src_idx)) {
            var _mpulse = 0.65 + 0.35 * sin(current_time / 150);
            draw_set_alpha(_mpulse);
            draw_set_color(c_yellow);
            draw_rectangle(_mx - 14, _m_y1 - 11, _mx + 14, _m_y2 + 11, true);
            draw_set_color(c_lime);
            draw_text_transformed(_mx, (_m_y1 + _m_y2) * 0.5, "|", 0.72, 0.72, 0);
            draw_set_alpha(1.0);
        }
    }
}

// ---------------------------------------------------------------------------
/// @function scr_draw_tutorial_ruler_hops(_strip_x1, _strip_y, _cell_w, _start_idx, _shift_amt)
/// @description On Tutorial Floors 1-3, animates step-by-step counting hops
///              along the A-Z Ruler from the Amber Start letter (_start_idx)
///              to the Green Target letter (+_shift_amt or -_shift_amt) so the
///              player visually sees HOW to count the cipher shift!
// ---------------------------------------------------------------------------
function scr_draw_tutorial_ruler_hops(_strip_x1, _strip_y, _cell_w, _start_idx, _shift_amt) {
    if (_shift_amt == 0) return;
    var _steps    = abs(_shift_amt);
    var _dir      = (_shift_amt > 0) ? 1 : -1;
    var _anim_hop = floor(current_time / 420) mod (_steps + 1); // 0.._steps animated hop counter

    for (var _h = 1; _h <= _steps; _h++) {
        var _prev_i = (_start_idx + (_h - 1) * _dir + 26) mod 26;
        var _curr_i = (_start_idx + _h * _dir + 26) mod 26;
        var _px     = _strip_x1 + _prev_i * _cell_w + _cell_w * 0.5;
        var _cx_hop = _strip_x1 + _curr_i * _cell_w + _cell_w * 0.5;
        var _is_lit = (_h <= _anim_hop);

        // Draw connecting line above the strip when adjacent (not wrapping around A<->Z edge)
        if (abs(_curr_i - _prev_i) == 1) {
            draw_set_color(_is_lit ? c_lime : make_color_rgb(90, 125, 110));
            draw_line(_px, _strip_y - 15, _cx_hop, _strip_y - 15);
        }

        // Draw numbered hop badge (+1, +2, +3 or -1, -2, -3) above each stepped letter
        var _lbl = ((_dir > 0) ? "+" : "-") + string(_h);
        draw_set_color(_is_lit ? c_lime : make_color_rgb(130, 165, 145));
        draw_text_transformed(_cx_hop, _strip_y - 20, _lbl, 0.58, 0.58, 0);

        // Highlight the currently animated hop cell on the ruler
        if (_h == _anim_hop) {
            draw_set_color(c_yellow);
            draw_rectangle(_cx_hop - 10, _strip_y - 13, _cx_hop + 10, _strip_y + 13, true);
        }
    }
}

// ---------------------------------------------------------------------------
/// @function scr_draw_tutorial_how_to_solve_modal(_gui_w, _gui_h, _mode_type, _chapter, _start_ch, _end_ch, _shift_val, _vig_key, _slot_num)
/// @description Renders an interactive visual "HOW TO SOLVE THIS PUZZLE"
///              demonstration card on Tutorial Floors 1-3 (auto-shown on first
///              visit to the Key Pedestal & first Cipher Door Lock, and
///              re-openable anytime during Tutorials by pressing [TAB]).
// ---------------------------------------------------------------------------
function scr_draw_tutorial_how_to_solve_modal(_gui_w, _gui_h, _mode_type, _chapter, _start_ch, _end_ch, _shift_val, _vig_key, _slot_num) {
    var _cx = _gui_w * 0.5;
    var _cy = _gui_h * 0.5;

    draw_set_alpha(0.88);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1.0);

    var _pw = 536;
    var _ph = 276;
    var _x1 = _cx - _pw * 0.5;
    var _y1 = _cy - _ph * 0.5;
    var _x2 = _cx + _pw * 0.5;
    var _y2 = _cy + _ph * 0.5;

    draw_set_color(make_color_rgb(12, 20, 34));
    draw_rectangle(_x1, _y1, _x2, _y2, false);
    draw_set_color(c_lime);
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    draw_rectangle(_x1 + 3, _y1 + 3, _x2 - 3, _y2 - 3, true);

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    var _ch_name = scr_get_chapter_name(_chapter);
    var _title   = (_mode_type == "pedestal")
        ? ("TUTORIAL DEMONSTRATION — HOW TO CALIBRATE THE " + _ch_name + " KEY")
        : ("TUTORIAL DEMONSTRATION — HOW TO DECRYPT A " + _ch_name + " LOCK");

    draw_set_color(make_color_rgb(255, 215, 60));
    draw_text_transformed(_cx, _y1 + 18, _title, 0.84, 0.84, 0);

    // Build the animated hop chain diagram: e.g. [ E ] --(+1)--> [ F ] --(+2)--> [ G ] --(+3)--> [ H ]
    var _steps    = abs(_shift_val);
    var _dir      = (_shift_val >= 0) ? 1 : -1;
    var _chain    = "[ " + _start_ch + " (START) ]";
    var _s_idx    = ord(_start_ch) - ord("A");

    if (_chapter == CHAPTER_ATBASH) {
        var _col_num = min(_s_idx, 25 - _s_idx) + 1;
        _chain = "TOP ROW: [ " + _start_ch + " ]   <--- (Mirror Column #" + string(_col_num) + ") --->   BOTTOM ROW: [ " + _end_ch + " (ANSWER) ]";
    } else if (_steps == 0) {
        _chain = "[ " + _start_ch + " (START) ]   --- (+0 / No Shift) --->   [ " + _end_ch + " (ANSWER) ]";
    } else {
        for (var _h = 1; _h <= _steps; _h++) {
            var _ci   = (_s_idx + _h * _dir + 26) mod 26;
            var _c_ch = chr(ord("A") + _ci);
            var _s_lb = ((_dir > 0) ? "+" : "-") + string(_h);
            _chain += "  --(" + _s_lb + ")-->  [" + _c_ch + ((_h == _steps) ? " (ANSWER)]" : "]");
        }
    }

    // Visual Hop Chain Box
    draw_set_color(make_color_rgb(18, 34, 48));
    draw_rectangle(_x1 + 18, _y1 + 36, _x2 - 18, _y1 + 88, false);
    draw_set_color(c_aqua);
    draw_rectangle(_x1 + 18, _y1 + 36, _x2 - 18, _y1 + 88, true);

    draw_set_color(c_aqua);
    draw_text_transformed(_cx, _y1 + 48, "LIVE VISUAL EXAMPLE FROM YOUR ACTIVE PUZZLE:", 0.72, 0.72, 0);
    draw_set_color(c_lime);
    draw_text_ext_transformed(_cx, _y1 + 69, _chain, 14, (_pw - 52) / 0.74, 0.74, 0.74, 0);

    // 3 Clear Step-by-Step Cards
    var _step1 = "";
    var _step2 = "";
    var _step3 = "";

    if (_mode_type == "pedestal") {
        if (_chapter == CHAPTER_VIGENERE) {
            var _kw1 = string_char_at(_vig_key, 1);
            _step1 = "STEP 1 (FIND START & TARGET): Look at the A-Z Ruler. Amber '" + _start_ch + "' is your START letter, and Green '" + _end_ch + "' is your TARGET letter for Keyword letter '" + _kw1 + "'.";
            _step2 = "STEP 2 (COUNT THE STEPS): Count how many spaces right it takes to hop from '" + _start_ch + "' to '" + _end_ch + "' (" + string(_shift_val) + " steps, because '" + _kw1 + "' = +" + string(_shift_val) + ").";
            _step3 = "STEP 3 (SLIDE THE DIAL): Press [LEFT / RIGHT] until the center dial shows '" + _kw1 + " (+" + string(_shift_val) + ")' and turns GREEN, then press [ENTER] to save Keyword '" + _vig_key + "'!";
        } else if (_chapter == CHAPTER_ATBASH) {
            _step1 = "STEP 1 (LOOK AT THE 2-ROW MIRROR BAR): The alphabet is folded in half—Top Row (A..M) mirrors directly onto Bottom Row (Z..N).";
            _step2 = "STEP 2 (FIND THE MIRROR PAIR): Find Amber '" + _start_ch + "' on the top row and look straight down to Green '" + _end_ch + "' on the bottom row.";
            _step3 = "STEP 3 (ALIGN & SAVE): Press [LEFT / RIGHT] until the dial highlights '" + _end_ch + "' in GREEN, then press [ENTER] to save the Atbash Mirror Key!";
        } else {
            var _sh_s = (_shift_val > 0) ? ("+" + string(_shift_val) + " (Right)") : (string(_shift_val) + " (Left)");
            _step1 = "STEP 1 (FIND START & TARGET): Look at the A-Z Ruler. The solid Amber box ('" + _start_ch + "') is START, and the Green outline ('" + _end_ch + "') is TARGET.";
            _step2 = "STEP 2 (COUNT THE HOPS): Watch the animated hop numbers above the ruler counting from '" + _start_ch + "' to '" + _end_ch + "' -> Shift = " + _sh_s + "!";
            _step3 = "STEP 3 (SLIDE THE DIAL): Press [LEFT / RIGHT] until the center Shift Key dial reaches " + ((_shift_val > 0) ? ("+" + string(_shift_val)) : string(_shift_val)) + " (Green), then press [ENTER]!";
        }
    } else {
        if (_chapter == CHAPTER_VIGENERE) {
            var _kw_c = string_char_at(_vig_key, ((_slot_num - 1) mod string_length(_vig_key)) + 1);
            _step1 = "STEP 1 (CHECK SLOT KEYWORD BADGE): Look above Slot #" + string(_slot_num) + "—its purple Keyword badge says '" + _kw_c + " (+" + string(_shift_val) + ")' (from Keyword '" + _vig_key + "').";
            _step2 = "STEP 2 (COUNT +" + string(_shift_val) + " ON THE RULER): Start at the Amber encrypted letter '" + _start_ch + "' on the ruler and count +" + string(_shift_val) + " steps right to land on Green '" + _end_ch + "'.";
            _step3 = "STEP 3 (SET & UNLOCK): Press [UP / DOWN] (or type '" + _end_ch + "') to set Slot #" + string(_slot_num) + " to '" + _end_ch + "', use [LEFT / RIGHT] for the remaining slots, and press [ENTER]!";
        } else if (_chapter == CHAPTER_ATBASH) {
            _step1 = "STEP 1 (FIND LETTER ON MIRROR BAR): Look at Slot #" + string(_slot_num) + "'s encrypted letter ('" + _start_ch + "') highlighted in Amber on the 2-Row Mirror Bar.";
            _step2 = "STEP 2 (READ ITS MIRROR OPPOSITE): Look straight across the yellow mirror box in that same column to find its opposite letter: Green '" + _end_ch + "'!";
            _step3 = "STEP 3 (SET & UNLOCK): Press [UP / DOWN] (or type '" + _end_ch + "') to set Slot #" + string(_slot_num) + " to '" + _end_ch + "', fill all 4 slots, and press [ENTER] to unlock!";
        } else {
            var _dir_w = (_shift_val > 0) ? ("+" + string(_shift_val) + " steps RIGHT") : (string(_shift_val) + " steps LEFT");
            _step1 = "STEP 1 (CHECK YOUR SHIFT KEY): The top badge shows your Floor Shift Key is " + ((_shift_val > 0) ? ("+" + string(_shift_val)) : string(_shift_val)) + " (positive = count RIGHT, negative = count LEFT).";
            _step2 = "STEP 2 (FOLLOW THE RULER HOPS): Start at Slot #" + string(_slot_num) + "'s Amber letter '" + _start_ch + "' on the A-Z Ruler and follow the animated hops " + _dir_w + " to Green '" + _end_ch + "'.";
            _step3 = "STEP 3 (SET & UNLOCK): Press [UP / DOWN] (or type '" + _end_ch + "') so Slot #" + string(_slot_num) + " becomes '" + _end_ch + "', repeat for all 4 slots, and press [ENTER]!";
        }
    }

    var _steps_arr = [_step1, _step2, _step3];
    draw_set_halign(fa_left);
    for (var _si = 0; _si < 3; _si++) {
        var _sy1 = _y1 + 96 + (_si * 46);
        var _sy2 = _sy1 + 40;
        draw_set_color(make_color_rgb(16, 26, 40));
        draw_rectangle(_x1 + 18, _sy1, _x2 - 18, _sy2, false);
        draw_set_color(make_color_rgb(65, 115, 155));
        draw_rectangle(_x1 + 18, _sy1, _x2 - 18, _sy2, true);
        draw_set_color(c_white);
        draw_text_ext_transformed(_x1 + 28, (_sy1 + _sy2) * 0.5, _steps_arr[_si], 13, (_pw - 56) / 0.68, 0.68, 0.68, 0);
    }

    draw_set_halign(fa_center);
    draw_set_color(c_lime);
    draw_text_transformed(_cx, _y2 - 18, "[ PRESS E / ENTER / SPACE / TAB / CLICK TO TRY IT YOURSELF! ]", 0.80, 0.80, 0);
}

// ---------------------------------------------------------------------------
/// @function scr_draw_override_console_ui(_gui_w, _gui_h)
/// @description Renders and updates the Lockdown Override Console UI (Option A2:
///              Encrypt a 2-letter command signal in the reverse direction -Key
///              to shut down the red lockdown alarms & hallway security drones).
// ---------------------------------------------------------------------------
function scr_draw_override_console_ui(_gui_w, _gui_h) {
    if (!variable_global_exists("override_plain")) scr_init_facility_puzzles();

    if (global.override_shake > 0) global.override_shake--;
    var _sx = (global.override_shake > 0) ? irandom_range(-4, 4) : 0;
    var _sy = (global.override_shake > 0) ? irandom_range(-4, 4) : 0;
    var _cx = (_gui_w * 0.5) + _sx;
    var _cy = (_gui_h * 0.5) + _sy;

    var _ch      = variable_global_exists("dungeon_chapter")      ? global.dungeon_chapter      : CHAPTER_CAESAR;
    var _key     = variable_global_exists("dungeon_cipher_key")   ? global.dungeon_cipher_key   : 3;
    var _vig_key = variable_global_exists("dungeon_vigenere_key") ? global.dungeon_vigenere_key : "CAB";
    var _has_key = (variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key);
    var _curr    = variable_global_exists("floor_curriculum")     ? global.floor_curriculum     : scr_get_floor_curriculum(1, 4);
    var _guided  = _curr.guided_ui;
    var _hide_sh = _curr.hide_shift_match;

    // 1. Dark Backdrop & Panel
    draw_set_alpha(0.84);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);

    var _pw = 540;
    var _ph = 272;
    var _x1 = _cx - _pw * 0.5;
    var _y1 = _cy - _ph * 0.5;
    var _x2 = _cx + _pw * 0.5;
    var _y2 = _cy + _ph * 0.5;

    draw_set_alpha(0.96);
    draw_set_color(make_color_rgb(18, 14, 26));
    draw_rectangle(_x1, _y1, _x2, _y2, false);
    draw_set_alpha(1.0);
    draw_set_color(make_color_rgb(255, 75, 95));
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    draw_rectangle(_x1 + 3, _y1 + 3, _x2 - 3, _y2 - 3, true);

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // 2. Header & Reverse-Shift Instruction Pill
    draw_set_color(make_color_rgb(255, 95, 110));
    draw_text_transformed(_cx, _y1 + 20, "LOCKDOWN OVERRIDE CONSOLE", 1.05, 1.05, 0);

    var _pill_y = _y1 + 44;
    draw_set_color(make_color_rgb(28, 20, 36));
    draw_rectangle(_cx - 175, _pill_y - 11, _cx + 175, _pill_y + 11, false);
    draw_set_color(_has_key ? c_aqua : make_color_rgb(255, 190, 55));
    draw_rectangle(_cx - 175, _pill_y - 11, _cx + 175, _pill_y + 11, true);

    if (!_has_key) {
        draw_text_transformed(_cx, _pill_y, "KEY: ???  (Unlock Gold Key Vault first!)", 0.84, 0.84, 0);
    } else if (_ch == CHAPTER_VIGENERE) {
        var _c1 = string_char_at(_vig_key, 1);
        var _c2 = string_char_at(_vig_key, 2);
        var _s1 = -(ord(_c1) - ord("A"));
        var _s2 = -(ord(_c2) - ord("A"));
        draw_text_transformed(_cx, _pill_y, "ENCRYPT SIGNAL (Reverse Key '" + _vig_key + "'):  Slot 1 (" + string(_s1) + "), Slot 2 (" + string(_s2) + ")", 0.80, 0.80, 0);
    } else if (_ch == CHAPTER_ATBASH) {
        draw_text_transformed(_cx, _pill_y, "ENCRYPT SIGNAL:  Reflect '" + global.override_plain + "' across Mirror (A <-> Z)", 0.82, 0.82, 0);
    } else {
        var _rev_k   = -_key;
        var _rev_str = (_rev_k > 0) ? ("+" + string(_rev_k)) : string(_rev_k);
        var _fw_str  = (_key > 0)   ? ("+" + string(_key))   : string(_key);
        draw_text_transformed(_cx, _pill_y, "ENCRYPT SIGNAL:  Shift by " + _rev_str + "  (Opposite of Door Key " + _fw_str + ")", 0.82, 0.82, 0);
    }

    // 3. Visual Ruler at Top (2-Row Mirror Bar for Chapter 3 Atbash, 1-Row A-Z Strip for Caesar/Vigenere)
    var _slot_idx   = global.override_slot;
    var _src_ch     = string_char_at(global.override_plain, _slot_idx + 1);
    var _src_idx    = ord(_src_ch) - ord("A");
    var _usr_ch     = global.override_input[_slot_idx];
    var _usr_idx    = (_usr_ch != "") ? (ord(_usr_ch) - ord("A")) : -1;
    var _target_ch  = string_char_at(global.override_target, _slot_idx + 1);
    var _target_idx = ord(_target_ch) - ord("A");

    if (_ch == CHAPTER_ATBASH) {
        scr_draw_atbash_mirror_bar(_cx, _y1 + 69, _src_idx, _usr_idx, _target_idx, (_guided && _has_key), c_lime);
    } else {
        var _strip_y  = _y1 + 80;
        var _cell_w   = 20;
        var _strip_w  = 26 * _cell_w;
        var _strip_x1 = _cx - _strip_w * 0.5;

        draw_set_color(make_color_rgb(22, 26, 40));
        draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, false);
        draw_set_color(make_color_rgb(80, 95, 130));
        draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, true);

        for (var _a = 0; _a < 26; _a++) {
            var _lx = _strip_x1 + _a * _cell_w + _cell_w * 0.5;
            var _ch_lbl = chr(ord("A") + _a);

            if (_a == _usr_idx) {
                draw_set_color(c_lime);
                draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, false);
                draw_set_color(c_black);
                draw_text(_lx, _strip_y, _ch_lbl);
            } else if (_a == _src_idx) {
                draw_set_color(make_color_rgb(255, 190, 40));
                draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, false);
                draw_set_color(c_black);
                draw_text(_lx, _strip_y, _ch_lbl);
            } else if (_guided && _has_key && _a == _target_idx) {
                draw_set_color(c_lime);
                draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, true);
                draw_rectangle(_lx - 8, _strip_y - 11, _lx + 8, _strip_y + 11, true);
                draw_text(_lx, _strip_y, _ch_lbl);
            } else {
                draw_set_color(make_color_rgb(160, 175, 200));
                draw_text_transformed(_lx, _strip_y, _ch_lbl, 0.85, 0.85, 0);
            }
        }
        if (_guided && _has_key) {
            scr_draw_tutorial_ruler_hops(_strip_x1, _strip_y, _cell_w, _src_idx, global.override_shifts[_slot_idx]);
        }
    }

    // 4. Two Signal Encryption Slots + Big Red Override Button
    var _slots_y = _y1 + 162;
    for (var _i = 0; _i < 2; _i++) {
        var _scx  = (_cx - 115) + _i * 82;
        var _pch  = string_char_at(global.override_plain, _i + 1);
        var _u_ch = global.override_input[_i];

        // In Chapter 2 (Vigenere), show each slot's Keyword letter & reverse shift badge above the slot!
        if (_ch == CHAPTER_VIGENERE && _has_key) {
            var _ov_kw_c = string_char_at(_vig_key, (_i mod string_length(_vig_key)) + 1);
            var _ov_sh   = global.override_shifts[_i];
            draw_set_color(make_color_rgb(215, 130, 255));
            draw_text_transformed(_scx, _slots_y - 54, _ov_kw_c + " (" + string(_ov_sh) + ")", 0.70, 0.70, 0);
        }

        // Plaintext command letter above slot
        draw_set_color((_i == _slot_idx) ? make_color_rgb(255, 205, 50) : make_color_rgb(175, 190, 210));
        draw_text(_scx, _slots_y - 40, _pch);
        draw_set_color(c_gray);
        draw_text_transformed(_scx, _slots_y - 26, "v", 0.72, 0.72, 0);

        if (_i == _slot_idx) {
            draw_sprite(spr_slot_active, 0, _scx, _slots_y);
        } else {
            draw_sprite(spr_slot, 0, _scx, _slots_y);
        }

        if (_u_ch != "") {
            draw_set_color(c_white);
            draw_text(_scx, _slots_y, _u_ch);

            if (_ch == CHAPTER_ATBASH) {
                var _ok_m = (_u_ch == scr_atbash_decode(_pch));
                draw_set_color((!_hide_sh && _has_key && _ok_m) ? c_lime : make_color_rgb(170, 190, 215));
                draw_text_transformed(_scx, _slots_y + 30, _pch + "<->" + _u_ch, 0.75, 0.75, 0);
            } else {
                var _diff = (ord(_u_ch) - ord(_pch) + 26) mod 26;
                if (_diff > 13) _diff -= 26;
                var _d_str = (_diff > 0) ? ("+" + string(_diff)) : string(_diff);
                var _ok_sh = (!_hide_sh && _has_key && _diff == global.override_shifts[_i]);
                draw_set_color(_ok_sh ? c_lime : make_color_rgb(170, 190, 215));
                draw_text_transformed(_scx, _slots_y + 30, _d_str, 0.85, 0.85, 0);
            }
        } else {
            draw_set_color(c_gray);
            draw_text(_scx, _slots_y, "?");
        }
    }

    // Arrow pointing to the Big Red Override Button on the right
    draw_set_color(c_gray);
    draw_text(_cx + 12, _slots_y, "->");

    var _both_filled = (global.override_input[0] != "" && global.override_input[1] != "");
    var _btn_cx      = _cx + 118;
    var _btn_cy      = _slots_y;
    var _btn_pulse   = 0.5 + 0.5 * sin(current_time / 180);

    draw_set_color(_both_filled ? make_color_rgb(95, 18, 28) : make_color_rgb(35, 22, 28));
    draw_roundrect(_btn_cx - 72, _btn_cy - 30, _btn_cx + 72, _btn_cy + 30, false);
    draw_set_color(_both_filled ? merge_color(make_color_rgb(255, 65, 85), c_yellow, _btn_pulse * 0.5) : make_color_rgb(110, 55, 65));
    draw_roundrect(_btn_cx - 72, _btn_cy - 30, _btn_cx + 72, _btn_cy + 30, true);

    draw_set_color(_both_filled ? c_white : c_gray);
    draw_text_transformed(_btn_cx, _btn_cy - 8, "OVERRIDE BUTTON", 0.78, 0.78, 0);
    draw_set_color(_both_filled ? c_lime : make_color_rgb(160, 120, 130));
    draw_text_transformed(_btn_cx, _btn_cy + 11, _both_filled ? "[PRESS ENTER!]" : "(Encrypt 2-Letter Code)", 0.75, 0.75, 0);

    // 5. Trace Timer, Status / Tutorial Callout & Footer
    if (!variable_global_exists("override_timer_max") || global.override_timer_max <= 0) {
        global.override_timer_max = scr_get_cipher_timer_frames("sever");
        global.override_timer     = global.override_timer_max;
    }
    if (global.override_win_t <= 0) {
        scr_draw_trace_timer(_cx, _y2 - 62, 300, global.override_timer, global.override_timer_max);
        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
    }
    if (global.override_msg != "") {
        draw_set_color(global.override_col);
        draw_text_transformed(_cx, _y2 - 40, global.override_msg, 0.88, 0.88, 0);
    } else if (_guided && _has_key) {
        draw_set_color(c_lime);
        draw_text_transformed(
            _cx, _y2 - 40,
            "TUTORIAL: Encrypt '" + _src_ch + "' -> '" + _target_ch + "' (Green box on ruler), then press [ENTER]!",
            0.80, 0.80, 0
        );
    }

    draw_set_color(make_color_rgb(150, 170, 195));
    draw_text_transformed(_cx, _y2 - 16, "[ARROWS] Select & Shift   |   [ENTER] Press Override   |   [ESC] Back", 0.80, 0.80, 0);

    // --- 6. INPUT HANDLING ---
    if (global.override_win_t > 0) {
        global.override_win_t--;
        if (global.override_win_t <= 0) {
            global.override_ui_open = false;
        }
        return;
    }

    if (keyboard_check_pressed(vk_escape)) {
        global.esc_block_frames = 2;
        keyboard_clear(vk_escape);
        global.override_ui_open = false;
        global.override_timer_max = 0; // re-arm the Trace Timer next time the console opens
        audio_play_sound(snd_button_click, 10, false);
        return;
    }

    // Trace Timer countdown (frozen while the pause menu is open)
    if (!(variable_global_exists("is_paused") && global.is_paused)) {
        global.override_timer--;
        if (global.override_timer <= 0) {
            global.floor_cipher_fails++;
            global.override_input     = ["", ""];
            global.override_slot      = 0;
            global.override_shake     = 12;
            global.override_col       = c_orange;
            global.override_msg       = "TRACE TIMEOUT! Signal expired — encrypt it again, faster!";
            global.override_timer     = global.override_timer_max;
            audio_play_sound(wrong1, 10, false);
            return;
        }
    }

    if (keyboard_check_pressed(vk_right)) {
        global.override_slot = 1;
        audio_play_sound(select1, 10, false);
    }
    if (keyboard_check_pressed(vk_left)) {
        global.override_slot = 0;
        audio_play_sound(select1, 10, false);
    }

    if (keyboard_check_pressed(vk_up)) {
        var _bch = (global.override_input[_slot_idx] == "") ? _src_ch : global.override_input[_slot_idx];
        var _ni  = (ord(_bch) - ord("A") + 1) mod 26;
        global.override_input[_slot_idx] = chr(ord("A") + _ni);
        global.override_msg = "";
        audio_play_sound(choose(select1, select2, select3), 10, false);
    }
    if (keyboard_check_pressed(vk_down)) {
        var _bch = (global.override_input[_slot_idx] == "") ? _src_ch : global.override_input[_slot_idx];
        var _ni  = (ord(_bch) - ord("A") - 1 + 26) mod 26;
        global.override_input[_slot_idx] = chr(ord("A") + _ni);
        global.override_msg = "";
        audio_play_sound(choose(select1, select2, select3), 10, false);
    }

    // DEMO SHORTCUT: Press Ctrl + P to auto-fill both Override slots (Caesar, Vigenere & Atbash)
    if (keyboard_check(vk_control) && keyboard_check_pressed(ord("P"))) {
        global.override_input[0] = string_char_at(global.override_target, 1);
        global.override_input[1] = string_char_at(global.override_target, 2);
        global.override_msg      = "";
        audio_play_sound(snd_correct_ping, 8, false);
    } else if (!keyboard_check(vk_control)) {
        for (var _k = ord("A"); _k <= ord("Z"); _k++) {
            if (keyboard_check_pressed(_k)) {
                global.override_input[_slot_idx] = chr(_k);
                global.override_msg = "";
                audio_play_sound(select1, 8, false);
            }
        }
    }

    if (keyboard_check_pressed(vk_enter)) {
        var _ans = global.override_input[0] + global.override_input[1];
        if (_ans == global.override_target) {
            global.lockdown_overridden = true;
            global.override_col        = c_lime;
            global.override_msg        = "LOCKDOWN OVERRIDDEN! Alarms & Drones Deactivated!";
            global.override_win_t      = 65;
            audio_play_sound(snd_objective_complete, 10, false);
        } else {
            global.override_shake = 10;
            global.override_col   = c_orange;
            if (!_has_key) {
                global.override_msg = "Unlock the Gold Key Vault first!";
            } else if (_ch == CHAPTER_ATBASH) {
                global.override_msg = "Reflect each letter of '" + global.override_plain + "' across the Atbash Mirror (A <-> Z)!";
            } else {
                global.override_msg = "Shift in the REVERSE direction to encrypt '" + global.override_plain + "'!";
            }
            audio_play_sound(wrong1, 10, false);
        }
    }
}

// ---------------------------------------------------------------------------
/// @function scr_draw_power_breaker_ui(_gui_w, _gui_h)
/// @description Renders and updates the Power Breaker Panel UI (Option B1:
///              3-Fuse Shift Verification — flip ON only the 2 fuses whose
///              Start -> End shift matches the floor's Cipher Key).
// ---------------------------------------------------------------------------
function scr_draw_power_breaker_ui(_gui_w, _gui_h) {
    if (!variable_global_exists("breaker_fuses")) scr_init_facility_puzzles();

    if (global.breaker_shake > 0) global.breaker_shake--;
    var _sx = (global.breaker_shake > 0) ? irandom_range(-4, 4) : 0;
    var _sy = (global.breaker_shake > 0) ? irandom_range(-4, 4) : 0;
    var _cx = (_gui_w * 0.5) + _sx;
    var _cy = (_gui_h * 0.5) + _sy;

    var _ch      = variable_global_exists("dungeon_chapter")      ? global.dungeon_chapter      : CHAPTER_CAESAR;
    var _key     = variable_global_exists("dungeon_cipher_key")   ? global.dungeon_cipher_key   : 3;
    var _vig_key = variable_global_exists("dungeon_vigenere_key") ? global.dungeon_vigenere_key : "CAB";
    var _has_key = (variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key);
    var _curr    = variable_global_exists("floor_curriculum")     ? global.floor_curriculum     : scr_get_floor_curriculum(1, 4);
    var _guided  = _curr.guided_ui;

    // 1. Dark Backdrop & Panel
    draw_set_alpha(0.84);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);

    var _pw = 548;
    var _ph = 276;
    var _x1 = _cx - _pw * 0.5;
    var _y1 = _cy - _ph * 0.5;
    var _x2 = _cx + _pw * 0.5;
    var _y2 = _cy + _ph * 0.5;

    draw_set_alpha(0.96);
    draw_set_color(make_color_rgb(14, 22, 34));
    draw_rectangle(_x1, _y1, _x2, _y2, false);
    draw_set_alpha(1.0);
    draw_set_color(c_aqua);
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    draw_rectangle(_x1 + 3, _y1 + 3, _x2 - 3, _y2 - 3, true);

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // 2. Header & Key Rule Pill
    draw_set_color(c_aqua);
    draw_text_transformed(_cx, _y1 + 20, "FLOOR POWER BREAKER PANEL", 1.05, 1.05, 0);

    var _pill_y = _y1 + 44;
    draw_set_color(make_color_rgb(20, 30, 46));
    draw_rectangle(_cx - 180, _pill_y - 11, _cx + 180, _pill_y + 11, false);
    draw_set_color(_has_key ? c_lime : make_color_rgb(255, 190, 55));
    draw_rectangle(_cx - 180, _pill_y - 11, _cx + 180, _pill_y + 11, true);

    if (!_has_key) {
        draw_text_transformed(_cx, _pill_y, "KEY: ???  (Unlock Gold Key Vault first!)", 0.84, 0.84, 0);
    } else if (_ch == CHAPTER_VIGENERE) {
        draw_text_transformed(_cx, _pill_y, "Flip [ON] only Fuses matching Keyword '" + _vig_key + "' (A=0, B=+1...)", 0.80, 0.80, 0);
    } else if (_ch == CHAPTER_ATBASH) {
        draw_text_transformed(_cx, _pill_y, "Flip [ON] only Fuses with true Mirror Pairs (A <-> Z)", 0.82, 0.82, 0);
    } else {
        var _k_str = (_key > 0) ? ("+" + string(_key)) : string(_key);
        draw_text_transformed(_cx, _pill_y, "Flip [ON] only Fuses matching Shift Key  " + _k_str, 0.85, 0.85, 0);
    }

    // 3. Visual Ruler Highlighting the Active Fuse's Start -> End Pair (2-Row Mirror Bar for Chapter 3 Atbash)
    var _act_fuse  = global.breaker_fuses[global.breaker_slot];
    var _f_s_idx   = ord(_act_fuse.start_ch) - ord("A");
    var _f_e_idx   = ord(_act_fuse.end_ch)   - ord("A");

    if (_ch == CHAPTER_ATBASH) {
        scr_draw_atbash_mirror_bar(_cx, _y1 + 69, _f_s_idx, _f_e_idx, -1, false, c_aqua);
    } else {
        var _strip_y  = _y1 + 80;
        var _cell_w   = 20;
        var _strip_w  = 26 * _cell_w;
        var _strip_x1 = _cx - _strip_w * 0.5;

        draw_set_color(make_color_rgb(20, 26, 40));
        draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, false);
        draw_set_color(make_color_rgb(70, 95, 130));
        draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, true);

        for (var _a = 0; _a < 26; _a++) {
            var _lx = _strip_x1 + _a * _cell_w + _cell_w * 0.5;
            var _ch_lbl = chr(ord("A") + _a);

            if (_a == _f_e_idx) {
                draw_set_color(c_aqua);
                draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, false);
                draw_set_color(c_black);
                draw_text(_lx, _strip_y, _ch_lbl);
            } else if (_a == _f_s_idx) {
                draw_set_color(make_color_rgb(255, 190, 40));
                draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, false);
                draw_set_color(c_black);
                draw_text(_lx, _strip_y, _ch_lbl);
            } else {
                draw_set_color(make_color_rgb(160, 175, 200));
                draw_text_transformed(_lx, _strip_y, _ch_lbl, 0.85, 0.85, 0);
            }
        }
        if (_guided && _has_key) {
            scr_draw_tutorial_ruler_hops(_strip_x1, _strip_y, _cell_w, _f_s_idx, _act_fuse.req_shift);
        }
    }

    // 4. Three Circuit Breaker Fuse Cards
    var _cards_y = _y1 + 158;
    for (var _fi = 0; _fi < 3; _fi++) {
        var _fcx    = _cx + (_fi - 1) * 162;
        var _fuse   = global.breaker_fuses[_fi];
        var _is_on  = global.breaker_state[_fi];
        var _is_sel = (_fi == global.breaker_slot);

        draw_set_color(_is_on ? make_color_rgb(18, 44, 34) : make_color_rgb(22, 26, 38));
        draw_rectangle(_fcx - 70, _cards_y - 44, _fcx + 70, _cards_y + 44, false);

        draw_set_color(_is_sel ? c_yellow : (_is_on ? c_lime : make_color_rgb(75, 95, 125)));
        draw_rectangle(_fcx - 70, _cards_y - 44, _fcx + 70, _cards_y + 44, true);
        if (_is_sel) {
            draw_rectangle(_fcx - 68, _cards_y - 42, _fcx + 68, _cards_y + 42, true);
        }

        // Fuse Title (with Keyword Letter & numeric shift in Chapter 2, or Mirror tag in Chapter 3)
        var _f_title = "FUSE #" + string(_fi + 1);
        if (_ch == CHAPTER_VIGENERE && _has_key) {
            var _kw_c  = string_char_at(_vig_key, (_fi mod string_length(_vig_key)) + 1);
            var _kw_sh = ord(_kw_c) - ord("A");
            _f_title += " ('" + _kw_c + "' = +" + string(_kw_sh) + ")";
        } else if (_ch == CHAPTER_ATBASH && _has_key) {
            _f_title += " (Mirror Pair?)";
        }
        draw_set_color(_is_sel ? c_yellow : make_color_rgb(175, 195, 220));
        draw_text_transformed(_fcx, _cards_y - 29, _f_title, 0.75, 0.75, 0);

        // Wire Pair: [ START -> END ]
        draw_set_color(c_white);
        draw_text_transformed(_fcx, _cards_y - 6, _fuse.start_ch + "   ->   " + _fuse.end_ch, 1.05, 1.05, 0);

        // Switch Toggle Pill: [ ON ] or [ OFF ]
        draw_set_color(_is_on ? c_lime : make_color_rgb(45, 52, 68));
        draw_rectangle(_fcx - 42, _cards_y + 14, _fcx + 42, _cards_y + 34, false);
        draw_set_color(_is_on ? c_black : make_color_rgb(170, 180, 200));
        draw_text_transformed(_fcx, _cards_y + 24, _is_on ? "SWITCH: ON" : "SWITCH: OFF", 0.78, 0.78, 0);
    }

    // 5. Guided Tutorial Hint (Floors 1-3) & Status Footer
    var _repaired = (variable_global_exists("breaker_repaired") && global.breaker_repaired);
    var _cur_scrp = variable_global_exists("scrap_count") ? global.scrap_count : 0;

    if (!_repaired) {
        // Draw Fried Breaker Relay Overlay Banner across lower half of panel
        draw_set_alpha(0.94);
        draw_set_color(make_color_rgb(36, 16, 22));
        draw_rectangle(_x1 + 18, _y2 - 66, _x2 - 18, _y2 - 26, false);
        draw_set_alpha(1.0);
        draw_set_color((_cur_scrp >= 2) ? c_lime : make_color_rgb(255, 95, 75));
        draw_rectangle(_x1 + 18, _y2 - 66, _x2 - 18, _y2 - 26, true);

        if (_cur_scrp >= 2) {
            draw_set_color(c_lime);
            draw_text_transformed(_cx, _y2 - 53, "BREAKER RELAY FRIED BY LOCKDOWN!  (Your Scrap: " + string(_cur_scrp) + " / 2)", 0.84, 0.84, 0);
            draw_set_color(c_white);
            draw_text_transformed(_cx, _y2 - 36, "[ PRESS SPACE / ENTER TO INSTALL 2 SCRAP & REPAIR BREAKER ]", 0.82, 0.82, 0);
        } else {
            draw_set_color(make_color_rgb(255, 185, 65));
            draw_text_transformed(_cx, _y2 - 53, "BREAKER RELAY FRIED!  Requires 2 Scrap to Repair  (Your Scrap: " + string(_cur_scrp) + " / 2)", 0.84, 0.84, 0);
            draw_set_color(c_white);
            draw_text_transformed(_cx, _y2 - 36, "Right-Click [RMB] Office Terminals or Ambush a Patrol Bot [E] to get Scrap!", 0.78, 0.78, 0);
        }
    } else if (global.breaker_msg != "") {
        draw_set_color(global.breaker_col);
        draw_text_transformed(_cx, _y2 - 40, global.breaker_msg, 0.88, 0.88, 0);
    } else if (_guided && _has_key) {
        var _should_be = _act_fuse.is_valid ? "VALID (Flip ON!)" : "FAULTY (Leave OFF!)";
        draw_set_color(_act_fuse.is_valid ? c_lime : c_orange);
        draw_text_transformed(
            _cx, _y2 - 40,
            "TUTORIAL: Fuse #" + string(global.breaker_slot + 1) + " (" + _act_fuse.start_ch + "->" + _act_fuse.end_ch + ") is " + _should_be,
            0.82, 0.82, 0
        );
    }

    draw_set_color(make_color_rgb(150, 170, 195));
    draw_text_transformed(_cx, _y2 - 14, _repaired
        ? "[LEFT/RIGHT] Select   |   [UP/DOWN/SPACE] Flip Switch   |   [ENTER] Restore Power   |   [ESC] Back"
        : "[SPACE / ENTER] Repair Breaker (-2 Scrap)   |   [ESC] Back to Floor", 0.76, 0.76, 0);

    // --- 6. INPUT HANDLING ---
    if (global.breaker_win_t > 0) {
        global.breaker_win_t--;
        if (global.breaker_win_t <= 0) {
            global.breaker_ui_open = false;
        }
        return;
    }

    if (keyboard_check_pressed(vk_escape)) {
        global.esc_block_frames = 2;
        keyboard_clear(vk_escape);
        global.breaker_ui_open = false;
        audio_play_sound(snd_button_click, 10, false);
        return;
    }

    // DEMO SHORTCUT: Press Ctrl + P to auto-repair & align all 3 Breaker Fuses (Caesar, Vigenere & Atbash)
    if (keyboard_check(vk_control) && keyboard_check_pressed(ord("P"))) {
        global.breaker_repaired = true;
        for (var _bf = 0; _bf < 3; _bf++) {
            global.breaker_state[_bf] = global.breaker_fuses[_bf].is_valid;
        }
        global.breaker_msg = "";
        audio_play_sound(snd_correct_ping, 8, false);
        return;
    }

    // Require 2 Scrap to repair the fried breaker relay before flipping switches!
    if (!_repaired) {
        if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("E"))) {
            if (_cur_scrp >= 2) {
                global.scrap_count     -= 2;
                global.breaker_repaired = true;
                global.breaker_col      = c_lime;
                global.breaker_msg      = "BREAKER REPAIRED (-2 SCRAP)! Now flip the 2 valid Fuses ON!";
                audio_play_sound(snd_correct_ping, 10, false);
            } else {
                global.breaker_shake = 10;
                audio_play_sound(wrong1, 10, false);
            }
        }
        return;
    }

    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
        global.breaker_slot = (global.breaker_slot + 1) mod 3;
        global.breaker_msg  = "";
        audio_play_sound(select1, 10, false);
    }
    if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) {
        global.breaker_slot = (global.breaker_slot + 2) mod 3;
        global.breaker_msg  = "";
        audio_play_sound(select1, 10, false);
    }

    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_down)
        || keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("W")) || keyboard_check_pressed(ord("S")))
    {
        global.breaker_state[global.breaker_slot] = !global.breaker_state[global.breaker_slot];
        global.breaker_msg = "";
        audio_play_sound(choose(select1, select2, select3), 10, false);
    }

    if (keyboard_check_pressed(vk_enter)) {
        var _all_ok = true;
        for (var _fi = 0; _fi < 3; _fi++) {
            if (global.breaker_state[_fi] != global.breaker_fuses[_fi].is_valid) {
                _all_ok = false;
            }
        }

        if (_all_ok) {
            global.power_restored = true;
            global.breaker_col    = c_lime;
            global.breaker_msg    = "POWER RESTORED! Office Lights & Elevator Online!";
            global.breaker_win_t  = 65;
            audio_play_sound(snd_objective_complete, 10, false);
        } else {
            global.breaker_shake = 10;
            global.breaker_col   = c_orange;
            if (!_has_key) {
                global.breaker_msg = "Unlock the Gold Key Vault first to know the Key!";
            } else {
                global.breaker_msg = "Circuit mismatch! Flip ON only the 2 Fuses that match the Key!";
            }
            audio_play_sound(wrong1, 10, false);
        }
    }
}

// ---------------------------------------------------------------------------
/// @function scr_trigger_dungeon_camera_cutscene(_lines, _targets)
/// @description Triggers a smooth Dungeon Camera Pan Cutscene coupled with a
///              Visual Novel Mentor Pop-Up Dialogue. Each page of `_lines`
///              smoothly pans the camera to the corresponding entry in `_targets`
///              (`{ tx, ty, label, sublabel, col }`), reveals & lights up that
///              room chunk, and returns the camera to Jack when dismissed.
// ---------------------------------------------------------------------------
function scr_trigger_dungeon_camera_cutscene(_lines, _targets) {
    var _n_lines = array_length(_lines);
    var _n_tgts  = array_length(_targets);
    if (_n_lines <= 0 || _n_tgts <= 0) return;

    var _start_x = instance_exists(obj_jack) ? obj_jack.x        : _targets[0].tx;
    var _start_y = instance_exists(obj_jack) ? (obj_jack.y - 12) : _targets[0].ty;

    global.cam_pan_mode     = "dungeon_cutscene";
    global.cam_pan_phase    = "pan_out";
    global.cam_pan_timer    = 0;
    global.cam_pan_targets  = _targets;
    global.cam_pan_from_x   = _start_x;
    global.cam_pan_from_y   = _start_y;
    global.cam_pan_cur_x    = _start_x;
    global.cam_pan_cur_y    = _start_y;
    global.cam_pan_to_x     = _targets[0].tx;
    global.cam_pan_to_y     = _targets[0].ty;
    global.cam_pan_label    = _targets[0].label;
    global.cam_pan_sublabel = variable_struct_exists(_targets[0], "sublabel") ? _targets[0].sublabel : "";
    global.cam_pan_col      = variable_struct_exists(_targets[0], "col")      ? _targets[0].col      : c_aqua;

    // Ensure Mentor NPC (Kyle) has its VN portrait & stage sprite initialized
    var _speaker = obj_jack;
    if (variable_global_exists("floor_mentor_inst") && instance_exists(global.floor_mentor_inst)) {
        _speaker = global.floor_mentor_inst;
        if (!variable_instance_exists(_speaker, "init_done") || !_speaker.init_done) {
            _speaker.init_done      = true;
            _speaker.myName         = "Kyle (Security Analyst)";
            _speaker.npc_spr        = spr_kyle_idle;
            _speaker.myPortrait     = spr_kyle_portrait;
            _speaker.myPortraitTalk = spr_kyle_portrait;
            _speaker.myVoice        = snd_voice2;
        }
    }

    var _spk_arr = array_create(_n_lines, _speaker);
    global.e_dialogue_intro_shown = true;
    create_textevent(_lines, _spk_arr);
}


// ---------------------------------------------------------------------------
/// @function scr_init_floor_salvage_tasks()
/// @description Initializes per-floor HR Property Limit counters & Salvage Tasks
///              that incentivize Wrench Scrapping while tempting players near
///              the 3-Property HR Write-Off Limit.
// ---------------------------------------------------------------------------
function scr_init_floor_salvage_tasks() {
    scr_statue_ensure_globals();
    if (!variable_global_exists("legal_fund"))          global.legal_fund          = 0;
    if (!variable_global_exists("intern_duty_flagged")) global.intern_duty_flagged = false;

    // Performance Tracker (resets every floor / workday)
    global.floor_cipher_fails     = 0;
    global.floor_times_busted     = 0;
    global.surge_shield_used      = false;
    global.override_timer_max     = 0;
    global.phone_ui_open          = false;
    global.shelf_ui_open          = false;
    global.elevator_room_found    = false;

    global.hr_scrap_count         = 0;
    global.hr_scrap_limit         = 6;
    global.breaker_repaired       = false;
    global.scrap_ui_open          = false;
    global.bot_grapple_active     = false;
    global.task_bots_scrapped     = 0;
    global.task_servers_scrapped  = 0;
    global.floor_scrap_collected  = 0;
    global.incident_solved        = false;
    global.drone_jammed_timer     = 0;
    global.patient_zero_inst      = noone;
    global.pc_screen_open         = false;
    global.pc_screen_is_pz        = false;
}


// ---------------------------------------------------------------------------
/// @function scr_open_scrap_sever_ui(_prop_inst)
/// @description Opens the Chapter-Adaptive Mainframe Sever Encryption UI when
///              Jack right-clicks a Terminal with his Wrench or apprehends a
///              Security Bot from behind ([E] mash).
///              Anytime-playable: rolls a local 2-letter Node ID & local key!
// ---------------------------------------------------------------------------
function scr_open_scrap_sever_ui(_prop_inst) {
    if (!instance_exists(_prop_inst)) return;

    var _ch    = variable_global_exists("dungeon_chapter") ? global.dungeon_chapter : CHAPTER_CAESAR;
    var _pairs = ["TX", "ND", "SV", "PC", "IO", "DB", "RT", "GW", "LK", "FW", "OS", "VM"];
    var _plain = _pairs[irandom(array_length(_pairs) - 1)];

    var _c1 = string_char_at(_plain, 1);
    var _c2 = string_char_at(_plain, 2);
    var _t1 = _c1;
    var _t2 = _c2;
    var _s1 = 0;
    var _s2 = 0;
    var _local_caesar = choose(-4, -3, -2, -1, 1, 2, 3, 4);
    var _v_keys       = ["BC", "CD", "DE", "BD", "CE", "DB", "EC", "CB"];
    var _local_vig    = _v_keys[irandom(array_length(_v_keys) - 1)];

    if (_ch == CHAPTER_ATBASH) {
        _t1 = scr_atbash_decode(_c1);
        _t2 = scr_atbash_decode(_c2);
    } else if (_ch == CHAPTER_VIGENERE) {
        var _vk1 = string_char_at(_local_vig, 1);
        var _vk2 = string_char_at(_local_vig, 2);
        _s1 = ord(_vk1) - ord("A");
        _s2 = ord(_vk2) - ord("A");
        _t1 = scr_caesar_encode(_c1, _s1);
        _t2 = scr_caesar_encode(_c2, _s2);
    } else {
        _s1 = _local_caesar;
        _s2 = _local_caesar;
        _t1 = scr_caesar_encode(_c1, _s1);
        _t2 = scr_caesar_encode(_c2, _s2);
    }

    var _is_bot = (_prop_inst.prop_type == TILE_PROP_DRONE);
    var _is_srv = (variable_instance_exists(_prop_inst, "is_server_rack") && _prop_inst.is_server_rack);

    global.scrap_ui_open       = true;
    global.scrap_target_inst   = _prop_inst;
    global.scrap_is_bot        = _is_bot;
    global.scrap_is_server     = _is_srv;
    global.scrap_ui_yield      = (_is_bot || _is_srv) ? 3 : 1;
    global.scrap_ui_rare       = (_is_bot || _is_srv) ? 1 : 0;
    global.scrap_plain         = _plain;
    global.scrap_target        = _t1 + _t2;
    global.scrap_shifts        = [_s1, _s2];
    global.scrap_local_key     = _local_caesar;
    global.scrap_vig_key       = _local_vig;
    global.scrap_input         = ["", ""];
    global.scrap_slot          = 0;
    global.scrap_msg           = "";
    global.scrap_col           = c_white;
    global.scrap_shake         = 0;
    global.scrap_win_t         = 0;
    global.scrap_fail_t        = 0;
    global.scrap_timer_max     = scr_get_cipher_timer_frames("sever");
    global.scrap_timer         = global.scrap_timer_max;
}


// ---------------------------------------------------------------------------
/// @function scr_scrap_sever_fail(_timeout)
/// @description Handles a wrong encryption or a Trace Timer timeout while severing.
///              - Copper Surge Totem (statue #2) absorbs the FIRST shock each floor
///                (UI stays open, timer resets).
///              - Otherwise the Anti-Tamper Protocol fries the device (1 Scrap to fix).
/// @returns {Bool} true if the device was fried (UI closing), false if the shield absorbed it.
// ---------------------------------------------------------------------------
function scr_scrap_sever_fail(_timeout) {
    global.floor_cipher_fails++;
    global.scrap_shake = 14;

    if (scr_has_active_statue(2) && !global.surge_shield_used) {
        global.surge_shield_used = true;
        global.scrap_col   = make_color_rgb(80, 225, 235);
        global.scrap_msg   = _timeout
            ? "TIMEOUT! COPPER SURGE TOTEM ABSORBED THE SHOCK — timer reset!"
            : "WRONG CODE! COPPER SURGE TOTEM ABSORBED THE SHOCK — try again!";
        global.scrap_timer = global.scrap_timer_max;
        audio_play_sound(snd_select, 10, false);
        audio_play_sound(wrong1, 9, false);
        return false;
    }

    global.scrap_col    = make_color_rgb(255, 75, 65);
    global.scrap_msg    = _timeout
        ? "TRACE TIMEOUT! ANTI-TAMPER TRIGGERED — Circuits Fried! (1 Scrap [RMB] to Fix)"
        : "ANTI-TAMPER TRIGGERED! Circuits Fried — Spend 1 Scrap [RMB] to Fix!";
    global.scrap_fail_t = 65;
    global.cam_shake_timer = 10;
    global.cam_shake_mag   = 4;
    audio_play_sound(snd_error, 10, false);
    audio_play_sound(wrong1, 9, false);

    if (instance_exists(global.scrap_target_inst)) {
        global.scrap_target_inst.is_fried        = true;
        global.scrap_target_inst.grapple_active  = false;
        global.scrap_target_inst.zap_cd          = 90;
        global.scrap_target_inst.scrap_pop_timer = 110;
        global.scrap_target_inst.scrap_pop_text  = "CIRCUITS FRIED! (1 SCRAP TO FIX)";
    }
    return true;
}


// ---------------------------------------------------------------------------
/// @function scr_draw_scrap_sever_ui(_gui_w, _gui_h)
/// @description Renders and updates the Wrench Sabotage / Mainframe Sever
///              Encryption UI:
///              - Correct Encryption: Severs connection, dismantles hardware,
///                awards Scrap (+1 or +3), and increments HR Property Counter.
///              - Wrong Encryption: Triggers Anti-Tamper Protocol, frying the
///                device's circuits (`is_fried = true`) so it costs 1 Scrap to fix!
// ---------------------------------------------------------------------------
function scr_draw_scrap_sever_ui(_gui_w, _gui_h) {
    if (!variable_global_exists("scrap_plain")) {
        global.scrap_ui_open = false;
        return;
    }

    if (global.scrap_shake > 0) global.scrap_shake--;
    var _sx = (global.scrap_shake > 0) ? irandom_range(-4, 4) : 0;
    var _sy = (global.scrap_shake > 0) ? irandom_range(-4, 4) : 0;
    var _cx = (_gui_w * 0.5) + _sx;
    var _cy = (_gui_h * 0.5) + _sy;

    var _ch      = variable_global_exists("dungeon_chapter")  ? global.dungeon_chapter  : CHAPTER_CAESAR;
    var _curr    = variable_global_exists("floor_curriculum") ? global.floor_curriculum : scr_get_floor_curriculum(1, 4);
    var _guided  = _curr.guided_ui;
    var _hide_sh = _curr.hide_shift_match;
    var _hr_cur  = variable_global_exists("hr_scrap_count")   ? global.hr_scrap_count   : 0;
    var _hr_lim  = variable_global_exists("hr_scrap_limit")   ? global.hr_scrap_limit   : 3;

    // 1. Dark Backdrop & Panel
    draw_set_alpha(0.86);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);

    var _pw = 548;
    var _ph = 286;
    var _x1 = _cx - _pw * 0.5;
    var _y1 = _cy - _ph * 0.5;
    var _x2 = _cx + _pw * 0.5;
    var _y2 = _cy + _ph * 0.5;

    var _theme_col = global.scrap_is_bot
        ? make_color_rgb(255, 165, 45)
        : (global.scrap_is_server ? make_color_rgb(235, 95, 255) : make_color_rgb(80, 225, 165));
    if (global.scrap_fail_t > 0) _theme_col = make_color_rgb(255, 60, 60);

    draw_set_alpha(0.96);
    draw_set_color(make_color_rgb(14, 20, 28));
    draw_rectangle(_x1, _y1, _x2, _y2, false);
    draw_set_alpha(1.0);
    draw_set_color(_theme_col);
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    draw_rectangle(_x1 + 3, _y1 + 3, _x2 - 3, _y2 - 3, true);

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // 2. Title & HR Write-Off Risk Sub-Banner
    var _hdr_txt = "WRENCH SABOTAGE — SEVER TERMINAL UPLINK";
    if (global.scrap_is_bot)    _hdr_txt = "BOT APPREHENDED! — SEVER DRONE TELEMETRY";
    if (global.scrap_is_server) _hdr_txt = "PROTOTYPE SERVER — SEVER HIGH-YIELD UPLINK";

    draw_set_color(_theme_col);
    draw_text_transformed(_cx, _y1 + 18, _hdr_txt, 1.0, 1.0, 0);

    var _at_risk = (_hr_cur >= _hr_lim);
    var _hr_txt  = _at_risk
        ? ("HR WARNING (" + string(_hr_cur) + "/" + string(_hr_lim) + "): Scrapping this exceeds 3/3 limit -> FLAGS INTERN BABYSITTING DUTY! (+" + string(global.scrap_ui_yield) + " Scrap)")
        : ("HR PROPERTY ALLOWANCE: " + string(_hr_cur) + " / " + string(_hr_lim) + " Scrapped (Safe Write-Off)   •   YIELD: +" + string(global.scrap_ui_yield) + " SCRAP");
    draw_set_color(_at_risk ? make_color_rgb(255, 95, 95) : make_color_rgb(255, 215, 75));
    draw_text_transformed(_cx, _y1 + 36, _hr_txt, 0.75, 0.75, 0);

    // 3. Chapter Encryption Instruction Pill
    var _pill_y = _y1 + 58;
    draw_set_color(make_color_rgb(22, 30, 44));
    draw_rectangle(_cx - 210, _pill_y - 10, _cx + 210, _pill_y + 10, false);
    draw_set_color(c_aqua);
    draw_rectangle(_cx - 210, _pill_y - 10, _cx + 210, _pill_y + 10, true);

    if (_ch == CHAPTER_VIGENERE) {
        var _vk  = global.scrap_vig_key;
        var _vs1 = global.scrap_shifts[0];
        var _vs2 = global.scrap_shifts[1];
        draw_set_color(c_white);
        draw_text_transformed(_cx, _pill_y, "ENCRYPT NODE '" + global.scrap_plain + "' (Vigenere Key '" + _vk + "'):  Slot 1 (+" + string(_vs1) + "), Slot 2 (+" + string(_vs2) + ")", 0.78, 0.78, 0);
    } else if (_ch == CHAPTER_ATBASH) {
        draw_set_color(c_white);
        draw_text_transformed(_cx, _pill_y, "ENCRYPT NODE '" + global.scrap_plain + "':  Reflect across Atbash Mirror (A <-> Z, B <-> Y)", 0.80, 0.80, 0);
    } else {
        var _lk     = global.scrap_local_key;
        var _lk_str = (_lk > 0) ? ("+" + string(_lk)) : string(_lk);
        draw_set_color(c_white);
        draw_text_transformed(_cx, _pill_y, "ENCRYPT NODE '" + global.scrap_plain + "':  Caesar Shift by " + _lk_str + "  (Wrong Code Fries Circuits!)", 0.80, 0.80, 0);
    }

    // 4. Visual A-Z Ruler (or 2-Row Mirror Guide in Chapter 3)
    var _slot_idx   = global.scrap_slot;
    var _src_ch     = string_char_at(global.scrap_plain, _slot_idx + 1);
    var _src_idx    = ord(_src_ch) - ord("A");
    var _usr_ch     = global.scrap_input[_slot_idx];
    var _usr_idx    = (_usr_ch != "") ? (ord(_usr_ch) - ord("A")) : -1;
    var _target_ch  = string_char_at(global.scrap_target, _slot_idx + 1);
    var _target_idx = ord(_target_ch) - ord("A");

    if (_ch == CHAPTER_ATBASH) {
        scr_draw_atbash_mirror_bar(_cx, _y1 + 83, _src_idx, _usr_idx, _target_idx, _guided, c_lime);
    } else {
        var _strip_y  = _y1 + 92;
        var _cell_w   = 20;
        var _strip_w  = 26 * _cell_w;
        var _strip_x1 = _cx - _strip_w * 0.5;

        draw_set_color(make_color_rgb(20, 26, 40));
        draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, false);
        draw_set_color(make_color_rgb(80, 105, 140));
        draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, true);

        for (var _a = 0; _a < 26; _a++) {
            var _lx     = _strip_x1 + _a * _cell_w + _cell_w * 0.5;
            var _ch_lbl = chr(ord("A") + _a);

            if (_a == _usr_idx) {
                draw_set_color(c_lime);
                draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, false);
                draw_set_color(c_black);
                draw_text(_lx, _strip_y, _ch_lbl);
            } else if (_a == _src_idx) {
                draw_set_color(make_color_rgb(255, 195, 45));
                draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, false);
                draw_set_color(c_black);
                draw_text(_lx, _strip_y, _ch_lbl);
            } else if (_guided && _a == _target_idx) {
                draw_set_color(c_lime);
                draw_rectangle(_lx - 9, _strip_y - 12, _lx + 9, _strip_y + 12, true);
                draw_rectangle(_lx - 8, _strip_y - 11, _lx + 8, _strip_y + 11, true);
                draw_text(_lx, _strip_y, _ch_lbl);
            } else {
                draw_set_color(make_color_rgb(165, 180, 205));
                draw_text_transformed(_lx, _strip_y, _ch_lbl, 0.85, 0.85, 0);
            }
        }
        if (_guided) {
            scr_draw_tutorial_ruler_hops(_strip_x1, _strip_y, _cell_w, _src_idx, global.scrap_shifts[_slot_idx]);
        }
    }

    // 5. Two Node Encryption Slots + Wrench Scrap Action Button
    var _slots_y = _y1 + 174;
    for (var _i = 0; _i < 2; _i++) {
        var _scx  = (_cx - 115) + _i * 82;
        var _pch  = string_char_at(global.scrap_plain, _i + 1);
        var _u_ch = global.scrap_input[_i];

        // In Chapter 2 (Vigenere), show each slot's Keyword letter & shift badge above the slot!
        if (_ch == CHAPTER_VIGENERE) {
            var _sc_kw_c = string_char_at(global.scrap_vig_key, _i + 1);
            var _sc_sh   = global.scrap_shifts[_i];
            draw_set_color(make_color_rgb(215, 130, 255));
            draw_text_transformed(_scx, _slots_y - 54, _sc_kw_c + " (+" + string(_sc_sh) + ")", 0.70, 0.70, 0);
        }

        draw_set_color((_i == _slot_idx) ? make_color_rgb(255, 210, 55) : make_color_rgb(175, 190, 210));
        draw_text(_scx, _slots_y - 40, _pch);
        draw_set_color(c_gray);
        draw_text_transformed(_scx, _slots_y - 26, "v", 0.72, 0.72, 0);

        if (_i == _slot_idx) {
            draw_sprite(spr_slot_active, 0, _scx, _slots_y);
        } else {
            draw_sprite(spr_slot, 0, _scx, _slots_y);
        }

        if (_u_ch != "") {
            draw_set_color(c_white);
            draw_text(_scx, _slots_y, _u_ch);

            if (_ch == CHAPTER_ATBASH) {
                var _ok_m = (_u_ch == scr_atbash_decode(_pch));
                draw_set_color((!_hide_sh && _ok_m) ? c_lime : make_color_rgb(170, 190, 215));
                draw_text_transformed(_scx, _slots_y + 30, _pch + "<->" + _u_ch, 0.75, 0.75, 0);
            } else {
                var _diff = (ord(_u_ch) - ord(_pch) + 26) mod 26;
                if (_diff > 13) _diff -= 26;
                var _d_str = (_diff > 0) ? ("+" + string(_diff)) : string(_diff);
                var _ok_sh = (!_hide_sh && _diff == global.scrap_shifts[_i]);
                draw_set_color(_ok_sh ? c_lime : make_color_rgb(170, 190, 215));
                draw_text_transformed(_scx, _slots_y + 30, _d_str, 0.85, 0.85, 0);
            }
        } else {
            draw_set_color(c_gray);
            draw_text(_scx, _slots_y, "?");
        }
    }

    draw_set_color(c_gray);
    draw_text(_cx + 12, _slots_y, "->");

    var _both_filled = (global.scrap_input[0] != "" && global.scrap_input[1] != "");
    var _btn_cx      = _cx + 118;
    var _btn_cy      = _slots_y;
    var _btn_pulse   = 0.5 + 0.5 * sin(current_time / 180);

    draw_set_color(_both_filled ? make_color_rgb(20, 75, 52) : make_color_rgb(24, 30, 38));
    draw_roundrect(_btn_cx - 76, _btn_cy - 30, _btn_cx + 76, _btn_cy + 30, false);
    draw_set_color(_both_filled ? merge_color(c_lime, c_yellow, _btn_pulse * 0.4) : make_color_rgb(75, 95, 115));
    draw_roundrect(_btn_cx - 76, _btn_cy - 30, _btn_cx + 76, _btn_cy + 30, true);

    draw_set_color(_both_filled ? c_white : c_gray);
    draw_text_transformed(_btn_cx, _btn_cy - 8, "SEVER & SCRAP", 0.80, 0.80, 0);
    draw_set_color(_both_filled ? c_lime : make_color_rgb(145, 160, 175));
    draw_text_transformed(_btn_cx, _btn_cy + 11, _both_filled ? "[PRESS ENTER!]" : "(+" + string(global.scrap_ui_yield) + " Scrap)", 0.76, 0.76, 0);

    // 6. Trace Timer, Status / Anti-Tamper Warning & Footer
    if (global.scrap_win_t <= 0 && global.scrap_fail_t <= 0) {
        scr_draw_trace_timer(_cx, _y2 - 62, 300, global.scrap_timer, global.scrap_timer_max);
        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
    }
    if (global.scrap_msg != "") {
        draw_set_color(global.scrap_col);
        draw_text_transformed(_cx, _y2 - 40, global.scrap_msg, 0.84, 0.84, 0);
    } else if (_guided) {
        draw_set_color(c_lime);
        draw_text_transformed(
            _cx, _y2 - 40,
            "GUIDE: Shift '" + _src_ch + "' -> '" + _target_ch + "' (Green box on ruler), then press [ENTER] to Wrench Scrap!",
            0.78, 0.78, 0
        );
    } else {
        draw_set_color(make_color_rgb(255, 185, 75));
        draw_text_transformed(_cx, _y2 - 40, "CAUTION: Entering a wrong encryption triggers Anti-Tamper and FRIES the circuits!", 0.76, 0.76, 0);
    }

    draw_set_color(make_color_rgb(150, 170, 195));
    draw_text_transformed(_cx, _y2 - 15, "[ARROWS / A-Z] Select & Shift   |   [ENTER] Sever & Scrap   |   [ESC] Cancel Safely", 0.78, 0.78, 0);

    // --- 7. INPUT & OUTCOME HANDLING ---
    if (global.scrap_win_t > 0) {
        global.scrap_win_t--;
        if (global.scrap_win_t <= 0) {
            global.scrap_ui_open = false;
        }
        return;
    }

    if (global.scrap_fail_t > 0) {
        global.scrap_fail_t--;
        if (global.scrap_fail_t <= 0) {
            global.scrap_ui_open = false;
        }
        return;
    }

    if (keyboard_check_pressed(vk_escape)) {
        global.esc_block_frames = 2;
        keyboard_clear(vk_escape);
        global.scrap_ui_open = false;
        if (instance_exists(global.scrap_target_inst) && global.scrap_is_bot) {
            // If player cancels out of severing an apprehended bot, push the bot back briefly so they can move away
            global.scrap_target_inst.zap_cd = 75;
        }
        audio_play_sound(snd_button_click, 10, false);
        return;
    }

    // Trace Timer countdown (frozen while the pause menu is open)
    if (!(variable_global_exists("is_paused") && global.is_paused)) {
        global.scrap_timer--;
        if (global.scrap_timer <= 0) {
            scr_scrap_sever_fail(true);
            return;
        }
    }

    if (keyboard_check_pressed(vk_right)) {
        global.scrap_slot = 1;
        audio_play_sound(select1, 10, false);
    }
    if (keyboard_check_pressed(vk_left)) {
        global.scrap_slot = 0;
        audio_play_sound(select1, 10, false);
    }

    if (keyboard_check_pressed(vk_up)) {
        var _bch = (global.scrap_input[_slot_idx] == "") ? _src_ch : global.scrap_input[_slot_idx];
        var _ni  = (ord(_bch) - ord("A") + 1) mod 26;
        global.scrap_input[_slot_idx] = chr(ord("A") + _ni);
        global.scrap_msg = "";
        audio_play_sound(choose(select1, select2, select3), 10, false);
    }
    if (keyboard_check_pressed(vk_down)) {
        var _bch = (global.scrap_input[_slot_idx] == "") ? _src_ch : global.scrap_input[_slot_idx];
        var _ni  = (ord(_bch) - ord("A") - 1 + 26) mod 26;
        global.scrap_input[_slot_idx] = chr(ord("A") + _ni);
        global.scrap_msg = "";
        audio_play_sound(choose(select1, select2, select3), 10, false);
    }

    // DEMO SHORTCUT: Press Ctrl + P to auto-fill both Wrench Scrap slots (Caesar, Vigenere & Atbash)
    if (keyboard_check(vk_control) && keyboard_check_pressed(ord("P"))) {
        global.scrap_input[0] = string_char_at(global.scrap_target, 1);
        global.scrap_input[1] = string_char_at(global.scrap_target, 2);
        global.scrap_msg      = "";
        audio_play_sound(snd_correct_ping, 8, false);
    } else if (!keyboard_check(vk_control)) {
        for (var _k = ord("A"); _k <= ord("Z"); _k++) {
            if (keyboard_check_pressed(_k)) {
                global.scrap_input[_slot_idx] = chr(_k);
                global.scrap_msg = "";
                audio_play_sound(select1, 8, false);
            }
        }
    }

    if (keyboard_check_pressed(vk_enter)) {
        if (!_both_filled) {
            global.scrap_shake = 8;
            global.scrap_col   = c_orange;
            global.scrap_msg   = "Fill both Node Encryption slots before severing!";
            audio_play_sound(wrong1, 10, false);
            return;
        }

        var _ans = global.scrap_input[0] + global.scrap_input[1];
        if (_ans == global.scrap_target) {
            // SUCCESS! Sever connection, dismantle prop, award Scrap & increment HR Counter!
            var _yield = global.scrap_ui_yield;
            var _rare  = global.scrap_ui_rare;
            global.scrap_count           += _yield;
            global.floor_scrap_collected += _yield;
            global.rare_cores            += _rare;
            global.hr_scrap_count        += 1;

            if (global.scrap_is_bot)    global.task_bots_scrapped++;
            if (global.scrap_is_server) global.task_servers_scrapped++;

            // Symmetrical Corporate Compliance Meter evaluation:
            // 4..6 Scrap = GREEN (Compliant / Clean Exit)
            // 3 or 7..8 = YELLOW (Mild Duty)
            // 1..2 or 9..11 = RED (Severe Duty)
            // 0 or 12+ = BLACK (Extreme Duty)
            var _scrap = global.hr_scrap_count;
            var _is_compliant = (_scrap >= 4 && _scrap <= 6);
            global.intern_duty_flagged = !_is_compliant;

            if (instance_exists(global.scrap_target_inst)) {
                global.scrap_target_inst.is_scrapped     = true;
                global.scrap_target_inst.is_fried        = false;
                global.scrap_target_inst.grapple_active  = false;
                global.scrap_target_inst.scrap_pop_timer = 95;
                global.scrap_target_inst.scrap_pop_text  = (_rare > 0)
                    ? ("+" + string(_yield) + " SCRAP  +1 CORE!")
                    : ("+" + string(_yield) + " SCRAP!");
            }

            if (_is_compliant) {
                global.scrap_col = c_lime;
                global.scrap_msg = "SCRAPPED (+" + string(_yield) + ")! COMPLIANCE MET (" + string(_scrap) + " Pcs) -> GREEN ZONE [SAFE EXIT]";
            } else if (_scrap < 4) {
                global.scrap_col = make_color_rgb(255, 215, 60); // Yellow
                global.scrap_msg = "SCRAPPED (+" + string(_yield) + ")! DEFICIT (" + string(_scrap) + "/4 Pcs) -> SCRAP MORE FOR GREEN ZONE";
            } else {
                global.scrap_col = make_color_rgb(255, 110, 95); // Red
                global.scrap_msg = "SCRAPPED (+" + string(_yield) + ")! OVERLOAD (" + string(_scrap) + " Pcs) -> EXCEEDED GREEN ZONE!";
            }
            global.scrap_win_t = 55;
            audio_play_sound(snd_objective_complete, 10, false);
        } else {
            // WRONG ENCRYPTION -> Copper Surge Totem shield (once per floor) or ANTI-TAMPER fries the circuits!
            scr_scrap_sever_fail(false);
        }
    }
}





// ---------------------------------------------------------------------------
/// @function scr_case_dept(_name)
/// @description Returns the company department of a named employee (used by the
///              whodunit case dossier so evidence can point at a department).
// ---------------------------------------------------------------------------
function scr_case_dept(_name) {
    var _keys  = ["David", "Alice", "Toby", "Dave", "Karen", "Frank", "Marcus", "Bob", "Chloe", "Greg", "Sarah"];
    var _depts = ["Security", "Legal", "Sales", "Accounting", "HR", "Facilities", "Engineering", "IT Support", "Marketing", "Operations", "Executive"];
    for (var _i = 0; _i < array_length(_keys); _i++) {
        if (string_pos(_keys[_i] + " ", _name + " ") == 1) return _depts[_i];
    }
    return "Admin";
}


// ---------------------------------------------------------------------------
/// @function scr_case_nameplate(_name)
/// @description Builds a short desk nameplate, e.g. "Dave Miller" -> "D. MILLER".
// ---------------------------------------------------------------------------
function scr_case_nameplate(_name) {
    var _base = _name;
    var _p = string_pos(" (", _name);
    if (_p > 0) _base = string_copy(_name, 1, _p - 1);
    var _sp = string_pos(" ", _base);
    if (_sp <= 0) return string_upper(_base);
    var _last = string_copy(_base, _sp + 1, string_length(_base) - _sp);
    return string_upper(string_char_at(_base, 1)) + ". " + string_upper(_last);
}


// ---------------------------------------------------------------------------
/// @function scr_case_recompute()
/// @description Re-evaluates every suspect's status (0 unknown, 1 cleared, 2 suspect)
///              from the evidence found so far. If all innocents are cleared, the
///              last one standing is flagged by elimination.
// ---------------------------------------------------------------------------
function scr_case_recompute() {
    if (!variable_global_exists("case_suspects")) return;
    var _sus = global.case_suspects;
    var _ev  = global.case_evidence;
    var _ns  = array_length(_sus);
    var _ne  = array_length(_ev);

    for (var _s = 0; _s < _ns; _s++) {
        var _cleared = false;
        var _impl    = false;
        for (var _e = 0; _e < _ne; _e++) {
            if (!_ev[_e].found) continue;
            if (_ev[_e].clears    == _s) _cleared = true;
            if (_ev[_e].implicates == _s) _impl    = true;
        }
        _sus[_s].status = _cleared ? 1 : (_impl ? 2 : 0);
        if (variable_struct_exists(_sus[_s], "accused_wrong") && _sus[_s].accused_wrong) _sus[_s].status = 1;
    }

    var _left = 0;
    var _left_idx = -1;
    for (var _s2 = 0; _s2 < _ns; _s2++) {
        if (_sus[_s2].status != 1) { _left++; _left_idx = _s2; }
    }
    if (_left == 1 && _left_idx >= 0) _sus[_left_idx].status = 2;
}


// ---------------------------------------------------------------------------
/// @function scr_log_evidence(_idx)
/// @description Logs evidence piece _idx into the case file. Returns true if it was new.
// ---------------------------------------------------------------------------
function scr_log_evidence(_idx) {
    if (!variable_global_exists("case_evidence")) return false;
    if (_idx < 0 || _idx >= array_length(global.case_evidence)) return false;
    if (global.case_evidence[_idx].found) return false;
    global.case_evidence[_idx].found = true;
    global.evidence_found++;
    scr_case_recompute();
    return true;
}


// ---------------------------------------------------------------------------
/// @function scr_npc_commit_clue(_prop_id)
/// @description Invoked when the player selects "Ask about..." during an NPC
///              dialogue so clues/evidence are only logged when asked.
// ---------------------------------------------------------------------------
function scr_npc_commit_clue(_prop_id) {
    if (!instance_exists(_prop_id)) return;
    var _has_key = (variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key);
    var _solved  = (variable_global_exists("incident_solved")        && global.incident_solved);

    // Only log Whodunit investigation clues during Phase 2 (after getting the Key Vault Cipher Key)
    if (!_has_key || _solved) return;

    if (_prop_id.evidence_idx >= 0) {
        _prop_id.talked_once = true;
        if (scr_log_evidence(_prop_id.evidence_idx)) {
            var _ep = audio_play_sound(snd_correct_ping, 6, false);
            audio_sound_gain(_ep, 0.45, 0);
        }
    } else {
        _prop_id.talked_once = true;
    }
}


// ---------------------------------------------------------------------------
/// @function scr_case_pick_pc(_pool, _avoid_x, _avoid_y, _min_dist)
/// @description Removes & returns a PC from _pool that is at least _min_dist px
///              from the avoid point (falls back to any). Returns noone if empty.
// ---------------------------------------------------------------------------
function scr_case_pick_pc(_pool, _avoid_x, _avoid_y, _min_dist) {
    var _n = array_length(_pool);
    if (_n <= 0) return noone;
    if (_min_dist > 0) {
        for (var _i = _n - 1; _i >= 0; _i--) {
            var _pc = _pool[_i];
            if (instance_exists(_pc) && point_distance(_pc.x, _pc.y, _avoid_x, _avoid_y) >= _min_dist) {
                array_delete(_pool, _i, 1);
                return _pc;
            }
        }
    }
    return array_pop(_pool);
}


// ---------------------------------------------------------------------------
/// @function scr_init_case_dossier(_case, _floor)
/// @description Builds this floor's whodunit: a shuffled suspect list (the culprit is
///              Patient Zero, the desk the hacker used as an entry point), the
///              evidence trail that clears innocents / implicates the culprit,
///              and shuffled attack-vector choices.
///              Floors 1-3: 2 suspects, 4-7: 3 suspects, 8-10: 4 suspects (+red herring).
// ---------------------------------------------------------------------------
function scr_init_case_dossier(_case, _floor) {
    var _n_susp = (_floor <= 3) ? 2 : ((_floor <= 7) ? 3 : 4);
    var _roster = ["Dave Miller", "Karen Jenkins", "Frank Castle", "Marcus Vance", "Bob Higgins",
                   "Chloe Rivera", "Greg Vance", "Sarah Connor", "Toby Flend", "Alice Cooper"];

    // --- Build suspect list: culprit first, then innocents (padded from roster) ---
    var _names = [_case.suspects[0]];
    for (var _k = 1; _k < array_length(_case.suspects) && array_length(_names) < _n_susp; _k++) {
        array_push(_names, _case.suspects[_k]);
    }
    var _guard = 0;
    while (array_length(_names) < _n_susp && _guard < 60) {
        _guard++;
        var _cand  = _roster[irandom(array_length(_roster) - 1)];
        var _cdept = scr_case_dept(_cand);
        var _dup   = false;
        for (var _d = 0; _d < array_length(_names); _d++) {
            if (scr_case_dept(_names[_d]) == _cdept) _dup = true;
        }
        if (!_dup) array_push(_names, _cand);
    }

    var _sus = [];
    for (var _i = 0; _i < array_length(_names); _i++) {
        array_push(_sus, {
            name:      _names[_i],
            dept:      scr_case_dept(_names[_i]),
            nameplate: scr_case_nameplate(_names[_i]),
            is_culprit: (_i == 0),
            status:    0
        });
    }

    // --- Shuffle suspects, then find the culprit ---
    for (var _a = array_length(_sus) - 1; _a > 0; _a--) {
        var _b = irandom(_a);
        var _t = _sus[_a];
        _sus[_a] = _sus[_b];
        _sus[_b] = _t;
    }
    var _cul = 0;
    for (var _c = 0; _c < array_length(_sus); _c++) {
        if (_sus[_c].is_culprit) _cul = _c;
    }

    // --- Evidence trail ---
    var _hours   = [9, 10, 11, 12, 13, 14, 15, 16, 8, 17];
    var _cidx    = variable_global_exists("floor_case_index") ? global.floor_case_index : 0;
    var _hr      = _hours[((_cidx mod 10) + 10) mod 10];
    var _t_str   = ((_hr < 10) ? "0" : "") + string(_hr) + ":20";
    var _tb_str  = ((_hr - 1 < 10) ? "0" : "") + string(_hr - 1) + ":45";

    var _how_label = "Suspicious activity detected";
    var _how_desc  = "";
    if (variable_struct_exists(_case, "desktop_items")) {
        for (var _di = 0; _di < array_length(_case.desktop_items); _di++) {
            if (_case.desktop_items[_di].is_breach) {
                _how_label = _case.desktop_items[_di].label;
                _how_desc  = _case.desktop_items[_di].desc;
            }
        }
    }

    var _ev = [];
    var _inn0 = (_cul == 0) ? 1 : 0;
    var _inn0_nm = _sus[_inn0].name;

    // =========================================================================
    // LEVEL 1 — BASIC TIP (Found on a semi-informed Coworker NPC or Memo)
    // =========================================================================
    array_push(_ev, {
        tier: 1,
        type: "lead",
        text: "[LVL 1: BASIC TIP] Heard the breach alarm start from the " + _sus[_cul].dept + " office around " + _t_str + ". Also, " + _inn0_nm + " was away from their desk!",
        npc_speech: "I heard the breach alarm start over in the " + _sus[_cul].dept + " office around " + _t_str + ", and I'm pretty sure " + _inn0_nm + " had already stepped away from their desk.",
        implicates: -1, clears: -1, suspect_desk_idx: -1, found: false
    });

    // =========================================================================
    // LEVEL 2 — SOLID CLUES (Found on Open-Office PCs & Witness NPCs)
    // =========================================================================
    array_push(_ev, {
        tier: 2,
        type: "log",
        text: "[LVL 2: SOLID CLUE] Security Alert (" + _t_str + "): The hack started from a computer inside the " + _sus[_cul].dept + " department!",
        implicates: _cul, clears: -1, suspect_desk_idx: -1, found: false
    });

    var _alibi_n = 0;
    for (var _s = 0; _s < array_length(_sus); _s++) {
        if (_s == _cul) continue;
        var _nm = _sus[_s].name;
        var _dp = _sus[_s].dept;
        var _np = _sus[_s].nameplate;
        var _txt = "";
        var _npc_line = "";
        switch (_alibi_n mod 3) {
            case 0:
                _txt      = "[LVL 2: SOLID CLUE] Coworker Alibi: '" + _nm + " (" + _dp + ") was on a video call with me at " + _t_str + " and never touched Desk " + _np + "!' -> Means " + _nm + " is innocent.";
                _npc_line = "I was on a video call with " + _nm + " right when the alarm went off at " + _t_str + "—they didn't touch their computer at all!";
                break;
            case 1:
                _txt      = "[LVL 2: SOLID CLUE] Coworker Alibi: 'I saw " + _nm + " (" + _dp + ") leave the building at " + _tb_str + " before the " + _t_str + " hack even started!' -> Means " + _nm + " is innocent.";
                _npc_line = "It couldn't have been " + _nm + "—I literally saw them walk out of the building at " + _tb_str + ", before the hack even started at " + _t_str + ".";
                break;
            default:
                _txt      = "[LVL 2: SOLID CLUE] Coworker Alibi: '" + _nm + " (" + _dp + ") was eating lunch with me in the cafeteria when the alarm went off at " + _t_str + "!' -> Means " + _nm + " is innocent.";
                _npc_line = "No way it was " + _nm + "! We were both downstairs eating lunch in the cafeteria when the alarm went off at " + _t_str + ".";
                break;
        }
        array_push(_ev, { tier: 2, type: "witness", text: _txt, npc_speech: _npc_line, implicates: -1, clears: _s, suspect_desk_idx: -1, found: false });
        _alibi_n++;
    }

    // =========================================================================
    // LEVEL 3 — CRITICAL PROOF (Found directly on Suspect Desk Terminals!)
    // =========================================================================
    for (var _sd = 0; _sd < array_length(_sus); _sd++) {
        if (_sd == _cul) {
            array_push(_ev, {
                tier: 3,
                type: "critical",
                text: "[LVL 3: CRITICAL PROOF] Desk " + _sus[_cul].nameplate + " (" + _sus[_cul].name + "): ACCIDENTAL BREACH ENTRY POINT! " + _how_label + " — " + _how_desc,
                implicates: _cul, clears: -1, suspect_desk_idx: _cul, found: false
            });
        } else {
            array_push(_ev, {
                tier: 3,
                type: "critical",
                text: "[LVL 3: CRITICAL PROOF] Desk " + _sus[_sd].nameplate + " (" + _sus[_sd].name + "): VPN was ON, unique password used, and PC was locked since " + _tb_str + ". All safety habits followed! -> Means " + _sus[_sd].name + " is clear.",
                implicates: -1, clears: _sd, suspect_desk_idx: _sd, found: false
            });
        }
    }

    // Shuffle evidence order so alibis and the log are not always found in the same order
    for (var _x = array_length(_ev) - 1; _x > 0; _x--) {
        var _y = irandom(_x);
        var _tmp = _ev[_x];
        _ev[_x] = _ev[_y];
        _ev[_y] = _tmp;
    }

    // --- Shuffled attack vectors ---
    var _vec_src = _case.vectors;
    var _vec_ok  = _case.correct_vector_idx;
    var _order   = [];
    for (var _v = 0; _v < array_length(_vec_src); _v++) array_push(_order, _v);
    for (var _o = array_length(_order) - 1; _o > 0; _o--) {
        var _p = irandom(_o);
        var _q = _order[_o];
        _order[_o] = _order[_p];
        _order[_p] = _q;
    }
    var _vecs = [];
    var _vec_correct = 0;
    for (var _w = 0; _w < array_length(_order); _w++) {
        array_push(_vecs, _vec_src[_order[_w]]);
        if (_order[_w] == _vec_ok) _vec_correct = _w;
    }

    // --- Shuffled safety fixes (Step 3 of Case Board accusation) ---
    var _fix_src = variable_struct_exists(_case, "fixes") ? _case.fixes : [
        _case.prevention_rule,
        "Ignore the security alert and keep using the same settings",
        "Turn off the computer's Firewall and Antivirus protection"
    ];
    var _fix_ok    = variable_struct_exists(_case, "correct_fix_idx") ? _case.correct_fix_idx : 0;
    var _fix_order = [];
    for (var _f = 0; _f < array_length(_fix_src); _f++) array_push(_fix_order, _f);
    for (var _fo = array_length(_fix_order) - 1; _fo > 0; _fo--) {
        var _fp = irandom(_fo);
        var _fq = _fix_order[_fo];
        _fix_order[_fo] = _fix_order[_fp];
        _fix_order[_fp] = _fq;
    }
    var _fixes = [];
    var _fix_correct = 0;
    for (var _fw = 0; _fw < array_length(_fix_order); _fw++) {
        array_push(_fixes, _fix_src[_fix_order[_fw]]);
        if (_fix_order[_fw] == _fix_ok) _fix_correct = _fw;
    }

    global.case_suspects          = _sus;
    global.case_culprit_idx       = _cul;
    global.case_evidence          = _ev;
    global.evidence_found         = 0;
    global.evidence_needed        = array_length(_ev);
    global.case_vectors           = _vecs;
    global.case_vector_correct    = _vec_correct;
    global.case_fixes             = _fixes;
    global.case_fix_correct       = _fix_correct;
    global.case_wrong_accusations = 0;
    global.case_culprit_confirmed = false;
    global.case_vector_confirmed  = false;
    global.pc_screen_mode         = 0;
    scr_case_recompute();
}
