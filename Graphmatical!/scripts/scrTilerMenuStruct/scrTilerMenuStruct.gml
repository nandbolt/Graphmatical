/// @func	TilerMenu();
function TilerMenu() : Menu() constructor
{
	/// @func	update();
	static update = function()
	{
		// Gui controller
		guiController.update();
		
		// Tiler scope
		with (other)
		{
			// Move inputs
			var _dx = keyboard_check_pressed(ord("D")) - keyboard_check_pressed(ord("A"));
			var _dy = keyboard_check_pressed(ord("S")) - keyboard_check_pressed(ord("W"));
			
			// If movement
			if (_dx != 0 || _dy != 0) move(_dx, _dy);
		}
		
		// Editor change
		var _dx = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left);
		if (_dx != 0)
		{
			// Tiler
			instance_create_layer(other.x, other.y, "Instances", oGrapher);
			
			// Destroy grapher
			instance_destroy(oTiler);
		}
	}
	
	/// @func	drawGui();
	static drawGui = function()
	{
		
	}
}