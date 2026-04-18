// --- obj_review_screen Create Event ---
// Standalone Review Mode overlay opened from the main menu REVIEW button.
// Supports mouse-clickable main tabs, sub-tabs per topic, Back navigation,
// and mouse-wheel scrolling within content pages.
//
// Structure:
//   view_mode   : "tabs"    = main tab list visible
//               : "content" = sub-tabs + content for a selected topic
//   selected_tab: index into main_tabs (only meaningful in "content" mode)
//   current_sub : index of currently visible sub-tab
//   scroll_y    : vertical scroll offset (pixels) for body text
//   hovered_tab : index of hovered main tab (-1 if none)
//   hovered_sub : index of hovered sub-tab  (-1 if none)
//   hover_back  : true when mouse hovers the Back button

view_mode    = "tabs";
selected_tab = 0;
current_sub  = 0;
scroll_y     = 0;
hovered_tab  = -1;
hovered_sub  = -1;
hover_back   = false;

// ── Main tab definitions ─────────────────────────────────────────────────────
// Each entry has: label, npc, and sub_tabs array.
// sub_tabs: array of { title, content } structs.

main_tabs = [

    // ── Tab 0: Caesar's Cipher ───────────────────────────────────────────────
    {
        label: "Caesar's Cipher",
        npc:   "Lea",
        sub_tabs: [
            {
                title: "What is the Caesar Cipher?",
                content:
                    "The Caesar Cipher is one of the oldest known encryption techniques,\n" +
                    "named after Julius Caesar who reportedly used it to protect military\n" +
                    "communications. It is a substitution cipher: each letter in the\n" +
                    "plaintext is replaced by a letter a fixed number of positions further\n" +
                    "along the alphabet.\n\n" +
                    "Because it only shifts letters (not numbers or symbols) and has just\n" +
                    "25 possible keys, the Caesar Cipher is trivial to break today — but\n" +
                    "it remains the perfect starting point for understanding how ciphers work."
            },
            {
                title: "The Shift (Offset / Key)",
                content:
                    "The shift value — also called the offset or key — determines how many\n" +
                    "positions each letter moves forward in the alphabet.\n\n" +
                    "Example with shift = 3:\n" +
                    "  A → D     B → E     C → F\n" +
                    "  X → A     Y → B     Z → C\n\n" +
                    "To decrypt, simply shift every letter in the OPPOSITE direction by the\n" +
                    "same amount. With shift 3: D → A, E → B, F → C, and so on.\n\n" +
                    "Because there are only 25 non-trivial shift values, an attacker can\n" +
                    "try every single one in seconds — a technique called a brute-force\n" +
                    "attack or exhaustive key search."
            },
            {
                title: "Rotation & Wrap-Around",
                content:
                    "When shifting pushes past the end of the alphabet, the letters wrap\n" +
                    "back to the beginning. This is modular arithmetic (mod 26).\n\n" +
                    "With shift = 3:\n" +
                    "  X (position 23) → position 26 → wraps to position 0 → A\n" +
                    "  Y (position 24) → B\n" +
                    "  Z (position 25) → C\n\n" +
                    "The same wrap-around applies when decrypting in reverse:\n" +
                    "  A (position 0)  → position -3 → wraps to position 23 → X\n\n" +
                    "In code this is usually written as:  ((index + key) mod 26)"
            },
            {
                title: "In SkipJack",
                content:
                    "SkipJack uses the Caesar Cipher as its first cryptography challenge.\n\n" +
                    "When you face a Caesar Cipher puzzle:\n" +
                    "  1. You will be shown a 4-letter ciphertext word.\n" +
                    "  2. A shift key (between -5 and +5) was used to encrypt it.\n" +
                    "  3. Your job is to find the original plaintext.\n\n" +
                    "Strategy tip:\n" +
                    "  Start by trying shift = 1, then 2, 3 ... until you see a real word.\n" +
                    "  With only 10 possible keys in SkipJack's version, you can crack it\n" +
                    "  quickly by reasoning about common letter patterns."
            },
        ]
    },

    // ── Tab 1: Malware 101 ───────────────────────────────────────────────────
    {
        label: "Malware 101",
        npc:   "Breado",
        sub_tabs: [
            {
                title: "Phishing",
                content:
                    "Phishing is a social engineering attack where a malicious actor sends\n" +
                    "a fraudulent message — usually an e-mail — designed to trick you into\n" +
                    "revealing sensitive information like passwords, credit card numbers,\n" +
                    "or login credentials. The message often impersonates a trusted source\n" +
                    "such as your bank, a government agency, or a popular website.\n\n" +
                    "Red flags to watch for:\n" +
                    "  - Urgent or threatening language (\"Your account will be closed!\")\n" +
                    "  - Suspicious sender addresses (support@bank-secure-login.xyz)\n" +
                    "  - Unexpected attachments\n" +
                    "  - Links whose URL doesn't match the real domain\n\n" +
                    "When in doubt, go directly to the website by typing the address\n" +
                    "yourself rather than clicking any link in the message."
            },
            {
                title: "Botnet",
                content:
                    "A botnet is a network of internet-connected devices that have been\n" +
                    "secretly compromised by malware. Once infected, each device — called\n" +
                    "a 'bot' or 'zombie' — is remotely controlled by an attacker (the\n" +
                    "'botmaster') without the device owner's knowledge.\n\n" +
                    "What botnets are used for:\n" +
                    "  - Sending spam e-mail at massive scale\n" +
                    "  - Launching DDoS (Distributed Denial-of-Service) attacks\n" +
                    "  - Mining cryptocurrency\n" +
                    "  - Spreading more malware to new targets\n\n" +
                    "Their distributed nature — sometimes millions of devices — makes\n" +
                    "them difficult to shut down entirely. Keeping software up to date\n" +
                    "and using a reputable antivirus is the best defence."
            },
            {
                title: "Spyware",
                content:
                    "Spyware is software that secretly monitors and collects information\n" +
                    "about a user or device without their consent. It can log keystrokes\n" +
                    "(a keylogger), capture screenshots, record browsing habits, or\n" +
                    "harvest credentials.\n\n" +
                    "Unlike a virus, spyware typically does not replicate itself — its\n" +
                    "goal is stealth and long-term data collection. It often arrives\n" +
                    "bundled with free software downloads or malicious e-mail attachments.\n\n" +
                    "Signs of possible spyware:\n" +
                    "  - Device suddenly slows down\n" +
                    "  - Unexpected browser toolbars or homepage changes\n" +
                    "  - Unfamiliar programs appearing in your app list\n" +
                    "  - Increased network activity when idle"
            },
        ]
    },

    // ── Tab 2: Cryptography ──────────────────────────────────────────────────
    {
        label: "Cryptography",
        npc:   "Clipper",
        sub_tabs: [
            {
                title: "What is Cryptography?",
                content:
                    "Cryptography is the practice of securing information by transforming\n" +
                    "it into an unreadable form for anyone who doesn't hold the correct key.\n\n" +
                    "Key terms:\n" +
                    "  Plaintext   — the original, readable message\n" +
                    "  Ciphertext  — the scrambled, encrypted result\n" +
                    "  Encryption  — converting plaintext into ciphertext\n" +
                    "  Decryption  — converting ciphertext back into plaintext\n" +
                    "  Key         — the secret value used to encrypt and/or decrypt\n\n" +
                    "Cryptography is used everywhere: HTTPS web traffic, banking apps,\n" +
                    "password storage, messaging apps, and more. Without it, any data\n" +
                    "sent over the internet would be readable by anyone who intercepts it."
            },
            {
                title: "Symmetric Encryption",
                content:
                    "In symmetric cryptography, both the sender and the receiver share\n" +
                    "one secret key. That same key is used to both encrypt and decrypt.\n\n" +
                    "Advantages:\n" +
                    "  - Very fast — ideal for encrypting large amounts of data\n" +
                    "  - Simple conceptually (one key, two operations)\n\n" +
                    "Disadvantage:\n" +
                    "  - The key-distribution problem: both parties must securely share\n" +
                    "    the key before any encrypted communication can happen. If the\n" +
                    "    key is intercepted, all security is lost.\n\n" +
                    "Common algorithms: AES (Advanced Encryption Standard), DES, ChaCha20."
            },
            {
                title: "Asymmetric Encryption",
                content:
                    "Asymmetric (or public-key) cryptography uses two mathematically\n" +
                    "linked keys: a public key and a private key.\n\n" +
                    "  Public key  — shared freely; anyone can use it to ENCRYPT a message.\n" +
                    "  Private key — kept secret; only the owner can use it to DECRYPT.\n\n" +
                    "This solves the key-distribution problem: there is no secret to share\n" +
                    "in advance. Anyone can send you a message using your public key, but\n" +
                    "only you can read it with your private key.\n\n" +
                    "It is also the foundation of digital signatures: the private key\n" +
                    "signs data, and the public key verifies the signature is genuine.\n\n" +
                    "Common algorithms: RSA, ECC (Elliptic Curve Cryptography), Diffie-Hellman."
            },
        ]
    },
];
