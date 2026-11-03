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
            title:    "Fake 'Urgent Login' Emails",
            scenario: "INCIDENT: Staff received a fake 'Urgent Password Reset' email from a spoofed domain that stole their logins. Name this attack:",
            hint:     "Fraudulent emails or fake websites that trick victims into handing over passwords.",
            takeaway: "REAL-WORLD DEFENSE: Always verify the sender's real domain and never click urgent password-reset links!",
            npc_clues: [
                "Greg here... I clicked an email from 'admin@skipjack-login-support.ru' saying my account would be deleted in 10 minutes. Kyle says that's called PHISHING—using fake emails to bait people into giving up passwords!",
                "Did you see that fake 'Free Holiday Bonus' email? Attackers use urgency or rewards to trick you into typing your login on a fake page. In cybersecurity, that attack is called PHISHING!",
                "I almost fell for the fake IT login page too, until I noticed the URL was misspelled! Remember the term for the Key Vault lock: deceptive emails stealing credentials is PHISHING!"
            ],
            pc_logs: [
                "[EMAIL FORENSICS]: Spoofed sender 'IT-Help@corpp-verify.net' detected. Attackers impersonated trusted staff to harvest credentials — a classic PHISHING attack.",
                "[BROWSER ALERT]: Blocked deceptive login page imitating internal portal. Classification: Credential Harvesting via PHISHING.",
                "[SECURITY TRAINING LOG]: Lesson #1 — PHISHING (pronounced 'fishing') uses fake emails as 'bait' to hook victims into revealing sensitive info."
            ],
            memo_notes: [
                "[STICKY NOTE]: 'Red flags of PHISHING: 1) Urgent threats or too-good-to-be-true rewards, 2) Misspelled sender domains, 3) Asking for your password or PIN!'",
                "[IT MEMO]: 'Quiz Vault Reminder: When hackers send fraudulent emails pretending to be someone you trust to steal data, the term is P-H-I-S-H-I-N-G.'"
            ]
        },
        {
            word:     "TROJAN",
            title:    "Disguised 'Calculator_Pro.exe' App",
            scenario: "INCIDENT: Someone installed a 'Free RAM Booster' app that looked harmless, but secretly opened a hacker backdoor. Name this malware:",
            hint:     "Malware disguised as legitimate, useful software that hides a malicious payload inside.",
            takeaway: "REAL-WORLD DEFENSE: Only download software from official, verified sources—free 'optimizers' or pirated apps often hide Trojans!",
            npc_clues: [
                "Someone in accounting downloaded 'Free_Spreadsheet_Turbo.exe'! It looked like a normal tool, but it secretly unlocked the building's backdoors. That's called a TROJAN—named after the wooden Trojan Horse!",
                "Unlike viruses that spread on their own, a TROJAN tricks you into installing it by pretending to be a helpful program or game!",
                "If the Gold Key Vault asks what hit our workstations today, remember: malware disguised as real, legitimate software is a TROJAN!"
            ],
            pc_logs: [
                "[PROCESS MONITOR]: 'Desktop_Clock_Widget.exe' is secretly opening port 4444 to an external hacker IP! Threat classification: TROJAN Horse.",
                "[ANTIVIRUS QUARANTINE]: File 'Free_PDF_Converter.exe' contains a hidden remote-access backdoor. Malware type: TROJAN.",
                "[CYBER GLOSSARY]: TROJAN — Malicious code hidden inside seemingly harmless software, just like soldiers hiding inside the wooden horse of Troy."
            ],
            memo_notes: [
                "[STICKY NOTE]: 'Never run random .exe files from unofficial download sites! A program that looks useful on the outside but hides malware inside is a TROJAN.'",
                "[IT MEMO]: 'Incident Summary: The breach began with disguised software hiding a backdoor payload — known in cybersecurity as a T-R-O-J-A-N.'"
            ]
        },
        {
            word:     "FIREWALL",
            title:    "Disabled Network Port Barrier",
            scenario: "INCIDENT: The security barrier that monitors and filters incoming/outgoing network traffic rules was turned off. Name this defense:",
            hint:     "A network security system that monitors and blocks unauthorized traffic between networks.",
            takeaway: "REAL-WORLD DEFENSE: Always keep your OS and router Firewalls enabled to block unauthorized incoming connections!",
            npc_clues: [
                "Someone disabled our network security barrier so they could host a LAN party at work, and the hackers walked right through! That barrier is called a FIREWALL!",
                "Think of a FIREWALL like a digital security guard at the building's front door—it checks every data packet against security rules and blocks suspicious traffic!",
                "Need the answer for the Gold Key Vault? The defense system that monitors and filters incoming and outgoing network traffic is a FIREWALL!"
            ],
            pc_logs: [
                "[NETWORK CONFIG]: CRITICAL WARNING — Inbound packet filter (FIREWALL) is currently OFF. All external ports are exposed to the public internet!",
                "[PACKET MONITOR]: A FIREWALL inspects network traffic between your private internal network and the outside internet, blocking unauthorized ports.",
                "[SYSADMIN LOG]: Rule #1 of network security: Never disable the FIREWALL in production!"
            ],
            memo_notes: [
                "[STICKY NOTE]: 'Just like a brick fire-wall stops flames from spreading between rooms, a network FIREWALL stops malicious traffic from entering our LAN!'",
                "[IT MEMO]: 'Key Vault Term: The security barrier that filters network traffic based on rules is a F-I-R-E-W-A-L-L.'"
            ]
        },
        {
            word:     "BOTNET",
            title:    "Army of Hijacked Smart Devices",
            scenario: "INCIDENT: Hackers infected 200 office PCs and smart printers, linking them into a remote-controlled 'zombie' army. Name this network:",
            hint:     "A network of infected computers/devices ('bots') remotely controlled by an attacker.",
            takeaway: "REAL-WORLD DEFENSE: Change default passwords on routers and smart IoT devices so hackers can't recruit them into a Botnet!",
            npc_clues: [
                "Even the breakroom smart fridge and the office printers got hijacked! When hackers link hundreds of infected devices together under remote control, it's called a BOTNET!",
                "The word BOTNET comes from 'Robot' + 'Network'. Each infected computer becomes a 'bot' or 'zombie' obeying the hacker's Command-and-Control server!",
                "Heading to the Gold Key Vault? Remember: a network of infected computers controlled remotely as a group is a BOTNET!"
            ],
            pc_logs: [
                "[TRAFFIC ANALYZER]: 240 office workstations and IoT cameras are simultaneously taking orders from an external Command & Control server. Diagnosis: BOTNET infection.",
                "[CYBER GLOSSARY]: BOTNET ('Bot' + 'Network') — A fleet of hijacked internet-connected devices used by attackers to launch massive DDoS floods.",
                "[IOT SECURITY LOG]: Smart thermostat still had default password 'admin/admin' and was recruited into the hacker's BOTNET."
            ],
            memo_notes: [
                "[STICKY NOTE]: 'One infected computer is a problem; thousands of infected computers linked together into a remote-controlled army is a BOTNET!'",
                "[IT MEMO]: 'Key Vault Term: A network of hijacked zombie devices controlled by a hacker is called a B-O-T-N-E-T.'"
            ]
        },
        {
            word:     "SPYWARE",
            title:    "Hidden Keylogger on Workstations",
            scenario: "INCIDENT: A silent background program recorded every keystroke and screen password without the user's knowledge. Name this software:",
            hint:     "Malicious software that secretly monitors user activity and steals private information.",
            takeaway: "REAL-WORLD DEFENSE: Use reputable anti-malware scanners and check startup processes to catch hidden Spyware and keyloggers!",
            npc_clues: [
                "How did the hackers know my new password 5 seconds after I typed it?! Kyle found a hidden keylogger on my PC—software that secretly watches and records you is called SPYWARE!",
                "Unlike ransomware that locks your screen right away, SPYWARE stays completely silent in the background so it can spy on your keystrokes, webcam, and passwords!",
                "For the Gold Key Vault quiz: software that secretly gathers your private information without your consent is SPYWARE!"
            ],
            pc_logs: [
                "[TASK MANAGER]: Hidden background process 'win_key_hook.dll' is logging all keyboard input and sending screenshots to an outside server. Classification: SPYWARE.",
                "[SECURITY AUDIT]: SPYWARE (including keyloggers) operates stealthily to harvest credentials, banking details, and browsing habits without consent.",
                "[PRIVACY ALERT]: Unauthorized microphone and keystroke monitoring detected — removing SPYWARE module."
            ],
            memo_notes: [
                "[STICKY NOTE]: 'If malware is secretly acting like a hidden spy—recording what you type and watching your screen—it is called SPYWARE!'",
                "[IT MEMO]: 'Key Vault Term: Software that covertly monitors user activity and steals data without consent is S-P-Y-W-A-R-E.'"
            ]
        },
        {
            word:     "MALWARE",
            title:    "The Parking Lot USB Drop",
            scenario: "INCIDENT: A harmful program from an unknown USB drive was designed to damage, exploit, and disable our servers. What is the umbrella term?",
            hint:     "Short for 'Malicious Software' — any program designed to harm or exploit a computer.",
            takeaway: "REAL-WORLD DEFENSE: Never plug unknown USB drives into your computer—'USB drop' attacks auto-launch Malware in seconds!",
            npc_clues: [
                "I found a USB drive in the lobby labeled 'Q4 Bonus Pay' and plugged it in... turns out it was loaded with MALWARE! That's short for Malicious Software!",
                "Viruses, Trojans, Spyware, and Ransomware are all part of one big family called MALWARE—any software intentionally written to harm or exploit a system!",
                "When you get to the Gold Key Vault, remember the umbrella term for any 'Malicious Software' designed to damage a system: MALWARE!"
            ],
            pc_logs: [
                "[USB PORT ALERT]: External drive auto-executed harmful payload! Threat category: MALWARE (Malicious Software).",
                "[CYBER GLOSSARY]: MALWARE = MALicious + softWARE. The general term for all hostile programs including viruses, worms, trojans, and spyware.",
                "[INCIDENT REPORT]: Hostile code attempting to corrupt system files and disable security services. Classification: MALWARE."
            ],
            memo_notes: [
                "[STICKY NOTE]: 'MALicious + softWARE = MALWARE! It's the umbrella term for any software built to harm, exploit, or hijack a computer.'",
                "[IT MEMO]: 'Key Vault Term: Any software intentionally designed to cause damage or unauthorized access is M-A-L-W-A-R-E.'"
            ]
        },
        {
            word:     "CAESAR",
            title:    "The Roman Alphabet Shift",
            scenario: "INCIDENT: The elevator lock encrypts words by shifting every letter a fixed number of steps down the alphabet. Name this classical cipher:",
            hint:     "A substitution cipher named after a Roman leader that shifts each letter by a fixed number.",
            takeaway: "REAL-WORLD CRYPTOGRAPHY: A Caesar cipher only has 25 possible keys, making it easy to break—modern encryption uses complex math keys!",
            npc_clues: [
                "The hackers locked the elevator with a cipher used over 2,000 years ago by Julius CAESAR! It works by shifting every letter in the alphabet by a fixed number!",
                "In a CAESAR cipher, if the shift key is +3, then 'A' shifts 3 spots forward to 'D', and to decrypt 'D' you shift 3 spots back to 'A'!",
                "The Gold Key Vault is testing your cryptography basics today: a cipher that shifts each letter of the alphabet by a fixed amount is a CAESAR cipher!"
            ],
            pc_logs: [
                "[CRYPTO ANALYSIS]: Door lock uses monoalphabetic shift substitution: E(x) = (x + k) mod 26. Historical name: CAESAR Cipher.",
                "[DECRYPTION GUIDE]: Named after Julius CAESAR, who used a shift of 3 to protect military messages. Today, 25 keys can be brute-forced instantly!",
                "[KEY VAULT LOG]: Retrieve the Shift Key from the Gold Vault to reverse the CAESAR cipher on the Extraction Elevator."
            ],
            memo_notes: [
                "[STICKY NOTE]: 'Julius CAESAR protected his battle plans by shifting every letter in the alphabet by a fixed number. That's why it's called the CAESAR Cipher!'",
                "[IT MEMO]: 'Key Vault Term: The classical substitution cipher that shifts letters by a fixed key is C-A-E-S-A-R.'"
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
