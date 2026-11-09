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
    var _clues_needed     = 2;
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
        _side_rooms       = 8;
        _encrypted_decoys = 2; // 2 extra encrypted rooms so player explores all encrypted doors to find Elevator!
        _room_extensions  = 3; // Multi-chunk long rooms & annex filler rooms
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
        _clues_needed     = 2;
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
        _clues_needed     = 2;
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
        _clues_needed     = 2;
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
        _clues_needed     = 2;
        _guided_ui        = false;
        _hide_shift_match = true;
        _is_final_exam    = true;
    }

    // 2. Chapter-Specific Lesson Titles & Onboarding Dialogue
    if (_ch == CHAPTER_CAESAR) {
        if (_flr == 1) {
            _objective_title = "Guided Lesson: Forward Alphabet Shifts (+1 to +3)";
            _mentor_intro = [
                "Welcome to Chapter 1 (Caesar Cipher)! On Floors 1 to 3, I'll guide you step-by-step.",
                "Step 1: Find 1 Clue [E] to unlock the Gold Key Vault and get the floor's Shift Key.",
                "Step 2: Unlock the Security Room & hit the Lockdown Override Button, then flip the Power Breaker to unlock the Elevator!"
            ];
        } else if (_flr == 2) {
            _objective_title = "Guided Lesson: Reverse Alphabet Shifts (-1 to -3)";
            _mentor_intro = [
                "Tutorial Floor 2/3! Caesar keys can also be NEGATIVE (-1 to -3), shifting letters backward toward 'A'.",
                "Find 1 Clue to open the Key Vault, then follow the green guide on the ruler to shift backward!"
            ];
        } else if (_flr == 3) {
            _objective_title = "Guided Lesson: Security Drones, Lockers & Brig Math";
            _mentor_intro = [
                "Tutorial Floor 3/3! Watch out—a rogue Security Drone is now patrolling the main hallway.",
                "Press [E] on blue Hallway Lockers to hide when it passes! If caught, solve the Brig's math clue to escape."
            ];
        } else if (_flr <= 6) {
            _objective_title = "Caesar Practice: Decode Locks Using the A-Z Ruler";
        } else if (_flr <= 9) {
            _objective_title = "Caesar Mastery: Count Shifts Without Slot Previews";
        } else {
            _objective_title = "CHAPTER 1 FINAL EXAM: Caesar Cipher & Cyber Mastery";
            _mentor_intro = [
                "This is Floor 10 — the CHAPTER 1 FINAL EXAM! All training wheels and ruler hints are off.",
                "Crack the 5-letter Exam Lock on the Extraction Elevator to pass Chapter 1 and unlock Vigenere!"
            ];
        }
    }
    else if (_ch == CHAPTER_VIGENERE) {
        if (_flr == 1) {
            _objective_title = "Guided Lesson: 2-Letter Keyword Shifts (B=+1, C=+2...)";
            _mentor_intro = [
                "Welcome to Chapter 2 (Vigenere Cipher)! Instead of one shift number, Vigenere uses a KEYWORD.",
                "Each letter in the keyword gives its own shift: A = +0, B = +1, C = +2, D = +3, E = +4, F = +5.",
                "Find 1 Clue to open the Key Vault, calibrate the Keyword, and follow the green guide on the door lock!"
            ];
        } else if (_flr == 2) {
            _objective_title = "Guided Lesson: Repeating 3-Letter Keywords (CAB / BED)";
            _mentor_intro = [
                "Tutorial Floor 2/3! When a 3-letter keyword like 'CAB' encrypts a 4-letter word, the keyword repeats: C-A-B-C.",
                "Watch the purple Keyword badge above each slot—it tells you that slot's exact shift!"
            ];
        } else if (_flr == 3) {
            _objective_title = "Guided Lesson: Vigenere Field Stealth & Lockers";
            _mentor_intro = [
                "Tutorial Floor 3/3! Security drones are back on patrol—use Hallway Lockers [E] to stay unseen.",
                "Gather 2 Clues, calibrate this floor's 3-letter Vigenere Keyword, and decode the Elevator!"
            ];
        } else if (_flr <= 6) {
            _objective_title = "Vigenere Practice: Apply Repeating Keyword Shifts";
        } else if (_flr <= 9) {
            _objective_title = "Vigenere Mastery: Independent Polyalphabetic Decoding";
        } else {
            _objective_title = "CHAPTER 2 FINAL EXAM: 4-Letter Keyword Mastery";
            _mentor_intro = [
                "Welcome to Floor 10 — the CHAPTER 2 FINAL EXAM! You'll face a 4-letter Vigenere Keyword with no slot hints.",
                "Clear this sector to master the Vigenere Cipher and unlock Chapter 3 (Atbash Mirror Cipher)!"
            ];
        }
    }
    else {
        if (_flr == 1) {
            _objective_title = "Guided Lesson: The Atbash Mirror Alphabet (A <-> Z)";
            _mentor_intro = [
                "Welcome to Chapter 3 (Atbash Cipher)! Atbash folds the alphabet in half like a mirror.",
                "The first letter 'A' swaps with the last letter 'Z', 'B' swaps with 'Y', all the way to 'M' <-> 'N'!",
                "Find 1 Clue, calibrate the Mirror Decoder in the Vault, and use the green guide to unlock the Elevator!"
            ];
        } else if (_flr == 2) {
            _objective_title = "Guided Lesson: Inner Mirror Pairs (G <-> T to M <-> N)";
            _mentor_intro = [
                "Tutorial Floor 2/3! Every letter on the top row (A..M) maps directly to the letter below it (Z..N).",
                "Look at the 2-row Mirror Bar in the lock UI—the green highlight shows the exact reflection!"
            ];
        } else if (_flr == 3) {
            _objective_title = "Guided Lesson: Mirror Decoding Under Drone Patrol";
            _mentor_intro = [
                "Tutorial Floor 3/3! Drones are patrolling the corridor again—use Lockers [E] to dodge their beams.",
                "Gather 2 Clues, activate the Atbash Mirror Key in the Vault, and reflect the Elevator code!"
            ];
        } else if (_flr <= 6) {
            _objective_title = "Atbash Practice: Decode Using the 2-Row Mirror Bar";
        } else if (_flr <= 9) {
            _objective_title = "Atbash Mastery: Partial Mirror Bar (Recall Opposite Pairs)";
        } else {
            _objective_title = "CHAPTER 3 FINAL EXAM: Pure Atbash Mirror Mastery";
            _mentor_intro = [
                "This is Floor 10 — the CHAPTER 3 FINAL EXAM! The bottom row of the Mirror Bar is hidden.",
                "Use pure Atbash recall (A<->Z, M<->N) to crack the 5-letter Exam Lock and beat the game!"
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

    // Case 9 dynamically reinforces the active chapter's cipher!
    var _cipher_case = {
        word:     "CAESAR",
        title:    "Alphabet Shift Cipher",
        scenario: "Classical cipher that shifts every letter in the alphabet by a fixed key:",
        hint:     "Named after Roman leader Julius Caesar.",
        takeaway: "TIP: Caesar ciphers only have 25 keys—easy for computers to crack!",
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
        ]
    };

    if (_ch == CHAPTER_VIGENERE) {
        _cipher_case = {
            word:     "VIGENERE",
            title:    "Polyalphabetic Keyword Cipher",
            scenario: "Cipher that uses a repeating KEYWORD to shift each letter by a different amount:",
            hint:     "Uses a repeating keyword (A=0, B=1, C=2...) instead of a single shift.",
            takeaway: "TIP: Vigenere resists simple frequency analysis by using multiple shifts!",
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
            ]
        };
    } else if (_ch == CHAPTER_ATBASH) {
        _cipher_case = {
            word:     "ATBASH",
            title:    "Alphabet Mirror Cipher",
            scenario: "Ancient substitution cipher that folds the alphabet like a mirror (A<->Z, B<->Y):",
            hint:     "Swaps the first letter (A) with the last (Z), second (B) with second-to-last (Y).",
            takeaway: "TIP: Atbash has no secret key—anyone who knows the mirror rule can decode it!",
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
            ]
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
            ]
        },
        {
            word:     "TROJAN",
            title:    "Disguised Malware App",
            scenario: "Malware disguised as a harmless, useful program:",
            hint:     "Hides inside a normal-looking app (like the Trojan Horse).",
            takeaway: "TIP: Only download apps from official, verified sources!",
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
            ]
        },
        {
            word:     "FIREWALL",
            title:    "Network Traffic Barrier",
            scenario: "The security barrier that monitors and blocks unauthorized network traffic:",
            hint:     "Blocks suspicious traffic between your network and the internet.",
            takeaway: "TIP: Keep your Firewall enabled to block unauthorized connections!",
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
            ]
        },
        {
            word:     "BOTNET",
            title:    "Hijacked Device Army",
            scenario: "A network of hijacked 'zombie' computers controlled remotely by a hacker:",
            hint:     "'Robot' + 'Network' — an army of infected devices.",
            takeaway: "TIP: Change default passwords on smart devices to stop Botnets!",
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
            ]
        },
        {
            word:     "SPYWARE",
            title:    "Hidden Keylogger",
            scenario: "Malicious software that secretly watches your screen and records keystrokes:",
            hint:     "Acts like a hidden spy to steal your passwords.",
            takeaway: "TIP: Scan regularly for hidden background keyloggers and Spyware!",
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
            ]
        },
        {
            word:     "MALWARE",
            title:    "Malicious Software",
            scenario: "The general umbrella term for any 'Malicious Software' built to harm a PC:",
            hint:     "Short for MALicious + softWARE.",
            takeaway: "TIP: Never plug unknown USB drives into your computer!",
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
            ]
        },
        {
            word:     "SPOOFING",
            title:    "Fake Caller / Sender ID",
            scenario: "Faking a trusted email address, caller ID, or IP address to impersonate someone:",
            hint:     "Disguising an untrusted sender's identity as a trusted one.",
            takeaway: "TIP: Display names and caller IDs can be faked—verify through a second channel!",
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
            ]
        },
        {
            word:     "RANSOM",
            title:    "Locked Files Extortion",
            scenario: "Attack that encrypts a victim's files and demands payment to unlock them:",
            hint:     "Holds your data hostage until a payment (ransom) is made.",
            takeaway: "TIP: Keep offline backups of critical data so you never have to pay a ransom!",
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
            ]
        },
        {
            word:     "BACKDOOR",
            title:    "Secret Bypass Entry",
            scenario: "A hidden entrance left in software that bypasses normal login security:",
            hint:     "Like a secret unlocked 'back door' into a building's system.",
            takeaway: "TIP: Audit code and remove default test accounts to close hidden backdoors!",
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
            ]
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

    // 3. Visual A-Z Ruler at Top
    var _strip_y  = _y1 + 80;
    var _cell_w   = 20;
    var _strip_w  = 26 * _cell_w;
    var _strip_x1 = _cx - _strip_w * 0.5;

    draw_set_color(make_color_rgb(22, 26, 40));
    draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, false);
    draw_set_color(make_color_rgb(80, 95, 130));
    draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, true);

    var _slot_idx   = global.override_slot;
    var _src_ch     = string_char_at(global.override_plain, _slot_idx + 1);
    var _src_idx    = ord(_src_ch) - ord("A");
    var _usr_ch     = global.override_input[_slot_idx];
    var _usr_idx    = (_usr_ch != "") ? (ord(_usr_ch) - ord("A")) : -1;
    var _target_ch  = string_char_at(global.override_target, _slot_idx + 1);
    var _target_idx = ord(_target_ch) - ord("A");

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

    // 4. Two Signal Encryption Slots + Big Red Override Button
    var _slots_y = _y1 + 162;
    for (var _i = 0; _i < 2; _i++) {
        var _scx  = (_cx - 115) + _i * 82;
        var _pch  = string_char_at(global.override_plain, _i + 1);
        var _u_ch = global.override_input[_i];

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

    for (var _k = ord("A"); _k <= ord("Z"); _k++) {
        if (keyboard_check_pressed(_k)) {
            global.override_input[_slot_idx] = chr(_k);
            global.override_msg = "";
            audio_play_sound(select1, 8, false);
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

    // 3. Visual A-Z Ruler Highlighting the Active Fuse's Start -> End Pair
    var _strip_y  = _y1 + 80;
    var _cell_w   = 20;
    var _strip_w  = 26 * _cell_w;
    var _strip_x1 = _cx - _strip_w * 0.5;

    draw_set_color(make_color_rgb(20, 26, 40));
    draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, false);
    draw_set_color(make_color_rgb(70, 95, 130));
    draw_rectangle(_strip_x1 - 5, _strip_y - 14, _strip_x1 + _strip_w + 5, _strip_y + 14, true);

    var _act_fuse  = global.breaker_fuses[global.breaker_slot];
    var _f_s_idx   = ord(_act_fuse.start_ch) - ord("A");
    var _f_e_idx   = ord(_act_fuse.end_ch)   - ord("A");

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

        // Fuse Title (with Keyword Letter in Chapter 2)
        var _f_title = "FUSE #" + string(_fi + 1);
        if (_ch == CHAPTER_VIGENERE && _has_key) {
            var _kw_c = string_char_at(_vig_key, (_fi mod string_length(_vig_key)) + 1);
            _f_title += " (Key '" + _kw_c + "')";
        }
        draw_set_color(_is_sel ? c_yellow : make_color_rgb(175, 195, 220));
        draw_text_transformed(_fcx, _cards_y - 29, _f_title, 0.78, 0.78, 0);

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
    global.hr_scrap_limit         = 3;
    global.breaker_repaired       = false;
    global.scrap_ui_open          = false;
    global.bot_grapple_active     = false;
    global.task_bots_scrapped     = 0;
    global.task_servers_scrapped  = 0;
    global.floor_scrap_collected  = 0;
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
    var _strip_y    = _y1 + 92;
    var _cell_w     = 20;
    var _strip_w    = 26 * _cell_w;
    var _strip_x1   = _cx - _strip_w * 0.5;
    var _slot_idx   = global.scrap_slot;
    var _src_ch     = string_char_at(global.scrap_plain, _slot_idx + 1);
    var _src_idx    = ord(_src_ch) - ord("A");
    var _usr_ch     = global.scrap_input[_slot_idx];
    var _usr_idx    = (_usr_ch != "") ? (ord(_usr_ch) - ord("A")) : -1;
    var _target_ch  = string_char_at(global.scrap_target, _slot_idx + 1);
    var _target_idx = ord(_target_ch) - ord("A");

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

    // 5. Two Node Encryption Slots + Wrench Scrap Action Button
    var _slots_y = _y1 + 174;
    for (var _i = 0; _i < 2; _i++) {
        var _scx  = (_cx - 115) + _i * 82;
        var _pch  = string_char_at(global.scrap_plain, _i + 1);
        var _u_ch = global.scrap_input[_i];

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

    for (var _k = ord("A"); _k <= ord("Z"); _k++) {
        if (keyboard_check_pressed(_k)) {
            global.scrap_input[_slot_idx] = chr(_k);
            global.scrap_msg = "";
            audio_play_sound(select1, 8, false);
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

            var _over_limit = (global.hr_scrap_count > global.hr_scrap_limit);
            if (_over_limit) {
                global.intern_duty_flagged = true;
            }

            if (instance_exists(global.scrap_target_inst)) {
                global.scrap_target_inst.is_scrapped     = true;
                global.scrap_target_inst.is_fried        = false;
                global.scrap_target_inst.grapple_active  = false;
                global.scrap_target_inst.scrap_pop_timer = 95;
                global.scrap_target_inst.scrap_pop_text  = (_rare > 0)
                    ? ("+" + string(_yield) + " SCRAP  +1 CORE!")
                    : ("+" + string(_yield) + " SCRAP!");
            }

            global.scrap_col   = _over_limit ? make_color_rgb(255, 110, 95) : c_lime;
            global.scrap_msg   = _over_limit
                ? ("SCRAPPED (+" + string(_yield) + " Scrap)!  HR LIMIT EXCEEDED (" + string(global.hr_scrap_count) + "/3) -> INTERN DUTY FLAGGED!")
                : ("UPLINK SEVERED & SCRAPPED!  +" + string(_yield) + " Scrap  (HR Limit: " + string(global.hr_scrap_count) + "/3)");
            global.scrap_win_t = 55;
            audio_play_sound(snd_objective_complete, 10, false);
        } else {
            // WRONG ENCRYPTION -> Copper Surge Totem shield (once per floor) or ANTI-TAMPER fries the circuits!
            scr_scrap_sever_fail(false);
        }
    }
}



