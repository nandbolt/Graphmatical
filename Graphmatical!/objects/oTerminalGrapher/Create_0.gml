// Inherit the parent event
event_inherited();

// Display
name = "Grapher";

// Graph
axes = noone;
axesOriginX = x - x mod TILE_SIZE + TILE_SIZE;
axesOriginY = y - y mod TILE_SIZE - TILE_SIZE * 4;
axesOffsetX = 1;
axesOffsetY = -4;
axesWidth = 18;
axesHeight = 10;
material = GraphType.NORMAL;
initialEquations = [""];

#region Functions

/// @func	interactPressed();
interactPressed = function()
{
	// Init graph if no axes initialized
	if (!instance_exists(axes)) initGraph();
	
	// Equation count
	//show_debug_message("eq count: " + string(array_length(axes.equations)));
	
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
	
	// Get axes origin
	axesOriginX = x - x mod TILE_SIZE + TILE_SIZE * axesOffsetX;
	axesOriginY = y - y mod TILE_SIZE + TILE_SIZE * axesOffsetY;
	
	// If there's axes already there, set that as the axes
	var _nearestAxes = instance_nearest(axesOriginX, axesOriginY, oAxes);
	if (point_distance(axesOriginX, axesOriginY, _nearestAxes.x, _nearestAxes.y) == 0)
	{
		axes = _nearestAxes;
		return;
	}
	
	// Create axes
	axes = instance_create_layer(axesOriginX, axesOriginY, "Instances", oAxes);
	with (axes)
	{
		// Set material
		material = other.material;
		
		// Equations
		for (var _i = 0; _i < array_length(other.initialEquations); _i++)
		{
			if (_i >= array_length(equations)) array_push(equations, new Equation(self));
			equations[_i].set(other.initialEquations[_i]);
		}

		// Set size
		setAxesSize(other.axesWidth, other.axesHeight);

		// Regraph
		regraphEquations();
	}
}

#endregion