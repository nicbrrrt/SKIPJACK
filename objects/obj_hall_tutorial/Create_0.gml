// obj_hall_tutorial — Create Event
// Manages the hallway tutorial sequence step by step.
//
// Phases:
//   0  Init: position Greg near Jack, lock Jack
//   1  Start greeting dialogue
//   2  Wait for greeting dialogue to end
//   3  WASD tutorial: player must press all four keys
//   4  Move Greg to distance, start "find me" instructions dialogue
//   5  Wait for "find me" dialogue to end, then unlock Jack
//   6  Wait for player to walk to Greg and press E (Greg fires congratulations)
//   7  Wait for congratulations dialogue to end
//   8  Transition to rm_level_1

phase = 0;
depth = -99999;

// WASD tracking
w_pressed = false;
a_pressed = false;
s_pressed = false;
d_pressed = false;

// Pulsing E-key animation timer (degrees)
e_pulse = 0;

// One-shot guards
transition_started = false;
