/// @func	Menu();
function Menu() constructor
{
	// Gui controller
	guiController = new GuiController();
	
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
	
	/// @func	cleanup();
	static cleanup = function()
	{
		// Gui controller
		if (is_struct(guiController))
		{
			guiController.cleanup();
			delete guiController;
		}
	}
}