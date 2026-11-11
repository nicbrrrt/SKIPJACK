/// @description obj_dungeon_prop — Create Event
/// Renders and controls interactive dungeon props, terminals, memos, coworker NPCs, and rogue drones:
///   TILE_PROP_PC    (7)  = Corporate Computer Terminal (only has_clue == true terminals are inspectable)
///   TILE_PROP_CHAIR (8)  = Office chair (spr_class_chair)
///   TILE_PROP_PAPER (10) = Inspectable Scattered Lockdown Memo (spr_paper)
///   TILE_PROP_NPC   (12) = Stranded Corporate Coworker NPC
///   TILE_PROP_DRONE (13) = Roaming Rogue Security / Virus Drone (patrols Hallway centerline)

depth           = 24; // Below room fog (10) and Jack (-y), above floor (50)
prop_type       = TILE_PROP_PC;
has_clue        = false; // Only specific computers hold a clue & look distinct
is_holding_clue = false; // True for props inside ROOM_HOLDING (displays the Math Equation for the Holding Room key!)
sub_img     = irandom(11);
rot_angle   = choose(-12, 0, 8, 15);
log_variant = irandom(5);
talked_once = false;
player_near = false;

// Dialogue speaker defaults (used by create_textevent)
myName         = "Terminal";
myPortrait     = spr_jack_portrait;
myPortraitTalk = spr_jack_portrait;
myVoice        = snd_voice1;
myFont         = fnt_dialogue;

// Stranded Coworker NPC fields (configured when prop_type == TILE_PROP_NPC)
npc_id        = irandom(4);
npc_spr       = spr_npc1_idle;
idle_facing   = "down";
idle_anim_acc = random(10);
npc_frame     = 0;

// Rogue Security Drone fields (configured when prop_type == TILE_PROP_DRONE)
drone_spr   = choose(spr_virus_idle, spr_normalvirus_idle);
patrol_vx   = 0.95;
patrol_vy   = 0;
wp_index    = 1;
wp_dir      = 1;
hover_t     = random(100);
zap_cd      = 0;
init_done   = false;

// Wrench Scrapping, Anti-Tamper Circuit Fry & Bot Apprehension state
is_scrapped      = false; // True once severed & wrenched for Scrap
is_fried         = false; // True if wrong encryption triggered Anti-Tamper (costs 1 Scrap to fix)
is_server_rack   = false; // True for High-Yield Prototype Servers inside Encrypted Decoy Rooms (+3 Scrap)
grapple_active   = false; // True while player is mashing [E] behind this Security Bot
grapple_meter    = 0.45;  // 0.0 = Bot breaks free & busts Jack; 1.0 = Bot pinned -> Sever Encryption UI
can_sneak_ambush = false; // True when Jack is behind the bot outside its front vision cone
scrap_pop_timer  = 0;     // Floating world-space status text timer
scrap_pop_text   = "";

// Whodunit case dossier fields (assigned by scr_dungeon_spawn after the floor is built)
evidence_idx     = -1;    // >= 0: this prop delivers that piece of case evidence
suspect_idx      = -1;    // >= 0: this PC is that suspect's desk (accuse here!)
nameplate        = "";    // Desk nameplate shown on suspect desks
spawn_room_type  = -1;    // Room type this PC spawned in
spawn_in_enc     = false; // True if spawned inside an encrypted room
