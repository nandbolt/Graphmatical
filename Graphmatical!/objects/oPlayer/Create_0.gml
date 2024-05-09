// States
debugMode = global.debugMode;

// Rigid body
rbInit();

// Inputs
inputRunDirection = 0;
inputJump = false;
inputJumpPressed = false;
inputCrouch = false;

// Movement
runStrength = 0.2;

// Jumping
jumpStrength = 3;
driftStrength = 0.05;
jumpBuffer = 10;
jumpBufferCounter = 0;
coyoteBuffer = 10;
coyoteBufferCounter = 0;

// Resistances
runGroundConstant = 0.15;
slideGroundConstant = 0.02;

#region Functions

/// @func	jump();
jump = function()
{
	// Apply jump
	velocity.x += normal.x * jumpStrength;
	velocity.y += normal.y * jumpStrength;
	
	// Reset counters
	jumpBufferCounter = 0;
	coyoteBufferCounter = 0;
	grounded = false;
}

#endregion