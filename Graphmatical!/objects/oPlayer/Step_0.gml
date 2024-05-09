// Update inputs
inputRunDirection = keyboard_check(ord("D")) - keyboard_check(ord("A"));
inputJump = keyboard_check(vk_space);
inputJumpPressed = keyboard_check_pressed(vk_space);
inputCrouch = keyboard_check(ord("S"));

// Apply x velocity
var _xStrength = runStrength;
if (!grounded) _xStrength = driftStrength;
else if (inputCrouch) _xStrength = 0;
velocity.x += inputRunDirection * _xStrength;

// Resistances
if (inputCrouch) groundConstant = slideGroundConstant;
else groundConstant = runGroundConstant;

#region Jump

// Set coyote jump
if (!grounded) coyoteBufferCounter = clamp(coyoteBufferCounter-1, 0, coyoteBuffer);
else coyoteBufferCounter = coyoteBuffer;

// Set jump buffer
if (inputJumpPressed && !inputCrouch) jumpBufferCounter = jumpBuffer;
else jumpBufferCounter = clamp(jumpBufferCounter-1, 0, jumpBuffer);

// Jump if initiated
if (jumpBufferCounter > 0 && (grounded || coyoteBufferCounter > 0)) jump();

#endregion

// Rigid body
rbUpdate();

#region Animations

// If airborne
if (!grounded)
{
	// If moving up
	if (velocity.y < 0)
	{
		// Center jump
		if (abs(velocity.x) < 0.5) sprite_index = sHumanJumpCenter;
		// Jump
		else sprite_index = sHumanJump;
	}
	// Fall
	else sprite_index = sHumanFall;
}
else
{
	// If crouch input
	if (inputCrouch)
	{
		// Crouch
		if (abs(velocity.x) < 0.05) sprite_index = sHumanCrouch;
		// Slide
		else sprite_index = sHumanSlide;
	}
	// Run
	else if (inputRunDirection != 0) sprite_index = sHumanRun;
	// Idle
	else sprite_index = sHumanIdle;
}

// Update image xscale based on x velocity
if (velocity.x > 0) image_xscale = 1;
else image_xscale = -1;

#endregion