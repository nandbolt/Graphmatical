/// @func	GuiController();
function GuiController() constructor
{
	// Gui elements
	elements = [];
	
	// Focus
	elementInFocus = undefined;
	canClick = true;
	clickedAnyElement = false;
	
	// Radio groups
	radioGroups = [];
	
	/// @func	update();
	static update = function()
	{
		// Reset click
		clickedAnyElement = false;
		canClick = true;
		
		// Loop through elements
		for (var _i = 0; _i < array_length(elements); _i++)
		{
			// Update element
			elements[_i].update();
		}
		
		// Remove focus if didn't click
		if (!clickedAnyElement && !canClick) elementInFocus = undefined;
	}
	
	/// @func	drawGui();
	static drawGui = function()
	{
		// Set draw params
		draw_set_font(fDefault);
		draw_set_halign(fa_left); 
		draw_set_valign(fa_middle);
		draw_set_color(c_white);
		draw_set_alpha(1);
		
		// Loop through elements (reverse)
		for (var _i = array_length(elements) - 1; _i >= 0; _i--)
		{
			// Draw element
			elements[_i].drawGui();
		}
	}
	
	/// @func	cleanup();
	static cleanup = function()
	{
		// Loop through elements (reverse)
		for (var _i = array_length(elements) - 1; _i >= 0; _i--)
		{
			// Cleanup element
			elements[_i].cleanup();
			delete elements[_i];
		}
		
		// Cleanup elements array
		elements = -1;
		
		// Loop through radio groups (reverse)
		for (var _i = array_length(radioGroups) - 1; _i >= 0; _i--)
		{
			// Cleanup element
			radioGroups[_i].cleanup();
			delete radioGroups[_i];
		}
		
		// Cleanup radio groups array
		radioGroups = -1;
		
		
	}
}