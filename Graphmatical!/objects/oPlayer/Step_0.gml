// Update inputs
if (canMove)
{
	// Move inputs
	inputMove.set(keyboard_check(ord("D")) - keyboard_check(ord("A")), keyboard_check(ord("S")) - keyboard_check(ord("W")));
	inputJump = keyboard_check(vk_space);
	inputJumpPressed = keyboard_check_pressed(vk_space);
	inputCrouch = keyboard_check(ord("S"));
}
inputEditorPressed = keyboard_check_pressed(vk_tab);

// Editor
if (inputEditorPressed)
{
	if (instance_exists(oPauser))
	{
		// Destroy editor
		instance_destroy(oPauser);
		
		// Allow movement
		canMove = true;
		
		// Set current editor
		currentEditor = oPauser;
		
		// Close editor sfx
		audio_play_sound(sfxOpenEditor, 2, false);
	}
	else if (instance_exists(oGrapher))
	{
		// Set current editor
		if (instance_exists(oGrapher.currentTerminal)) currentEditor = oPauser;
		else currentEditor = oGrapher;
		
		// Destroy grapher
		instance_destroy(oGrapher);
		
		// Allow movement
		canMove = true;
		
		// Close editor sfx
		audio_play_sound(sfxOpenEditor, 2, false);
	}
	else if (instance_exists(oTiler))
	{
		// Destroy grapher
		instance_destroy(oTiler);
		
		// Allow movement
		canMove = true;
		
		// Set current editor
		currentEditor = oTiler;
		
		// Close editor sfx
		audio_play_sound(sfxOpenEditor, 2, false);
	}
	else
	{
		// Create current editor
		var _x = camera_get_view_x(view_camera[0]) + oCamera.halfCamWidth, _y = camera_get_view_y(view_camera[0]) + oCamera.halfCamHeight;
		_x -= _x mod TILE_SIZE;
		_y -= _y mod TILE_SIZE;
		instance_create_layer(_x, _y, "Instances", currentEditor);
		
		// Stop move inputs
		canMove = false;
		resetMoveInputs();
	}
}

// State logic
switch (currentState)
{
	case HumanState.NORMAL:
		// Ignore graphs
		if (inputCrouch && inputJump) ignoreGraphs = true;
		else ignoreGraphs = false;

		#region Apply Move Input

		// Calculate strengths
		var _moveStrength = runStrength;
		if (inputCrouch) _moveStrength = 0;
		if (!grounded) _moveStrength = driftStrength;

		// Apply input
		velocity.x += inputMove.x * _moveStrength;

		#endregion

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
		
		// NORMAL -> FLY
		if (inputJumpPressed && keyboard_check(vk_shift) && global.editMode)
		{
			currentState = HumanState.FLY;
			ignoreGraphs = true;
			gravityStrength = 0;
		}
		break;
	case HumanState.RIDE:
		// If you have a ride
		if (instance_exists(ride))
		{
			// Move to ride
			velocity.x = 0;
			velocity.y = 0;
			x = ride.x;
			y = ride.y;
		}
		break;
	case HumanState.FLY:
		#region Apply Move Input
		
		// Apply input
		if (inputMove.getLength() > 0)
		{
			velocity.x += inputMove.x * runStrength;
			velocity.y += inputMove.y * runStrength;
		}
		else
		{
			velocity.x = lerp(velocity.x, 0, 0.1);
			velocity.y = lerp(velocity.y, 0, 0.1);
		}

		#endregion
		
		// FLY -> NORMAL
		if (inputJumpPressed && keyboard_check(vk_space))
		{
			currentState = HumanState.NORMAL;
			ignoreGraphs = false;
			gravityStrength = normalGravity;
		}
		break;
}

// Update rigid body movements
rbUpdate();

// Update ikh animations based on resulting rigid body
isVisible = visibleToCamera(self.id);
if (isVisible) ikhUpdate();

// Slide sound
if (grounded && inputCrouch && abs(velocity.x) > 0.05 && !audio_is_playing(sfxSlide))
{
	audio_play_sound(sfxSlide, 1, false, clamp(abs(velocity.x) * 0.25, 0, 1));
}