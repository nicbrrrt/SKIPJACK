/// @description Returns the instance the player should head toward for the active objective.
function scr_get_objective_target() {

	if (room == rm_hallway) {
		if (global.quest_talk_to_kyle && !global.kyle_lesson_done && instance_exists(obj_kyle))
			return instance_find(obj_kyle, 0);
		if (global.quest_talk_to_david && !global.david_defeated && instance_exists(obj_david))
			return instance_find(obj_david, 0);
		if (global.quest_talk_to_breado && !global.tutorial_complete && instance_exists(obj_start_combat))
			return instance_find(obj_start_combat, 0);
		if (global.tutorial_complete && !global.quest_find_greg_done && instance_exists(obj_npc1))
			return instance_find(obj_npc1, 0);
	}

	if (room == rm_tutorial_void && instance_exists(obj_tutorial_controller)
		&& obj_tutorial_controller.tutorial_phase == 2 && instance_exists(obj_npc1))
		return instance_find(obj_npc1, 0);

	if (room == rm_level_1) {
		if (global.quest_find_greg_done && !global.quest_greg_level1_done && instance_exists(obj_npc1))
			return instance_find(obj_npc1, 0);
		if (global.greg_quest_started) {
			if (!global.quest_clipper_done && instance_exists(obj_clipper))
				return instance_find(obj_clipper, 0);
			if (!global.quest_lea_done && instance_exists(obj_lea))
				return instance_find(obj_lea, 0);
		}
	}

	return noone;
}
