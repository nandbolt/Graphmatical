// Inherit the parent event
event_inherited();

// Display
name = "Grapher";

// Graph
axes = noone;
axesOriginX = x - x mod TILE_SIZE + TILE_SIZE;
axesOriginY = y - y mod TILE_SIZE - TILE_SIZE * 4;

#region Functions

/// @func	interactPressed();
interactPressed = function()
{
	// Create graph editor
	with(instance_create_layer(axesOriginX, axesOriginY, "Instances", oGrapher))
	{
		// Set terminal
		currentTerminal = other.id;
		
		// Set axes
		if (instance_exists(other.axes)) currentAxes = other.axes;
		else currentAxes = instance_create_layer(other.axesOriginX, other.axesOriginY, "Instances", oAxes);
		other.axes = currentAxes;
		
		// Edit graph
		changeMenu(GrapherEditMenu);
	}
		
	// Stop move inputs
	if (instance_exists(oPlayer))
	{
		with (oPlayer)
		{
			canMove = false;
			resetMoveInputs();
		}
	}
}

/// @func	initGraph();
initGraph = function()
{
	// Destroy axes if it exists
	if (instance_exists(axes)) instance_destroy(axes);
	
	// Create axes
	axes = instance_create_layer(axesOriginX, axesOriginY, "Instances", oAxes);
	
	// Set equations
}

#endregion

// Init graph
initGraph();