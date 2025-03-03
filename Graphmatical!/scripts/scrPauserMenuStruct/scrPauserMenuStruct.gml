/// @func	PauserMenu();
function PauserMenu() : Menu() constructor
{
	// Buttons
	var _width = 150, _height = 32, _vspacing = 8;
	
	// Resume button
	var _x = display_get_gui_width() * 0.5 - _width * 0.5, _y = display_get_gui_height() * 0.5 - _height - _vspacing * 0.5;
	buttonResume = new GuiButton("resume", _x, _y, other.resume);
	buttonResume.width = _width;
	buttonResume.height = _height;
	
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
	
	// Level name + creator
	if (global.editMode)
	{
		_x -= 25;
		_y = display_get_gui_height() * 0.5 - _height - _vspacing * 0.5 - (_height + _vspacing) * 2;
		textfieldLevelName = new GuiTextfield("Level Name", _x, _y, global.currentLevelName, "Level name", other.onLevelNameEntered);
		_y += _height + _vspacing;
		textfieldLevelCreator = new GuiTextfield("Level Creator", _x, _y, global.currentLevelCreator, "Creator", other.onLevelCreatorEntered);
	}
	
	/// @func	update();
	static update = function()
	{
		// Gui controller
		guiController.update();
		
		// Editor change
		var _dx = (oLevel.globalGraphing ? keyboard_check_pressed(vk_right) : 0) -
			(oLevel.globalTiling ? keyboard_check_pressed(vk_left) : 0);
		if (_dx != 0)
		{
			// Create new editor
			if (_dx > 0) instance_create_layer(other.x, other.y, "Instances", oGrapher);
			else instance_create_layer(other.x, other.y, "Instances", oTiler);
			
			// Destroy pauser
			instance_destroy(oPauser);
		}
	}
	
	/// @func	drawGui();
	static drawGui = function()
	{
		// Gui controller
		guiController.drawGui();
		
		// Switch editor
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		var _x = 16, _y = 16;
		if (oLevel.globalGraphing) draw_text(_x, _y, "Graphing enabled (->)");
		else draw_text(_x, _y, "Graphing disabled");
		_y += 16;
		if (oLevel.globalTiling) draw_text(_x, _y, "Tiling enabled (<-)");
		else draw_text(_x, _y, "Tiling disabled");
		
		// Switch editor
		draw_set_halign(fa_right);
		draw_set_valign(fa_bottom);
		_x = display_get_gui_width() - 16;
		_y = display_get_gui_height() - 16;
		if (instance_exists(oCustomEditorManager))
		{
			// Windows
			if (os_browser == browser_not_a_browser) draw_text(_x, _y, "Level save files are located\nin your local app data folder.");
			// Browser
			else draw_text(_x, _y, "Level save files are located\nin your browser's memory using the\ninspector (which can be tricky to find).");
		}
	}
}