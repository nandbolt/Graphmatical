/// @func	GrapherInitMenu();
function GrapherInitMenu() : Menu() constructor
{
	// Buttons
	var _x = display_get_gui_width() * 0.5 - 100, _y = display_get_gui_height() * 0.5 - 32;
	buttonCreateGraph = new GuiButton("create new graph", _x, _y, other.createGraph);
	_y += 32;
	buttonSelectGraph = new GuiButton("select existing graph", _x, _y, other.selectGraph);
}