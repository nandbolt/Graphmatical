// Inherit parent
event_inherited();

// Rigid body
rbInit();

// IKH
ikhWalkerInit();

// Input
inputDirection = new Vector2(1, 0);

// Movement
crawlSpeed = 0.4;

// Rotation
rotates = true;				// To let parent know to draw using imageAngle rather than image_angle
rotationSpeed = 0.05;

// Graphs
ignoreGraphs = true;
touchingGraph = false;

// Gravity
normalGravityStrength = 0.05;

// Ground
nearGround = false;
groundY = 0;
nearGroundGoalYMin = 0;
nearGroundGoalYMax = 0;
groundAxes = noone;
groundEquation = undefined;

// Walls
rightWall = false;
leftWall = false;

// Visible
isVisible = true;

#region Functions

/// @func	interactPressed();
interactPressed = function()
{
	with (oPlayer)
	{
		toggleRide(other.id);
	}
}

///	@func	updateNearGround();
updateNearGround = function()
{
	nearGround = rbTileCollisionAtPoint(x, bbox_bottom + HALF_TILE_SIZE) != -1;
}

#endregion