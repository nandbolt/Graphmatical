/// @func	GrapherInitMenu();
function GrapherInitMenu() : Menu() constructor
{
	// Error message
	errorMessage = "";
	
	// Buttons
	var _width = 150, _height = 32, _vspacing = 8;
	
	// Create axes button
	var _x = display_get_gui_width() * 0.5 - _width * 0.5, _y = display_get_gui_height() * 0.5 - _height - _vspacing * 0.5;
	buttonCreateAxes = new GuiButton("create new axes", _x, _y, other.createAxes);
	buttonCreateAxes.width = _width;
	buttonCreateAxes.height = _height;
	
	// Select graph button
	_y += _height + _vspacing;
	buttonSelectAxes = new GuiButton("select existing axes", _x, _y, other.selectAxes);
	buttonSelectAxes.width = _width;
	buttonSelectAxes.height = _height;
	
	/// @func	update();
	static update = function()
	{
		// Gui controller
		guiController.update();
		
		// Editor change
		var _dx = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left);
		if (_dx != 0)
		{
			// Create new editor
			if (_dx > 0) instance_create_layer(other.x, other.y, "Instances", oTiler);
			else instance_create_layer(other.x, other.y, "Instances", oPauser);
			
			// Destroy grapher
			instance_destroy(oGrapher);
		}
	}
	
	/// @func	drawGui();
	static drawGui = function()
	{
		// Gui controller
		guiController.drawGui();
		
		// Error message
		var _x = buttonSelectAxes.x + buttonSelectAxes.width * 0.5 - string_width(errorMessage) * 0.5;
		var _y = buttonSelectAxes.y + buttonSelectAxes.height * 1.5 + 8;
		draw_set_color(c_yellow);
		draw_text(_x, _y, errorMessage);
		draw_set_color(c_white);
		
		// Switch editor
		draw_set_halign(fa_right);
		draw_set_valign(fa_bottom);
		_x = display_get_gui_width() - 16;
		_y = display_get_gui_height() - 16;
		draw_text(_x, _y, "Switch editor: Left + right arrow keys");
	}
}