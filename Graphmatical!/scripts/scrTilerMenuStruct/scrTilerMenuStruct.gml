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
		var _dx = keyboard_check_pressed(vk_right) - (oLevel.globalGraphing ? keyboard_check_pressed(vk_left) : 0);
		if (_dx != 0)
		{
			// Create new editor
			if (_dx > 0) instance_create_layer(other.x, other.y, "Instances", oPauser);
			else instance_create_layer(other.x, other.y, "Instances", oGrapher);
			
			// Destroy grapher
			instance_destroy(oTiler);
		}
	}
	
	/// @func	drawGui();
	static drawGui = function()
	{
		// Axes stats
		draw_set_halign(fa_right);
		var _x = display_get_gui_width() - 16, _y = 16;
		draw_text(_x, _y, "Instance count: "+string(instance_count));
		
		// Switch editor
		draw_set_halign(fa_right);
		draw_set_valign(fa_bottom);
		_x = display_get_gui_width() - 16;
		_y = display_get_gui_height() - 16;
		draw_text(_x, _y, "Switch editor: Left + right arrow keys");
	}
}