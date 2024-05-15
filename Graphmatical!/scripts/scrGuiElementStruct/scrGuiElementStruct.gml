/// @func	GuiElement();
function GuiElement() constructor
{
	// Gui controller
	guiController = other.guiController;
	
	// Value
	value = undefined;
	name = undefined;
	
	// Dimensions
	static width = 200;
	static height = 32;
	static padding = 16;
	
	// Add to gui elements
	array_push(guiController.elements, self);
	
	/// @func	cleanup();
	static cleanup = function()
	{
		// Loop through elements
		for (var _i = 0; _i < array_length(guiController.elements); _i++)
		{
			// If found self in elements
			if (guiController.elements[_i] == self)
			{
				// Remove self from elements
				array_delete(guiController.elements, _i, 1);
				
				// Exit loop
				break;
			}
		}
	}
	
	/// @func	hasFocus();
	static hasFocus = function(){ return guiController.elementInFocus == self; }
	
	/// @func	setFocus();
	static setFocus = function()
	{
		guiController.elementInFocus = self;
		guiController.clickedAnyElement = true;
	}
	
	/// @func	removeFocus();
	static removeFocus = function(){ guiController.elementInFocus = undefined; }
	
	/// @func	get();
	static get = function(){ return value; }
	
	/// @func	set({var} value);
	static set = function(_value){ value = _value; }
	
	/// @func	update();
	static update = function()
	{
		// Check left click + not already clicking something this gamestep + clicked element
		if (mouse_check_button_pressed(mb_left) && guiController.canClick &&
			point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + width, y + height))
		{
			// Click element
			guiController.canClick = false;
			click();
		}
		
		// If element has focus, listen for input
		if (hasFocus()) listen();
	}
	
	/// @func	click();
	static click = function(){ setFocus(); }
	
	/// @func	listen();
	static listen = function(){}
	
	/// @func	drawGui();
	static drawGui = function(){}
}