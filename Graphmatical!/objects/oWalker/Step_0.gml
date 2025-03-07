// Update walls
rightWall = false;
leftWall = false;
if (inputDirection.x > 0)
{
	rightWall = rbTileCollisionAtPoint(bbox_right+1, bbox_top) != -1;
	if (!rightWall) rightWall = rbTileCollisionAtPoint(bbox_right+1, bbox_bottom) != -1;
}
else
{
	leftWall = rbTileCollisionAtPoint(bbox_left-1, bbox_top) != -1;
	if (!leftWall) leftWall = rbTileCollisionAtPoint(bbox_left-1, bbox_bottom) != -1;
}

// Update input based off wall locations
if (rightWall) inputDirection.x = -1;
else if (leftWall) inputDirection.x = 1;

// Get graph colliding with
touchingGraph = false;
groundAxes = noone;
groundEquation = undefined;
if (!grounded && instance_exists(oAxes))
{
	// Check if graph 
	var _axes = noone;
	with (graphDetector)
	{
		// Grab touching axes
		_axes = instance_place(x + other.velocity.x, y + other.velocity.y, oAxes);
	}
		
	// Get axes collided with
	if (instance_exists(_axes))
	{
		// Go through equations
		for (var _i = 0; _i < array_length(_axes.equations); _i++)
		{
			// If touching an equation
			if (graphTouching(_axes.equations[_i], self.id))
			{
				// Get goal y
				var _groundX = x + inputDirection.x * crawlSpeed;
				var _groundAxisY = _axes.equations[_i].evaluate(xToAxisX(_axes, _groundX));
				if (!is_string(_groundAxisY))
				{
					// Calculate goal ground position
					var _groundY = axisYtoY(_axes, _groundAxisY);
					
					// If not in a tile
					if (rbTileCollisionAtPoint(_groundX, _groundY) == -1)
					{
						// Calculate velocity
						var _v = new Vector2(_groundX - x, _groundY - y);
						_v.normalize();
						_v.scale(crawlSpeed);
						velocity.set(lerp(velocity.x, _v.x, 0.5), lerp(velocity.y, _v.y, 0.5));
					
						// On graph bool
						touchingGraph = true;
						groundAxes = _axes;
						groundEquation = _axes.equations[_i];
					}
				}
				
				// Stop checking equations
				break;
			}
		}
	}
}

// Ground walking
updateNearGround();
if (!touchingGraph && (grounded || nearGround))
{
	// Lerp body to ground walk position
	groundY = floor((bbox_bottom + TILE_SIZE) / TILE_SIZE) * TILE_SIZE;
	nearGroundGoalYMax = groundY - HALF_TILE_SIZE + 2;
	nearGroundGoalYMin = nearGroundGoalYMax - 4;
	if (y > nearGroundGoalYMax) velocity.y = lerp(velocity.y, -0.5, 0.02);
	else if (y < nearGroundGoalYMin) velocity.y = lerp(velocity.y, 0.5, 0.02);
	else velocity.y = lerp(velocity.y, 0, 0.02);
	
	// Apply input
	velocity.x = lerp(velocity.x, inputDirection.x * crawlSpeed, 0.5);
}

// Gravity
if (touchingGraph || grounded || nearGround) gravityStrength = 0;
else gravityStrength = normalGravityStrength;

// Update rigid body movements
rbUpdate();

// Update ikh animations based on resulting rigid body
isVisible = visibleToCamera(self.id);
if (isVisible) ikhWalkerUpdate();

// Rotate
var _diff = angle_difference(velocity.getAngleDegrees(), imageAngle);
imageAngle += _diff * rotationSpeed;
if (imageAngle > 180) imageAngle -= 360;
else if (imageAngle < -180) imageAngle += 360;