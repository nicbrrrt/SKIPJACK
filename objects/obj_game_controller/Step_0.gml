/// Step Event - obj_game_controller

// While paused, handle pause-menu input only — skip world logic
if (global.is_paused) {
    if (mouse_locked_until_release) {
        if (!mouse_check_button(mb_left)) mouse_locked_until_release = false;
    }
    if (keyboard_check_pressed(vk_escape)) {
        if (pause_menu_state == "settings_ui" && instance_exists(obj_settings_ui)) {
            instance_destroy(obj_settings_ui);
            pause_menu_state = "main";
        } else {
            unpause_game();
        }
    }
    exit;
}

// --- JRPG ROOM TRANSITION HANDLER ---
if (room == rm_level_1 && global.last_battle_id == "greg_boss") {
    if (!instance_exists(obj_textevent)) {
        // Reset the ID so it doesn't loop, then TELEPORT
        global.last_battle_id             = "none";
        global.is_jrpg                    = true;
        global.battle_enemy_sprite        = spr_npc1_idle;
        global.battle_enemy_attack_sprite = spr_npc1_idle;
        global.return_room                = rm_level_1;
        room_goto(rm_battle_scramble);
        show_debug_message("CONTROLLER: Teleporting to JRPG Battle.");
    }
}

// --- FINAL BOSS SPAWN (both Lea + Clipper defeated) ---
if (room == rm_level_1
    && variable_global_exists("clipper_defeated") && global.clipper_defeated
    && variable_global_exists("lea_defeated")     && global.lea_defeated
    && !global.boss_spawned
    && !instance_exists(obj_final_boss_placeholder)) {
    global.boss_spawned = true;
    var _boss = instance_create_layer(640, 380, "Instances", obj_final_boss_placeholder);
    _boss.visible = false;
    if (instance_exists(obj_save_manager)) obj_save_manager.save_game();
    show_debug_message("CONTROLLER: Final boss spawned.");
    // Trigger camera pan to boss
    global.cam_pan_phase  = "pan_out";
    global.cam_pan_timer  = 0;
    global.cam_pan_from_x = instance_exists(obj_jack) ? clamp(obj_jack.x, global.cam_width/2, room_width - global.cam_width/2) : _boss.x;
    global.cam_pan_from_y = instance_exists(obj_jack) ? clamp(obj_jack.y, global.cam_height/2, room_height - global.cam_height/2) : _boss.y;
    global.cam_pan_to_x   = _boss.x;
    global.cam_pan_to_y   = _boss.y;
    if (!instance_exists(obj_textevent)) {
        create_textevent(["WARNING: Anomaly signal detected. Threat level: CRITICAL."], [_boss]);
    }
}

// Restore boss after loading save (spawned but fight not done)
if (room == rm_level_1
    && global.boss_spawned
    && !global.final_boss_defeated
    && !instance_exists(obj_final_boss_placeholder)) {
    var _boss = instance_create_layer(640, 380, "Instances", obj_final_boss_placeholder);
    _boss.visible = false;
    show_debug_message("CONTROLLER: Final boss restored from save.");
}

// --- FINAL BOSS PHASE 1 DEFEATED (overworld → JRPG transition) ---
if (room == rm_level_1 && global.last_battle_id == "final_boss_phase1_defeated") {
    global.last_battle_id = "none";
    boss_pending_jrpg = true;
    var _boss = instance_find(obj_final_boss_placeholder, 0);
    if (_boss != noone) {
        with (_boss) {
            if (!instance_exists(obj_textevent)) {
                create_textevent([
                    "Impressive... You've breached the outer layer.",
                    "But I am MORE than code and firewalls.",
                    "The CORE awaits you."
                ], [id, id, id]);
            }
        }
    }
}

// Auto-fire JRPG once the taunt dialogue closes
if (room == rm_level_1 && boss_pending_jrpg && !instance_exists(obj_textevent)) {
    boss_pending_jrpg = false;
    global.puzzle_word_list           = ["ANOMALY", "PROTOCOL", "ENCRYPT", "EXPLOIT", "PAYLOAD", "CIPHER"];
    global.puzzle_hint_list = [
        "System anomaly detected.",
        "Standard operating procedures.",
        "Scramble data for security.",
        "Take advantage of a weakness.",
        "Data delivered to a target.",
        "System for encoding messages."
    ];
    global.last_battle_id             = "final_boss_jrpg";
    global.is_jrpg                    = true;
    global.battle_enemy_sprite        = spr_boss_idle;
    global.battle_enemy_attack_sprite = spr_boss_attack;
    global.return_room                = rm_level_1;
    room_goto(rm_battle_scramble);
    show_debug_message("CONTROLLER: Transitioning to final boss JRPG phase.");
}

// --- FINAL BOSS JRPG DEFEATED (victory) ---
if (room == rm_level_1 && global.last_battle_id == "final_boss_jrpg_defeated") {
    global.last_battle_id      = "none";
    global.final_boss_defeated = true;
    if (instance_exists(obj_save_manager)) obj_save_manager.save_game();
    var _boss = instance_find(obj_final_boss_placeholder, 0);
    if (_boss != noone) {
        with (_boss) {
            if (!instance_exists(obj_textevent)) {
                create_textevent([
                    "Impossible... I am... the SKIPJACK protocol...",
                    "You have... corrupted... my core...",
                    "...SYSTEM TERMINATED."
                ], [id, id, id]);
            }
            visible = false;
        }
    }
}

// --- GREG POST-BATTLE TRIGGER ---
if (room == rm_level_1 && global.last_battle_id == "greg_boss_defeated") {
    global.greg_quest_started = true;
    
    var _greg = instance_find(obj_npc1, 0);
    if (_greg != noone) {
        with (_greg) {
            // We force this dialogue to appear immediately
            create_textevent([
                "Impressive work, Jack.",
                "Go find Clipper and Lea. I've updated your HUD."
            ], [id, id]);
        }
    }
    
    global.last_battle_id = "none";
    if (instance_exists(obj_save_manager)) obj_save_manager.save_game();
}
// 1. MOUSE LOCK LOGIC
if (mouse_locked_until_release)
{
    if (!mouse_check_button(mb_left))
    {
        mouse_locked_until_release = false;
    }
    else
    {
        exit; 
    }
}

// 2. ESCAPE KEY TOGGLE
if (keyboard_check_pressed(vk_escape))
{
    if (global.is_paused)
    {
        unpause_game();
    }
    else
    {
        var _popup_open = (instance_exists(obj_kyle) && obj_kyle.gui_open)
                       || (instance_exists(obj_hallway_poster) && obj_hallway_poster.is_open);
        if (!_popup_open && (instance_exists(obj_jack) || is_special_event_active()))
        {
            pause_game();
        }
    }
}

// --- THAT'S IT! NO BUTTON LOGIC HERE ---
// The button clicks are now handled entirely inside the Draw GUI event.

// --- EMERGENCY PRESENTATION OVERRIDE (debug only) ---
if (global.DEBUG_MODE && keyboard_check_pressed(vk_f1)) {
    global.greg_quest_started = true;
    if (instance_exists(obj_save_manager)) obj_save_manager.save_game();
    show_debug_message("!!! QUESTS MANUALLY STARTED & SAVED !!!");
}

// F2: toggle debug mode (always available)
if (keyboard_check_pressed(vk_f2)) {
    global.DEBUG_MODE = !global.DEBUG_MODE;
    show_debug_message("[DEBUG] Debug mode " + (global.DEBUG_MODE ? "ENABLED" : "DISABLED"));
}

// --- SECONDARY OBJECTIVE: inspect all hallway objects ---
if (room == rm_hallway && !global.all_objects_inspected
    && global.quest_talk_to_david && !global.david_defeated) {
    if (global.poster_opened && global.paper_opened
     && global.computer1_opened && global.computer2_opened) {
        global.all_objects_inspected = true;
        inspect_flash_timer          = 90; // 1.5 s flash at 60 fps
        audio_play_sound(snd_objective_complete, 10, false);
    }
}
if (inspect_flash_timer > 0) inspect_flash_timer--;

// --- TOOLTIP SYSTEM (all gameplay rooms) ---
var _in_gameplay = (room == rm_hallway   || room == rm_level_1
                 || room == rm_level_2   || room == rm_cutscene_lab);

if (_in_gameplay && !global.is_paused) {

    // ── Jack movement tracking ────────────────────────────────────────────
    if (instance_exists(obj_jack)) {
        if (obj_jack.x != jack_last_x || obj_jack.y != jack_last_y) {
            jack_idle_frames = 0;
            jack_last_x      = obj_jack.x;
            jack_last_y      = obj_jack.y;
        } else {
            jack_idle_frames++;
        }
    } else {
        jack_idle_frames = 0;
    }
    if (tip_ctxl_cooldown > 0) tip_ctxl_cooldown--;

    // ── Kill instantly when dialogue opens ────────────────────────────────
    if (instance_exists(obj_textevent) && tip_state != "idle") {
        tip_state        = "idle";
        tip_alpha        = 0;
        tip_timer        = 0;
        tip_current_text = "";
    }

    // ── Tab = dismiss early ───────────────────────────────────────────────
    if (keyboard_check_pressed(vk_tab) && (tip_state == "show" || tip_state == "fade_in")) {
        tip_state = "fade_out";
        tip_timer = 0;
    }

    // ── Contextual triggers (only when idle, no dialogue, cooldown clear) ─
    if (tip_state == "idle" && !instance_exists(obj_textevent)
        && tip_ctxl_cooldown <= 0 && instance_exists(obj_jack)) {

        // 1. WASD tip — player hasn't moved for 5 s
        if (!tip_shown_wasd && jack_idle_frames >= 300) {
            tip_current_text  = tip_texts[0];
            tip_state         = "fade_in";
            tip_timer         = 0;
            tip_shown_wasd    = true;
            tip_ctxl_cooldown = 600;
        }

        // 2. Press E tip — player is within 100 px of any NPC
        else if (!tip_shown_press_e) {
            var _near_npc = false;
            var _npc_list = [obj_kyle, obj_npc1, obj_lea, obj_clipper, obj_final_boss_placeholder];
            for (var _ni = 0; _ni < array_length(_npc_list); _ni++) {
                if (instance_exists(_npc_list[_ni])) {
                    var _npc_inst = instance_find(_npc_list[_ni], 0);
                    if (_npc_inst != noone
                        && point_distance(obj_jack.x, obj_jack.y, _npc_inst.x, _npc_inst.y) < 100) {
                        _near_npc = true;
                        break;
                    }
                }
            }
            if (_near_npc) {
                tip_current_text  = tip_texts[3];
                tip_state         = "fade_in";
                tip_timer         = 0;
                tip_shown_press_e = true;
                tip_ctxl_cooldown = 600;
            }
        }

        // 3. Characters nearby tip — active search quest + player is moving
        else if (!tip_shown_nearby && jack_idle_frames < 30) {
            var _searching = false;
            if (room == rm_hallway) {
                _searching = (global.quest_talk_to_kyle   && !global.kyle_lesson_done)
                          || (global.quest_talk_to_david  && !global.david_defeated)
                          || (global.quest_talk_to_breado && !global.tutorial_complete)
                          || (global.tutorial_complete    && !global.quest_find_greg_done);
            }
            if (room == rm_level_1) {
                _searching = global.greg_quest_started
                          && (!global.clipper_defeated || !global.lea_defeated);
            }
            if (_searching) {
                tip_current_text = tip_texts[2];
                tip_state        = "fade_in";
                tip_timer        = 0;
                tip_shown_nearby = true;
                tip_ctxl_cooldown = 600;
            }
        }
    }

    // ── Passive state machine ─────────────────────────────────────────────
    switch (tip_state) {

        case "idle":
            tip_timer++;
            if (tip_timer >= tip_idle_frames && !instance_exists(obj_textevent)) {
                tip_current_text = tip_texts[tip_index];
                tip_state        = "fade_in";
                tip_timer        = 0;
            }
            break;

        case "fade_in":
            tip_timer++;
            tip_alpha = tip_timer / tip_fade_frames;
            if (tip_timer >= tip_fade_frames) {
                tip_alpha = 1;
                tip_state = "show";
                tip_timer = 0;
            }
            break;

        case "show":
            tip_timer++;
            if (tip_timer >= tip_show_frames) {
                tip_state = "fade_out";
                tip_timer = 0;
            }
            break;

        case "fade_out":
            tip_timer++;
            tip_alpha = 1 - (tip_timer / tip_fade_frames);
            if (tip_timer >= tip_fade_frames) {
                tip_alpha        = 0;
                tip_state        = "idle";
                tip_timer        = 0;
                tip_current_text = "";
                tip_index        = (tip_index + 1) mod array_length(tip_texts);
            }
            break;
    }
}