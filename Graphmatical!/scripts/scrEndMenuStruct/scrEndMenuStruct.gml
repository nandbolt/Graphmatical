/// @func	EndMenu();
function EndMenu() : Menu() constructor
{
	// Buttons
	var _width = 150, _height = 32, _vspacing = 8;
	
	// Restart button
	var _x = display_get_gui_width() * 0.5 - _width * 0.5, _y = display_get_gui_height() * 0.6 - _height - _vspacing * 0.5;
	buttonRestart = new GuiButton("restart", _x, _y, other.restart);
	buttonRestart.width = _width;
	buttonRestart.height = _height;
	
	// Hub button
	_y += _height + _vspacing;
	buttonHub = new GuiButton("back to hub", _x, _y, other.backToHub);
	buttonHub.width = _width;
	buttonHub.height = _height;
	
	// Quit button
	_y += _height + _vspacing;
	buttonQuit = new GuiButton("quit game", _x, _y, other.quitGame);
	buttonQuit.width = _width;
	buttonQuit.height = _height;
	
	/// @func	update();
	static update = function()
	{
		// Gui controller
		guiController.update();
	}
	
	/// @func	drawGui();
	static drawGui = function()
	{
		// Gui controller
		guiController.drawGui();
	}
}