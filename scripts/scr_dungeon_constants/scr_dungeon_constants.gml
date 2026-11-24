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
            { label: "Network: Connected to 'Free_Cafe_Guest_WiFi' (VPN: OFF)", is_breach: true,  desc: "David forgot to turn on his VPN on free public Wi-Fi, so hackers on the same network saw our secret Caesar shift number!" },
            { label: "Memo: Scheduled Key Rotation for Q3",                     is_breach: false, desc: "Normal security policy reminder to rotate employee keys." },
            { label: "Report: Firewall Packet Inspection Log",                  is_breach: false, desc: "Normal inbound traffic inspection." }
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
            artifact_header: "CAPTURED WI-FI SESSION:  SSID = 'BeanScene_Cafe_Free_Guest' (Security: OPEN)",
            artifact_body:   "VPN STATUS: Disconnected  |  TRAFFIC: Synced 'floor_caesar_shift_config.json' over local Wi-Fi",
            plain_summary:   "PLAIN ENGLISH: An employee sent our secret cipher key file over free coffee-shop Wi-Fi with no password and their VPN privacy shield turned OFF.",
            scanner_note:    "FORENSIC GUIDE: Inspect the Wi-Fi security type ('OPEN') and whether an encrypted VPN tunnel was active during the file sync!",
            prompt:          "Analyze this network log—what security mistake allowed an attacker in the cafe to intercept the Caesar Key?",
            options: [
                "Syncing sensitive data over an OPEN public Wi-Fi network while the encrypted VPN was Disconnected",
                "Public Wi-Fi is automatically encrypted as long as the Wi-Fi signal strength is 100%",
                "Using a '.json' configuration file instead of a '.txt' file over a corporate VPN"
            ],
            correct_idx: 0,
            explain_win: "SPOT ON! Open public Wi-Fi isn't encrypted—always turn on a VPN so snoops on the same network can't read your traffic!"
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
                { label: "File: '/Public_Shared_Drive/vigenere_keyword_backup.txt' (Access: Everyone)", is_breach: true,  desc: "David was afraid of forgetting the Vigenere keyword, so he typed it into an unlocked public folder where hackers found it!" },
                { label: "Memo: Vigenere Table Matrix Reference",                                       is_breach: false, desc: "26x26 Caesar shift grid for manual decryption." },
                { label: "Notice: Password Hygiene Guidelines",                                         is_breach: false, desc: "Standard company password security memo." }
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
                artifact_header: "CAPTURED FILE PROPERTIES:  Path = /Company_Guest_Share/floor_vigenere_key.txt",
                artifact_body:   "ENCRYPTION: None (Plain Text)  |  SHARE ACCESS: Guest_Network (Read / Write Allowed)",
                plain_summary:   "PLAIN ENGLISH: Someone saved the floor's secret keyword inside an unlocked 'Guest' folder where anyone on the guest network could open and read it.",
                scanner_note:    "FORENSIC GUIDE: Check the file's Encryption setting and who has Share Access to '/Company_Guest_Share/'!",
                prompt:          "Analyze this file audit—why were attackers able to steal the floor's Vigenere Keyword without hacking a password?",
                options: [
                    "The secret keyword was saved as an unencrypted plain-text '.txt' file inside a Guest-accessible shared folder",
                    "Plain-text password files are safe on shared drives as long as you don't put the word 'password' in the filename",
                    "The Vigenere cipher used a 3-letter keyword instead of a single Caesar shift number"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Never store passwords or cipher keywords in plain-text shared folders—use an encrypted Password Manager!"
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
                { label: "Config: 'Door_Lock_Mode = ATBASH_MIRROR (Secret_Key: NONE)'", is_breach: true,  desc: "David tested the doors with an Atbash mirror cipher (A<->Z) and forgot that Atbash has NO secret password—anyone can flip it back!" },
                { label: "Doc: Ancient Hebrew Cipher History",                          is_breach: false, desc: "Historical document on Biblical monoalphabetic ciphers." },
                { label: "Memo: Terminal Maintenance Schedule",                          is_breach: false, desc: "Routine cleaning and dusting for server racks." }
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
                artifact_header: "CAPTURED LOCK DIAGNOSTIC:  Cipher_Algorithm = ATBASH_REFLECT (A<->Z)",
                artifact_body:   "KEY PARAMETER: None (Fixed Rule: Output = 25 - Input)  |  AUTH_REQUIRED: False",
                plain_summary:   "PLAIN ENGLISH: This lock just flips the alphabet backwards (A<->Z) with NO secret password or key—so anyone who knows the trick can unlock it.",
                scanner_note:    "FORENSIC GUIDE: Check the 'KEY PARAMETER' field—does Atbash use a secret key, or does it always use the exact same A<->Z flip?",
                prompt:          "Analyze this door lock config—what cryptographic flaw let intruders decode the lock without a key?",
                options: [
                    "Atbash has NO secret key (Key Parameter: None)—anyone who recognizes the A<->Z mirror rule can reverse it immediately",
                    "Hiding the cipher name ('Security by Obscurity') is just as strong as using a secret password key",
                    "Flipping a message with Atbash twice in a row makes it twice as hard for computers to decrypt"
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
                { label: "Email: 'URGENT: Overdue Invoice' (From: support@skipj4ck-verify.net)", is_breach: true,  desc: "Dave was rushing before lunch and clicked an 'URGENT: Overdue Invoice' link without noticing the sender's domain ('skipj4ck-verify.net') was fake (Phishing)!" },
                { label: "Email: 'Weekly Shipping Schedule' (From: dispatch@skipjack.com)",      is_breach: false, desc: "From dispatch@skipjack.com - standard logistics spreadsheet." },
                { label: "Email: 'Warehouse Coffee Machine Repaired' (From: facilities@skipjack.com)", is_breach: false, desc: "Office announcement from building maintenance." }
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
                artifact_header: "CAPTURED INBOX MESSAGE:  From: support@skipj4ck-login-verify.net  |  Subject: URGENT INVOICE!",
                artifact_body:   "BODY: 'Account suspension in 10 mins! Sign in at https://skipj4ck-login-verify.net/auth to keep access.'",
                plain_summary:   "PLAIN ENGLISH: This scary '10-minute deadline' email comes from a fake misspelled address ('skipj4ck' with a '4' instead of 'skipjack.com').",
                scanner_note:    "FORENSIC GUIDE: Compare the sender domain ('skipj4ck-login-verify.net') against our official domain ('skipjack.com') and note the 10-minute panic timer!",
                prompt:          "Analyze this email—how can you tell it is a Phishing trap rather than a real IT notice?",
                options: [
                    "It uses a look-alike domain ('skipj4ck') and artificial '10-minute' urgency to trick you into typing your password",
                    "The link starts with 'https://', which guarantees the website is owned by your real company",
                    "Any email marked 'URGENT' in the subject line is automatically verified by the mail server"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Even fake Phishing sites can use 'https://'—always check the exact domain spelling ('skipj4ck') and ignore panic timers!"
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
                { label: "Download: 'Free_PDF_Helper_Pro.exe' (Source: mega-freeware-dl.biz)", is_breach: true,  desc: "Karen downloaded a free PDF tool from a random website to finish her HR forms faster—not realizing a Trojan virus was hiding inside!" },
                { label: "Doc: 'Benefits Enrollment Form 2026.docx'",                          is_breach: false, desc: "Standard company insurance policy documentation." },
                { label: "Memo: 'Intern Babysitting Shift Rota'",                              is_breach: false, desc: "Shift schedule for supervising the intern ward." }
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
                artifact_header: "CAPTURED INSTALLER PROMPT:  File = 'Free_PDF_Helper_Pro.exe'  |  Source: mega-free-tools.biz",
                artifact_body:   "DIGITAL SIGNATURE: None (Unknown Publisher)  |  PERMISSIONS REQUESTED: Full System & Network Access",
                plain_summary:   "PLAIN ENGLISH: A 'free PDF tool' from a random website has no verified creator and is secretly asking for full control of the computer and internet.",
                scanner_note:    "FORENSIC GUIDE: Check the installer's Digital Signature ('Unknown Publisher'), download site, and why a simple PDF tool wants Full Network Access!",
                prompt:          "Analyze this installer prompt—what warning sign reveals this 'free utility' is likely a Trojan Horse?",
                options: [
                    "It is an unsigned '.exe' from an unofficial third-party site requesting Full System & Network Access",
                    "Any program with 'Pro' or 'Helper' in its filename is verified safe by Windows automatically",
                    "Running an unknown '.exe' as Administrator prevents hidden background scripts from executing"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Trojans disguise themselves as useful free utilities—always check for a verified publisher and official source!"
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
                { label: "System Setting: 'Inbound Network Firewall = OFF (Paused for video call)'", is_breach: true,  desc: "Bob switched off his Firewall for 5 minutes because his video call was lagging, and accidentally forgot to turn it back on!" },
                { label: "Draft: 'New Product Press Release'",                                       is_breach: false, desc: "Marketing copy for the upcoming Skipjack cipher tool." },
                { label: "Bookmark: 'Social Media Analytics Dashboard'",                             is_breach: false, desc: "Official marketing metrics page." }
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
                artifact_header: "CAPTURED NETWORK SHIELD STATUS:  Inbound_Packet_Filter (FIREWALL) = OFF",
                artifact_body:   "PORT POLICY: Accept All Incoming Connections (Ports 1-65535 Open)  |  UPTIME: Disabled for 3 hrs",
                plain_summary:   "PLAIN ENGLISH: The computer's digital security guard (Firewall) was switched OFF for 3 hours, leaving every digital door wide open to outside hackers.",
                scanner_note:    "FORENSIC GUIDE: Look at the 'PORT POLICY' when the Firewall is turned OFF—every network port is left open to external scanners!",
                prompt:          "Analyze this security status—what risk was created when the user turned off the Firewall to troubleshoot video lag?",
                options: [
                    "All incoming network ports were left wide open without a traffic barrier to block unauthorized outside connections",
                    "Turning off the Firewall only affects video streaming apps and keeps all other network ports locked",
                    "Disabling the Firewall doubles Wi-Fi download speed without changing computer security"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Your Firewall filters incoming traffic across all ports—turning it off leaves the system exposed to automated attacks!"
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
                { label: "Device Config: 'Smart_Printers_&_Lights_Setup (Login: admin / Pass: 1234)'", is_breach: true,  desc: "Chloe plugged in the new office smart printers and lights in a rush and forgot to change their factory 'admin / 1234' password!" },
                { label: "Log: 'Breakroom Thermostat Schedule'",                                       is_breach: false, desc: "Normal AC settings for the 3rd floor." },
                { label: "Notice: 'Elevator Maintenance Due'",                                         is_breach: false, desc: "Routine building service log." }
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
                artifact_header: "CAPTURED SMART DEVICE CONFIG:  240 Wi-Fi Printers & Smart Lights Online",
                artifact_body:   "REMOTE ADMIN PORT: Enabled  |  AUTH CREDENTIALS: User = 'admin' / Pass = '1234' (Factory Preset)",
                plain_summary:   "PLAIN ENGLISH: 240 smart printers and lights were plugged into the internet still using their factory 'admin / 1234' password that anyone can guess.",
                scanner_note:    "FORENSIC GUIDE: Inspect the 'AUTH CREDENTIALS' on these 240 network-connected smart devices—were the factory presets ever changed?",
                prompt:          "Analyze this device configuration—how were attackers able to hijack all 240 smart devices at once into a Botnet?",
                options: [
                    "The devices were left on their well-known factory-default login ('admin / 1234') with Remote Admin enabled",
                    "Smart printers and Wi-Fi lightbulbs cannot be hacked because they don't have keyboards or monitors",
                    "Leaving all 240 devices on '1234' is safe as long as they are inside an office building"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Automated Botnet scanners test factory passwords like 'admin / 1234' across thousands of smart devices per second!"
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
                { label: "Browser History: 'Clicked ALLOW on Pop-Up: Browser_Update_Patch.exe'", is_breach: true,  desc: "Greg accidentally clicked 'Allow' on a flashing browser pop-up ad, which silently installed Spyware that recorded his keyboard!" },
                { label: "Sheet: 'Q2 Tax Returns.xlsx'",                                         is_breach: false, desc: "Quarterly accounting spreadsheet." },
                { label: "Receipt: 'Office Supplies Order #401'",                                is_breach: false, desc: "Purchased printer toner and pens." }
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
                artifact_header: "CAPTURED WEB POP-UP BANNER:  Origin = 'ad-server.free-coupons-daily.net'",
                artifact_body:   "BANNER TEXT: 'WARNING: Your Browser Is Out of Date! Click [ALLOW] to install Browser_Security_Fix.exe'",
                plain_summary:   "PLAIN ENGLISH: A coupon website's pop-up ad is pretending to be a 'Browser Security Update' to trick the user into installing a password-stealing program.",
                scanner_note:    "FORENSIC GUIDE: Check the Origin of the update alert ('ad-server.free-coupons-daily.net')—do real browser updates come from website ad banners?",
                prompt:          "Analyze this browser alert—why did clicking '[ALLOW]' infect the PC with keylogging Spyware?",
                options: [
                    "The update prompt came from a third-party website ad banner ('ad-server...') rather than the browser's built-in Settings menu",
                    "Any pop-up banner that says 'Security Fix' comes directly from your computer's operating system",
                    "Spyware can only record passwords if your webcam light is turned on"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Real browser and OS updates never appear as website pop-up ads—fake update banners are a classic Spyware trap!"
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
                { label: "External Drive: 'Mounted USB Drive [FOUND_IN_PARKING_LOT] -> Ran Owner_Info.scr.exe'", is_breach: true,  desc: "Marcus found a lost USB drive outside and plugged it into his work PC just to see whose name was on it—accidentally launching Malware!" },
                { label: "Code: 'skipjack_core.c (Clean Git Commit)'",                                           is_breach: false, desc: "Normal source code repository checkout." },
                { label: "Doc: 'API Documentation v2.1'",                                                        is_breach: false, desc: "Internal developer documentation." }
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
                artifact_header: "CAPTURED HARDWARE EVENT:  USB Mass Storage Device Connected (Volume: 'LOST_DRIVE')",
                artifact_body:   "FILE OPENED: 'If_Found_Read_Me.pdf.exe'  |  PROCESS SPAWNED: cmd.exe /c powershell - hidden",
                plain_summary:   "PLAIN ENGLISH: Someone plugged in a 'lost' USB drive found outside and opened a file pretending to be a PDF that actually ends in '.exe' (a hidden program).",
                scanner_note:    "FORENSIC GUIDE: Look closely at the double file extension ('If_Found_Read_Me.pdf.exe') and the hidden PowerShell process it launched from the found USB!",
                prompt:          "Analyze this USB event log—how did plugging in a 'lost' flash drive infect the workstation with Malware?",
                options: [
                    "Plugging in the unknown USB and opening 'If_Found_Read_Me.pdf.exe' executed a disguised '.exe' Malware script",
                    "A file ending in '.pdf.exe' is a harmless PDF document that cannot run code",
                    "USB flash drives found outside are safe to inspect on a work PC as long as you unplug them within 30 seconds"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Attackers bait 'lost' USB drives and use double extensions ('.pdf.exe') to trick helpful people into launching Malware!"
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
                { label: "Sent Email: 'Re: Urgent Access Code' (To: 'Company CEO' <ceo.task88@free-mail-host.org>)", is_breach: true,  desc: "Sarah replied to an email whose display name said 'Company CEO' without noticing the actual email address was a fake external account (Spoofing)!" },
                { label: "Contract: 'Vendor NDA Agreement'",                                                         is_breach: false, desc: "Standard mutual non-disclosure contract." },
                { label: "Email: 'Reminder: Compliance Training Friday'",                                            is_breach: false, desc: "Legitimate HR compliance notification." }
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
                artifact_header: "CAPTURED MESSAGE HEADER:  From: \"Company CEO (Director)\" <exec.office.task99@free-mail-host.org>",
                artifact_body:   "REPLY-TO: exec.office.task99@free-mail-host.org  |  BODY: 'I'm in a board meeting—text me the floor override code now.'",
                plain_summary:   "PLAIN ENGLISH: The sender typed 'Company CEO' as their display name, but their real email address inside '< >' is a random free email account.",
                scanner_note:    "FORENSIC GUIDE: Compare the Display Name in quotes (\"Company CEO\") against the actual email address inside the '< >' brackets!",
                prompt:          "Analyze this email header—how can you tell the sender's identity is Spoofed?",
                options: [
                    "The display name says 'Company CEO', but the actual address inside '< >' is an unrelated external free-mail account",
                    "Email apps verify display names automatically, so no one can type 'Company CEO' unless they own the account",
                    "Because the sender says they are in a board meeting, you should send the security code without calling to verify"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Anyone can set their display name to 'Company CEO'—always inspect the real '<address>' and verify via a known phone number!"
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
                { label: "Account Audit: 'Work Login Password = Same as Leaked 2024 Gaming Forum Account'", is_breach: true,  desc: "Toby used the exact same password ('Toby123!') on his work PC as on an old gaming forum that got hacked, letting attackers lock his files for Ransom!" },
                { label: "Pitch: 'Q3 Enterprise Sales Deck.pptx'",                                          is_breach: false, desc: "Client presentation slides." },
                { label: "Contact: 'Lead List - West Coast'",                                               is_breach: false, desc: "Normal sales prospect directory." }
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
                artifact_header: "CAPTURED BREACH & EXTORTION REPORT:  User = tflend@skipjack.com",
                artifact_body:   "LOGIN METHOD: Valid Password ('Toby123!' — matched public breach dump from 'RetroGamesForum.net')  |  FILES: Encrypted (.LOCKED)",
                plain_summary:   "PLAIN ENGLISH: Hackers stole Toby's password from an old gaming website and used that exact same password to log into his work PC and lock his files.",
                scanner_note:    "FORENSIC GUIDE: Look at how the attacker logged in ('Valid Password matched public breach dump from RetroGamesForum.net') before deploying Ransomware!",
                prompt:          "Analyze this incident report—how did the Ransomware attackers get into Toby's work account on the first try?",
                options: [
                    "Toby reused the exact same password ('Toby123!') on a public gaming forum and his work computer",
                    "A breach on an outside gaming website can never affect your work account if the two sites have different domain names",
                    "Paying the hacker's ransom demand is the only way to protect files because backups cannot restore encrypted folders"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Credential stuffing attacks test leaked passwords from old websites on work/email accounts—always use unique passwords and offline backups!"
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
                { label: "Remote Config: 'Port_8080_Debug_Tunnel (Skip_Password_&_2FA = TRUE)'", is_breach: true,  desc: "Frank turned on a temporary 'skip-password' remote link while fixing a server from home and accidentally fell asleep before turning it off!" },
                { label: "Config: 'Nginx Reverse Proxy Config'",                                  is_breach: false, desc: "Normal web server routing configuration." },
                { label: "Log: 'System Uptime: 412 Days'",                                        is_breach: false, desc: "Standard Linux server uptime statistics." }
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
                artifact_header: "CAPTURED SERVER CONFIG:  Endpoint = '/admin_quick_maint' (Port 8080)",
                artifact_body:   "AUTH_CHECK: Bypassed (require_password = FALSE, require_2fa = FALSE)  |  STATUS: Active Overnight",
                plain_summary:   "PLAIN ENGLISH: An engineer created a late-night maintenance shortcut that completely turned off the password and 2FA login screens, and left it open overnight.",
                scanner_note:    "FORENSIC GUIDE: Inspect the 'AUTH_CHECK' settings on '/admin_quick_maint'—both password and 2FA verification were set to FALSE!",
                prompt:          "Analyze this server configuration—why did this maintenance shortcut act as a Backdoor for attackers?",
                options: [
                    "It disabled both password and 2FA checks ('require_password = FALSE') on an active external port overnight",
                    "Hidden maintenance URLs are safe without passwords because hackers only check the main login page",
                    "Turning off Two-Factor Authentication (2FA) overnight makes servers more secure against automated bots"
                ],
                correct_idx: 0,
                explain_win: "SPOT ON! Attackers scan all ports and endpoints—any shortcut that skips password and 2FA checks is an open Backdoor!"
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

    if (variable_global_exists("override_input_cooldown") && global.override_input_cooldown > 0) {
        global.override_input_cooldown--;
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
    if (variable_global_exists("demo_mode_active") && global.demo_mode_active) {
        if (!variable_global_exists("scrap_count") || global.scrap_count < 2) {
            global.scrap_count = 2;
        }
    }
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

    // One-time visual tutorial when opening the Power Breaker UI
    scr_ensure_tutorial_flags();
    if (!global.tut_seen_breaker) {
        global.tut_seen_breaker = true;
        global.visual_tut_kind  = "breaker";
    }
    if (global.visual_tut_kind == "breaker") {
        scr_draw_visual_mechanic_tutorial("breaker", _gui_w, _gui_h);
        if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)
            || keyboard_check_pressed(vk_escape) || mouse_check_button_pressed(mb_left))
        {
            if (keyboard_check_pressed(vk_escape)) {
                global.esc_block_frames = 2;
                keyboard_clear(vk_escape);
            }
            keyboard_clear(ord("E"));
            keyboard_clear(vk_enter);
            keyboard_clear(vk_space);
            global.visual_tut_kind = "";
            audio_play_sound(snd_button_click, 8, false);
        }
        return;
    }

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
    global.scrap_input_cooldown = 4;
    keyboard_clear(ord("R"));
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

    if (variable_global_exists("scrap_input_cooldown") && global.scrap_input_cooldown > 0) {
        global.scrap_input_cooldown--;
    }

    // DEMO SHORTCUT: Press Ctrl + P to auto-fill both Wrench Scrap slots (Caesar, Vigenere & Atbash)
    if (keyboard_check(vk_control) && keyboard_check_pressed(ord("P"))) {
        global.scrap_input[0] = string_char_at(global.scrap_target, 1);
        global.scrap_input[1] = string_char_at(global.scrap_target, 2);
        global.scrap_msg      = "";
        audio_play_sound(snd_correct_ping, 8, false);
    } else if (!keyboard_check(vk_control) && (!variable_global_exists("scrap_input_cooldown") || global.scrap_input_cooldown <= 0)) {
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

    // --- Evidence trail & per-suspect interactive Desktop Audit items ---
    var _hours   = [9, 10, 11, 12, 13, 14, 15, 16, 8, 17];
    var _cidx    = variable_global_exists("floor_case_index") ? global.floor_case_index : 0;
    var _hr      = _hours[((_cidx mod 10) + 10) mod 10];
    var _t_str   = ((_hr < 10) ? "0" : "") + string(_hr) + ":20";
    var _tb_str  = ((_hr - 1 < 10) ? "0" : "") + string(_hr - 1) + ":45";

    global.wrongful_audits = 0;
    var _rh_pool   = scr_get_benign_red_herring_pool();
    var _rh_offset = irandom(array_length(_rh_pool) - 1);

    for (var _sa = 0; _sa < array_length(_sus); _sa++) {
        _sus[_sa].audit_done            = false;
        _sus[_sa].wrongful_fine_applied = false;
        if (_sus[_sa].is_culprit && variable_struct_exists(_case, "desktop_items")) {
            var _c_items = [];
            for (var _ci2 = 0; _ci2 < array_length(_case.desktop_items); _ci2++) {
                var _src_it = _case.desktop_items[_ci2];
                var _risky  = (_src_it.is_breach == true);
                array_push(_c_items, {
                    label:          _src_it.label,
                    is_breach:      _risky,
                    is_risky:       _risky,
                    is_red_herring: false,
                    desc:           _src_it.desc,
                    audit_feedback: _risky
                        ? ("BREACH CONFIRMED: " + _src_it.desc)
                        : ("SAFE WORK ITEM: '" + _src_it.label + "' is normal work (" + _src_it.desc + "). Inspect the other items on this PC!")
                });
            }
            for (var _sh1 = array_length(_c_items) - 1; _sh1 > 0; _sh1--) {
                var _sh2  = irandom(_sh1);
                var _stmp = _c_items[_sh1];
                _c_items[_sh1] = _c_items[_sh2];
                _c_items[_sh2] = _stmp;
            }
            _sus[_sa].audit_items = _c_items;
        } else {
            var _rh_item = _rh_pool[(_sa + _rh_offset) mod array_length(_rh_pool)];
            var _inn_items = [
                {
                    label:          "Network: Corporate VPN Tunnel = CONNECTED & Firewall = ON",
                    is_breach:      false,
                    is_risky:       false,
                    is_red_herring: false,
                    desc:           "SAFE HABIT: Encrypted VPN tunnel and inbound Firewall are both active on " + _sus[_sa].name + "'s workstation.",
                    audit_feedback: "Audit Rejected: An active Corporate VPN tunnel and enabled Firewall are standard compliant security controls!"
                },
                {
                    label:          "Login: Encrypted Password Manager (Unique 16-Char Key + 2FA ON) & Locked at " + _tb_str,
                    is_breach:      false,
                    is_risky:       false,
                    is_red_herring: false,
                    desc:           "SAFE HABIT: " + _sus[_sa].name + " uses a unique password in an encrypted Password Manager with 2FA and locked their PC at " + _tb_str + ".",
                    audit_feedback: "Audit Rejected: Using a Password Manager with 2FA and locking the screen before leaving is compliant cyber hygiene!"
                },
                {
                    label:          _rh_item.label,
                    is_breach:      false,
                    is_risky:       false,
                    is_red_herring: true,
                    desc:           _rh_item.desc,
                    audit_feedback: _rh_item.audit_feedback
                }
            ];
            for (var _ish1 = array_length(_inn_items) - 1; _ish1 > 0; _ish1--) {
                var _ish2  = irandom(_ish1);
                var _istmp = _inn_items[_ish1];
                _inn_items[_ish1] = _inn_items[_ish2];
                _inn_items[_ish2] = _istmp;
            }
            _sus[_sa].audit_items = _inn_items;
        }
    }

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
    global.floor_scanned_terms    = [];
    global.case_cited_term        = undefined;
    global.policy_drawer_open     = false;
    global.policy_drawer_sel      = 0;
    global.policy_drawer_scroll   = 0;
    scr_auto_collect_floor_terms([_case.scenario, _case.hint, _case.takeaway]);
    scr_case_recompute();
}

// =============================================================================
// CYBERSECURITY GLOSSARY, CLICKABLE TERM SCANNER & QUICK-DEFINITION POPUP
// =============================================================================
function scr_init_cyber_glossary() {
    if (!variable_global_exists("codex_unlocked_terms") || !is_struct(global.codex_unlocked_terms)) {
        global.codex_unlocked_terms = {};
    }
    if (!variable_global_exists("codex_new_count")) {
        global.codex_new_count = 0;
    }
    if (!variable_global_exists("active_term_popup")) {
        global.active_term_popup = undefined;
    }
    if (!variable_global_exists("active_term_popup_just_new")) {
        global.active_term_popup_just_new = false;
    }
    if (!variable_global_exists("term_popup_block_frames")) {
        global.term_popup_block_frames = 0;
    }
    if (!variable_global_exists("term_popup_history") || !is_array(global.term_popup_history)) {
        global.term_popup_history = [];
    }
    if (variable_global_exists("cyber_glossary") && is_array(global.cyber_glossary) && array_length(global.cyber_glossary) > 0) {
        return;
    }

    global.cyber_branch_names = [
        "SOCIAL ENGINEERING",
        "IDENTITY & ACCESS",
        "MALWARE & ENDPOINTS",
        "NETWORK & PHYSICAL",
        "CRYPTOGRAPHY"
    ];

    global.cyber_glossary = [
        // ── BRANCH 0: SOCIAL ENGINEERING ─────────────────────────────────────
        {
            id: "phishing",
            term: "Phishing",
            branch_idx: 0,
            branch_name: "SOCIAL ENGINEERING",
            keywords: ["phish", "fake login", "urgent invoice", "payroll pdf", "suspicious email", "fake portal"],
            short_def: "Phishing is a scam where attackers send fake emails or messages pretending to be a trusted company, boss, or coworker to trick you into clicking a malicious link or typing your password.",
            deep_how: "Attackers craft messages with artificial urgency ('Account suspended in 2 hours!', 'Overdue invoice') to bypass careful thinking. Clicking the link takes you to a cloned login page that steals your credentials or downloads malware.",
            deep_real: "Over 80% of workplace breaches start with a single phishing email. Even one employee entering their password on a fake Microsoft or Payroll portal gives attackers an entry point into the whole office.",
            deep_defense: "Inspect the sender's actual email domain, hover over links before clicking, never enter passwords from an email link, and verify urgent requests through an official internal channel."
        },
        {
            id: "typosquatting",
            term: "Look-Alike Domain",
            branch_idx: 0,
            branch_name: "SOCIAL ENGINEERING",
            keywords: ["typosquat", "look-alike", "lookalike", "payr0ll", "skipj4ck", "misspelled domain", ".net", "fake domain"],
            short_def: "A look-alike domain (typosquatting) is a fake website address that swaps similar letters or numbers—like replacing 'o' with '0' (payr0ll) or '.com' with '.net'—to impersonate a real company.",
            deep_how: "Attackers register domains one character off from legitimate services (e.g. 'skipj4ck-hr.net' instead of 'skipjack.com'). At a quick glance, victims trust the URL and enter their login details.",
            deep_real: "In automated email clients, display names can say 'Skipjack HR' while the underlying address is '@skipj4ck-portal.com'. Look-alike domains are the #1 disguise used in credential-harvesting phishing.",
            deep_defense: "Read every character of a URL and sender address carefully. Bookmark official company login pages instead of clicking links inside emails."
        },
        {
            id: "pretexting",
            term: "Pretexting",
            branch_idx: 0,
            branch_name: "SOCIAL ENGINEERING",
            keywords: ["pretext", "impersonat", "fake story", "executive", "director", "urgent wire", "gift card"],
            short_def: "Pretexting is when an attacker invents a believable fake story or impersonates an authority figure (like an executive, HR, or auditor) to pressure an employee into breaking security rules.",
            deep_how: "Instead of hacking software, the attacker hacks human helpfulness and fear of authority. They research staff names online and claim an 'emergency' requires bypassing normal verification steps.",
            deep_real: "Common examples include 'CEO Fraud' (fake urgent wire-transfer or gift-card requests) or someone calling pretending to be an external auditor needing immediate file access.",
            deep_defense: "Never approve sensitive actions, password resets, or money transfers based solely on urgency or authority. Always verify via a second, trusted channel (call-back or in-person)."
        },
        {
            id: "vishing",
            term: "Vishing (Voice Phishing)",
            branch_idx: 0,
            branch_name: "SOCIAL ENGINEERING",
            keywords: ["vishing", "phone call", "caller id", "voice", "called", "spoofed number"],
            short_def: "Vishing (Voice Phishing) is a phone-based scam where attackers spoof Caller ID and impersonate IT, banks, or managers to talk victims into reading out passwords or 2FA codes.",
            deep_how: "Caller ID can be easily faked (spoofed) to display your company's real IT Helpdesk number. Once you answer, the scammer creates panic ('Your account is being hacked right now!') and asks for your 6-digit login code.",
            deep_real: "Real IT staff and banks NEVER need your password or your 6-digit SMS/Authenticator code to 'fix' or 'secure' your account. Sharing that code lets the attacker log in as you immediately.",
            deep_defense: "Hang up and dial the official internal Helpdesk extension yourself. Never read 2FA/OTP codes aloud to anyone over the phone."
        },
        {
            id: "tech_support_scam",
            term: "Tech-Support Scam",
            branch_idx: 0,
            branch_name: "SOCIAL ENGINEERING",
            keywords: ["tech-support", "tech support", "helpdesk", "popup", "unsolicited", "remote support"],
            short_def: "A tech-support scam uses fake 'VIRUS DETECTED!' popups or unsolicited IT calls to scare users into installing remote-control software that hands the computer over to attackers.",
            deep_how: "Full-screen browser popups play loud alarms and claim your PC is infected, displaying a fake support number. Calling the number connects you to a scammer who talks you into downloading remote access tools.",
            deep_real: "Once remote access is granted, attackers can copy sensitive files, install persistent backdoors, or demand payment for 'repairs' on a PC that was never infected in the first place.",
            deep_defense: "Close suspicious browser popups with Task Manager / Ctrl+W—never call numbers on screen. Only accept IT support through your organization's verified ticket system."
        },

        // ── BRANCH 1: IDENTITY & ACCESS ──────────────────────────────────────
        {
            id: "credential_stuffing",
            term: "Credential Stuffing",
            branch_idx: 1,
            branch_name: "IDENTITY & ACCESS",
            keywords: ["credential stuffing", "leaked database", "automated login", "bot login", "breached password"],
            short_def: "Credential stuffing is an automated attack where hackers take passwords leaked from one website breach and test them across thousands of other sites (like your work email or bank).",
            deep_how: "Bots load millions of username/password pairs from public dark-web leaks (e.g., an old gaming forum breach) and rapidly try logging into corporate portals, banks, and cloud apps.",
            deep_real: "Even if your company's servers were never hacked, reusing the same password from a breached hobby site lets bots walk straight into your work account on the first try.",
            deep_defense: "Use a completely unique password for every single account (managed by a Password Manager) and enable 2FA/MFA so a stolen password alone cannot log in."
        },
        {
            id: "password_reuse",
            term: "Password Reuse",
            branch_idx: 1,
            branch_name: "IDENTITY & ACCESS",
            keywords: ["reused", "same password", "password reuse", "gaming password", "shared password", "weak password"],
            short_def: "Password reuse means using the same (or slightly modified) password across multiple websites. If one small site gets hacked, attackers instantly have the key to your work and personal accounts.",
            deep_how: "Humans naturally reuse passwords because memorizing dozens of complex strings is hard. Attackers rely on this habit—compromise one low-security site, then unlock high-value corporate accounts.",
            deep_real: "Changing 'Spring2025!' to 'Spring2026!' is predictable and easily cracked by automated rules. Every reused password links the security of your workplace to the weakest website you ever signed up for.",
            deep_defense: "Never reuse work passwords on personal sites. Let a Password Manager generate random 16+ character passwords for every account."
        },
        {
            id: "password_manager",
            term: "Password Manager",
            branch_idx: 1,
            branch_name: "IDENTITY & ACCESS",
            keywords: ["password manager", "vault", "unique password", "autofill"],
            short_def: "A Password Manager is an encrypted digital vault that creates, stores, and auto-fills long, unique passwords for every website so you only have to remember one strong master password.",
            deep_how: "It generates random passwords (like 'k9#Vm2!qP8xL4@zR') for each account and encrypts them locally with strong cryptography. Bonus: it refuses to auto-fill on look-alike phishing domains!",
            deep_real: "Because a Password Manager matches the exact domain name before auto-filling, it protects against both password reuse AND typosquatting phishing pages.",
            deep_defense: "Use an approved Password Manager for all work and personal logins, protected by a long master passphrase and 2FA."
        },
        {
            id: "mfa_2fa",
            term: "2FA / MFA",
            branch_idx: 1,
            branch_name: "IDENTITY & ACCESS",
            keywords: ["2fa", "mfa", "two-factor", "multi-factor", "authenticator", "otp"],
            short_def: "Two-Factor / Multi-Factor Authentication (2FA/MFA) requires a second proof of identity—like a 6-digit code from an Authenticator App or a hardware key—in addition to your password.",
            deep_how: "Authentication relies on factors: Something You Know (password), Something You Have (phone/hardware token), and Something You Are (fingerprint/face). Combining at least two stops password-only attacks.",
            deep_real: "Microsoft and Google security studies show that enabling MFA blocks over 99% of automated account compromise attacks, even when the attacker already knows your password.",
            deep_defense: "Prefer Authenticator Apps or FIDO2 hardware keys over SMS text codes, and never approve login prompts you did not initiate."
        },
        {
            id: "mfa_fatigue",
            term: "MFA Push Bombing",
            branch_idx: 1,
            branch_name: "IDENTITY & ACCESS",
            keywords: ["push bombing", "mfa fatigue", "approve prompt", "login prompt", "repeated prompts", "approve"],
            short_def: "MFA Push Bombing (MFA Fatigue) is when an attacker who already has your password spams your phone with dozens of 'Approve Login?' notifications until you accidentally tap Approve just to make them stop.",
            deep_how: "If an organization uses simple 'Approve / Deny' push notifications, attackers run a script that triggers login prompts at 2 AM or during busy work hours, hoping the tired user hits 'Yes' out of annoyance.",
            deep_real: "Major tech breaches have occurred simply because an employee tapped 'Approve' on an unexpected MFA prompt after 20 minutes of nonstop buzzing.",
            deep_defense: "NEVER approve an MFA prompt you didn't just trigger yourself. Tap 'Deny / Report Fraud' and change your password immediately—unexpected prompts mean someone already has your password!"
        },
        {
            id: "oauth_permissions",
            term: "OAuth & App Permissions",
            branch_idx: 1,
            branch_name: "IDENTITY & ACCESS",
            keywords: ["oauth", "permissions", "sign in with", "read all files", "third-party app", "consent"],
            short_def: "OAuth lets you sign into third-party apps using your work or Google/Microsoft account—but granting broad permissions ('Read/Write all files & emails') hands attackers silent access without needing your password.",
            deep_how: "In an 'OAuth Consent Phishing' attack, a fake productivity plugin or browser extension asks you to click 'Allow' on a real login screen. Once approved, it receives an API token that bypasses MFA.",
            deep_real: "Even after you change your password, an approved malicious OAuth app can keep reading your inbox and cloud drive until an admin revokes its token.",
            deep_defense: "Always read the permission list before clicking 'Allow'. Only connect IT-approved apps and periodically revoke unused third-party app connections."
        },
        {
            id: "session_cookie",
            term: "Session Token / Cookie",
            branch_idx: 1,
            branch_name: "IDENTITY & ACCESS",
            keywords: ["session cookie", "session token", "cookies", "api token", "hijack"],
            short_def: "A Session Token or Cookie is a temporary digital pass stored by your browser after you log in, proving to the website that you are already authenticated so you don't have to re-type your password on every page.",
            deep_how: "If an attacker steals your active session cookie (via Packet Sniffing on unsecured Wi-Fi or a malicious browser extension), they can paste it into their own browser and impersonate you without needing your password or 2FA.",
            deep_real: "Session hijacking is one of the fastest ways attackers take over cloud email and corporate dashboards after a user connects to open Wi-Fi or installs unvetted extensions.",
            deep_defense: "Always use HTTPS websites, enable a VPN on public Wi-Fi, log out of shared devices, and avoid untrusted browser extensions."
        },

        // ── BRANCH 2: MALWARE & ENDPOINTS ────────────────────────────────────
        {
            id: "ransomware",
            term: "Ransomware",
            branch_idx: 2,
            branch_name: "MALWARE & ENDPOINTS",
            keywords: ["ransomware", "encrypt", "locked files", "ransom", ".locked"],
            short_def: "Ransomware is malicious software that scrambles (encrypts) all files on a computer or company network so nobody can open them, then demands payment to unlock them.",
            deep_how: "After sneaking in via phishing, an infected USB, or a fake update, ransomware quietly spreads across shared network drives and encrypts documents with a key only the attacker holds.",
            deep_real: "Ransomware can halt hospitals, schools, and businesses for days. Paying the ransom doesn't guarantee your files back and funds future attacks.",
            deep_defense: "Keep offline/immutable backups (the 3-2-1 backup rule), never run unverified attachments or fake updates, and disconnect an infected PC from the network immediately."
        },
        {
            id: "rat_malware",
            term: "Remote Access Trojan (RAT)",
            branch_idx: 2,
            branch_name: "MALWARE & ENDPOINTS",
            keywords: ["rat", "remote access", "backdoor", "trojan", "keylog", "remote control"],
            short_def: "A Remote Access Trojan (RAT) is malware disguised as a harmless file or tool that secretly gives an attacker full remote control over your screen, keyboard, and files.",
            deep_how: "Unlike legitimate IT remote tools, a RAT hides in the background, logs keystrokes, captures screenshots, and opens an outbound connection so attackers bypass firewalls.",
            deep_real: "RATs often arrive disguised as 'Invoice_Final.exe', cracked software, or remote-support tools installed during a tech-support scam call.",
            deep_defense: "Only install software from official IT catalogs, watch for unknown background processes, and keep endpoint antivirus/EDR active."
        },
        {
            id: "firewall",
            term: "Firewall",
            branch_idx: 3,
            branch_name: "NETWORK & PHYSICAL",
            keywords: ["firewall", "port", "inbound traffic", "packet inspection"],
            short_def: "A Firewall is a network security barrier (software or hardware) that inspects incoming and outgoing data packets and blocks unauthorized connections based on strict security rules.",
            deep_how: "Think of a Firewall like a security guard at a building lobby: it checks every packet's source, destination, and port number, allowing safe corporate traffic through while dropping suspicious scans or unapproved remote access attempts.",
            deep_real: "Turning off your computer's Firewall—even briefly to 'fix Wi-Fi speed'—exposes open network ports directly to attackers on the same Wi-Fi network.",
            deep_defense: "Never disable your OS or corporate Firewall. Restrict open ports to only what is strictly required and pair with a VPN when working remotely."
        },
        {
            id: "https_tls",
            term: "HTTPS & TLS",
            branch_idx: 3,
            branch_name: "NETWORK & PHYSICAL",
            keywords: ["https", "tls", "padlock", "ssl"],
            short_def: "HTTPS (powered by TLS encryption) is the secure version of web browsing—shown by a padlock icon—that encrypts data traveling between your browser and a website so snoops cannot read it.",
            deep_how: "When you visit an HTTPS site, your browser uses Asymmetric cryptography during a TLS handshake to verify the site's identity certificate and agree on a fast Symmetric session key for the rest of your visit.",
            deep_real: "Without HTTPS (plain HTTP), passwords, messages, and session cookies travel in readable plaintext that anyone performing Packet Sniffing on public Wi-Fi can capture.",
            deep_defense: "Never enter passwords or payment info on plain HTTP sites without a padlock, and heed browser warnings about invalid TLS certificates."
        },
        {
            id: "usb_baiting",
            term: "USB Baiting & HID Injection",
            branch_idx: 2,
            branch_name: "MALWARE & ENDPOINTS",
            keywords: ["usb", "flash drive", "thumb drive", "hid", "rubber ducky", "lost drive"],
            short_def: "USB Baiting leaves 'lost' flash drives in parking lots or lobbies hoping someone plugs them in. Some look like storage drives but act as a fake keyboard (HID Injection) that types hack commands in milliseconds.",
            deep_how: "Even if AutoRun is disabled, a malicious USB (like a 'Rubber Ducky') tells Windows/Mac it is a USB keyboard and types hundreds of invisible terminal commands before you can react.",
            deep_real: "Plugging in an unknown USB 'just to see whose it is and return it' is a classic physical-to-digital breach vector.",
            deep_defense: "Never plug unknown or personal USB drives into a work computer. Hand found drives directly to Physical Security or IT."
        },
        {
            id: "malvertising",
            term: "Malvertising & Fake Updates",
            branch_idx: 2,
            branch_name: "MALWARE & ENDPOINTS",
            keywords: ["malvertising", "fake update", "browser update", "ad link", "sponsored", "installer"],
            short_def: "Malvertising uses paid search ads or fake 'Update Chrome/PDF Reader Now!' popups to trick users into downloading malware disguised as legitimate software installers.",
            deep_how: "Attackers buy top search-engine ad slots for popular tools (like Zoom, Teams, or Notepad++) or inject fake update banners into compromised websites, serving trojanized '.exe' / '.msi' files.",
            deep_real: "Real web browsers and corporate apps update automatically in the background or through your OS/IT Software Center—never via random website banners.",
            deep_defense: "Skip 'Sponsored' ad links when downloading software, use official vendor URLs or IT Software Center, and ignore popup update prompts."
        },
        {
            id: "shadow_it",
            term: "Shadow IT",
            branch_idx: 2,
            branch_name: "MALWARE & ENDPOINTS",
            keywords: ["shadow it", "unapproved", "personal cloud", "browser extension", "free converter"],
            short_def: "Shadow IT means using unapproved apps, free online file converters, or personal cloud drives for company work—bypassing IT security checks and exposing sensitive data.",
            deep_how: "Employees often install unvetted browser extensions or upload confidential PDFs to random 'Free PDF Merge' websites to save time, unknowingly handing company data to third-party servers.",
            deep_real: "Malicious browser extensions can read every page you visit, capture session cookies, and steal logins without triggering traditional antivirus.",
            deep_defense: "Use only IT-approved tools and extensions for company data. If you need a new tool, request an official security review."
        },
        {
            id: "antivirus_edr",
            term: "Antivirus & EDR",
            branch_idx: 2,
            branch_name: "MALWARE & ENDPOINTS",
            keywords: ["antivirus", "edr", "endpoint detection"],
            short_def: "Antivirus and Endpoint Detection & Response (EDR) are security tools running on computers and servers to spot, block, and isolate malware like Ransomware or Trojans before they spread.",
            deep_how: "Traditional Antivirus checks files against known malware signatures, while modern EDR watches live behavior—like a program suddenly encrypting hundreds of files or opening a hidden remote shell—and automatically quarantines the threat.",
            deep_real: "Disabling Antivirus/EDR to 'speed up' a PC or run an unverified installer removes the last safety net protecting an endpoint.",
            deep_defense: "Keep Antivirus and EDR enabled and updated on every device, and never bypass security warnings for downloaded executables."
        },

        // ── BRANCH 3: NETWORK & PHYSICAL ─────────────────────────────────────
        {
            id: "public_wifi",
            term: "Unsecured Public Wi-Fi",
            branch_idx: 3,
            branch_name: "NETWORK & PHYSICAL",
            keywords: ["public wi-fi", "public wifi", "coffee shop", "evil twin", "free_wifi", "hotspot", "open wi-fi"],
            short_def: "Unsecured public Wi-Fi (like coffee-shop or airport networks without a password) lets nearby attackers spy on unencrypted traffic or set up fake 'Evil Twin' hotspots with matching names.",
            deep_how: "An attacker sits in the same cafe with a laptop broadcasting 'Cafe_Guest_Free_WiFi'. Anyone who connects routes all their internet requests straight through the attacker's device.",
            deep_real: "Working on company dashboards over open Wi-Fi without a VPN exposes session tokens and data to anyone sitting a few tables away.",
            deep_defense: "Use your mobile hotspot or always turn ON your Corporate VPN before doing any work on public Wi-Fi."
        },
        {
            id: "packet_sniffing",
            term: "Packet Sniffing",
            branch_idx: 3,
            branch_name: "NETWORK & PHYSICAL",
            keywords: ["packet sniff", "sniffing", "intercept", "unencrypted traffic", "plaintext traffic"],
            short_def: "Packet sniffing is capturing and reading the small chunks of data ('packets') traveling over a network—like eavesdropping on a postcard sent without an envelope.",
            deep_how: "Tools like Wireshark or rogue Wi-Fi routers record every packet passing through a shared network. If the traffic isn't encrypted (HTTP instead of HTTPS, or no VPN), passwords and messages are readable in plain text.",
            deep_real: "On shared or open Wi-Fi, packet sniffing lets attackers hijack active login sessions (session cookies) even without knowing your password.",
            deep_defense: "Always verify HTTPS (padlock) on websites and keep an encrypted VPN enabled on untrusted networks."
        },
        {
            id: "vpn",
            term: "VPN (Encrypted Tunnel)",
            branch_idx: 3,
            branch_name: "NETWORK & PHYSICAL",
            keywords: ["vpn", "aes-256", "encrypted tunnel", "virtual private network"],
            short_def: "A Virtual Private Network (VPN) wraps all your internet traffic inside an encrypted tunnel (often using AES-256 encryption) so hackers on public Wi-Fi cannot read or tamper with it.",
            deep_how: "Before data leaves your laptop, the VPN client encrypts it and sends it straight to your company's secure VPN server. Anyone sniffing the local Wi-Fi only sees scrambled, unreadable noise.",
            deep_real: "A Corporate VPN is essential whenever working remotely from cafes, hotels, or home networks to protect internal resources.",
            deep_defense: "Turn ON your Corporate VPN before opening work apps outside the office, and verify it shows 'CONNECTED'."
        },
        {
            id: "wpa_security",
            term: "WPA2 / WPA3 Encryption",
            branch_idx: 3,
            branch_name: "NETWORK & PHYSICAL",
            keywords: ["wpa2", "wpa3", "wi-fi encryption", "wifi security"],
            short_def: "WPA2 and WPA3 are modern Wi-Fi security standards that scramble wireless signals between your device and the router so outsiders cannot eavesdrop on your connection.",
            deep_how: "Unlike older broken protocols (WEP) or Open networks, WPA2/WPA3 require authentication and encrypt each device's wireless traffic with unique session keys.",
            deep_real: "Connecting to an 'OPEN' Wi-Fi network without WPA2/WPA3 leaves your wireless packets exposed in the air to anyone within range.",
            deep_defense: "Only connect to password-protected WPA2 or WPA3 Wi-Fi networks, and pair them with a VPN when away from the office."
        },
        {
            id: "tailgating",
            term: "Tailgating (Piggybacking)",
            branch_idx: 3,
            branch_name: "NETWORK & PHYSICAL",
            keywords: ["tailgat", "piggyback", "badge", "hold the door", "propped door", "physical"],
            short_def: "Tailgating is when an unauthorized person slips through a secured badge-access door right behind an employee—often by carrying coffee or boxes so someone politely holds the door.",
            deep_how: "Physical security protects servers, desks, and unlocked PCs. Attackers exploit everyday politeness ('Mind holding the door? My badge is in my bag!') to walk past keycard readers.",
            deep_real: "Once inside a restricted floor, an attacker can plug in rogue devices, photograph sticky-note passwords, or access unattended workstations.",
            deep_defense: "Never hold badge-locked doors open for anyone without seeing their valid company badge. Politely ask visitors to check in at Reception."
        },
        {
            id: "shoulder_surfing",
            term: "Shoulder Surfing & Clean Desk",
            branch_idx: 3,
            branch_name: "NETWORK & PHYSICAL",
            keywords: ["shoulder surf", "sticky note", "unlocked", "win+l", "screen lock", "clean desk"],
            short_def: "Shoulder surfing is peeking over someone's shoulder (or reading sticky notes on an unlocked desk) to steal passwords, PINs, or confidential screen data.",
            deep_how: "Leaving your workstation unlocked when grabbing coffee—or taping a password sticky note under your keyboard—turns a 5-second walk-by into a full account compromise.",
            deep_real: "In shared offices, cafes, and elevators, onlookers or security cameras can easily capture visible passwords or sensitive client spreadsheets.",
            deep_defense: "Lock your screen every time you stand up (Win+L on Windows, Ctrl+Cmd+Q on Mac), never write passwords on sticky notes, and use privacy screen filters in public."
        },

        // ── BRANCH 4: CRYPTOGRAPHY ───────────────────────────────────────────
        {
            id: "plaintext_ciphertext",
            term: "Plaintext & Ciphertext",
            branch_idx: 4,
            branch_name: "CRYPTOGRAPHY",
            keywords: ["plaintext", "ciphertext", "encrypt", "decrypt", "unreadable"],
            short_def: "Plaintext is normal, human-readable data (like 'HELLO'). Ciphertext is the scrambled, unreadable version produced by encryption (like 'KHOOR') so unauthorized people cannot read it.",
            deep_how: "Encryption converts Plaintext -> Ciphertext using an algorithm and a key. Decryption reverses the process (Ciphertext -> Plaintext) only for someone holding the matching key.",
            deep_real: "Every HTTPS website, messaging app, and password vault relies on converting sensitive plaintext into ciphertext before storing or transmitting it.",
            deep_defense: "Never store or transmit passwords or sensitive records in plaintext—always enforce strong encryption at rest and in transit."
        },
        {
            id: "caesar_cipher",
            term: "Caesar Cipher",
            branch_idx: 4,
            branch_name: "CRYPTOGRAPHY",
            keywords: ["caesar", "shift", "offset", "wrap-around", "rotation"],
            short_def: "The Caesar Cipher is a classic substitution cipher that shifts every letter forward in the alphabet by a fixed number (e.g., Shift +3 turns A into D, wrapping Z back to C).",
            deep_how: "To decrypt a Caesar-encrypted word, shift every letter backward by the exact same offset (mod 26). Because there are only 25 possible shifts, a computer—or patient human—can brute-force all of them in seconds.",
            deep_real: "While too weak for modern security, the Caesar Cipher teaches the foundational concepts of keys, modular wrap-around, and why small keyspaces are vulnerable to brute-force attacks.",
            deep_defense: "Modern systems never use single-shift ciphers; they use massive 128-bit or 256-bit keys that cannot be brute-forced."
        },
        {
            id: "vigenere_cipher",
            term: "Vigenere Cipher",
            branch_idx: 4,
            branch_name: "CRYPTOGRAPHY",
            keywords: ["vigenere", "keyword", "polyalphabetic", "repeating key"],
            short_def: "The Vigenere Cipher upgrades the Caesar Cipher by using a repeating keyword (e.g. 'KEY') so each letter in the message is shifted by a different amount instead of one fixed number.",
            deep_how: "Each letter of the keyword corresponds to a shift (A=0, B=1 ... Z=25). The keyword repeats across the message, hiding simple single-letter frequency patterns that break Caesar ciphers.",
            deep_real: "Known for centuries as 'le chiffre indechiffrable' (the indecipherable cipher), it demonstrates how polyalphabetic keys dramatically strengthen encryption—though repeating short keys can still be analyzed.",
            deep_defense: "Modern stream and block ciphers use non-repeating cryptographic keys and initialization vectors (IVs) to prevent pattern analysis."
        },
        {
            id: "atbash_cipher",
            term: "Atbash Cipher",
            branch_idx: 4,
            branch_name: "CRYPTOGRAPHY",
            keywords: ["atbash", "mirror", "reversed alphabet", "z=a"],
            short_def: "The Atbash Cipher is a mirror-substitution cipher that flips the alphabet completely: A swaps with Z, B swaps with Y, C swaps with X, and so on.",
            deep_how: "Because the mapping is perfectly symmetrical (A<->Z, M<->N), encrypting and decrypting use the exact same mirror rule—no numeric key is needed.",
            deep_real: "Atbash shows the difference between encoding (a fixed, secretless rule) and true keyed encryption: once someone recognizes the pattern, there is no secret key protecting the message.",
            deep_defense: "True security never relies on keeping the algorithm secret ('security through obscurity')—it relies on strong, secret cryptographic keys."
        },
        {
            id: "symmetric_asymmetric",
            term: "Symmetric vs. Asymmetric",
            branch_idx: 4,
            branch_name: "CRYPTOGRAPHY",
            keywords: ["symmetric", "asymmetric", "public key", "private key", "aes", "rsa", "tls"],
            short_def: "Symmetric encryption (like AES-256) uses one shared secret key to lock and unlock data. Asymmetric encryption (like RSA) uses a pair: a Public Key to lock and a Private Key to unlock.",
            deep_how: "Symmetric encryption is blazingly fast for encrypting files and VPN tunnels, while Asymmetric encryption solves the 'how do we safely share the key over the internet?' problem during HTTPS/TLS handshakes.",
            deep_real: "Every time you see the padlock in your browser (HTTPS), your browser uses Asymmetric crypto to safely agree on a temporary Symmetric AES key for your session.",
            deep_defense: "Use modern vetted standards like AES-256, ChaCha20, and TLS 1.3—never invent custom encryption algorithms."
        },
        {
            id: "symmetric_encryption",
            term: "Symmetric Encryption",
            branch_idx: 4,
            branch_name: "CRYPTOGRAPHY",
            keywords: ["symmetric encryption", "aes-256", "shared secret key", "chacha20"],
            short_def: "Symmetric encryption uses ONE shared secret key to both lock (encrypt) and unlock (decrypt) data—like a physical house key that both locks and opens the same door.",
            deep_how: "Algorithms like AES-256 scramble huge amounts of data very quickly using a single secret key. Because both sender and receiver need the exact same key, the main challenge is sharing that key safely beforehand.",
            deep_real: "Symmetric encryption powers hard-drive encryption (BitLocker), Password Manager vaults, and active VPN tunnels because it can encrypt gigabytes of traffic in real time.",
            deep_defense: "Use strong 256-bit Symmetric ciphers (AES-256) and never transmit the shared secret key in plaintext—exchange it using Asymmetric encryption."
        },
        {
            id: "asymmetric_encryption",
            term: "Asymmetric Encryption",
            branch_idx: 4,
            branch_name: "CRYPTOGRAPHY",
            keywords: ["asymmetric encryption", "public key", "private key", "rsa"],
            short_def: "Asymmetric encryption (public-key cryptography) uses a mathematically linked pair of keys: a Public Key anyone can use to lock data, and a secret Private Key that only the owner can use to unlock it.",
            deep_how: "Think of a Public Key like an open padlock you hand out to anyone: anyone can snap it shut on a box (encrypt), but only your matching Private Key can open it (decrypt). Algorithms like RSA and ECC make this possible without sharing a secret key first.",
            deep_real: "Asymmetric encryption secures HTTPS/TLS website handshakes, digital signatures on software updates, and SSH logins so attackers sniffing the network cannot intercept the key.",
            deep_defense: "Guard your Private Key like a master secret—never share or commit private keys to public folders or code repositories."
        },
        {
            id: "security_by_obscurity",
            term: "Security by Obscurity",
            branch_idx: 4,
            branch_name: "CRYPTOGRAPHY",
            keywords: ["security by obscurity", "security through obscurity", "secretless"],
            short_def: "Security by Obscurity is the flawed belief that a system is safe simply because its method or hidden location isn't widely known—without using a real secret key or password.",
            deep_how: "Ciphers like Atbash or renaming 'passwords.txt' to 'notes_old.txt' rely on attackers not noticing the trick. As soon as someone guesses or discovers the fixed rule, protection drops to zero.",
            deep_real: "Real-world cryptography follows Kerckhoffs's Principle: a system should stay secure even if everyone knows how the algorithm works, because security depends on keeping the KEY secret.",
            deep_defense: "Never rely on hiding files or secretless rules. Always protect data with strong authentication and vetted keyed encryption."
        }
    ];
}

function scr_get_cyber_glossary() {
    scr_init_cyber_glossary();
    return global.cyber_glossary;
}

function scr_get_cyber_glossary_unlocked_count() {
    scr_init_cyber_glossary();
    var _n = 0;
    for (var i = 0; i < array_length(global.cyber_glossary); i++) {
        if (variable_struct_exists(global.codex_unlocked_terms, global.cyber_glossary[i].id)) _n++;
    }
    return _n;
}

function scr_find_cyber_term_by_id(_term_id) {
    scr_init_cyber_glossary();
    for (var i = 0; i < array_length(global.cyber_glossary); i++) {
        if (global.cyber_glossary[i].id == _term_id) {
            return global.cyber_glossary[i];
        }
    }
    return undefined;
}

function scr_silent_archive_cyber_term(_term_struct) {
    scr_init_cyber_glossary();
    if (!is_struct(_term_struct)) return false;
    var _is_new = !variable_struct_exists(global.codex_unlocked_terms, _term_struct.id);
    if (_is_new) {
        global.codex_unlocked_terms[$ _term_struct.id] = true;
        global.codex_new_count++;
    }
    scr_add_floor_scanned_term(_term_struct);
    // Composite concepts automatically unlock their foundational sub-concepts
    if (_term_struct.id == "symmetric_asymmetric") {
        var _sym  = scr_find_cyber_term_by_id("symmetric_encryption");
        var _asym = scr_find_cyber_term_by_id("asymmetric_encryption");
        if (is_struct(_sym) && !variable_struct_exists(global.codex_unlocked_terms, _sym.id)) {
            global.codex_unlocked_terms[$ _sym.id] = true;
            global.codex_new_count++;
        }
        if (is_struct(_asym) && !variable_struct_exists(global.codex_unlocked_terms, _asym.id)) {
            global.codex_unlocked_terms[$ _asym.id] = true;
            global.codex_new_count++;
        }
    }
    return _is_new;
}

function scr_unlock_cyber_term(_term_struct) {
    scr_init_cyber_glossary();
    if (!is_struct(_term_struct)) return;
    var _is_new = scr_silent_archive_cyber_term(_term_struct);
    global.term_popup_history         = [];
    global.active_term_popup          = _term_struct;
    global.active_term_popup_just_new = _is_new;
}

function scr_scan_clickable_terms(_text_array, _max_terms) {
    scr_init_cyber_glossary();
    if (is_undefined(_max_terms)) _max_terms = 5;
    var _joined = "";
    if (is_string(_text_array)) {
        _joined = string_lower(_text_array);
    } else if (is_array(_text_array)) {
        for (var i = 0; i < array_length(_text_array); i++) {
            _joined += " " + string_lower(string(_text_array[i]));
        }
    }
    var _found = [];
    for (var g = 0; g < array_length(global.cyber_glossary); g++) {
        var _entry = global.cyber_glossary[g];
        var _kws   = _entry.keywords;
        var _hit   = false;
        for (var k = 0; k < array_length(_kws); k++) {
            if (string_pos(_kws[k], _joined) > 0) {
                _hit = true;
                break;
            }
        }
        if (_hit) {
            array_push(_found, _entry);
            if (array_length(_found) >= _max_terms) break;
        }
    }
    return _found;
}

function scr_draw_clickable_term_bar(_x, _y, _max_w, _term_list, _label, _label_col = -1) {
    scr_init_cyber_glossary();
    if (!is_array(_term_list) || array_length(_term_list) == 0) return false;
    if (is_undefined(_label)) _label = "CLICK TERM TO DEFINE & ARCHIVE:";
    var _lcol = (_label_col != -1 && !is_undefined(_label_col)) ? _label_col : make_color_rgb(130, 215, 255);

    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _can_click = (global.active_term_popup == undefined) && (global.term_popup_block_frames <= 0);
    var _clicked   = _can_click && mouse_check_button_pressed(mb_left);
    var _did_click = false;

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    draw_set_color(_lcol);
    draw_text_transformed(_x, _y + 4, _label, 0.56, 0.56, 0);

    var _cx = _x;
    var _cy = _y + 17;
    var _ph = 18;
    var _gap = 6;

    for (var i = 0; i < array_length(_term_list); i++) {
        var _t        = _term_list[i];
        scr_silent_archive_cyber_term(_t);
        var _unlocked = variable_struct_exists(global.codex_unlocked_terms, _t.id);
        var _tag      = _unlocked ? ("[+ " + _t.term + "]") : ("[? " + _t.term + "]");
        var _pw      = string_width(_tag) * 0.58 + 12;

        if (_cx + _pw > _x + _max_w && _cx > _x) {
            _cx = _x;
            _cy += _ph + 4;
        }

        var _hov = _can_click && (_mx >= _cx && _mx <= _cx + _pw && _my >= _cy && _my <= _cy + _ph);
        var _bg  = _hov ? make_color_rgb(28, 72, 105) : (_unlocked ? make_color_rgb(14, 42, 34) : make_color_rgb(18, 34, 62));
        var _bd  = _hov ? c_yellow : (_unlocked ? make_color_rgb(90, 235, 150) : make_color_rgb(90, 200, 255));

        draw_set_color(_bg);
        draw_rectangle(_cx, _cy, _cx + _pw, _cy + _ph, false);
        draw_set_color(_bd);
        draw_rectangle(_cx, _cy, _cx + _pw, _cy + _ph, true);

        draw_set_color(_hov ? c_yellow : (_unlocked ? make_color_rgb(160, 255, 195) : make_color_rgb(190, 235, 255)));
        draw_text_transformed(_cx + 6, _cy + _ph * 0.5, _tag, 0.58, 0.58, 0);

        if (_hov && _clicked && !_did_click) {
            scr_unlock_cyber_term(_t);
            if (asset_get_type("snd_button_click") == asset_sound) audio_play_sound(snd_button_click, 5, false);
            _did_click = true;
        }

        _cx += _pw + _gap;
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    return _did_click;
}

function scr_get_term_inline_link_map() {
    // Ordered longest-first so multi-word phrases match before single words
    return [
        { token: "security through obscurity", id: "security_by_obscurity" },
        { token: "security by obscurity",    id: "security_by_obscurity" },
        { token: "two-factor authentication", id: "mfa_2fa" },
        { token: "multi-factor authentication", id: "mfa_2fa" },
        { token: "password manager",         id: "password_manager" },
        { token: "credential stuffing",      id: "credential_stuffing" },
        { token: "look-alike domain",        id: "typosquatting" },
        { token: "tech-support scam",        id: "tech_support_scam" },
        { token: "mfa push bombing",         id: "mfa_fatigue" },
        { token: "remote access trojan",     id: "rat_malware" },
        { token: "shoulder surfing",         id: "shoulder_surfing" },
        { token: "packet sniffing",          id: "packet_sniffing" },
        { token: "session cookies",          id: "session_cookie" },
        { token: "session cookie",           id: "session_cookie" },
        { token: "session tokens",           id: "session_cookie" },
        { token: "session token",            id: "session_cookie" },
        { token: "public wi-fi",             id: "public_wifi" },
        { token: "typosquatting",            id: "typosquatting" },
        { token: "asymmetric",               id: "asymmetric_encryption" },
        { token: "symmetric",                id: "symmetric_encryption" },
        { token: "ransomware",               id: "ransomware" },
        { token: "ciphertext",               id: "plaintext_ciphertext" },
        { token: "plaintext",                id: "plaintext_ciphertext" },
        { token: "plain text",               id: "plaintext_ciphertext" },
        { token: "firewalls",                id: "firewall" },
        { token: "firewall",                 id: "firewall" },
        { token: "antivirus",                id: "antivirus_edr" },
        { token: "phishing",                 id: "phishing" },
        { token: "pretexting",               id: "pretexting" },
        { token: "tailgating",               id: "tailgating" },
        { token: "vigenere",                 id: "vigenere_cipher" },
        { token: "caesar",                   id: "caesar_cipher" },
        { token: "atbash",                   id: "atbash_cipher" },
        { token: "vishing",                  id: "vishing" },
        { token: "aes-256",                  id: "symmetric_encryption" },
        { token: "oauth",                    id: "oauth_permissions" },
        { token: "https",                    id: "https_tls" },
        { token: "wpa2/wpa3",                id: "wpa_security" },
        { token: "wpa2",                     id: "wpa_security" },
        { token: "wpa3",                     id: "wpa_security" },
        { token: "vpn",                      id: "vpn" },
        { token: "mfa",                      id: "mfa_2fa" },
        { token: "2fa",                      id: "mfa_2fa" },
        { token: "edr",                      id: "antivirus_edr" },
        { token: "tls",                      id: "https_tls" },
        { token: "rsa",                      id: "asymmetric_encryption" },
        { token: "rat",                      id: "rat_malware" },
        { token: "usb",                      id: "usb_baiting" }
    ];
}

function scr_is_word_boundary_char(_ch) {
    if (_ch == "") return true;
    var _o = ord(string_upper(_ch));
    var _is_alnum = ((_o >= 65 && _o <= 90) || (_o >= 48 && _o <= 57));
    return !_is_alnum;
}

function scr_wrap_text_lines(_str, _max_w_unscaled) {
    var _lines = [];
    if (!is_string(_str) || _str == "") return [""];
    var _paras = string_split(_str, "\n");
    for (var _pi = 0; _pi < array_length(_paras); _pi++) {
        var _words = string_split(_paras[_pi], " ");
        var _cur   = "";
        for (var _wi = 0; _wi < array_length(_words); _wi++) {
            var _w = _words[_wi];
            var _cand = (_cur == "") ? _w : (_cur + " " + _w);
            if (_cur != "" && string_width(_cand) > _max_w_unscaled) {
                array_push(_lines, _cur);
                _cur = _w;
            } else {
                _cur = _cand;
            }
        }
        array_push(_lines, _cur);
    }
    return _lines;
}

function scr_measure_linked_cyber_text_h(_str, _lsep, _max_w_unscaled, _sc) {
    var _lines = scr_wrap_text_lines(_str, _max_w_unscaled);
    return array_length(_lines) * _lsep * _sc;
}

/// @function scr_draw_linked_cyber_text(_x, _y, _str, _lsep, _max_w_unscaled, _sc, _base_col, _exclude_id, _allow_click, _clip_y1, _clip_y2)
/// @description Wraps and draws text with inline clickable highlights for recognized Codex terms.
///              Returns the clicked term struct if a highlighted term was clicked, otherwise undefined.
function scr_draw_linked_cyber_text(_x, _y, _str, _lsep, _max_w_unscaled, _sc, _base_col, _exclude_id, _allow_click, _clip_y1, _clip_y2) {
    var _lines   = scr_wrap_text_lines(_str, _max_w_unscaled);
    var _map     = scr_get_term_inline_link_map();
    var _mx      = device_mouse_x_to_gui(0);
    var _my      = device_mouse_y_to_gui(0);
    var _clicked = _allow_click && mouse_check_button_pressed(mb_left);
    var _ret     = undefined;

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var _line_h = _lsep * _sc;

    for (var _li = 0; _li < array_length(_lines); _li++) {
        var _ly = _y + _li * _line_h;
        if (_ly < _clip_y1 || (_ly + _line_h) > _clip_y2) continue;

        var _line     = _lines[_li];
        var _line_low = string_lower(_line);
        var _len      = string_length(_line);
        var _pos      = 1;
        var _cur_x    = _x;

        while (_pos <= _len) {
            var _best_pos = _len + 1;
            var _best_len = 0;
            var _best_id  = "";

            for (var _mi = 0; _mi < array_length(_map); _mi++) {
                var _tok    = _map[_mi].token;
                var _tid    = _map[_mi].id;
                if (_tid == _exclude_id) continue;
                var _tlen   = string_length(_tok);
                var _search = _pos;
                while (_search <= _len) {
                    var _sub  = string_copy(_line_low, _search, _len - _search + 1);
                    var _rel  = string_pos(_tok, _sub);
                    if (_rel <= 0) break;
                    var _abs  = _search + _rel - 1;
                    var _prev = (_abs > 1) ? string_char_at(_line, _abs - 1) : "";
                    var _next = (_abs + _tlen <= _len) ? string_char_at(_line, _abs + _tlen) : "";
                    if (scr_is_word_boundary_char(_prev) && scr_is_word_boundary_char(_next)) {
                        if (_abs < _best_pos || (_abs == _best_pos && _tlen > _best_len)) {
                            _best_pos = _abs;
                            _best_len = _tlen;
                            _best_id  = _tid;
                        }
                        break;
                    }
                    _search = _abs + 1;
                }
            }

            if (_best_pos > _len) {
                var _tail = string_copy(_line, _pos, _len - _pos + 1);
                draw_set_color(_base_col);
                draw_text_transformed(_cur_x, _ly, _tail, _sc, _sc, 0);
                break;
            }

            if (_best_pos > _pos) {
                var _pre = string_copy(_line, _pos, _best_pos - _pos);
                draw_set_color(_base_col);
                draw_text_transformed(_cur_x, _ly, _pre, _sc, _sc, 0);
                _cur_x += string_width(_pre) * _sc;
            }

            var _tok_txt = string_copy(_line, _best_pos, _best_len);
            var _tok_w   = string_width(_tok_txt) * _sc;
            var _hov     = (_mx >= _cur_x - 1 && _mx <= _cur_x + _tok_w + 1 && _my >= _ly - 1 && _my <= _ly + _line_h);

            draw_set_color(_hov ? c_yellow : make_color_rgb(95, 225, 255));
            draw_text_transformed(_cur_x, _ly, _tok_txt, _sc, _sc, 0);
            draw_line(_cur_x, _ly + _line_h - 3, _cur_x + _tok_w, _ly + _line_h - 3);

            if (_hov && _clicked && _ret == undefined) {
                _ret = scr_find_cyber_term_by_id(_best_id);
            }

            _cur_x += _tok_w;
            _pos    = _best_pos + _best_len;
        }
    }

    draw_set_color(_base_col);
    return _ret;
}

function scr_get_related_terms_in_text(_term_struct, _max_out) {
    if (is_undefined(_max_out)) _max_out = 5;
    var _out = [];
    if (!is_struct(_term_struct)) return _out;
    var _joined = string_lower(_term_struct.short_def + " " + _term_struct.deep_how + " " + _term_struct.deep_real + " " + _term_struct.deep_defense);
    var _map    = scr_get_term_inline_link_map();
    var _seen   = {};
    var _len    = string_length(_joined);

    for (var _mi = 0; _mi < array_length(_map); _mi++) {
        var _tid = _map[_mi].id;
        if (_tid == _term_struct.id || variable_struct_exists(_seen, _tid)) continue;
        var _tok  = _map[_mi].token;
        var _tlen = string_length(_tok);
        var _idx  = string_pos(_tok, _joined);
        if (_idx > 0) {
            var _prev = (_idx > 1) ? string_char_at(_joined, _idx - 1) : "";
            var _next = (_idx + _tlen <= _len) ? string_char_at(_joined, _idx + _tlen) : "";
            if (scr_is_word_boundary_char(_prev) && scr_is_word_boundary_char(_next)) {
                var _target = scr_find_cyber_term_by_id(_tid);
                if (is_struct(_target)) {
                    _seen[$ _tid] = true;
                    array_push(_out, _target);
                    if (array_length(_out) >= _max_out) break;
                }
            }
        }
    }
    return _out;
}

function scr_handle_term_popup_input() {
    scr_init_cyber_glossary();
    if (global.term_popup_block_frames > 0) {
        global.term_popup_block_frames--;
    }
    if (global.active_term_popup == undefined) return false;

    var _gw  = display_get_gui_width();
    var _gh  = display_get_gui_height();
    var _bw  = min(510, _gw - 40);
    var _bh  = 210;
    var _bx1 = (_gw - _bw) * 0.5;
    var _by1 = (_gh - _bh) * 0.5;
    var _bx2 = _bx1 + _bw;
    var _by2 = _by1 + _bh;
    var _mx  = device_mouse_x_to_gui(0);
    var _my  = device_mouse_y_to_gui(0);

    var _click_outside = mouse_check_button_pressed(mb_left)
                      && (_mx < _bx1 || _mx > _bx2 || _my < _by1 || _my > _by2);

    if (_click_outside
     || keyboard_check_pressed(vk_escape)
     || keyboard_check_pressed(ord("E"))
     || keyboard_check_pressed(vk_space)
     || keyboard_check_pressed(vk_enter)) {
        if (keyboard_check_pressed(vk_escape)) {
            global.esc_block_frames = 2;
            keyboard_clear(vk_escape);
        }
        keyboard_clear(ord("E"));
        keyboard_clear(vk_space);
        keyboard_clear(vk_enter);
        global.active_term_popup        = undefined;
        global.term_popup_history       = [];
        global.term_popup_block_frames  = 2;
        if (asset_get_type("snd_button_click") == asset_sound) audio_play_sound(snd_button_click, 5, false);
    }
    return true;
}

function scr_draw_term_quick_popup() {
    scr_init_cyber_glossary();
    if (global.active_term_popup == undefined) return;

    var _t  = global.active_term_popup;
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    draw_set_alpha(0.72);
    draw_set_color(make_color_rgb(3, 6, 14));
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    var _bw = min(510, _gw - 40);
    var _bh = 210;
    var _bx1 = (_gw - _bw) * 0.5;
    var _by1 = (_gh - _bh) * 0.5;
    var _bx2 = _bx1 + _bw;
    var _by2 = _by1 + _bh;

    draw_set_color(make_color_rgb(10, 18, 34));
    draw_rectangle(_bx1, _by1, _bx2, _by2, false);
    draw_set_color(make_color_rgb(80, 215, 255));
    draw_rectangle(_bx1, _by1, _bx2, _by2, true);
    draw_rectangle(_bx1 + 2, _by1 + 2, _bx2 - 2, _by2 - 2, true);

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // Branch pill
    draw_set_color(make_color_rgb(20, 46, 78));
    draw_rectangle(_bx1 + 14, _by1 + 12, _bx1 + 210, _by1 + 30, false);
    draw_set_color(make_color_rgb(100, 220, 255));
    draw_rectangle(_bx1 + 14, _by1 + 12, _bx1 + 210, _by1 + 30, true);
    draw_text_transformed(_bx1 + 20, _by1 + 15, "BRANCH: " + _t.branch_name, 0.58, 0.58, 0);

    // Optional [< Back] button when navigated via inline link
    if (array_length(global.term_popup_history) > 0) {
        var _bk_x1 = _bx1 + 218;
        var _bk_y1 = _by1 + 12;
        var _bk_x2 = _bk_x1 + 78;
        var _bk_y2 = _by1 + 30;
        var _bk_hov = (_mx >= _bk_x1 && _mx <= _bk_x2 && _my >= _bk_y1 && _my <= _bk_y2);
        draw_set_color(_bk_hov ? make_color_rgb(35, 75, 110) : make_color_rgb(16, 36, 58));
        draw_rectangle(_bk_x1, _bk_y1, _bk_x2, _bk_y2, false);
        draw_set_color(_bk_hov ? c_yellow : c_aqua);
        draw_rectangle(_bk_x1, _bk_y1, _bk_x2, _bk_y2, true);
        draw_set_halign(fa_center);
        draw_text_transformed((_bk_x1 + _bk_x2) * 0.5, _bk_y1 + 3, "< BACK", 0.58, 0.58, 0);
        draw_set_halign(fa_left);
        if (_bk_hov && mouse_check_button_pressed(mb_left)) {
            var _prev = array_pop(global.term_popup_history);
            global.active_term_popup          = _prev;
            global.active_term_popup_just_new = false;
            if (asset_get_type("snd_button_click") == asset_sound) audio_play_sound(snd_button_click, 5, false);
        }
    }

    // Codex status pill + [X] Close button
    var _cl_x1 = _bx2 - 32, _cl_y1 = _by1 + 12, _cl_x2 = _bx2 - 12, _cl_y2 = _by1 + 30;
    var _cl_hov = (_mx >= _cl_x1 && _mx <= _cl_x2 && _my >= _cl_y1 && _my <= _cl_y2);
    draw_set_color(_cl_hov ? make_color_rgb(110, 32, 38) : make_color_rgb(30, 38, 54));
    draw_rectangle(_cl_x1, _cl_y1, _cl_x2, _cl_y2, false);
    draw_set_color(_cl_hov ? c_red : make_color_rgb(120, 175, 210));
    draw_rectangle(_cl_x1, _cl_y1, _cl_x2, _cl_y2, true);
    draw_set_halign(fa_center);
    draw_set_color(_cl_hov ? c_white : make_color_rgb(200, 225, 245));
    draw_text_transformed((_cl_x1 + _cl_x2) * 0.5, _cl_y1 + 3, "X", 0.62, 0.62, 0);
    if (_cl_hov && mouse_check_button_pressed(mb_left)) {
        global.active_term_popup       = undefined;
        global.term_popup_history      = [];
        global.term_popup_block_frames = 2;
        if (asset_get_type("snd_button_click") == asset_sound) audio_play_sound(snd_button_click, 5, false);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
        exit;
    }

    draw_set_halign(fa_right);
    var _st_txt = global.active_term_popup_just_new ? "[+] ARCHIVED TO CODEX!" : "[+] IN HOMEROOM CODEX";
    draw_set_color(global.active_term_popup_just_new ? make_color_rgb(255, 220, 80) : make_color_rgb(110, 245, 165));
    draw_text_transformed(_cl_x1 - 8, _by1 + 15, _st_txt, 0.56, 0.56, 0);

    // Term Title
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text_transformed(_bx1 + 14, _by1 + 38, _t.term, 1.05, 1.05, 0);

    draw_set_color(make_color_rgb(50, 95, 145));
    draw_line(_bx1 + 14, _by1 + 64, _bx2 - 14, _by1 + 64);

    // Short Definition with inline clickable highlighted sub-terms
    var _jump_term = scr_draw_linked_cyber_text(
        _bx1 + 14, _by1 + 74, _t.short_def, 20, (_bw - 28) / 0.72, 0.72,
        make_color_rgb(225, 240, 255), _t.id, true, _by1 + 66, _by2 - 28
    );
    if (is_struct(_jump_term)) {
        array_push(global.term_popup_history, _t);
        var _jnew = scr_silent_archive_cyber_term(_jump_term);
        global.active_term_popup          = _jump_term;
        global.active_term_popup_just_new = _jnew;
        if (asset_get_type("snd_button_click") == asset_sound) audio_play_sound(snd_button_click, 5, false);
    }

    // Footer
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(155, 200, 235));
    draw_text_transformed((_bx1 + _bx2) * 0.5, _by2 - 20, "Click highlighted terms to jump  |  Homeroom [C] for full guide  |  [E / ESC / X] Close", 0.55, 0.55, 0);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

// =============================================================================
// 5-BRANCH CYBERSECURITY COMPETENCY TRACKING & MASTERY BARS
// =============================================================================
function scr_ensure_cyber_stats() {
    if (!variable_global_exists("cyber_stats") || !is_struct(global.cyber_stats)) {
        global.cyber_stats = {
            social_eng:   { correct: 0, total: 0 },
            identity:     { correct: 0, total: 0 },
            malware:      { correct: 0, total: 0 },
            network_phys: { correct: 0, total: 0 },
            crypto:       { correct: 0, total: 0 }
        };
        return;
    }
    var _keys = ["social_eng", "identity", "malware", "network_phys", "crypto"];
    for (var i = 0; i < array_length(_keys); i++) {
        var _k = _keys[i];
        if (!variable_struct_exists(global.cyber_stats, _k) || !is_struct(global.cyber_stats[$ _k])) {
            global.cyber_stats[$ _k] = { correct: 0, total: 0 };
        }
    }
}

/// @function scr_record_cyber_stat(branch_key, is_correct)
/// @description Increments total by 1 and correct by 1 if is_correct is true for the given branch_key.
function scr_record_cyber_stat(_branch_key, _is_correct) {
    scr_ensure_cyber_stats();
    if (!variable_struct_exists(global.cyber_stats, _branch_key)) {
        _branch_key = "social_eng";
    }
    var _entry = global.cyber_stats[$ _branch_key];
    _entry.total += 1;
    if (_is_correct) {
        _entry.correct += 1;
    }
    global.cyber_stats[$ _branch_key] = _entry;

    if (variable_global_exists("floor_branch_key") && global.floor_branch_key == _branch_key) {
        global.floor_branch_mastery_pct = scr_get_branch_mastery_pct(_branch_key);
        global.floor_priority_tag = "PRIORITY ASSIGNMENT: " + global.floor_branch_name
            + " (Mastery: " + string(global.floor_branch_mastery_pct) + "%)";
    }
}

function scr_get_branch_mastery_pct(_branch_key) {
    scr_ensure_cyber_stats();
    if (!variable_struct_exists(global.cyber_stats, _branch_key)) return 0;
    var _st = global.cyber_stats[$ _branch_key];
    return clamp(round((_st.correct / max(1, _st.total)) * 100), 0, 100);
}

function scr_get_branch_display_name(_branch_key) {
    switch (_branch_key) {
        case "social_eng":   return "SOCIAL ENGINEERING";
        case "identity":     return "IDENTITY & ACCESS";
        case "malware":      return "MALWARE & ENDPOINTS";
        case "network_phys": return "NETWORK & PHYSICAL";
        case "crypto":       return "CRYPTOGRAPHY";
    }
    return "CYBERSECURITY";
}

function scr_get_case_branch_key(_case_id) {
    switch (_case_id) {
        case 0:  return "crypto";
        case 1:  return "social_eng";
        case 2:  return "malware";
        case 3:  return "network_phys";
        case 4:  return "identity";
        case 5:  return "malware";
        case 6:  return "network_phys";
        case 7:  return "social_eng";
        case 8:  return "malware";
        case 9:  return "identity";
        default: return "social_eng";
    }
}

/// @function scr_draw_cyber_mastery_bars(x1, y1, w, h, show_header)
/// @description Draws 5 compact horizontal progress bars showing 0%–100% branch mastery.
function scr_draw_cyber_mastery_bars(_x1, _y1, _w, _h, _show_header) {
    scr_ensure_cyber_stats();
    var _keys   = ["social_eng", "identity", "malware", "network_phys", "crypto"];
    var _labels = ["SOCIAL ENG.", "IDENTITY & IAM", "MALWARE", "NETWORK & PHYS", "CRYPTOGRAPHY"];
    var _cols   = [
        make_color_rgb(255, 175, 65),
        make_color_rgb(95, 215, 255),
        make_color_rgb(255, 105, 135),
        make_color_rgb(120, 240, 165),
        make_color_rgb(195, 145, 255)
    ];

    draw_set_font(fnt_dialogue);
    draw_set_color(make_color_rgb(8, 15, 26));
    draw_rectangle(_x1, _y1, _x1 + _w, _y1 + _h, false);
    draw_set_color(make_color_rgb(55, 120, 165));
    draw_rectangle(_x1, _y1, _x1 + _w, _y1 + _h, true);

    var _bar_top = _y1 + 4;
    if (_show_header) {
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(make_color_rgb(160, 225, 255));
        draw_text_transformed(_x1 + 8, _y1 + 3, "CYBERSECURITY COMPETENCY MASTERY (5 BRANCHES)", 0.52, 0.52, 0);
        _bar_top = _y1 + 15;
    }

    var _n      = array_length(_keys);
    var _gap    = 6;
    var _cell_w = (_w - 12 - (_gap * (_n - 1))) / _n;
    var _bar_h  = max(6, (_y1 + _h) - _bar_top - 13);

    for (var i = 0; i < _n; i++) {
        var _k   = _keys[i];
        var _pct = scr_get_branch_mastery_pct(_k);
        var _st  = global.cyber_stats[$ _k];
        var _cx1 = _x1 + 6 + i * (_cell_w + _gap);
        var _cx2 = _cx1 + _cell_w;

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(make_color_rgb(210, 225, 240));
        draw_text_transformed(_cx1, _bar_top, _labels[i], 0.46, 0.46, 0);

        draw_set_halign(fa_right);
        draw_set_color((_st.total > 0) ? _cols[i] : make_color_rgb(130, 145, 165));
        draw_text_transformed(_cx2, _bar_top, string(_pct) + "%", 0.48, 0.48, 0);

        var _by1 = _bar_top + 10;
        var _by2 = _by1 + _bar_h;
        draw_set_color(make_color_rgb(20, 30, 46));
        draw_rectangle(_cx1, _by1, _cx2, _by2, false);

        if (_pct > 0) {
            var _fill_w = max(2, (_cell_w - 2) * (_pct / 100));
            draw_set_color(_cols[i]);
            draw_rectangle(_cx1 + 1, _by1 + 1, _cx1 + 1 + _fill_w, _by2 - 1, false);
        }

        draw_set_color(make_color_rgb(65, 105, 140));
        draw_rectangle(_cx1, _by1, _cx2, _by2, true);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

// =============================================================================
// BENIGN ANOMALIES ("RED HERRINGS") & WRONGFUL AUDIT PENALTY HELPERS
// =============================================================================
function scr_get_benign_red_herring_pool() {
    return [
        {
            label:          "File: 'bonus_structure_2026.pdf.exe' in C:\\EDR_Quarantine\\Blocked\\",
            is_breach:      false,
            is_risky:       false,
            is_red_herring: true,
            desc:           "SAFE (QUARANTINED): Double-extension malware was automatically blocked inside C:\\EDR_Quarantine\\Blocked\\ and reported to IT.",
            audit_feedback: "Audit Rejected: That '.pdf.exe' file was never executed—it is safely isolated inside C:\\EDR_Quarantine\\Blocked\\!"
        },
        {
            label:          "Browser: Login Page open at 'https://sso.company-internal.com' (Valid TLS Lock)",
            is_breach:      false,
            is_risky:       false,
            is_red_herring: true,
            desc:           "SAFE (OFFICIAL SSO): The domain 'sso.company-internal.com' is the verified internal Single Sign-On portal with a valid TLS certificate.",
            audit_feedback: "Audit Rejected: 'https://sso.company-internal.com' with a valid TLS lock is the legitimate corporate SSO portal, not a phishing site!"
        },
        {
            label:          "Desktop Sticky Note: 'Password Reminder -> Stored in Bitwarden Vault'",
            is_breach:      false,
            is_risky:       false,
            is_red_herring: true,
            desc:           "SAFE (PASSWORD MANAGER): The sticky note contains zero credentials—it only reminds the employee to use their encrypted Bitwarden Vault.",
            audit_feedback: "Audit Rejected: That sticky note doesn't expose a password—it directs the user to their encrypted Bitwarden Password Manager!"
        },
        {
            label:          "USB Port: Flash Drive Mounted — 'IT-Approved Encrypted Backup (BitLocker)'",
            is_breach:      false,
            is_risky:       false,
            is_red_herring: true,
            desc:           "SAFE (AUTHORIZED HARDWARE): Hardware-encrypted BitLocker drive issued and signed by Corporate IT Asset Management.",
            audit_feedback: "Audit Rejected: That USB drive is an IT-Approved, BitLocker-encrypted backup drive—not an untrusted parking-lot drop!"
        },
        {
            label:          "Email: '[EXTERNAL] Urgent Wire Request' -> Replied: 'Verifying via Official Directory First'",
            is_breach:      false,
            is_risky:       false,
            is_red_herring: true,
            desc:           "SAFE (OUT-OF-BAND VERIFICATION): The employee spotted the external pretexting email and refused to open the attachment without calling the official directory.",
            audit_feedback: "Audit Rejected: The employee followed proper anti-phishing procedure by verifying via the official phone directory before opening anything!"
        },
        {
            label:          "Phone Log: 5 Missed MFA Push Prompts -> Status: 'DENIED & REPORTED TO SOC'",
            is_breach:      false,
            is_risky:       false,
            is_red_herring: true,
            desc:           "SAFE (MFA FATIGUE BLOCKED): When spammed with unexpected login prompts, the employee tapped 'Deny' and alerted the Security Operations Center.",
            audit_feedback: "Audit Rejected: Those MFA Push Bombing prompts were DENIED and reported to the SOC—the employee stopped the attack!"
        },
        {
            label:          "Wi-Fi: Connected to 'CoffeeShop_Free_WiFi' -> Corporate VPN: 'AES-256 TUNNEL ACTIVE'",
            is_breach:      false,
            is_risky:       false,
            is_red_herring: true,
            desc:           "SAFE (ENCRYPTED VPN TUNNEL): Although using guest Wi-Fi, an AES-256 Corporate VPN tunnel was active the entire session, preventing packet sniffing.",
            audit_feedback: "Audit Rejected: The employee had their AES-256 Corporate VPN Tunnel ON before sending any traffic over guest Wi-Fi!"
        },
        {
            label:          "Software: 'Chrome_Security_Patch.msi' -> Source: 'Verified Corporate IT Software Center'",
            is_breach:      false,
            is_risky:       false,
            is_red_herring: true,
            desc:           "SAFE (OFFICIAL PATCH): Update was deployed and digitally signed by the internal Corporate IT Software Center, not a web popup.",
            audit_feedback: "Audit Rejected: That patch was installed from the verified Corporate IT Software Center, not a malvertising browser popup!"
        }
    ];
}

function scr_apply_wrongful_audit_penalty(_suspect_struct, _reason_msg) {
    if (!variable_global_exists("wrongful_audits")) {
        global.wrongful_audits = 0;
    }
    var _already_fined = (is_struct(_suspect_struct)
        && variable_struct_exists(_suspect_struct, "wrongful_fine_applied")
        && _suspect_struct.wrongful_fine_applied);

    if (!_already_fined) {
        if (is_struct(_suspect_struct)) {
            _suspect_struct.wrongful_fine_applied = true;
        }
        global.wrongful_audits += 1;
        return "HR COMPLIANCE WARNING (-$75 Wrongful Audit Fine): " + _reason_msg;
    }
    return "HR COMPLIANCE WARNING (Fine Already Logged on This Desk): " + _reason_msg;
}

// =============================================================================
// CITE YOUR SOURCE: FLOOR SCANNED TERMS & POLICY CITATION VALIDATION
// =============================================================================
function scr_add_floor_scanned_term(_term_struct) {
    if (!is_struct(_term_struct)) return;
    if (!variable_global_exists("floor_scanned_terms") || !is_array(global.floor_scanned_terms)) {
        global.floor_scanned_terms = [];
    }
    for (var i = 0; i < array_length(global.floor_scanned_terms); i++) {
        if (global.floor_scanned_terms[i].id == _term_struct.id) return;
    }
    array_push(global.floor_scanned_terms, _term_struct);
}

function scr_is_term_scanned_on_floor(_term_id) {
    if (!variable_global_exists("floor_scanned_terms") || !is_array(global.floor_scanned_terms)) return false;
    for (var i = 0; i < array_length(global.floor_scanned_terms); i++) {
        if (global.floor_scanned_terms[i].id == _term_id) return true;
    }
    return false;
}

function scr_auto_collect_floor_terms(_text_array) {
    var _matched = scr_scan_clickable_terms(_text_array, 6);
    for (var i = 0; i < array_length(_matched); i++) {
        scr_silent_archive_cyber_term(_matched[i]);
    }
}

function scr_get_policy_drawer_terms() {
    scr_init_cyber_glossary();
    var _out  = [];
    var _seen = {};

    // 1. Terms clicked/scanned during this floor
    if (variable_global_exists("floor_scanned_terms") && is_array(global.floor_scanned_terms)) {
        for (var i = 0; i < array_length(global.floor_scanned_terms); i++) {
            var _ft = global.floor_scanned_terms[i];
            if (!variable_struct_exists(_seen, _ft.id)) {
                _seen[$ _ft.id] = true;
                array_push(_out, _ft);
            }
        }
    }

    // 2. Terms already unlocked in the player's Homeroom Codex
    for (var g = 0; g < array_length(global.cyber_glossary); g++) {
        var _gt = global.cyber_glossary[g];
        if (variable_struct_exists(global.codex_unlocked_terms, _gt.id) && !variable_struct_exists(_seen, _gt.id)) {
            _seen[$ _gt.id] = true;
            array_push(_out, _gt);
        }
    }

    // 3. Ensure at least 5 cross-branch options exist (prevents 1-option giveaways on a fresh save)
    var _fallback_ids = ["phishing", "password_reuse", "ransomware", "vpn", "tailgating", "caesar_cipher"];
    for (var f = 0; f < array_length(_fallback_ids); f++) {
        if (array_length(_out) >= 6) break;
        var _fid = _fallback_ids[f];
        if (!variable_struct_exists(_seen, _fid)) {
            for (var g2 = 0; g2 < array_length(global.cyber_glossary); g2++) {
                if (global.cyber_glossary[g2].id == _fid) {
                    _seen[$ _fid] = true;
                    array_push(_out, global.cyber_glossary[g2]);
                    break;
                }
            }
        }
    }
    return _out;
}

function scr_get_case_valid_policy_ids(_case_id) {
    switch (_case_id) {
        case 0:  return ["caesar_cipher", "vigenere_cipher", "atbash_cipher", "plaintext_ciphertext", "symmetric_asymmetric", "vpn", "password_manager"];
        case 1:  return ["phishing", "typosquatting", "oauth_permissions", "password_manager"];
        case 2:  return ["rat_malware", "malvertising", "shadow_it", "tech_support_scam"];
        case 3:  return ["vpn", "wpa_security", "public_wifi", "packet_sniffing"];
        case 4:  return ["credential_stuffing", "password_reuse", "mfa_2fa", "password_manager"];
        case 5:  return ["malvertising", "rat_malware", "shadow_it", "tech_support_scam"];
        case 6:  return ["usb_baiting", "tailgating", "shoulder_surfing"];
        case 7:  return ["pretexting", "vishing", "phishing", "typosquatting"];
        case 8:  return ["ransomware", "password_reuse", "credential_stuffing", "phishing"];
        case 9:  return ["mfa_2fa", "mfa_fatigue", "oauth_permissions", "rat_malware"];
        default: return ["phishing"];
    }
}

function scr_validate_case_policy_citation(_term_struct, _case_id) {
    if (!is_struct(_term_struct)) {
        return {
            ok:  false,
            msg: "POLICY CITATION REQUIRED: Click [+ ATTACH CODEX POLICY] (or press [P]) to cite a Codex concept before submitting!"
        };
    }
    var _valid_ids   = scr_get_case_valid_policy_ids(_case_id);
    var _floor_bkey  = variable_global_exists("floor_branch_key") ? global.floor_branch_key : scr_get_case_branch_key(_case_id);
    var _floor_bname = scr_get_branch_display_name(_floor_bkey);

    for (var i = 0; i < array_length(_valid_ids); i++) {
        if (_term_struct.id == _valid_ids[i]) {
            return {
                ok:  true,
                msg: "POLICY VERIFIED: '" + _term_struct.term + "' (" + _term_struct.branch_name + ") matches this incident!"
            };
        }
    }
    if (_term_struct.branch_name == _floor_bname) {
        return {
            ok:  false,
            msg: "CLOSE! '" + _term_struct.term + "' is in " + _floor_bname + ", but look for the specific concept that directly matches this floor's breach!"
        };
    }
    return {
        ok:  false,
        msg: "POLICY MISMATCH: '" + _term_struct.term + "' is " + _term_struct.branch_name + ", whereas this breach involves " + _floor_bname + ". Attach the matching policy!"
    };
}

// =============================================================================
// VISUAL / ANIMATED MECHANIC TUTORIALS (LOW TEXT CLUTTER, HIGH VISUAL CLARITY)
// =============================================================================
function scr_ensure_tutorial_flags() {
    if (!variable_global_exists("tut_seen_terms"))     global.tut_seen_terms     = false;
    if (!variable_global_exists("tut_seen_bot"))       global.tut_seen_bot       = false;
    if (!variable_global_exists("tut_seen_scrap"))     global.tut_seen_scrap     = false;
    if (!variable_global_exists("tut_seen_brig"))      global.tut_seen_brig      = false;
    if (!variable_global_exists("tut_seen_breaker"))   global.tut_seen_breaker   = false;
    if (!variable_global_exists("homeroom_tour_done")) global.homeroom_tour_done = false;
    if (!variable_global_exists("visual_tut_kind"))    global.visual_tut_kind    = "";
}

function scr_draw_visual_mechanic_tutorial(_kind, _gui_w, _gui_h) {
    if (_kind == "") return;

    var _t   = (current_time / 1000.0);
    var _cy  = _gui_h * 0.5;
    var _cx  = _gui_w * 0.5;
    var _pw  = 460;
    var _ph  = 212;
    var _x1  = _cx - _pw * 0.5;
    var _y1  = _cy - _ph * 0.5;
    var _x2  = _cx + _pw * 0.5;
    var _y2  = _cy + _ph * 0.5;

    draw_set_alpha(0.76);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(0.97);
    draw_set_color(make_color_rgb(12, 18, 32));
    draw_rectangle(_x1, _y1, _x2, _y2, false);
    draw_set_alpha(1.0);
    draw_set_color(c_aqua);
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    draw_rectangle(_x1 + 2, _y1 + 2, _x2 - 2, _y2 - 2, true);

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    var _title = "MECHANIC VISUAL GUIDE";
    var _sub   = "";
    var _ay    = _y1 + 102;

    if (_kind == "clickable_terms") {
        _title = "VISUAL GUIDE: CLICKABLE CYBER TERMS";
        _sub   = "Click glowing [? Term] badges -> Read Quick Popup -> Study full entry in Homeroom [C]";

        var _step = floor(_t * 0.9) mod 3;
        // 1. Glowing [? Phishing] pill
        draw_set_color(_step == 0 ? make_color_rgb(28, 75, 110) : make_color_rgb(18, 34, 62));
        draw_rectangle(_cx - 195, _ay - 16, _cx - 85, _ay + 16, false);
        draw_set_color(_step == 0 ? c_yellow : c_aqua);
        draw_rectangle(_cx - 195, _ay - 16, _cx - 85, _ay + 16, true);
        draw_text_transformed(_cx - 140, _ay, "[? Phishing]", 0.66, 0.66, 0);

        // Animated pointer arrow
        if (_step == 0) {
            var _bob = sin(_t * 8) * 3;
            draw_set_color(c_yellow);
            draw_triangle(_cx - 140, _ay + 20 + _bob, _cx - 146, _ay + 28 + _bob, _cx - 134, _ay + 28 + _bob, false);
        }

        draw_set_color(c_white);
        draw_text_transformed(_cx - 66, _ay, "->", 0.85, 0.85, 0);

        // 2. Quick Popup
        draw_set_color(_step == 1 ? make_color_rgb(20, 56, 86) : make_color_rgb(14, 24, 42));
        draw_rectangle(_cx - 48, _ay - 24, _cx + 58, _ay + 24, false);
        draw_set_color(_step == 1 ? c_yellow : c_aqua);
        draw_rectangle(_cx - 48, _ay - 24, _cx + 58, _ay + 24, true);
        draw_text_transformed(_cx + 5, _ay - 8, "QUICK POPUP", 0.56, 0.56, 0);
        draw_set_color(c_lime);
        draw_text_transformed(_cx + 5, _ay + 8, "[+] Archived!", 0.54, 0.54, 0);

        draw_set_color(c_white);
        draw_text_transformed(_cx + 76, _ay, "->", 0.85, 0.85, 0);

        // 3. Homeroom Codex
        draw_set_color(_step == 2 ? make_color_rgb(22, 65, 52) : make_color_rgb(14, 28, 38));
        draw_rectangle(_cx + 94, _ay - 22, _cx + 204, _ay + 22, false);
        draw_set_color(_step == 2 ? c_lime : c_aqua);
        draw_rectangle(_cx + 94, _ay - 22, _cx + 204, _ay + 22, true);
        draw_text_transformed(_cx + 149, _ay - 7, "[C] CODEX", 0.62, 0.62, 0);
        draw_set_color(c_white);
        draw_text_transformed(_cx + 149, _ay + 9, "Deep Dive (Homeroom)", 0.48, 0.48, 0);

    } else if (_kind == "security_bot") {
        _title = "VISUAL GUIDE: SECURITY BOTS & STEALTH";
        _sub   = "Directional red edge glow = Bot direction!  You have 2.5s in its beam—hide in [E] Lockers or behind walls!";

        var _sw = sin(_t * 2.4);
        var _bx = _cx - 80 + _sw * 35;
        // Bot & sweeping cone
        draw_set_alpha(0.35);
        draw_set_color(c_red);
        draw_triangle(_bx, _ay, _bx + 68, _ay - 24, _bx + 68, _ay + 24, false);
        draw_set_alpha(1.0);
        draw_set_color(c_red);
        draw_circle(_bx, _ay, 8, false);
        draw_set_color(c_white);
        draw_text_transformed(_bx, _ay - 16, "BOT", 0.52, 0.52, 0);

        // 2.5s Detection Bar
        var _fill = frac(_t * 0.35);
        draw_set_color(c_black);
        draw_rectangle(_cx - 30, _ay + 28, _cx + 30, _ay + 34, false);
        draw_set_color((_fill > 0.7) ? c_red : c_yellow);
        draw_rectangle(_cx - 30, _ay + 28, _cx - 30 + 60 * _fill, _ay + 34, false);
        draw_set_color(c_white);
        draw_text_transformed(_cx, _ay + 43, "2.5s Detection Grace", 0.52, 0.52, 0);

        // Blue Locker safe zone on right
        draw_set_color(make_color_rgb(20, 60, 110));
        draw_rectangle(_cx + 120, _ay - 26, _cx + 168, _ay + 26, false);
        draw_set_color(c_aqua);
        draw_rectangle(_cx + 120, _ay - 26, _cx + 168, _ay + 26, true);
        draw_text_transformed(_cx + 144, _ay - 6, "LOCKER", 0.58, 0.58, 0);
        draw_set_color(c_lime);
        draw_text_transformed(_cx + 144, _ay + 10, "[E] HIDE", 0.54, 0.54, 0);

    } else if (_kind == "scrapping") {
        _title = "VISUAL GUIDE: WRENCH SCRAPPING (GREEN ZONE)";
        _sub   = "Right-Click [RMB] or [R] on PCs -> Need 2 Scrap for Breaker, finish in 4-6 GREEN ZONE!";

        var _sc_n = 1 + (floor(_t * 1.4) mod 6);
        var _in_g = (_sc_n >= 4 && _sc_n <= 6);

        // Terminal -> Wrench icon
        draw_set_color(make_color_rgb(26, 40, 60));
        draw_rectangle(_cx - 175, _ay - 22, _cx - 95, _ay + 22, false);
        draw_set_color(c_aqua);
        draw_rectangle(_cx - 175, _ay - 22, _cx - 95, _ay + 22, true);
        draw_text_transformed(_cx - 135, _ay - 7, "TERMINAL", 0.58, 0.58, 0);
        draw_set_color(c_yellow);
        draw_text_transformed(_cx - 135, _ay + 9, "[RMB / R]", 0.56, 0.56, 0);

        draw_set_color(c_white);
        draw_text_transformed(_cx - 72, _ay, "->", 0.85, 0.85, 0);

        // Animated 0..8 Compliance Bar with 4-6 Green Zone
        var _bx1 = _cx - 45;
        var _bw  = 220;
        for (var _seg = 0; _seg < 8; _seg++) {
            var _sx1 = _bx1 + _seg * (_bw / 8);
            var _sx2 = _sx1 + (_bw / 8) - 2;
            var _is_g = (_seg >= 3 && _seg <= 5);
            var _lit  = (_seg < _sc_n);
            draw_set_color(_lit ? (_is_g ? c_lime : c_orange) : make_color_rgb(24, 30, 42));
            draw_rectangle(_sx1, _ay - 12, _sx2, _ay + 12, false);
            draw_set_color(_is_g ? c_lime : make_color_rgb(70, 90, 115));
            draw_rectangle(_sx1, _ay - 12, _sx2, _ay + 12, true);
        }
        draw_set_color(_in_g ? c_lime : c_white);
        draw_text_transformed(_bx1 + _bw * 0.5, _ay + 26, "SCRAPPED: " + string(_sc_n) + " / 4-6 GREEN ZONE", 0.60, 0.60, 0);

    } else if (_kind == "brig") {
        _title = "HOLDING CELL (BRIG) — HOW TO ESCAPE";
        _sub   = "1. Read the Math Terminal [E] inside this cell   2. Solve for X   3. Decode the Brig Door [E]!";

        draw_set_color(make_color_rgb(24, 42, 64));
        draw_rectangle(_cx - 160, _ay - 22, _cx - 40, _ay + 22, false);
        draw_set_color(c_aqua);
        draw_rectangle(_cx - 160, _ay - 22, _cx - 40, _ay + 22, true);
        draw_text_transformed(_cx - 100, _ay - 7, "MATH PC [E]", 0.62, 0.62, 0);
        draw_set_color(c_white);
        draw_text_transformed(_cx - 100, _ay + 9, "X = (3*3) - 6", 0.54, 0.54, 0);

        draw_set_color(c_white);
        draw_text_transformed(_cx, _ay, "->", 0.85, 0.85, 0);

        draw_set_color(make_color_rgb(56, 32, 18));
        draw_rectangle(_cx + 40, _ay - 22, _cx + 160, _ay + 22, false);
        draw_set_color(make_color_rgb(255, 165, 55));
        draw_rectangle(_cx + 40, _ay - 22, _cx + 160, _ay + 22, true);
        draw_text_transformed(_cx + 100, _ay - 7, "BRIG DOOR [E]", 0.62, 0.62, 0);
        draw_set_color(c_lime);
        draw_text_transformed(_cx + 100, _ay + 9, "Shift by X!", 0.56, 0.56, 0);

    } else if (_kind == "breaker") {
        _title = "VISUAL GUIDE: POWER BREAKER (3 FUSES)";
        _sub   = "1. Spend 2 Scrap to repair relay   2. Flip ON the 2 VALID cipher pairs   3. Leave FAULTY pair OFF!";

        var _f_lbls = ["FUSE 1: VALID", "FUSE 2: FAULTY", "FUSE 3: VALID"];
        var _f_on   = [true, false, true];
        var _f_x    = [_cx - 125, _cx, _cx + 125];
        for (var _fi = 0; _fi < 3; _fi++) {
            var _fx = _f_x[_fi];
            var _ok = _f_on[_fi];
            draw_set_color(_ok ? make_color_rgb(16, 46, 32) : make_color_rgb(48, 22, 24));
            draw_rectangle(_fx - 52, _ay - 24, _fx + 52, _ay + 24, false);
            draw_set_color(_ok ? c_lime : make_color_rgb(255, 110, 80));
            draw_rectangle(_fx - 52, _ay - 24, _fx + 52, _ay + 24, true);
            draw_text_transformed(_fx, _ay - 8, _f_lbls[_fi], 0.54, 0.54, 0);
            draw_text_transformed(_fx, _ay + 9, _ok ? "SWITCH: ON" : "SWITCH: OFF", 0.58, 0.58, 0);
        }
    }

    draw_set_color(c_yellow);
    draw_text_transformed(_cx, _y1 + 22, _title, 0.86, 0.86, 0);
    draw_set_color(make_color_rgb(205, 225, 245));
    draw_text_ext_transformed(_cx, _y1 + 44, _sub, 14, (_pw - 36) / 0.66, 0.66, 0.66, 0);

    draw_set_color(c_lime);
    draw_text_transformed(_cx, _y2 - 18, "[E / ENTER / CLICK] Got It!", 0.72, 0.72, 0);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

// =============================================================================
// 7-BEAT LIVE PRESENTATION DEMONSTRATION MODE (TELEPROMPTER & SAFETY NETS)
// =============================================================================
function scr_start_demonstration_mode() {
    scr_init_cyber_glossary();
    scr_ensure_cyber_stats();
    scr_ensure_tutorial_flags();

    global.demo_mode_active   = true;
    global.demo_guide_beat    = 1;
    global.demo_hud_minimized = false;

    // 1. Unlock all 3 Chapters & all 10 Floors
    global.unlock_all_ciphers  = true;
    global.vigenere_unlocked   = true;
    global.atbash_unlocked     = true;
    global.chapter_best_floor  = [10, 10, 10];
    global.dungeon_chapter     = CHAPTER_CAESAR;
    global.chapter_floor       = 1;
    global.intern_duty_flagged = false;

    // 2. Unlock all 34 Cybersecurity Codex entries
    for (var _gi = 0; _gi < array_length(global.cyber_glossary); _gi++) {
        global.codex_unlocked_terms[$ global.cyber_glossary[_gi].id] = true;
    }
    global.codex_new_count = 0;

    // 3. Populate realistic 5-Branch Competency Mastery stats (so Mastery Bars & 2x Adaptive Weighting shine)
    global.cyber_stats = {
        social_eng:   { correct: 4, total: 5 },
        identity:     { correct: 4, total: 5 },
        malware:      { correct: 3, total: 4 },
        network_phys: { correct: 2, total: 4 },
        crypto:       { correct: 5, total: 5 }
    };

    // 4. Give presenter starter kit & suppress unprompted tutorial interruptions
    global.player_cash                  = 500;
    global.scrap_count                  = 4;
    global.hr_scrap_count               = 4;
    global.rare_cores                   = 2;
    global.statues_owned                = [true, false, false];
    global.statues_pending              = [false, false, false];
    global.equipped_statues             = [0, -1, -1];
    global.chapter_select_tutorial_seen = true;
    global.homeroom_tour_done           = true;
    global.tut_seen_terms               = true;
    global.tut_seen_bot                 = true;
    global.tut_seen_scrap               = true;
    global.tut_seen_brig                = true;
    global.tut_seen_breaker             = true;
    global.visual_tut_kind              = "";

    if (instance_exists(obj_codex_manager)) {
        obj_codex_manager.tab_locked = [false, false, false, false, false];
    }
}

function scr_update_demo_mode_state() {
    if (!variable_global_exists("demo_mode_active") || !global.demo_mode_active) return;
    if (!variable_global_exists("demo_guide_beat"))    global.demo_guide_beat    = 1;
    if (!variable_global_exists("demo_hud_minimized")) global.demo_hud_minimized = false;

    // Keyboard controls for Presenter Teleprompter:
    // [F2] Minimize/Expand, [ / ] Previous/Next Beat, [Shift + D] Exit Demo Mode
    if (keyboard_check_pressed(vk_f2)) {
        global.demo_hud_minimized = !global.demo_hud_minimized;
        if (asset_get_type("snd_button_click") == asset_sound) audio_play_sound(snd_button_click, 6, false);
    }
    if (keyboard_check_pressed(219)) { // '['
        global.demo_guide_beat = max(1, global.demo_guide_beat - 1);
        if (asset_get_type("snd_button_hover") == asset_sound) audio_play_sound(snd_button_hover, 6, false);
    }
    if (keyboard_check_pressed(221)) { // ']'
        global.demo_guide_beat = min(7, global.demo_guide_beat + 1);
        if (asset_get_type("snd_button_hover") == asset_sound) audio_play_sound(snd_button_hover, 6, false);
    }
    if (keyboard_check(vk_shift) && keyboard_check_pressed(ord("D"))) {
        global.demo_mode_active = false;
        if (asset_get_type("snd_button_click") == asset_sound) audio_play_sound(snd_button_click, 6, false);
        return;
    }

    // Automatic context-aware Beat progression so the teleprompter follows the presenter naturally
    if (room == rm_cipher_select) {
        if (global.demo_guide_beat > 2) global.demo_guide_beat = 1;
    } else if (room == rm_homeroom) {
        if (global.demo_guide_beat < 2) global.demo_guide_beat = 2;
    } else if (room == dungeon_test) {
        if (instance_exists(obj_dungeon_victory)) {
            global.demo_guide_beat = 7;
        } else if (variable_global_exists("incident_solved") && global.incident_solved) {
            if (global.demo_guide_beat < 6) global.demo_guide_beat = 6;
        } else if (variable_global_exists("pc_screen_open") && global.pc_screen_open
                && variable_global_exists("pc_screen_mode") && global.pc_screen_mode >= 1) {
            if (global.demo_guide_beat < 5) global.demo_guide_beat = 5;
        } else if (variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key) {
            if (global.demo_guide_beat < 4) global.demo_guide_beat = 4;
        } else if (global.demo_guide_beat < 3) {
            global.demo_guide_beat = 3;
        }
    }
}

function scr_demo_warp_to_beat(_beat) {
    if (instance_exists(obj_transition) && obj_transition.fade_mode != "none") return;

    if (_beat == 1) {
        global.demo_guide_beat = 2;
        room_goto(rm_homeroom);
        return;
    }
    if (_beat == 2) {
        if (room != rm_homeroom) {
            room_goto(rm_homeroom);
            return;
        }
        if (instance_exists(obj_codex_manager) && !obj_codex_manager.is_open) {
            obj_codex_manager.is_open        = true;
            obj_codex_manager.current_branch = 4; // CRYPTOGRAPHY
            obj_codex_manager.content_scroll = 0;
            obj_codex_manager.sidebar_scroll = 0;
            var _b4 = obj_codex_manager.get_branch_terms(4);
            obj_codex_manager.current_concept = 0;
            for (var _i = 0; _i < array_length(_b4); _i++) {
                if (_b4[_i].id == "symmetric_asymmetric") {
                    obj_codex_manager.current_concept = _i;
                    break;
                }
            }
            return;
        }
        if (instance_exists(obj_codex_manager)) obj_codex_manager.is_open = false;
        global.dungeon_chapter     = CHAPTER_CAESAR;
        global.chapter_floor       = 1;
        global.intern_duty_flagged = false;
        global.demo_guide_beat     = 3;
        room_goto(dungeon_test);
        return;
    }

    // Beats 3..7 take place inside dungeon_test
    if (room != dungeon_test) {
        global.dungeon_chapter     = CHAPTER_CAESAR;
        global.chapter_floor       = 1;
        global.intern_duty_flagged = false;
        room_goto(dungeon_test);
        return;
    }

    if (!instance_exists(obj_jack)) return;

    if (_beat == 3) {
        // Warp to Gold Key Vault Quiz Lock or Pedestal
        if (instance_exists(obj_door_quiz_lock)) {
            with (obj_door_quiz_lock) {
                if (locked) {
                    obj_jack.x = draw_x + 8;
                    obj_jack.y = draw_y + 24;
                    return;
                }
            }
        }
        if (instance_exists(obj_caesar_key_pedestal)) {
            obj_jack.x = obj_caesar_key_pedestal.x + 8;
            obj_jack.y = obj_caesar_key_pedestal.y + 22;
        }
        global.demo_guide_beat = 4;
    } else if (_beat == 4) {
        global.has_dungeon_cipher_key = true;
        global.scrap_count            = max(4, global.scrap_count);
        global.hr_scrap_count         = 4;
        // Warp near a patrol bot / locker in the hallway
        with (obj_dungeon_prop) {
            if (prop_type == TILE_PROP_LOCKER) {
                obj_jack.x = x + 8;
                obj_jack.y = y + 22;
                break;
            }
        }
        global.demo_guide_beat = 5;
    } else if (_beat == 5) {
        global.has_dungeon_cipher_key = true;
        global.scrap_count            = max(4, global.scrap_count);
        global.hr_scrap_count         = 4;
        // Reveal Level 1 & 2 evidence and warp directly to Patient Zero's desk terminal
        if (variable_global_exists("case_evidence") && is_array(global.case_evidence)) {
            var _fnd = 0;
            for (var _ei = 0; _ei < array_length(global.case_evidence); _ei++) {
                if (global.case_evidence[_ei].tier <= 2) {
                    global.case_evidence[_ei].found = true;
                }
                if (global.case_evidence[_ei].found) _fnd++;
            }
            global.evidence_found = _fnd;
        }
        with (obj_dungeon_prop) {
            if (prop_type == TILE_PROP_PC && suspect_idx == global.case_culprit_idx) {
                obj_jack.x = x + 8;
                obj_jack.y = y + 22;
                break;
            }
        }
    } else if (_beat == 6) {
        global.has_dungeon_cipher_key = true;
        global.incident_solved        = true;
        global.scrap_count            = max(4, global.scrap_count);
        global.hr_scrap_count         = clamp(global.hr_scrap_count, 4, 6);
        global.intern_duty_flagged    = false;
        with (obj_door_caesar_lock) { locked = false; }

        if (!variable_global_exists("lockdown_overridden") || !global.lockdown_overridden) {
            with (obj_dungeon_prop) {
                if (prop_type == TILE_PROP_OVERRIDE) {
                    obj_jack.x = x + 8;
                    obj_jack.y = y + 22;
                    return;
                }
            }
        } else if (!variable_global_exists("power_restored") || !global.power_restored) {
            with (obj_dungeon_prop) {
                if (prop_type == TILE_PROP_BREAKER) {
                    obj_jack.x = x + 8;
                    obj_jack.y = y + 22;
                    return;
                }
            }
        } else {
            global.demo_guide_beat = 7;
            if (!instance_exists(obj_dungeon_victory)) {
                instance_create_depth(0, 0, -15000, obj_dungeon_victory);
            }
        }
    } else if (_beat == 7) {
        global.hr_scrap_count      = clamp(global.hr_scrap_count, 4, 6);
        global.intern_duty_flagged = false;
        if (!instance_exists(obj_dungeon_victory)) {
            instance_create_depth(0, 0, -15000, obj_dungeon_victory);
        }
    }
}

function scr_draw_demo_teleprompter_hud(_gui_w, _gui_h) {
    if (!variable_global_exists("demo_mode_active") || !global.demo_mode_active) return;
    if (room == rm_menu) return;

    var _beat = clamp(variable_global_exists("demo_guide_beat") ? global.demo_guide_beat : 1, 1, 7);
    var _min  = (variable_global_exists("demo_hud_minimized") && global.demo_hud_minimized);
    var _mx   = device_mouse_x_to_gui(0);
    var _my   = device_mouse_y_to_gui(0);

    var _titles = [
        "",
        "BEAT 1/7: PREMISE & CHAPTER SELECT",
        "BEAT 2/7: HOMEROOM & CROSS-LINKED CODEX",
        "BEAT 3/7: KEY VAULT LOG & KEY CALIBRATION",
        "BEAT 4/7: BOT STEALTH & 4-6 GREEN ZONE SCRAP",
        "BEAT 5/7: DESK AUDIT & 'CITE SOURCE' CASE BOARD",
        "BEAT 6/7: LOCKDOWN OVERRIDE, BREAKER & ELEVATOR",
        "BEAT 7/7: DEBRIEF, PAYSTUB & ADAPTIVE MASTERY"
    ];
    var _do_lines = [
        "",
        "DO: Point out 3 Chapters (Caesar/Vigenere/Atbash) & 1-10 Floors -> Press [H] or [WARP >] for Homeroom.",
        "DO: Press [C] -> Click cyan 'Symmetric' inside text -> [< BACK] -> Close [C] & enter Floor 1 [WARP >].",
        "DO: Show [M] Radar & [+ Term] pill -> Unlock Gold Key Vault [E] ([* DEMO]) -> Calibrate Key [E] (Ctrl+P).",
        "DO: Approach Bot for directional red edge glow & [E] Locker -> Scrap PC [RMB/R] (Ctrl+P) into 4-6 Green Zone.",
        "DO: Audit [E] Patient Zero desk ([* DEMO]) -> Open [TAB] Case Board -> Steps 1-3 + [P] Attach Codex Policy.",
        "DO: Red Override Console [E] (Ctrl+P) -> Power Breaker [E] (2 Scrap + 2 Valid Fuses, Ctrl+P) -> Elevator!",
        "DO: Complete Safety Check (+$50, [* DEMO]) -> Show Paystub & 5-Branch Mastery Bars (2x adaptive weight)."
    ];
    var _say_lines = [
        "",
        "SAY: 'SKIPJACK teaches cybersecurity & 3 ciphers across 10 scaffolded floors per chapter.'",
        "SAY: 'All 34 concepts auto-archive into 5 branches, with clickable hyperlinked sub-terms inside descriptions.'",
        "SAY: 'You inspect a forensic log to open the Key Vault, then calibrate the cipher key across 3 difficulty tiers.'",
        "SAY: 'Directional red glow warns of bots without harsh flashing; salvage must stay in the 4-6 Green Zone.'",
        "SAY: 'Innocent desks have benign red herrings (-$75 fine); Step 3 requires citing the matching Codex policy.'",
        "SAY: 'Override flips decryption into encryption under a trace timer; fixing the breaker auto-unlocks the elevator.'",
        "SAY: 'Every floor updates 5-branch mastery and gives 2x spawn weight to your weakest branch on the next floor.'"
    ];

    if (_min) {
        var _mw1 = 158;
        var _mh1 = 18;
        var _mx2 = _gui_w - 8;
        var _mx1 = _mx2 - _mw1;
        var _my2 = _gui_h - 4;
        var _my1 = _my2 - _mh1;
        var _hov_m = (_mx >= _mx1 && _mx <= _mx2 && _my >= _my1 && _my <= _my2);

        draw_set_alpha(0.90);
        draw_set_color(_hov_m ? make_color_rgb(30, 56, 86) : make_color_rgb(12, 22, 38));
        draw_rectangle(_mx1, _my1, _mx2, _my2, false);
        draw_set_alpha(1.0);
        draw_set_color(make_color_rgb(255, 215, 65));
        draw_rectangle(_mx1, _my1, _mx2, _my2, true);
        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed((_mx1 + _mx2) * 0.5, (_my1 + _my2) * 0.5, "[*] DEMO BEAT " + string(_beat) + "/7 [F2]", 0.54, 0.54, 0);
        if (_hov_m && mouse_check_button_pressed(mb_left)) {
            global.demo_hud_minimized = false;
            if (asset_get_type("snd_button_click") == asset_sound) audio_play_sound(snd_button_click, 6, false);
        }
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
        return;
    }

    var _cw  = 342;
    var _ch  = 54;
    var _cx2 = _gui_w - 6;
    var _cx1 = _cx2 - _cw;
    var _cy1 = (room == rm_homeroom) ? 44 : 6;
    var _cy2 = _cy1 + _ch;

    draw_set_alpha(0.92);
    draw_set_color(make_color_rgb(10, 18, 32));
    draw_rectangle(_cx1, _cy1, _cx2, _cy2, false);
    draw_set_alpha(1.0);
    draw_set_color(make_color_rgb(255, 215, 65));
    draw_rectangle(_cx1, _cy1, _cx2, _cy2, true);

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(255, 220, 75));
    draw_text_transformed(_cx1 + 6, _cy1 + 9, "[*] " + _titles[_beat], 0.54, 0.54, 0);

    // Header mini buttons: [<] [>] [WARP >] [F2] [X]
    var _bx = _cx2 - 126;
    var _by = _cy1 + 3;
    var _bh = 13;
    var _btns = [
        { lbl: "<",      w: 16, act: "prev" },
        { lbl: ">",      w: 16, act: "next" },
        { lbl: "WARP >", w: 42, act: "warp" },
        { lbl: "F2",     w: 22, act: "min"  },
        { lbl: "X",      w: 16, act: "exit" }
    ];
    draw_set_halign(fa_center);
    for (var _bi = 0; _bi < array_length(_btns); _bi++) {
        var _b   = _btns[_bi];
        var _bx2 = _bx + _b.w;
        var _bhov = (_mx >= _bx && _mx <= _bx2 && _my >= _by && _my <= _by + _bh);
        draw_set_color(_bhov ? make_color_rgb(42, 86, 128) : make_color_rgb(20, 36, 58));
        draw_rectangle(_bx, _by, _bx2, _by + _bh, false);
        draw_set_color(_bhov ? c_yellow : c_aqua);
        draw_rectangle(_bx, _by, _bx2, _by + _bh, true);
        draw_set_color(_bhov ? c_yellow : c_white);
        draw_text_transformed((_bx + _bx2) * 0.5, _by + _bh * 0.5, _b.lbl, 0.46, 0.46, 0);

        if (_bhov && mouse_check_button_pressed(mb_left)) {
            if (asset_get_type("snd_button_click") == asset_sound) audio_play_sound(snd_button_click, 6, false);
            if (_b.act == "prev") global.demo_guide_beat = max(1, _beat - 1);
            if (_b.act == "next") global.demo_guide_beat = min(7, _beat + 1);
            if (_b.act == "warp") scr_demo_warp_to_beat(_beat);
            if (_b.act == "min")  global.demo_hud_minimized = true;
            if (_b.act == "exit") global.demo_mode_active   = false;
        }
        _bx = _bx2 + 3;
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var _do_sc  = min(0.49, (_cw - 12) / max(1, string_width(_do_lines[_beat])));
    var _say_sc = min(0.48, (_cw - 12) / max(1, string_width(_say_lines[_beat])));
    draw_set_color(c_aqua);
    draw_text_transformed(_cx1 + 6, _cy1 + 20, _do_lines[_beat], _do_sc, _do_sc, 0);
    draw_set_color(make_color_rgb(215, 235, 250));
    draw_text_transformed(_cx1 + 6, _cy1 + 33, _say_lines[_beat], _say_sc, _say_sc, 0);
    draw_set_color(make_color_rgb(145, 225, 165));
    draw_text_transformed(_cx1 + 6, _cy1 + 44, "SHORTCUTS: [Ctrl+P] Auto-Solve Minigame  |  [ / ] Change Beat  |  [WARP >] Jump", 0.45, 0.45, 0);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
