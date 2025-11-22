// SAFETY CHECK
if (!instance_exists(obj_jack) || !instance_exists(obj_npc1) || !instance_exists(obj_npc2)) exit;

switch(sequence_step) {

	// -------------------- STEP 0: SETUP --------------------
	case 0:
		// 1. Lock everyone
		obj_jack.isInCutscene = true;
		obj_npc1.isInCutscene = true;
		obj_npc2.isInCutscene = true;

		// 2. JACK SETUP
		obj_jack.sprite_index = spr_jack_idle; 
		obj_jack.image_speed = 0; // Stop spinning
		// Force Jack to look Right (Frame 6 usually)
		if (variable_instance_exists(obj_jack, "anim")) obj_jack.image_index = obj_jack.anim.right_start;
		else obj_jack.image_index = 6;

		// 3. NPC 1 SETUP (LOOK LEFT)
		obj_npc1.sprite_index = spr_npc1_idle; 
		obj_npc1.image_speed = 0.1;  // Stop spinning
		
		// FORCE LEFT FRAME:
		// Change "18" to whatever frame number is "Facing Left" on your sprite sheet.
		// (If you use the same layout as Jack, it's likely 18).
		obj_npc1.image_index = 18; 
		
		// 4. NPC 2 SETUP
		obj_npc2.sprite_index = spr_npc2_read; 
		obj_npc2.image_speed = 0.1; 
		obj_npc2.image_index = 0;

		sequence_step = 1;
		break;

	// -------------------- STEP 1: DISSOCIATE QUESTION --------------------
	case 1:
		if (!instance_exists(obj_textevent)) {
			var _text = ["Hey... Jack?", "Are you in your own world again?"];
			create_textevent(_text, [obj_npc1, obj_npc1]);
		}
		sequence_step = 2;
		break;

	// -------------------- STEP 2: WAIT --------------------
	case 2:
		if (!instance_exists(obj_textevent)) sequence_step = 3;
		break;

	// -------------------- STEP 3: PLAYER ANSWER --------------------
	case 3:
		if (!instance_exists(obj_textevent)) {
			var _text = [
				"Uh... yeah. Sorry. What was that?", 
				"Haix, I swear you always lose focus.",
				"Anyway, I'll repeat the instructions ONE more time."
			];
			create_textevent(_text, [obj_jack, obj_npc1, obj_npc1]);
		}
		sequence_step = 4;
		break;

	// -------------------- STEP 4: WAIT --------------------
	case 4:
		if (!instance_exists(obj_textevent)) sequence_step = 5;
		break;

	// -------------------- STEP 5: TUTORIAL --------------------
	case 5:
		if (!instance_exists(obj_textevent)) {
			var _text = [
				"Use WASD keys to move around and for selection.",
				"Press E for interaction with stuff",
				"Oh almost forgot, someone was asking for help in the other lab room"
			];
			create_textevent(_text, [obj_npc2, obj_npc2, obj_npc2]);
		}
		sequence_step = 6;
		break;

	// -------------------- STEP 6: WAIT --------------------
	case 6:
		if (!instance_exists(obj_textevent)) sequence_step = 7;
		break;

	// -------------------- STEP 7: THE QUEST --------------------
	case 7:
		if (!instance_exists(obj_textevent)) {
			var _text = [
				"So go ahead and check it out.",
				"Head out the door and go down the hall."
			];
			create_textevent(_text, [obj_npc1, obj_npc1]);
		}
		sequence_step = 8;
		break;

	// -------------------- STEP 8: WAIT FOR END --------------------
	case 8:
		if (!instance_exists(obj_textevent)) {
			sequence_step = 9; 
		}
		break;

// -------------------- STEP 9: UNLOCK PLAYER --------------------
	case 9:
		// 1. Unlock the player
		obj_jack.isInCutscene = false;
		
		// FIX: Don't set to 1. Set to his defined animation speed variable (0.2)
		obj_jack.image_speed = obj_jack.anim_speed; 
		
		// 2. Unlock NPCs 
		obj_npc1.isInCutscene = false;
		obj_npc2.isInCutscene = false;

		// 3. Destroy the cutscene manager
		instance_destroy();
		break;
}