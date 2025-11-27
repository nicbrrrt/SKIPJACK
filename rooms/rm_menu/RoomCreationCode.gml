// Force delete ANY transition object so the buttons are clickable
if (instance_exists(obj_transition)) {
    instance_destroy(obj_transition);
}

// Force delete Jack (he shouldn't be in the menu)
if (instance_exists(obj_jack)) {
    instance_destroy(obj_jack);
}