// Equations
equations = [new Equation()];

// Visibility
bboxVisible = true;
axesVisible = true;

// Domain(x) + range(y)
lowerDomain = -9;
upperDomain = 9;
lowerRange = -5;
upperRange = 5;

#region Functions

/// @func	setAxesSize({int} tileWidth, {int} tileHeight);
setAxesSize = function(_tileWidth=18, _tileHeight=10)
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

#endregion

// Set size of axes
setAxesSize();

// Visibility
image_alpha = 0.2;