// Inherit the parent event
event_inherited();

// Textbox
boxWidth = 128;
boxHeight = 48;
boxOffset = 32;		// How far the box's bottom is from the sign's y origin
boxPadding = 4;

// Text
text = "Insert sign text here.";
displayText = "";			// The text actually being displayed
displayTextScale = 0.5;
displayTextSeparation = 16;
displayTextIdx = 0;			// The cursor where the display starts 
displayTextLength = 0;		// The length of the display text
displayTextCounter = 0;		// The counter used to tell when to add a letter to the display text
displayTextSpeed = 2;		// The speed of updating the display text (lower = faster)
displayTextDone = false;	// Becomes true when display text is done
displayTextShown = false;	// Becomes true when display text is shown
displayTextMaxWidth = boxWidth * 1 / displayTextScale - boxPadding * 2 / displayTextScale;
displayTextMaxHeight = boxHeight * 1 / displayTextScale - boxPadding * 2 / displayTextScale;

// Edit
editting = false;
editMenu = undefined;

// Draw
textAlpha = 0;
textAlphaSpeed = 0.05;

#region Functions

/// @func	updateDisplayText();
updateDisplayText = function()
{
	// Add another character
	displayTextLength++;
	displayText = string_copy(text, displayTextIdx, displayTextLength);
			
	// If past height of box
	if (string_height_ext(displayText, displayTextSeparation, displayTextMaxWidth) > displayTextMaxHeight)
	{
		// Subtract a character
		displayTextLength--;
		displayText = string_copy(text, displayTextIdx, displayTextLength);
				
		// Set done
		displayTextDone = true;
	}
	// Else if last character
	else if (displayTextIdx + displayTextLength > string_length(text))
	{
		// Set done
		displayTextDone = true;
	}
}

/// @func	interactPressed();
interactPressed = function()
{
	// If edit mode
	if (global.editMode)
	{
		// Toggle sign edit
		editting = !editting;
		
		// Toggle player movement
		oPlayer.canMove = !editting;
		
		// Create menu if editting
		if (editting) editMenu = new SignMenu();
		// Else destroy menu
		else
		{
			editMenu.cleanup();
			delete editMenu;
		}
	}
	// Else if not editing
	else if (!editting)
	{
		// Show text if not displayed
		if (!displayTextShown) displayTextShown = true;
		// Else if display text done
		else if (displayTextDone)
		{
			// Advance index
			displayTextIdx += displayTextLength;
		
			// If no more to message
			if (displayTextIdx > string_length(text))
			{
				// Reset index
				displayTextIdx = 0;
			
				// Close sign
				displayTextShown = false;
			}
		
			// Reset
			displayText = "";
			displayTextLength = 0;
			displayTextCounter = 0;
			displayTextDone = false;
		}
		else
		{
			// Display entire message
			while (!displayTextDone)
			{
				// Update display text
				updateDisplayText();
			}
		}
	}
	
	// Sound
	audio_play_sound(sfxSignRead, 2, false);
}

/// @func	onPlayerNear();
onPlayerNear = function()
{
	// If display text is not done
	if (displayTextShown && !displayTextDone)
	{
		// Increment counter
		displayTextCounter++;
	
		// If time to update display text
		if (displayTextCounter >= displayTextSpeed)
		{
			// Update display text
			updateDisplayText();
		
			// Reset counter
			displayTextCounter = 0;
		}
	}
}

/// @func	onSignTextEntered();
onSignTextEntered = function()
{
	text = editMenu.textfieldSign.value;
}

#endregion