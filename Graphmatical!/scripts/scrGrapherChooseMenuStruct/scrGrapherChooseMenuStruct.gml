/// @func	GrapherChooseMenu();
function GrapherChooseMenu() : Menu() constructor
{
	// Buttons
	var _x = display_get_gui_width() * 0.5 - 100, _y = display_get_gui_height() * 0.5 - 16;
	buttonCreateGraph = new GuiButton("edit?", _x, _y, other.editGraph);
	_y += 32;
	//buttonSelectGraph = new GuiButton("select existing graph", _x, _y, other.selectExistingGraph);
}