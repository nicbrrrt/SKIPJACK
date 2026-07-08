// --- obj_review_screen Create Event ---
// Main-menu CODEX / modules browser (separate from in-game C-key codex).

display_set_gui_size(window_get_width(), window_get_height());

current_tab    = 0;
current_module = 0;
content_scroll = 0;

// Layout cache (filled by review_refresh_layout)
card_x = 0; card_y = 0; card_w = 0; card_h = 0;
tab_h = 42; tab_w = 0; tab_cnt = 0; tab_strip_y = 0;
pad = 28;
content_y1 = 0; content_y2 = 0; body_x = 0; body_y = 0; body_w = 0; body_h = 0;
hint_y = 0;

function review_refresh_layout() {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    card_w = _gw * 0.82;
    card_h = _gh * 0.86;
    card_x = (_gw - card_w) * 0.5;
    card_y = (_gh - card_h) * 0.5;
    tab_cnt = array_length(tabs);
    tab_w   = card_w / tab_cnt;
    tab_strip_y = card_y + 30;
    hint_y      = card_y + card_h - 30;
    content_y1  = tab_strip_y + tab_h + 4;
    content_y2  = hint_y - 12;
    body_x      = card_x + pad;
    body_y      = content_y1 + 52;
    body_w      = card_w - pad * 2;
    body_h      = max(40, content_y2 - body_y);
}

function review_active_mod_count() {
    return array_length(tabs[current_tab].modules);
}

function review_active_mod() {
    var _mods = tabs[current_tab].modules;
    var _n = array_length(_mods);
    if (_n <= 0) return { title: "NO MODULES", content: "" };
    current_module = clamp(current_module, 0, _n - 1);
    return _mods[current_module];
}

function review_content_height(_text) {
    return string_height_ext(_text, 22, body_w);
}

function review_max_scroll(_text) {
    return max(0, review_content_height(_text) - body_h);
}

// Tab structure: { label, locked, modules: [ { title, content } ] }
tabs = [

    {
        label:  "Cybersecurity",
        locked: false,
        modules: [
            {
                title: "MALWARE",
                content:
                    "PHISHING\n" +
                    "Phishing is a social engineering attack where a malicious actor sends\n" +
                    "a fraudulent message -- usually an e-mail -- designed to trick you\n" +
                    "into revealing sensitive information like passwords, credit card\n" +
                    "numbers, or login credentials. The message often impersonates a\n" +
                    "trusted source such as your bank, a government agency, or a popular\n" +
                    "website.\n" +
                    "\n" +
                    "Red flags: urgent language, suspicious sender addresses, unexpected\n" +
                    "attachments, and links that don't match the real domain.\n" +
                    "\n" +
                    "BOTNET\n" +
                    "A botnet is a network of internet-connected devices that have been\n" +
                    "secretly compromised by malware. Once infected, each device -- called\n" +
                    "a 'bot' or 'zombie' -- is remotely controlled by an attacker without\n" +
                    "the device owner's knowledge. Botnets are used to send spam, launch\n" +
                    "DDoS attacks, mine cryptocurrency, or spread more malware.\n" +
                    "\n" +
                    "SPYWARE\n" +
                    "Spyware secretly monitors and collects information about a user or\n" +
                    "device without their consent. It can log keystrokes, capture\n" +
                    "screenshots, or harvest credentials -- all without replicating itself."
            },
            {
                title: "CRYPTOGRAPHY",
                content:
                    "WHAT IS CRYPTOGRAPHY?\n" +
                    "Cryptography secures information by transforming it into an unreadable\n" +
                    "form for anyone who doesn't hold the correct key. The readable original\n" +
                    "is called plaintext; the scrambled result is ciphertext. The two core\n" +
                    "operations are encryption (plaintext to ciphertext) and decryption\n" +
                    "(ciphertext back to plaintext).\n" +
                    "\n" +
                    "SYMMETRIC ENCRYPTION\n" +
                    "Both the sender and receiver share a single secret key used to both\n" +
                    "encrypt and decrypt. Fast and efficient for large data -- but the\n" +
                    "challenge is safely delivering that shared key without interception.\n" +
                    "Common algorithms: AES, DES, ChaCha20.\n" +
                    "\n" +
                    "ASYMMETRIC ENCRYPTION\n" +
                    "Uses two linked keys: a public key (shared freely, used to encrypt)\n" +
                    "and a private key (kept secret, used to decrypt). Solves the\n" +
                    "key-distribution problem and underpins digital signatures.\n" +
                    "Common algorithms: RSA, ECC, Diffie-Hellman."
            },
            {
                title: "THE CIA TRIAD & DEFENSES",
                content:
                    "THE CIA TRIAD\n" +
                    "Every security policy is built on three pillars:\n" +
                    "\n" +
                    "CONFIDENTIALITY -- Only authorized users can access protected data.\n" +
                    "Enforced through encryption, access controls, and authentication.\n" +
                    "\n" +
                    "INTEGRITY -- Data is accurate and has not been tampered with.\n" +
                    "Enforced through hashing, digital signatures, and audit logs.\n" +
                    "\n" +
                    "AVAILABILITY -- Systems and data remain accessible when needed.\n" +
                    "Enforced through redundancy, backups, and DDoS mitigation.\n" +
                    "\n" +
                    "COMMON DEFENSES\n" +
                    "Firewalls filter traffic between networks. Antivirus software detects\n" +
                    "known malware signatures. Multi-factor authentication (MFA) requires\n" +
                    "more than one proof of identity. Regular patching closes known\n" +
                    "vulnerabilities before attackers can exploit them."
            }
        ]
    },

    {
        label:  "Caesar Cipher",
        locked: false,
        modules: [
            {
                title: "WHAT IS THE CAESAR CIPHER?",
                content:
                    "The Caesar Cipher is one of the oldest known encryption techniques,\n" +
                    "named after Julius Caesar who reportedly used it to protect military\n" +
                    "communications. It is a substitution cipher: each letter in the\n" +
                    "plaintext is replaced by a letter a fixed number of positions further\n" +
                    "along the alphabet.\n" +
                    "\n" +
                    "SHIFT (OFFSET)\n" +
                    "The shift value -- also called the offset or key -- determines how\n" +
                    "many positions each letter moves. With a shift of 3:\n" +
                    "  A becomes D    B becomes E    Z becomes C\n" +
                    "\n" +
                    "To decrypt, shift every letter in the opposite direction by the same\n" +
                    "amount. Because there are only 25 non-trivial shift values, an\n" +
                    "attacker can try all of them in seconds."
            },
            {
                title: "ENCRYPTION & DECRYPTION",
                content:
                    "ENCRYPTING A MESSAGE\n" +
                    "1. Choose a shift value (your secret key).\n" +
                    "2. For each letter, move it FORWARD that many steps in the alphabet.\n" +
                    "3. Wrap from Z back to A when needed (modulo 26).\n" +
                    "\n" +
                    "Example -- shift of 3:\n" +
                    "  Plaintext:   H  E  L  L  O\n" +
                    "  Ciphertext:  K  H  O  O  R\n" +
                    "\n" +
                    "DECRYPTING A MESSAGE\n" +
                    "1. Use the same shift value.\n" +
                    "2. For each letter, move it BACKWARD that many steps.\n" +
                    "3. Wrap from A back to Z when needed.\n" +
                    "\n" +
                    "  Ciphertext:  K  H  O  O  R\n" +
                    "  Plaintext:   H  E  L  L  O"
            },
            {
                title: "ROTATION & WEAKNESS",
                content:
                    "ROTATION (WRAP-AROUND)\n" +
                    "When shifting pushes past the end of the alphabet, letters wrap back\n" +
                    "to the beginning. This is modular arithmetic (mod 26). With a shift\n" +
                    "of 3, X (position 23) becomes A (position 0), Y becomes B, Z becomes\n" +
                    "C. The same wrap applies in reverse during decryption.\n" +
                    "\n" +
                    "WEAKNESS: BRUTE FORCE\n" +
                    "There are only 25 possible non-trivial shift values. An attacker can\n" +
                    "try every one of them in seconds -- no computer required. This makes\n" +
                    "the Caesar Cipher completely insecure for real-world use.\n" +
                    "\n" +
                    "WEAKNESS: FREQUENCY ANALYSIS\n" +
                    "Because each letter always maps to the same ciphertext letter, the\n" +
                    "frequency pattern of a language (e.g. 'E' is most common in English)\n" +
                    "is preserved in the ciphertext, making it trivially crackable."
            }
        ]
    },

    {
        label:  "Atbash Cipher",
        locked: true,
        modules: [
            {
                title: "HOW IT WORKS",
                content:
                    "The Atbash Cipher is a simple substitution cipher originating from\n" +
                    "the Hebrew alphabet. Each letter is replaced by its mirror image in\n" +
                    "the alphabet -- the first letter maps to the last, the second to the\n" +
                    "second-to-last, and so on.\n" +
                    "\n" +
                    "  A B C D E F G H ... Z\n" +
                    "  Z Y X W V U T S ... A\n" +
                    "\n" +
                    "No key is required -- the reversed alphabet IS the cipher."
            }
        ]
    },

    {
        label:  "Vigenere Cipher",
        locked: true,
        modules: [
            {
                title: "HOW IT WORKS",
                content:
                    "The Vigenere Cipher extends the Caesar Cipher by applying MULTIPLE\n" +
                    "different shift values using a repeating keyword."
            }
        ]
    }
];

review_refresh_layout();
