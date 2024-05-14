/// @func	GrapherChooseMenu();
function GrapherChooseMenu() : Menu() constructor
{
	// Graph options
	leftAxes = noone;
	rightAxes = noone;
	topAxes = noone;
	bottomAxes = noone;
	
	// Buttons
	var _width = 50, _height = 32;
	
	// Edit axes button
	var _x = display_get_gui_width() * 0.5 - _width * 0.5, _y = display_get_gui_height() - _height - 16;
	buttonEditAxes = new GuiButton("edit?", _x, _y, other.editAxes);
	buttonEditAxes.width = _width;
	buttonEditAxes.height = _height;
	
	/// @func	update();
	static update = function()
	{
		// Gui controller
		guiController.update();
		
		#region Check Axes Change
		
		// Left axes check
		if (leftAxes != noone && keyboard_check_pressed(ord("A")))
		{
			with (other)
			{
				changeAxes(other.leftAxes);
			}
		}
		// Right axes check
		else if (rightAxes != noone && keyboard_check_pressed(ord("D")))
		{
			with (other)
			{
				changeAxes(other.rightAxes);
			}
		}
		// Top axes check
		else if (topAxes != noone && keyboard_check_pressed(ord("W")))
		{
			with (other)
			{
				changeAxes(other.topAxes);
			}
		}
		// Bottom axes check
		else if (bottomAxes != noone && keyboard_check_pressed(ord("S")))
		{
			with (other)
			{
				changeAxes(other.bottomAxes);
			}
		}
		
		#endregion
	}
	
	/// @func	drawGui();
	static drawGui = function()
	{
		// Gui controller
		guiController.drawGui();
		
		#region Arrows
		
		// Init params
		draw_set_color(c_yellow);
		var _arrowString = "<", _halfArrowWidth = string_width(_arrowString) * 0.5, _x = 0, _y = 0;
		
		// Left arrow
		_y = buttonEditAxes.y + buttonEditAxes.height * 0.5;
		if (leftAxes != noone)
		{
			_x = buttonEditAxes.x - _halfArrowWidth - 8;
			draw_text(_x, _y, _arrowString);
		}
		
		// Right arrow
		_arrowString = ">";
		if (rightAxes != noone)
		{
			_x = buttonEditAxes.x + buttonEditAxes.width - _halfArrowWidth + 8;
			draw_text(_x, _y, _arrowString);
		}
		
		// Up arrow
		_x = buttonEditAxes.x + buttonEditAxes.width * 0.5;
		if (topAxes != noone)
		{
			_y = buttonEditAxes.y - 4;
			draw_text_transformed(_x, _y, _arrowString, 1, 1, 90);
		}
		
		// Down arrow
		if (bottomAxes != noone)
		{
			_y = buttonEditAxes.y + buttonEditAxes.height + 2;
			draw_text_transformed(_x, _y, _arrowString, 1, 1, 270);
		}
		
		// Reset color
		draw_set_color(c_white);
		
		#endregion
	}
}