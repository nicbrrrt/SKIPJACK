// --- 1. "Text Crawl" Effect ---

// Get the full text for the current page
var _current_page_text = text_to_show[page_number];

// If our text progress is less than the full length...
if (text_progress < string_length(_current_page_text))
{
	// ...add characters based on our speed
	text_progress += text_speed;
	
	// This "copies" the part of the text we've revealed so far
	string_to_draw = string_copy(_current_page_text, 1, text_progress);
}
else
{
	// We're done typing, so just show the full text
	string_to_draw = _current_page_text;
}


// --- 2. Player Input ---
// (You'll want to use a "key pressed" check so it only fires once)
var _key_confirm = keyboard_check_pressed(ord("E"));

if (_key_confirm)
{
	// Check if the text is still typing
	if (text_progress < string_length(_current_page_text))
	{
		// If it is, skip to the end of the page
		text_progress = string_length(_current_page_text);
	}
	else
	{
		// The page is finished, so let's go to the next page
		page_number += 1;
		
		// If we've run out of pages...
		if (page_number >= array_length(text_to_show))
		{
			// ...destroy the dialogue box
			instance_destroy();
		}
		else
		{
			// Otherwise, reset the text crawl for the new page
			text_progress = 0;
			string_to_draw = "";
		}
	}
}