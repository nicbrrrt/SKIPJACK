// ---------------------------------------------------------
// 1. CHOICE MODE (Navigation)
// ---------------------------------------------------------
if (choice_active) 
{
    // Move Up
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
        current_option--;
        if (current_option < 0) current_option = array_length(options) - 1; 
    }

    // Move Down
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
        current_option++;
        if (current_option >= array_length(options)) current_option = 0; 
    }

    // Confirm Selection
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("E"))) {
        // Send the result back to the cutscene object!
        if (instance_exists(obj_cutscene_intro)) {
            obj_cutscene_intro.choice_result = current_option;
        }
        
        // Close the text event
        instance_destroy();
    }
    
    // STOP here so we don't run typing logic while choosing
    exit; 
}

// ---------------------------------------------------------
// 2. TYPING LOGIC (This was missing!)
// ---------------------------------------------------------
var _len = string_length(myText[page]);

if (charCount < _len) {
    charCount += myTextSpeed; // Increase characters based on speed
}

// ---------------------------------------------------------
// 3. INTERACTION (Skipping & Advancing)
// ---------------------------------------------------------
if (keyboard_check_pressed(ord("E"))) 
{
    // CASE A: Text is still typing? -> SKIP to end
    if (charCount < _len) 
    {
        charCount = _len;
    }
    // CASE B: Text is finished? -> Decide what happens next
    else 
    {
        // 1. Check for Options FIRST
        if (page >= array_length(myText) - 1 && array_length(options) > 0) 
        {
            choice_active = true; // Activate the menu we created in Part 1
        }
        // 2. Check for Next Page
        else if (page < array_length(myText) - 1)
        {
            page++;
            charCount = 0;
        }
        // 3. No Options, No Next Page -> Destroy
        else 
        {
            instance_destroy();
        }
    }
}

// ---------------------------------------------------------
// 4. SAFETY CHECK
// ---------------------------------------------------------
// If the visual textbox sprite (if you use a separate object) is gone, destroy this logic too.
if (!instance_exists(myTextbox) && myTextbox != noone) {
    instance_destroy();
}