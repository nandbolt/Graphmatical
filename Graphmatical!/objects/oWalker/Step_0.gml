// Update walls
rightWall = false;
leftWall = false;
if (inputDirection.x > 0) rightWall = rbTileCollisionAtPoint(bbox_right+1, y) != -1;
else leftWall = rbTileCollisionAtPoint(bbox_left-1, y) != -1;

// Ground walking
updateNearGround();
if (grounded || nearGround)
{
	// Turn off gravity
	gravityStrength = 0;
	
	// Lerp body to ground walk position
	groundY = floor((bbox_bottom + TILE_SIZE) / TILE_SIZE) * TILE_SIZE;
	nearGroundGoalYMax = groundY - HALF_TILE_SIZE + 2;
	nearGroundGoalYMin = nearGroundGoalYMax - 4;
	if (y > nearGroundGoalYMax) velocity.y = lerp(velocity.y, -0.5, 0.02);
	else if (y < nearGroundGoalYMin) velocity.y = lerp(velocity.y, 0.5, 0.02);
	else velocity.y = lerp(velocity.y, 0, 0.02);
	
	// Update input based off wall locations
	if (rightWall) inputDirection.x = -1;
	else if (leftWall) inputDirection.x = 1;
	
	// Apply input
	velocity.x = inputDirection.x * crawlSpeed;
}
// Turn on gravity
else gravityStrength = normalGravityStrength;

// Update rigid body movements
rbUpdate();

// Update ikh animations based on resulting rigid body
isVisible = visibleToCamera(self.id);
if (isVisible) ikhWalkerUpdate();

// Rotate
var _diff = angle_difference(velocity.getAngleDegrees(), imageAngle);
imageAngle += _diff * rotationSpeed;