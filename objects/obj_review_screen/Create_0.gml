// --- obj_review_screen Create Event ---
// Standalone Review Mode overlay opened from the main menu REVIEW button.
// The in-game Codex (C key) is separate and untouched.

current_tab = 0;

// Each tab: { label, npc, content }
// "label"   -> shown on the tab button
// "npc"     -> attribution line ("As taught by <npc>")
// "content" -> full body text displayed in the reading pane
tabs = [
    {
        label: "Malware 101",
        npc:   "Breado",
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
            "a 'bot' or 'zombie' -- is remotely controlled by an attacker (the\n" +
            "'botmaster') without the device owner's knowledge.\n" +
            "\n" +
            "Botnets are used to send spam, launch Distributed Denial-of-Service\n" +
            "(DDoS) attacks, mine cryptocurrency, or spread more malware. Their\n" +
            "distributed nature makes them difficult to shut down entirely.\n" +
            "\n" +
            "SPYWARE\n" +
            "Spyware is software that secretly monitors and collects information\n" +
            "about a user or device without their consent. It can log keystrokes,\n" +
            "capture screenshots, record browsing habits, or harvest credentials.\n" +
            "\n" +
            "Unlike a virus, spyware typically does not replicate itself -- its\n" +
            "goal is stealth and long-term data collection. It often arrives\n" +
            "bundled with free software downloads or malicious e-mail attachments."
    },
    {
        label: "Cryptography",
        npc:   "Clipper",
        content:
            "WHAT IS CRYPTOGRAPHY?\n" +
            "Cryptography is the practice of securing information by transforming\n" +
            "it into an unreadable form for anyone who doesn't hold the correct\n" +
            "key. The readable original is called plaintext; the scrambled result\n" +
            "is ciphertext. The two core operations are encryption (plaintext to\n" +
            "ciphertext) and decryption (ciphertext back to plaintext).\n" +
            "\n" +
            "SYMMETRIC ENCRYPTION\n" +
            "In symmetric cryptography, both the sender and receiver share a\n" +
            "single secret key. That same key is used to encrypt and to decrypt.\n" +
            "This is fast and efficient -- ideal for large data transfers -- but\n" +
            "the challenge is safely delivering that shared key to both parties\n" +
            "without it being intercepted along the way.\n" +
            "\n" +
            "Common algorithms: AES, DES, ChaCha20.\n" +
            "\n" +
            "ASYMMETRIC ENCRYPTION\n" +
            "Asymmetric (or public-key) cryptography uses two mathematically\n" +
            "linked keys: a public key and a private key. The public key can be\n" +
            "shared freely -- anyone can use it to encrypt a message. Only the\n" +
            "holder of the matching private key can decrypt it.\n" +
            "\n" +
            "This solves the key-distribution problem. It is also the foundation\n" +
            "of digital signatures: the private key signs data and the public key\n" +
            "verifies that the signature is genuine.\n" +
            "\n" +
            "Common algorithms: RSA, ECC, Diffie-Hellman."
    },
    {
        label: "Caesar Cipher",
        npc:   "Lea",
        content:
            "WHAT IS THE CAESAR CIPHER?\n" +
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
            "attacker can try all of them in seconds -- this is why the Caesar\n" +
            "Cipher is used for education today, not for real security.\n" +
            "\n" +
            "ROTATION (WRAP-AROUND)\n" +
            "When shifting pushes past the end of the alphabet, the letters wrap\n" +
            "back to the beginning. This is modular arithmetic (mod 26). With a\n" +
            "shift of 3, the letter X (position 23) becomes A (position 0), Y\n" +
            "becomes B, and Z becomes C.\n" +
            "\n" +
            "The same wrap-around applies in reverse when you decrypt by\n" +
            "reversing the shift."
    }
];
