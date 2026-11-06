/// @description Dungeon Generation — Global Constants
/// All dungeon system constants are defined here as macros.

// ---------------------------------------------------------------------------
// Tile type identifiers (used inside 9x9 room template arrays)
// ---------------------------------------------------------------------------
#macro TILE_VOID          -1   // Structural building void / outer wall mass
#macro TILE_FLOOR          0   // Standard corporate floor tile
#macro TILE_WALL           1   // Corporate interior wall cell
#macro TILE_DOOR           2   // Open doorway / threshold tile
#macro TILE_LOCK_QUIZ      3   // Doorway locked by a Cybersecurity Question
#macro TILE_LOCK_CAESAR    4   // Doorway locked by a Caesar Cipher encryption
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

// ---------------------------------------------------------------------------
// Logic-map room type identifiers (used in obj_dungeon_generator's grid)
// ---------------------------------------------------------------------------
#macro ROOM_NONE          -1   // Slot is unoccupied (default)
#macro ROOM_START          1   // Security Reception / Starting Lobby
#macro ROOM_NORMAL         2   // Office / Apartment Room branching off the hallway
#macro ROOM_END            3   // Corporate Extraction Elevator Room
#macro ROOM_CAESAR_KEY     4   // Locked IT Key Vault containing the Caesar cipher key
#macro ROOM_CAESAR_LOCKED  5   // Mainframe sector locked behind a Caesar cipher door
#macro ROOM_HALLWAY        6   // Central building hallway spine connecting all rooms
#macro ROOM_HOLDING        7   // Security Detention / Holding Room where drones send Jack if caught

// ---------------------------------------------------------------------------
// Spatial configuration
// ---------------------------------------------------------------------------
#macro CHUNK_SIZE   9   // Tiles per room chunk (width AND height)
#macro TILE_SIZE    16  // Pixels per tile (16x16)

// ---------------------------------------------------------------------------
// Logic grid dimensions (number of room slots, not pixels)
// ---------------------------------------------------------------------------
#macro LOGIC_GRID_W 10  // Logic map width  in room-slots
#macro LOGIC_GRID_H 10  // Logic map height in room-slots

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
/// @function scr_get_floor_incident_case(_case_idx)
/// @description Returns a complete Cybersecurity Incident Case struct for the floor.
///              All terminals, memos, coworker NPCs, and the Key Vault Quiz on the
///              floor teach and test this cohesive cybersecurity topic.
// ---------------------------------------------------------------------------
function scr_get_floor_incident_case(_case_idx) {
    var _cases = [
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
            word:     "CAESAR",
            title:    "Alphabet Shift Cipher",
            scenario: "Classical cipher that shifts every letter in the alphabet by a fixed key:",
            hint:     "Named after Roman leader Julius Caesar.",
            takeaway: "TIP: Caesar ciphers only have 25 keys—easy for computers to crack!",
            npc_clues: [
                "The hackers encrypted the doors with a 2,000-year-old Roman cipher that shifts every letter in the alphabet!",
                "If the shift key is +3, then 'A' becomes 'D'—and you shift 3 steps back to decrypt it!",
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
    var _hk     = scr_roll_cipher_key();
    var _tries  = 0;
    while (_hk == _main_k && _tries < 20) {
        _hk = scr_roll_cipher_key();
        _tries++;
    }
    global.holding_cipher_key = _hk;

    // Build a multi-step arithmetic / algebra equation whose solution is _hk
    var _variant = irandom(2);
    var _eq_str  = "";
    if (_variant == 0) {
        // Form: (a * b) - c = _hk
        var _a = irandom_range(3, 6);
        var _b = irandom_range(2, 5);
        var _c = (_a * _b) - _hk;
        _eq_str = "SHIFT KEY (X)  =  (" + string(_a) + " * " + string(_b) + ") - " + string(_c);
    } else if (_variant == 1) {
        // Form: (a / b) + c = _hk  or  (a / b) - c = _hk
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
        // Form: 2X + c = rhs  ->  Solve for X
        var _c   = irandom_range(4, 12);
        var _rhs = (2 * _hk) + _c;
        _eq_str = "Solve for Shift Key (X):    2X + " + string(_c) + "  =  " + string(_rhs);
    }

    global.holding_math_clue = _eq_str;
}
