/// @func	GuiDropdown({string} name, {real} x, {real} y, {array} options, {int} idx {func} onChange);
function GuiDropdown(_name, _x, _y, _options, _idx, _onChange=function(){}) : GuiElement() constructor
{
	// Values
	name = _name;
	x = _x;
	y = _y;
	onChange = _onChange;
	options = _options;
	
	/// @func	listen();
	static listen = function()
	{
		// Return if no mouse click
		if (!mouse_check_button_pressed(mb_left)) return;
		
		// Prevent click-through
		canClick = false;
		
		// Loop through options
		for (var _i = 0; _i < array_length(options); _i++)
		{
			// Continue if didn't click
			if (!point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y + (height * (_i + 1)), x + width, y + (height * (_i + 2)))) continue;
			
			// Set value and return
			set(_i);
			onChange();
			removeFocus();
			//show_debug_message("You selected option #" + string(get()) + " (`" + (options[get()]) + "`) in the Dropdown named `" + string(name) + "`!");
			return;
		}
	}
	
	/// @func	drawGui();
	static drawGui = function()
	{
		// Get focus
		var _hasFocus = hasFocus();
		
		// If menu is open
		if (_hasFocus)
		{
			// Options border
			//draw_sprite_stretched(sBorder1, 0, x, y + height, width, height * array_length(options));
			
			// Loop through options
			for (var _i = array_length(options)-1; _i >= 0; _i--)
			{
				// Draw option
				if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y + (height * (_i + 1)), x + width, y + (height * (_i + 2))))
				{
					// Hover
					draw_set_alpha(0.8);
					draw_sprite_stretched(sBorder2, 0, x, y + (height * (_i + 1)), width, height);
					
				}
				else
				{
					// No hover
					draw_set_alpha(0.5);
					draw_sprite_stretched(sBorder1, 0, x, y + (height * (_i + 1)), width, height);
				}
				draw_set_alpha(1);
				draw_text(x + width * 0.5 - string_width(name) * 0.5, y + height * (_i + 1.5), options[_i]);
			}
		}
		
		if (hovering)
		{
			// Border
			draw_set_alpha(0.8);
			draw_sprite_stretched(sBorder2, 0, x - hoverSizeIncrease, y - hoverSizeIncrease, width + hoverSizeIncrease * 2, height + hoverSizeIncrease * 2);
		}
		else
		{
			// Border
			draw_set_alpha(0.5);
			draw_sprite_stretched(sBorder1, 0, x, y, width, height);
		}
		draw_set_alpha(1);
		
		// Text
		draw_text(x + width * 0.5 - string_width(name) * 0.5, y + height * 0.5, options[get()]);
		
		// Down arrow
		if (_hasFocus)
		{
			draw_set_color(#92dcba);
			draw_text(x + width * 0.5 + string_width(name) * 0.5, y + height * 0.5, "v");
			draw_set_color(c_white);
		}
	}
	
	// Set value
	set(_idx);
}