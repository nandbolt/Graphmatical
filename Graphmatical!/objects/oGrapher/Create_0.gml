// State
currentState = GrapherState.INIT;

// Menu
currentMenu = undefined;

#region Functions

/// @func	createGraph();
createGraph = function()
{
	show_debug_message("New graph created!");
	changeMenu(GrapherChooseMenu);
}

/// @func	selectGraph();
selectGraph = function()
{
	show_debug_message("Existing graph selected!");
	changeMenu(GrapherChooseMenu);
}

/// @func	editGraph();
editGraph = function()
{
	show_debug_message("Editing existing graph!");
	changeMenu();
}

#endregion

// Init first menu
currentMenu = new GrapherInitMenu();