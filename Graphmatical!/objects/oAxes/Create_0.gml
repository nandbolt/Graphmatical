// Equations
equations = [new Equation()];

// Visibility
bboxVisible = true;
axesVisible = true;

#region Functions

/// @func	setAxesSize({int} tileWidth, {int} tileHeight);
setAxesSize = function(_tileWidth=18, _tileHeight=10)
{
	// Dimensions
	image_xscale = _tileWidth * TILE_SIZE * 0.5;
	image_yscale = _tileHeight * TILE_SIZE * 0.5;
}

/// @func	addEquation

#endregion

// Set size of axes
setAxesSize();

// Visibility
image_alpha = 0.2;