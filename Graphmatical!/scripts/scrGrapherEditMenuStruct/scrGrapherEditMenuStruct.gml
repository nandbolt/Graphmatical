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
		array_push(textfieldEquations, new GuiTextfield("Equation " + string(_i+1), _x, _y, "", "", other.enterEquation));
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
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_text(16, 16, "Equations");
	}
	
	// Load equations
	addEquationTextfield();
	//_width = 100;
	//_height = 32;
	//_x = 16;
	//_y += buttonAddEquation.height + _vspacing;
	//var _equations = other.currentAxes.equations;
	//for (var _i = 0; _i < array_length(_equations); _i++)
	//{
	//	array_push(textfieldEquations, new GuiTextfield("Equation " + string(_i+1), _x, _y, _equations[_i].equationString, ""));
	//	textfieldEquations[_i].width = _width;
	//	textfieldEquations[_i].height = _height;
	//	_y += _height + _vspacing;
	//}
}