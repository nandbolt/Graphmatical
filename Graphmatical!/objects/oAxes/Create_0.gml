// Equations
equations = [new Equation(self)];

// Visibility
bboxVisible = false;
axesVisible = false;

// Domain(x) + range(y)
lowerDomain = -9;
upperDomain = 9;
lowerRange = -5;
upperRange = 5;

// Material
material = GraphType.LASER;

#region Functions

/// @func	setAxesSize({int} tileWidth, {int} tileHeight);
setAxesSize = function(_tileWidth=18, _tileHeight=10)
{
	// If big enough dimensions
	if (_tileWidth > 0 && _tileHeight > 0)
	{
		// Dimensions
		image_xscale = _tileWidth * TILE_SIZE * 0.5;
		image_yscale = _tileHeight * TILE_SIZE * 0.5;
	
		// Domain + range
		lowerDomain = -_tileWidth * 0.5;
		upperDomain = _tileWidth * 0.5;  
		lowerRange = -_tileHeight * 0.5;
		upperRange = _tileHeight * 0.5;
	}
}

/// @func	regraphEquations();
regraphEquations = function()
{
	for (var _i = 0; _i < array_length(equations); _i++)
	{
		with (equations[_i])
		{
			set(expressionString);
		}
	}
}

#endregion

// Set size of axes
setAxesSize();

// Visibility
image_alpha = 0.2;
image_blend = #92dcba;