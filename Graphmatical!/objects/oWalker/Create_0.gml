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

/// @func	die();
die = function()
{
	// Death
	for (var _i = 0; _i < 9; _i++)
	{
		var _x = irandom_range(x - 8, x + 8), _y = irandom_range(y - 8, y + 8);
		with (oParticleManager)
		{
			part_particles_create_color(partSystem, _x, _y, partTypeDust, #8B93AF, 1);
		}
	}
	audio_play_sound(sfxHurt, 2, false);
	instance_destroy();
}

#endregion

// Set interactable alarm
alarm[2] = 30;