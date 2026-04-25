// obj_tutorial_controller — Create Event
// Four-phase tutorial state machine.
//   Phase 0: Intro greeting — player presses E to advance
//   Phase 1: WASD tracking — player presses all four movement keys
//   Phase 2: Walk to Greg — player walks over and presses E
//   Phase 3: Congratulations — dialogue plays, then room transitions

tutorial_phase        = 0;
first_dialogue_shown  = false; // set true by Alarm 0 once dialogue fires

w_pressed = false;
a_pressed = false;
s_pressed = false;
d_pressed = false;

tutorial_done = false;

// Fire the intro greeting after 30 frames so the room fade-in settles
alarm[0] = 30;
