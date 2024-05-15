/// @func	Equation();
function Equation() constructor
{
	equationString = "";
	graph = noone;
	
	/// @func	cleanup();
	static cleanup = function()
	{
		// Destroy graph
		if (graph != noone) instance_destroy(graph);
	}
	
	/// @func	set({string} equationString);
	static set = function(_equationString="")
	{
		equationString = _equationString;
	}
	
	/// @func	graphEquation();
	static graphEquation = function()
	{
		// Debug message
		show_debug_message("Equation graphed!");
		
		// If graph doesn't exist
		if (graph == noone)
		{
			// Create graph
			graph = instance_create_layer(other.x, other.y, "Instances", oGraph);
			
			// Set expression
		}
		else
		{
			// Clear expression
			
			// Set expression
		}
	}
}