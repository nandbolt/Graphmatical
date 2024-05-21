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
		var _x = camera_get_view_x(view_camera[0]) + oCamera.halfCamWidth, _y = camera_get_view_y(view_camera[0]) + oCamera.halfCamHeight;
		_x -= _x mod TILE_SIZE;
		_y -= _y mod TILE_SIZE;
		instance_create_layer(_x, _y, "Instances", oGrapher);
		
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
if (inputJumpPressed && !inputCrouch) jumpBufferCounter = jumpBuffer;
else jumpBufferCounter = clamp(jumpBufferCounter-1, 0, jumpBuffer);

// Jump if initiated
if (jumpBufferCounter > 0 && (grounded || coyoteBufferCounter > 0)) jump();
else if (!grounded && !inputJump && velocity.y < 0) velocity.y += smallJumpStrength;

#endregion

// Update rigid body movements
rbUpdate();

// Update ikh animations based on resulting rigid body
ikhUpdate();