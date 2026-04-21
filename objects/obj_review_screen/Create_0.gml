// --- obj_review_screen Create Event ---
// Standalone Review Mode overlay opened from the main menu REVIEW button.
// The in-game Codex (C key / obj_codex_manager) is separate and untouched.

current_tab    = 0;
current_module = 0;

// Tab structure: { label, locked, modules: [ { title, content } ] }
tabs = [

    // ── Tab 0: Cybersecurity (unlocked) ──────────────────────────────────
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

    // ── Tab 1: Caesar Cipher (unlocked) ──────────────────────────────────
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

    // ── Tab 2: Atbash Cipher (locked) ────────────────────────────────────
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
                    "No key is required -- the reversed alphabet IS the cipher. Anyone who\n" +
                    "knows the method can immediately decode any message, making it purely\n" +
                    "an educational tool today."
            },
            {
                title: "ENCRYPTION EXAMPLE",
                content:
                    "Apply the reversed-alphabet table to each letter in the message:\n" +
                    "\n" +
                    "  Plaintext:   H  E  L  L  O\n" +
                    "  Ciphertext:  S  V  O  O  L\n" +
                    "\n" +
                    "The same substitution table is used every time -- fixed and keyless.\n" +
                    "\n" +
                    "SELF-RECIPROCAL PROPERTY\n" +
                    "Atbash is its own inverse: apply it once to encrypt, apply it again\n" +
                    "to decrypt -- the same operation both ways. This is because the\n" +
                    "reversed-alphabet mapping undoes itself perfectly.\n" +
                    "\n" +
                    "  Encrypt HELLO  ->  SVOOL\n" +
                    "  Encrypt SVOOL  ->  HELLO"
            },
            {
                title: "PROPERTIES & WEAKNESS",
                content:
                    "HISTORICAL CONTEXT\n" +
                    "Atbash was originally used for the Hebrew alphabet and appears in the\n" +
                    "Book of Jeremiah in the Bible. Later it was adapted for the Latin\n" +
                    "alphabet. It represents one of the earliest recorded examples of a\n" +
                    "substitution cipher.\n" +
                    "\n" +
                    "NO SECRET KEY\n" +
                    "The algorithm itself is the only 'key.' Since there is just one\n" +
                    "possible mapping, any attacker who knows the cipher name can instantly\n" +
                    "decode every message -- there is nothing to keep secret.\n" +
                    "\n" +
                    "WEAKNESS\n" +
                    "Trivially broken. Offers zero cryptographic security for modern use.\n" +
                    "Its value today is purely educational -- understanding Atbash builds\n" +
                    "intuition for how substitution ciphers and key spaces work."
            }
        ]
    },

    // ── Tab 3: Vigenère Cipher (locked) ──────────────────────────────────
    {
        label:  "Vigenere Cipher",
        locked: true,
        modules: [
            {
                title: "HOW IT WORKS",
                content:
                    "The Vigenere Cipher extends the Caesar Cipher by applying MULTIPLE\n" +
                    "different shift values using a repeating keyword. Instead of every\n" +
                    "letter shifting by the same amount, each letter shifts by the value\n" +
                    "of the corresponding keyword letter.\n" +
                    "\n" +
                    "Letter values:  A=0  B=1  C=2 ... Z=25\n" +
                    "\n" +
                    "The keyword repeats across the full length of the message, so a short\n" +
                    "keyword can encrypt a very long message. This makes frequency analysis\n" +
                    "far more difficult than against a Caesar Cipher."
            },
            {
                title: "THE KEYWORD IN ACTION",
                content:
                    "Keyword: K E Y  ->  shift values: 10, 4, 24\n" +
                    "Message: H E L L O\n" +
                    "\n" +
                    "  H + K(10) = R\n" +
                    "  E + E(4)  = I\n" +
                    "  L + Y(24) = J\n" +
                    "  L + K(10) = V   <- keyword wraps back to start\n" +
                    "  O + E(4)  = S\n" +
                    "\n" +
                    "Ciphertext: R I J V S\n" +
                    "\n" +
                    "DECRYPTION\n" +
                    "Use the same keyword and shift each ciphertext letter BACKWARD by the\n" +
                    "matching keyword letter's value. This perfectly recovers the plaintext."
            },
            {
                title: "STRENGTH & THE KASISKI TEST",
                content:
                    "STRENGTH\n" +
                    "Because each plaintext letter is shifted by a different amount, the\n" +
                    "simple frequency analysis that breaks Caesar Cipher fails here. The\n" +
                    "same plaintext letter can produce many different ciphertext letters\n" +
                    "depending on its position relative to the keyword.\n" +
                    "\n" +
                    "WEAKNESS: THE KASISKI TEST\n" +
                    "If the same sequence of plaintext letters coincides with the same\n" +
                    "part of the keyword, it produces identical ciphertext. By finding\n" +
                    "repeated ciphertext sequences and measuring the distances between\n" +
                    "them, an analyst can deduce the keyword length.\n" +
                    "\n" +
                    "Once the key length is known, the cipher splits into several\n" +
                    "independent Caesar Ciphers -- each solvable by frequency analysis."
            }
        ]
    }
];
