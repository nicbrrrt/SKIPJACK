// --- MASTER GLOBAL INITIALIZATION ---
// This ensures variables exist before the save system tries to read them.
global.greg_defeated = false;
global.tutorial_complete = false;
global.level1_intro_done = false;

global.save_filename = "save_v1.json";
global.save_path = working_directory + global.save_filename;

global.target_x = -1;
global.target_y = -1;
global.is_loading_from_save = false;

// Force delete ANY transition object so the buttons are clickable
if (instance_exists(obj_transition)) {
    instance_destroy(obj_transition);
}

// Force delete Jack (he shouldn't be in the menu)
if (instance_exists(obj_jack)) {
    instance_destroy(obj_jack);
}

global.save_path = working_directory + "save_v1.json";