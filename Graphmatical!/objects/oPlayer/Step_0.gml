// Update inputs
if (canMove)
{
	// Move inputs
	inputMove.x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
	inputMove.y = keyboard_check(ord("S")) - keyboard_check(ord("W"));
	inputJump = keyboard_check(vk_space);
	inputJumpPressed = keyboard_check_pressed(vk_space);
	inputCrouch = keyboard_check(ord("S"));
}
inputEditorPressed = keyboard_check_pressed(vk_tab);

// Editor
if (inputEditorPressed)
{
	if (instance_exists(oGrapher))
	{
		// Destroy grapher
		instance_destroy(oGrapher);
		
		// Allow movement
		canMove = true;
	}
	else
	{
		// Create grapher
		instance_create_layer(x, y, "Instances", oGrapher);
		
		// Stop move inputs
		canMove = false;
		resetMoveInputs();
	}
}

// Apply x velocity
var _xStrength = runStrength;
if (!grounded) _xStrength = driftStrength;
else if (inputCrouch) _xStrength = 0;
velocity.x += inputMove.x * _xStrength;

// Resistances
if (inputCrouch) groundConstant = slideGroundConstant;
else groundConstant = runGroundConstant;

#region Jump

// Set coyote jump
if (!grounded) coyoteBufferCounter = clamp(coyoteBufferCounter-1, 0, coyoteBuffer);
else coyoteBufferCounter = coyoteBuffer;

// Set jump buffer
if (inputJumpPressed && !(inputCrouch && onPassableFloor())) jumpBufferCounter = jumpBuffer;
else jumpBufferCounter = clamp(jumpBufferCounter-1, 0, jumpBuffer);

// Jump if initiated
if (jumpBufferCounter > 0 && (normal.x != 0 || normal.y != 0 || coyoteBufferCounter > 0)) jump();
else if (!grounded && !inputJump && velocity.y < 0) velocity.y += smallJumpStrength;

#endregion

// Rigid body
rbUpdate();

// IKH
ikhUpdate();