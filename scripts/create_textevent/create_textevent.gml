///@description create_textevent
///@arg Text
///@arg Speaker
///@arg *Effects
///@arg *Speed
///@arg *Type
///@arg *Next_Line
///@arg *Scripts
///@arg *Text_Col
///@arg *Emotion
///@arg *Emote
function create_textevent() {

	// Stop a new box from opening if one is already open
	if (instance_exists(obj_textevent)) { exit; }

	var _text    = argument[0];
	var _speaker = argument[1];
	var _e_line  = "Press E to continue through dialogue.";

	if (!variable_global_exists("e_dialogue_intro_shown")) {
		global.e_dialogue_intro_shown = false;
	}

	// First dialogue of a new game: teach E before story lines
	if (!global.e_dialogue_intro_shown) {
		global.e_dialogue_intro_shown = true;

		if (!is_array(_text)) {
			_text = [_text];
		}
		if (!is_array(_speaker)) {
			_speaker = [_speaker];
		}

		if (array_length(_text) == 0 || _text[0] != _e_line) {
			array_insert(_text, 0, _e_line);
			array_insert(_speaker, 0, _speaker[0]);
		}
	}

	// Create the text event object
	var textevent = instance_create_layer(0, 0, "Instances", obj_textevent);

	// Pass all the arguments to the new object
	with (textevent) {
		reset_dialogue_defaults();

		switch (argument_count - 1) {
			case 9: myEmote     = argument[9];
			case 8: myEmotion   = argument[8];
			case 7: myTextCol   = argument[7];
			case 6: myScripts   = argument[6];
			case 5: myNextLine  = argument[5];
			case 4: myTypes     = argument[4];
			case 3: myTextSpeed = argument[3];
			case 2: myEffects   = argument[2];
		}
		mySpeaker = _speaker;
		myText    = _text;

		event_perform(ev_other, ev_user0);
	}

	return textevent;
}
