// Inherit the parent event
event_inherited();

// Textbox
boxWidth = 128;
boxHeight = 32;
boxOffset = 32;		// How far the box's bottom is from the sign's y origin
boxPadding = 4;

// Text
text = "";
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

/// @func	interact();
interact = function()
{
	// If holding shift
	if (keyboard_check(vk_shift))
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

#region Set Long Example Text

text = "In my younger and more vulnerable years my father gave me some advice that I've been turning over in my mind ever since.\n\n" +
"\"Whenever you feel like criticizing any one,\" he told me, \"just remember that all the people in this world haven't had the advantages that you've had.\"\n\n" +
"He didn't say any more but we've always been unusually communicative in a reserved way, and I understood that he meant a great deal more than that. In consequence I'm inclined to reserve all judgments, a habit that has opened up many curious natures to me and also made me the victim of not a few veteran bores. The abnormal mind is quick to detect and attach itself to this quality when it appears in a normal person, and so it came about that in college I was unjustly accused of being a politician, because I was privy to the secret griefs of wild, unknown men. Most of the confidences were unsought—frequently I have feigned sleep, preoccupation, or a hostile levity when I realized by some unmistakable sign that an intimate revelation was quivering on the horizon—for the intimate revelations of young men or at least the terms in which they express them are usually plagiaristic and marred by obvious suppressions. Reserving judgments is a matter of infinite hope. I am still a little afraid of missing something if I forget that, as my father snobbishly suggested, and I snobbishly repeat, a sense of the fundamental decencies is parcelled out unequally at birth.";

#endregion