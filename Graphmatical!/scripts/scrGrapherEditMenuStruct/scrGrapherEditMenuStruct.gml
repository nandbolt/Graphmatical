/// @func	GrapherEditMenu();
function GrapherEditMenu() : Menu() constructor
{
	// Equations textfields
	textfieldEquations = [];
	textfieldEquationWidth = 112;
	textfieldEquationHeight = 32;
	textfieldEquationVspacing = 8;
	
	// Buttons
	var _width = 16, _height = 16;
	
	// Add equation button
	var _x = 80, _y = 16;
	buttonAddEquation = new GuiButton("+", _x, _y, other.addEquation);
	buttonAddEquation.width = _width;
	buttonAddEquation.height = _height;
	
	// Remove equation button
	_x += 24;
	buttonRemoveEquation = new GuiButton("-", _x, _y, other.removeEquation);
	buttonRemoveEquation.width = _width;
	buttonRemoveEquation.height = _height;
	
	// Remove axes button
	_x += 24;
	if (!instance_exists(oGrapher.currentTerminal))
	{
		buttonRemoveAxes = new GuiButton("T", _x, _y, other.removeAxes);
		buttonRemoveAxes.width = _width;
		buttonRemoveAxes.height = _height;
	}
	
	// Material dropdown
	_x += 24;
	_width = 64;
	if (!instance_exists(oGrapher.currentTerminal))
	{
		dropdownMaterial = new GuiDropdown("Material", _x, _y, ["Normal", "Laser", "Bouncy", "Dotted", "Tube", "Dotted Tube"], oGrapher.currentAxes.material, other.changeMaterial);
		dropdownMaterial.width = _width;
		dropdownMaterial.height = _height;
	}
	
	/// @func	addEquationTextfield();
	static addEquationTextfield = function()
	{
		// Set position
		var _x = 32, _y = buttonAddEquation.y + buttonAddEquation.height + textfieldEquationVspacing;
		for (var _i = 0; _i < array_length(textfieldEquations); _i++)
		{
			_y += textfieldEquationHeight + textfieldEquationVspacing;
		}
		
		// Add textfield to array
		var _i = array_length(textfieldEquations);
		var _equation = other.currentAxes.equations[_i];
		array_push(textfieldEquations, new GuiTextfield("Equation " + string(_i+1), _x, _y, _equation.expressionString, "", other.enterEquation));
		textfieldEquations[_i].width = textfieldEquationWidth;
		textfieldEquations[_i].height = textfieldEquationHeight;
	}
	
	/// @func	removeEquationTextfield();
	static removeEquationTextfield = function()
	{
		// Pop equation textfield from array
		var _textfieldEquation = array_pop(textfieldEquations);
		
		// Cleanup
		_textfieldEquation.cleanup();
		delete _textfieldEquation;
	}
	
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
		
		// Terminal
		var _hasTerminal = instance_exists(oGrapher.currentTerminal);
		
		// Equations
		var _x = 16, _y = 16;
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_text(_x, _y, "Equations");
		
		// Y's
		draw_set_color(c_white);
		_y += 32;
		for (var _i = 0; _i < array_length(textfieldEquations); _i++)
		{
			draw_text_ext(_x, _y, "y=", 16, 200);
			_y += textfieldEquationHeight + textfieldEquationVspacing;
		}
		
		// Error messages
		_x += textfieldEquationWidth + 24;
		_y = 48;
		for (var _i = 0; _i < array_length(textfieldEquations); _i++)
		{
			draw_set_color(#fffc40);
			draw_text_ext(_x, _y, other.currentAxes.equations[_i].errorMessage, 16, 200);
			_y += textfieldEquationHeight + textfieldEquationVspacing;
			
			// Get focus index
			if (textfieldEquations[_i].hasFocus())
			{
				with (other.currentAxes.equations[_i])
				{
					draw_set_color(c_white);
					// Equation stats
					draw_set_halign(fa_right);
					var _xx = display_get_gui_width() - 16, _yy = 16 * 5;
					draw_text(_xx, _yy, "Domain count: "+string(array_length(xGraphPaths)));
					for (var _j = 0; _j < array_length(xGraphPaths); _j++)
					{
						_yy += 16;
						var _domain = xGraphPaths[_j], _domainCount = array_length(_domain);
						var _domainString = "?";
						if (_domainCount < 4) _domainString = string(_domain);
						else _domainString = "[" + string(xToAxisX(axes, _domain[0])) + ", ..., " + string(xToAxisX(axes, _domain[_domainCount - 1])) + "  ]";
						draw_text(_xx, _yy, "Domain " + string(_j + 1) + ": " + _domainString);
					}
					draw_set_halign(fa_left);
				}
			}
		}
		draw_set_color(c_white);
		
		// Axes stats
		draw_set_halign(fa_right);
		_x = display_get_gui_width() - 16;
		_y = 16;
		draw_text(_x, _y, "Origin: ("+string(floor(other.currentAxes.x / TILE_SIZE)) + ", " + string(floor(-other.currentAxes.y / TILE_SIZE)) + ")");
		_y += 16;
		draw_text(_x, _y, "Width: "+string(other.currentAxes.upperDomain * 2));
		_y += 16;
		draw_text(_x, _y, "Height: "+string(other.currentAxes.upperRange * 2));
		_y += 16;
		if (!_hasTerminal) draw_text(_x, _y, "Axes count: "+string(instance_number(oAxes)));
		
		// Adjust axes
		if (!_hasTerminal)
		{
			draw_set_halign(fa_right);
			draw_set_valign(fa_bottom);
			_x = display_get_gui_width() - 16;
			_y = display_get_gui_height() - 16;
			draw_text(_x, _y, "Scale axes: Shift + Arrow keys");
			_y -= 16;
			draw_text(_x, _y, "Move origin: Arrow keys");
		}
	}
	
	// Load equations
	for (var _i = 0; _i < array_length(other.currentAxes.equations); _i++)
	{
		addEquationTextfield();
	}
}