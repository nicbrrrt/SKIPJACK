// --- Create Event of obj_codex_manager ---

persistent = true;

is_open        = false;
current_tab    = 0;
current_module = 0;

// Tab definitions — 4 subject tabs; last two are locked until unlocked by story
tab_names  = ["CYBERSECURITY", "CAESAR CIPHER", "ATBASH CIPHER", "VIGENERE CIPHER"];
tab_locked = [false, false, true, true];

// Per-tab module arrays (pre-loaded review content)
tab_modules = [

    // ── Tab 0: Cybersecurity (unlocked) ─────────────────────────────────
    [
        {
            title:   "WHAT IS CYBERSECURITY?",
            content: "Cybersecurity is the practice of protecting systems, networks, and programs from digital attacks.\n\nThese attacks aim to access, change, or destroy sensitive information, extort money, or disrupt normal operations.\n\nEvery device connected to the internet is a potential target."
        },
        {
            title:   "THE CIA TRIAD",
            content: "CONFIDENTIALITY: Keep data private — only authorized users may access it.\n\nINTEGRITY: Ensure data is accurate and untampered.\n\nAVAILABILITY: Keep systems and data accessible to authorized users whenever needed.\n\nThese three pillars form the foundation of every security policy."
        },
        {
            title:   "COMMON THREATS",
            content: "MALWARE: Malicious software designed to damage systems — includes viruses, ransomware, and spyware.\n\nPHISHING: Fake emails or sites that trick users into revealing passwords or personal data.\n\nSOCIAL ENGINEERING: Manipulating people psychologically to gain unauthorized access without breaking any code."
        },
        {
            title:   "ENCRYPTION BASICS",
            content: "Encryption converts readable PLAINTEXT into scrambled CIPHERTEXT using an algorithm and a key.\n\nSYMMETRIC: One shared key encrypts and decrypts. Fast, but the key must stay completely secret.\n\nASYMMETRIC: A public key encrypts; a matching private key decrypts. Safer for communicating over open networks."
        }
    ],

    // ── Tab 1: Caesar Cipher (unlocked) ─────────────────────────────────
    [
        {
            title:   "HOW IT WORKS",
            content: "The Caesar Cipher is one of the oldest known encryption techniques, named after Julius Caesar.\n\nEach letter in the message is SHIFTED a fixed number of positions down the alphabet.\n\nExample (shift 3):  A → D,  B → E,  Z wraps around → C."
        },
        {
            title:   "ENCRYPTION",
            content: "To ENCRYPT a message:\n1. Choose a shift value — this is your secret key.\n2. For each letter, move it FORWARD that many steps in the alphabet.\n3. Wrap from Z back to A as needed.\n\nShift 3 example:\n  Plaintext:  H E L L O\n  Ciphertext: K H O O R"
        },
        {
            title:   "DECRYPTION",
            content: "To DECRYPT a message:\n1. Obtain the same shift value used during encryption.\n2. For each letter, move it BACKWARD that many steps.\n3. Wrap from A back to Z when necessary.\n\nShift 3 example:\n  Ciphertext: K H O O R\n  Plaintext:  H E L L O"
        },
        {
            title:   "KEY FACTS & WEAKNESS",
            content: "SHIFT: The number of positions each letter moves — the only secret.\n\nROTATION: Wrapping past Z back to A uses modulo-26 arithmetic.\n\nOFFSET: Another common name for the shift value.\n\nWEAKNESS: Only 25 possible keys exist. An attacker can try all of them in seconds — this is called a brute-force attack."
        }
    ],

    // ── Tab 2: Atbash Cipher (locked) ────────────────────────────────────
    [
        {
            title:   "HOW IT WORKS",
            content: "The Atbash Cipher substitutes each letter with its mirror image in the alphabet.\n\nThe first letter maps to the last:  A ↔ Z\nThe second maps to the second-to-last:  B ↔ Y\n...and so on through the entire alphabet.\n\nNo key is required — the reversed alphabet IS the cipher."
        },
        {
            title:   "ENCRYPTION EXAMPLE",
            content: "Apply the reversed alphabet to every letter in the message:\n\n  A B C D E F G ... Z\n  Z Y X W V U T ... A\n\nPlaintext:  H E L L O\nCiphertext: S V O O L\n\nThe same substitution table is always used, making it fixed and keyless."
        },
        {
            title:   "PROPERTIES & WEAKNESS",
            content: "SELF-RECIPROCAL: Applying Atbash twice returns the original message. Encrypt once to get ciphertext; apply again to decrypt — same operation both ways.\n\nNO SECRET KEY: The algorithm itself is the only 'key,' so anyone who knows the method can instantly decode any message.\n\nWEAKNESS: Trivially broken — there is only one possible mapping."
        }
    ],

    // ── Tab 3: Vigenere Cipher (locked) ──────────────────────────────────
    [
        {
            title:   "HOW IT WORKS",
            content: "The Vigenere Cipher applies MULTIPLE Caesar shifts using a repeating keyword.\n\nEach letter of the plaintext is shifted by the value of the matching keyword letter.\n\nLetter values:  A=0  B=1  C=2 ... Z=25\n\nThe keyword repeats to cover the full length of the message."
        },
        {
            title:   "THE KEYWORD IN ACTION",
            content: "Keyword: K E Y  →  shifts: 10, 4, 24\nMessage: H E L L O\n\n  H + K(10) = R\n  E + E(4)  = I\n  L + Y(24) = J\n  L + K(10) = V   ← keyword wraps\n  O + E(4)  = S\n\nCiphertext: R I J V S"
        },
        {
            title:   "DECRYPTION",
            content: "To DECRYPT a Vigenere message:\n1. Use the exact same keyword.\n2. For each letter, shift BACKWARD by the keyword letter's value.\n3. Wrap from A to Z when needed.\n\nThis perfectly reverses the encryption and recovers the original plaintext."
        },
        {
            title:   "STRENGTH & WEAKNESS",
            content: "STRENGTH: Each plaintext letter is shifted differently, so simple frequency analysis (used to break Caesar) fails.\n\nWEAKNESS: If the keyword length is discovered, the cipher splits into several Caesar ciphers that can be solved individually.\n\nThe KASISKI TEST and INDEX OF COINCIDENCE are classical methods used to find the key length."
        }
    ]
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
