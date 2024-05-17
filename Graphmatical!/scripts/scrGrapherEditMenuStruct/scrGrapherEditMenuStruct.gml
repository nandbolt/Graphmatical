/// @func	GrapherEditMenu();
function GrapherEditMenu() : Menu() constructor
{
	// Equations textfields
	textfieldEquations = [];
	textfieldEquationWidth = 104;
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
	
	/// @func	addEquationTextfield();
	static addEquationTextfield = function()
	{
		// Set position
		var _x = 16, _y = buttonAddEquation.y + buttonAddEquation.height + textfieldEquationVspacing;
		for (var _i = 0; _i < array_length(textfieldEquations); _i++)
		{
			_y += textfieldEquationHeight + textfieldEquationVspacing;
		}
		
		// Add textfield to array
		var _i = array_length(textfieldEquations);
		var _equation = other.currentAxes.equations[_i];
		array_push(textfieldEquations, new GuiTextfield("Equation " + string(_i+1), _x, _y, _equation.equationString, "", other.enterEquation));
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
		
		// Equations
		var _x = 16, _y = 16;
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_text(_x, _y, "Equations");
		
		// Error messages
		_x += textfieldEquationWidth + 8;
		_y += 32;
		for (var _i = 0; _i < array_length(textfieldEquations); _i++)
		{
			draw_text_ext(_x, _y, other.currentAxes.equations[_i].errorMessage, 16, 200);
			_y += textfieldEquationHeight + textfieldEquationVspacing;
		}
	}
	
	// Load equations
	for (var _i = 0; _i < array_length(other.currentAxes.equations); _i++)
	{
		addEquationTextfield();
	}
}