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
jumpBuffer = 10;
jumpBufferCounter = 0;
coyoteBuffer = 10;
coyoteBufferCounter = 0;

#region Functions

/// @func	jump();
jump = function()
{
	// Apply jump
	velocity.y = -jumpStrength;
	
	// Reset counters
	jumpBufferCounter = 0;
	coyoteBufferCounter = 0;
}

#endregion