/// @func	GrapherEditMenu();
function GrapherEditMenu() : Menu() constructor
{
	// Buttons
	var _width = 100, _height = 32, _vspacing = 8;
	
	// Create axes button
	var _x = 16, _y = 32;
	textfieldEquations = [new GuiTextfield("Equation 1", _x, _y, "", "y=x+4")];
	textfieldEquations[0].width = _width;
	textfieldEquations[0].height = _height;
	
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
}