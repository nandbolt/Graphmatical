/// @func	ikhInit();
///	@desc	Inits an inverse kinematic human. This assumes it is also a rigid body, too.
function ikhInit()
{
	// Animation states
	currentAnimationState = HumanAnimationState.IDLE;
	currentAnimationStateName = "Idle";
	currentAnimationFunc = ikhAnimIdle;
	animationCounter = 0;
	animationSpeed = 0.1;
	
	// Root positions
	neckPosition = new Vector2(x, y - 4);
	hipPosition = new Vector2(x, y);
	
	// Arms
	rightArm = new Arm(neckPosition.x, neckPosition.y, 3, 3, -30, 30);
	leftArm = new Arm(neckPosition.x, neckPosition.y, 3, 3, 210, 30);
	leftArm.color = #b3b9d1;
	
	// Legs
	rightLeg = new Arm(hipPosition.x, hipPosition.y, 4, 4, -45, -45);
	leftLeg = new Arm(hipPosition.x, hipPosition.y, 4, 4, -90, -45);
	rightLeg.flippedArm = true;
	leftLeg.flippedArm = true;
	leftLeg.color = #b3b9d1;
	
	// Run animation
	leftFootGrounded = true;
	
	// Slide
	slideParticleCounter = 0;
}

/// @func	ikhCleanup();
function ikhCleanup()
{
	// Vectors
	delete neckPosition;
	delete hipPosition;
	
	// Arms
	rightArm.cleanup();
	leftArm.cleanup();
	rightLeg.cleanup();
	leftLeg.cleanup();
}

/// @func	ikhUpdate();
function ikhUpdate()
{
	// Facing direction
	if (velocity.x > 0) image_xscale = 1;
	else if (velocity.x < 0) image_xscale = -1;

	// Update animation state
	ikhUpdateAnimState();

	// Update animation counter
	animationCounter += animationSpeed;
	
	// Run animation
	currentAnimationFunc();

	// Move roots
	rightArm.moveRoot(neckPosition.x, neckPosition.y);
	leftArm.moveRoot(neckPosition.x, neckPosition.y);
	rightLeg.moveRoot(hipPosition.x, hipPosition.y);
	leftLeg.moveRoot(hipPosition.x, hipPosition.y);

	// Move limbs
	rightArm.moveArm();
	leftArm.moveArm();
	rightLeg.moveArm();
	leftLeg.moveArm();
}

/// @func	ikhDraw();
function ikhDraw()
{
	// Head
	//draw_sprite(sHumanHead, 0, neckPosition.x, neckPosition.y);
	draw_sprite_ext(sHumanHeadRound, 0, neckPosition.x, neckPosition.y, 0.25, 0.25, 0, c_white, 1);
	
	// If looking right
	if (image_xscale > 0)
	{
		// Left side is back
		leftArm.color = #b3b9d1;
		leftLeg.color = #b3b9d1;
		if (currentState == HumanState.RIDE)
		{
			leftArm.color = c_white;
			leftLeg.color = c_white;
		}
		leftArm.draw();
		leftLeg.draw();
	}
	else
	{
		// Right side is back
		rightArm.color = #b3b9d1;
		rightLeg.color = #b3b9d1;
		if (currentState == HumanState.RIDE)
		{
			rightArm.color = c_white;
			rightLeg.color = c_white;
		}
		rightArm.draw();
		rightLeg.draw();
	}

	// Body
	var _bodyLength = point_distance(neckPosition.x, neckPosition.y, hipPosition.x, hipPosition.y);
	var _bodyAngle = point_direction(neckPosition.x, neckPosition.y, hipPosition.x, hipPosition.y);
	//draw_sprite_ext(sSquare, 0, neckPosition.x, neckPosition.y, _bodyLength * 0.5, 0.5, _bodyAngle, #dae0ea, 1);
	draw_sprite_ext(sSquareRound1, 0, neckPosition.x, neckPosition.y, _bodyLength * 0.125, 0.125, _bodyAngle, #dae0ea, 1);
	
	// If looking right
	if (image_xscale > 0)
	{
		// Left side is front
		rightArm.color = c_white;
		rightLeg.color = c_white;
		rightLeg.draw();
		rightArm.draw();
	}
	else
	{
		// Right side is front
		leftArm.color = c_white;
		leftLeg.color = c_white;
		leftLeg.draw();
		leftArm.draw();
	}
}

/// @func	ikhDrawDebug();
function ikhDrawDebug()
{
	// Bones
	rightLeg.drawDebug();
	rightArm.drawDebug();
	leftLeg.drawDebug();
	leftArm.drawDebug();
}

/// @func	ikhUpdateAnimState();
/// @desc	Updates the current animation state.
function ikhUpdateAnimState()
{
	if (currentState == HumanState.RIDE)
	{
		// On entering ride
		if (currentAnimationState != HumanAnimationState.RIDE) currentAnimationStateName = "Ride";
				
		// Ride
		currentAnimationState = HumanAnimationState.RIDE;
		currentAnimationFunc = ikhAnimRide;
	}
	else if (grounded)
	{
		if (velocity.isZero())
		{
			if (inputCrouch)
			{
				// On entering crouch
				if (currentAnimationState != HumanAnimationState.CROUCH) currentAnimationStateName = "Crouch";
				
				// Crouch
				currentAnimationState = HumanAnimationState.CROUCH;
				currentAnimationFunc = ikhAnimCrouch;
			}
			else
			{
				// Ground both feet if entering idle
				if (currentAnimationState != HumanAnimationState.IDLE)
				{
					currentAnimationStateName = "Idle";
					ikhGroundFoot(leftLeg, leftLeg.handPosition.x);
					ikhGroundFoot(rightLeg, rightLeg.handPosition.x);
					
					// Dirt particles
					with (oParticleManager)
					{
						part_particles_create(partSystem, other.leftLeg.handPosition.x, other.leftLeg.handPosition.y, partTypeDirt, 1);
						part_particles_create(partSystem, other.rightLeg.handPosition.x, other.rightLeg.handPosition.y, partTypeDirt, 1);
					}
				}
				
				// Idle
				currentAnimationState = HumanAnimationState.IDLE;
				animationSpeed = 0.1;
				currentAnimationFunc = ikhAnimIdle;
			}
		}
		else
		{
			if (inputCrouch)
			{
				// On entering crouch
				if (currentAnimationState != HumanAnimationState.SLIDE) currentAnimationStateName = "Slide";
				
				// Slide
				currentAnimationState = HumanAnimationState.SLIDE;
				currentAnimationFunc = ikhAnimSlide;
				
				// Dirt particles
				slideParticleCounter++;
				if (slideParticleCounter mod clamp(floor(10 - velocity.getLength()), 1, 10) == 0)
				{
					with (oParticleManager)
					{
						part_particles_create(partSystem, other.leftLeg.handPosition.x, other.leftLeg.handPosition.y, partTypeDirt, 1);
						part_particles_create(partSystem, other.rightLeg.handPosition.x, other.rightLeg.handPosition.y, partTypeDirt, 1);
					}
				}
			}
			else
			{
				// Ground one foot if entering run
				if (currentAnimationState != HumanAnimationState.RUN)
				{
					currentAnimationStateName = "Run";
					ikhGroundFoot(leftLeg, leftLeg.targetPosition.x);
					ikhGroundFoot(rightLeg, rightLeg.targetPosition.x);
				}
				
				// Run
				currentAnimationState = HumanAnimationState.RUN;
				animationSpeed = 0.1;
				currentAnimationFunc = ikhAnimRun;
			}
		}
	}
	else
	{
		if (velocity.y > 0)
		{
			// On entering fall
			if (currentAnimationState != HumanAnimationState.FALL) currentAnimationStateName = "Fall";
			
			// Fall
			currentAnimationState = HumanAnimationState.FALL;
			currentAnimationFunc = ikhAnimFall;
		}
		else
		{
			// If entering jump
			if (currentAnimationState != HumanAnimationState.JUMP)
			{
				currentAnimationStateName = "Jump";
				
				// Dirt particles
				with (oParticleManager)
				{
					part_particles_create(partSystem, other.leftLeg.handPosition.x, other.leftLeg.handPosition.y, partTypeDirt, 2);
					part_particles_create(partSystem, other.rightLeg.handPosition.x, other.rightLeg.handPosition.y, partTypeDirt, 2);
				}
			}
			
			// Jump
			currentAnimationState = HumanAnimationState.JUMP;
			currentAnimationFunc = ikhAnimJump;
		}
	}
}

/// @func	ikhGroundFoot({Arm} leg, {real} xGround);
function ikhGroundFoot(_leg, _xGround)
{
	// If on graph
	if (onGraph)
	{
		// Evaluate x position
		var _ay = onGraphEquation.evaluate(xToAxisX(onGraphEquation.axes, _xGround));
		if (!is_string(_ay)) _leg.moveTarget(_xGround, axisYtoY(onGraphEquation.axes, _ay));
	}
	// Else touching tile
	else _leg.moveTarget(_xGround, bbox_bottom);
}

/// @func	ikhAnimIdle();
/// @desc	Runs the idling animation (grounded, speed approx. zero).
function ikhAnimIdle()
{
	// Facing direction
	if (image_xscale > 0)
	{
		// Arm targets
		leftArm.lerpTarget(x + 4, y-1, 0.2);
		rightArm.lerpTarget(x - 1, y, 0.2);
		
		// Orientation
		rightArm.flippedArm = false;
		leftArm.flippedArm = false;
		rightLeg.flippedArm = true;
		leftLeg.flippedArm = true;
	}
	else
	{
		// Arm targets
		leftArm.lerpTarget(x + 1, y, 0.2);
		rightArm.lerpTarget(x - 4, y-1, 0.2);
			
		// Orientation
		rightArm.flippedArm = true;
		leftArm.flippedArm = true;
		rightLeg.flippedArm = false;
		leftLeg.flippedArm = false;
	}
		
	// Leg targets
	//rightLeg.targetPosition.y = lerp(rightLeg.targetPosition.y, bbox_bottom, 0.2);
	//leftLeg.targetPosition.y = lerp(leftLeg.targetPosition.y, bbox_bottom, 0.2);
			
	// Neck + hip
	var _hover = sin(animationCounter) * 0.5;
	neckPosition.x = x;
	neckPosition.y = lerp(neckPosition.y, y - 4 + _hover, 0.5);
	hipPosition.x = x;
	hipPosition.y = lerp(hipPosition.y, y + _hover, 0.5);
}

/// @func	ikhAnimCrouch();
/// @desc	Runs the crouching animation (grounded, speed approx. zero, input crouch).
function ikhAnimCrouch()
{
	// Facing direction
	if (image_xscale > 0)
	{
		// Arm targets
		leftArm.lerpTarget(x + 4, y + 1, 0.2);
		rightArm.lerpTarget(x - 1, y + 3, 0.2);
			
		// Orientation
		rightArm.flippedArm = false;
		leftArm.flippedArm = false;
		rightLeg.flippedArm = true;
		leftLeg.flippedArm = true;
	}
	else
	{
		// Arm targets
		leftArm.lerpTarget(x + 1, y + 3, 0.2);
		rightArm.lerpTarget(x - 4, y + 1, 0.2);
			
		// Orientation
		rightArm.flippedArm = true;
		leftArm.flippedArm = true;
		rightLeg.flippedArm = false;
		leftLeg.flippedArm = false;
	}
		
	// Leg targets
	rightLeg.targetPosition.y = lerp(rightLeg.targetPosition.y, bbox_bottom, 0.2);
	leftLeg.targetPosition.y = lerp(leftLeg.targetPosition.y, bbox_bottom, 0.2);
			
	// Neck + hip
	var _hover = sin(animationCounter) * 0.5;
	neckPosition.x = x;
	neckPosition.y = lerp(neckPosition.y, y + _hover, 0.5);
	hipPosition.x = x;
	hipPosition.y = lerp(hipPosition.y, y + 4 + _hover, 0.5);
}

/// @func	ikhAnimRun();
/// @desc	Runs the running animation (grounded, speed > zero).
function ikhAnimRun()
{
	// Orientation
	if (image_xscale > 0)
	{
		rightArm.flippedArm = false;
		leftArm.flippedArm = false;
		rightLeg.flippedArm = true;
		leftLeg.flippedArm = true;
	}
	else
	{
		rightArm.flippedArm = true;
		leftArm.flippedArm = true;
		rightLeg.flippedArm = false;
		leftLeg.flippedArm = false;
	}
		
	// If left leg grounded
	if (leftFootGrounded)
	{
		// If left leg too far
		if (leftLeg.getTargetDistance() > leftLeg.rootArmLength + leftLeg.elbowArmLength && sign(leftLeg.targetPosition.x - x) != image_xscale)
		{
			// // Plant right leg forward right if moving right
			if (image_xscale > 0) ikhGroundFoot(rightLeg, bbox_right + 3);
			// Else plant right leg forward left
			else ikhGroundFoot(rightLeg, bbox_left - 3);
				
			// Get target displacement
			var _tx = rightLeg.targetPosition.x, _ty = rightLeg.targetPosition.y;
			var _tdx = x - _tx;
			
			// Move leg targets
			leftLeg.targetPosition.x = x + _tdx;
			
			// Set planted foot
			leftFootGrounded = false;
			
			// Footstep
			if (!audio_is_playing(sfxFootstep)) audio_play_sound(sfxFootstep, 1, false);
			
			// Dirt particles
			with (oParticleManager)
			{
				part_particles_create(partSystem, _tx, _ty, partTypeDirt, 1);
			}
		}
		else
		{
			// Get target displacement
			var _tx = leftLeg.targetPosition.x, _ty = leftLeg.targetPosition.y;
			var _tdx = x - _tx;
			
			// Move leg targets
			ikhGroundFoot(rightLeg, x + _tdx);
			rightLeg.targetPosition.y -= 2;
			
			// Move arm targets
			rightArm.moveTarget(x - _tdx * 0.5, hipPosition.y - 1);
			leftArm.moveTarget(x + _tdx * 0.5, hipPosition.y - 1);
		}
	}
	else
	{	
		// If right leg too far (e.g. behind)
		if (rightLeg.getTargetDistance() > rightLeg.rootArmLength + rightLeg.elbowArmLength && sign(rightLeg.targetPosition.x - x) != image_xscale)
		{
			// If moving right
			if (image_xscale > 0) ikhGroundFoot(leftLeg, bbox_right + 3);
			else ikhGroundFoot(leftLeg, bbox_left - 3);
				
			// Get target displacement
			var _tx = leftLeg.targetPosition.x, _ty = leftLeg.targetPosition.y;
			var _tdx = x - _tx;
			
			// Move leg targets
			rightLeg.targetPosition.x = x + _tdx;
			
			// Set planted foot
			leftFootGrounded = true;
			
			// Footstep
			if (!audio_is_playing(sfxFootstep)) audio_play_sound(sfxFootstep, 1, false);
			
			// Dirt particles
			with (oParticleManager)
			{
				part_particles_create(partSystem, _tx, _ty, partTypeDirt, 1);
			}
		}
		else
		{
			// Get target displacement
			var _tx = rightLeg.targetPosition.x, _ty = rightLeg.targetPosition.y;
			var _tdx = x - _tx;
			
			// Move leg targets
			ikhGroundFoot(leftLeg, x + _tdx);
			leftLeg.targetPosition.y -= 2;
			
			// Move arm targets
			rightArm.moveTarget(x + _tdx * 0.5, hipPosition.y - 1);
			leftArm.moveTarget(x - _tdx * 0.5, hipPosition.y - 1);
		}
	}
		
	// Neck + hip
	neckPosition.x = x;
	neckPosition.y = lerp(neckPosition.y, y - 4, 0.5);
	hipPosition.x = x;
	hipPosition.y = lerp(hipPosition.y, y, 0.5);
}

/// @func	ikhAnimSlide();
/// @desc	Runs the sliding animation (grounded, speed > zero, input crouch).
function ikhAnimSlide()
{
	// Facing direction
	if (image_xscale > 0)
	{
		// Targets
		rightArm.moveTarget(x + 4, y + 3);
		leftArm.moveTarget(x - 2, y + 3);
		ikhGroundFoot(rightLeg, x + 8);
		ikhGroundFoot(leftLeg, x - 1);
			
		// Orientation
		rightArm.flippedArm = false;
		leftArm.flippedArm = false;
		rightLeg.flippedArm = true;
		leftLeg.flippedArm = false;
	}
	else
	{
		// Targets
		rightArm.moveTarget(x + 2, y + 3);
		leftArm.moveTarget(x - 4, y + 3);
		ikhGroundFoot(rightLeg, x + 1);
		ikhGroundFoot(leftLeg, x - 8);
			
		// Orientation
		rightArm.flippedArm = true;
		leftArm.flippedArm = true;
		rightLeg.flippedArm = true;
		leftLeg.flippedArm = false;
	}
			
	// Neck + hip
	neckPosition.x = x;
	neckPosition.y = lerp(neckPosition.y, y, 0.6);
	hipPosition.x = x;
	hipPosition.y = lerp(hipPosition.y, y + 4, 0.6);
}

/// @func	ikhAnimJump();
/// @desc	Runs the jumping animation (not grounded, moving up).
function ikhAnimJump()
{
	// Facing direction
	if (image_xscale > 0)
	{
		// Arm targets
		rightArm.moveTarget(x - 3, y + 1 - velocity.y);
		leftArm.moveTarget(x - 5, y - 1 - velocity.y);
			
		// Orientation
		rightArm.flippedArm = false;
		leftArm.flippedArm = false;
		rightLeg.flippedArm = true;
		leftLeg.flippedArm = true;
	}
	else
	{
		// Arm targets
		rightArm.moveTarget(x + 5, y - 1 - velocity.y);
		leftArm.moveTarget(x + 3, y + 1 - velocity.y);
			
		// Orientation
		rightArm.flippedArm = true;
		leftArm.flippedArm = true;
		rightLeg.flippedArm = false;
		leftLeg.flippedArm = false;
	}
		
	// Leg targets
	rightLeg.moveTarget(x - velocity.x + 2, bbox_bottom - velocity.y);
	leftLeg.moveTarget(x - velocity.x - 2, bbox_bottom - velocity.y);
			
	// Neck + hip
	neckPosition.x = x;
	neckPosition.y = lerp(neckPosition.y, y - 4, 0.75);
	hipPosition.x = x;
	hipPosition.y = lerp(hipPosition.y, y, 0.75);
}

/// @func	ikhAnimFall();
/// @desc	Runs the jumping animation (not grounded, moving down).
function ikhAnimFall()
{
	// Y drag
	var _yDrag = clamp(velocity.y, 0, 1);
		
	// Facing direction
	if (image_xscale > 0)
	{
		// Arm targets
		rightArm.lerpTarget(x - 3, y + 1 - _yDrag, 0.5);
		leftArm.lerpTarget(x - 5, y - 1 - _yDrag, 0.5);
			
		// Orientation
		rightArm.flippedArm = false;
		leftArm.flippedArm = false;
		rightLeg.flippedArm = true;
		leftLeg.flippedArm = true;
	}
	else
	{
		// Arm targets
		rightArm.lerpTarget(x + 5, y - 1 - _yDrag, 0.5);
		leftArm.lerpTarget(x + 3, y + 1 - _yDrag, 0.5);
			
		// Orientation
		rightArm.flippedArm = true;
		leftArm.flippedArm = true;
		rightLeg.flippedArm = false;
		leftLeg.flippedArm = false;
	}
		
	// Leg targets
	rightLeg.lerpTarget(x + velocity.x + 2, bbox_bottom - _yDrag, 0.5);
	leftLeg.lerpTarget(x + velocity.x - 2, bbox_bottom - _yDrag, 0.5);
			
	// Neck + hip
	neckPosition.x = x;
	neckPosition.y = lerp(neckPosition.y, y - 4, 0.75);
	hipPosition.x = x;
	hipPosition.y = lerp(hipPosition.y, y, 0.75);
}

/// @func	ikhAnimRide();
/// @desc	Runs the riding animation (on a walker).
function ikhAnimRide()
{
	// Exit if no ride
	if (!instance_exists(ride)) return;
	
	// Y drag
	var _yDrag = clamp(ride.velocity.y, 0, 1);
	var _xDrag = clamp(ride.velocity.x, 0, 1);
		
	// Facing direction
	if (ride.sprite_index == sWalker)
	{
		// Orientation
		rightArm.flippedArm = false;
		leftArm.flippedArm = true;
		rightLeg.flippedArm = true;
		leftLeg.flippedArm = false;
	}
	else if (ride.imageAngle > -90 && ride.imageAngle < 90)
	{
		// Orientation
		rightArm.flippedArm = false;
		leftArm.flippedArm = false;
		rightLeg.flippedArm = true;
		leftLeg.flippedArm = true;
	}
	else
	{
		// Orientation
		rightArm.flippedArm = true;
		leftArm.flippedArm = true;
		rightLeg.flippedArm = false;
		leftLeg.flippedArm = false;
	}
	
	// Arm targets
	rightArm.moveTarget(ride.rightArmPos.x, ride.rightArmPos.y);
	leftArm.moveTarget(ride.leftArmPos.x, ride.leftArmPos.y);
	rightLeg.moveTarget(ride.rightLegPos.x, ride.rightLegPos.y);
	leftLeg.moveTarget(ride.leftLegPos.x, ride.leftLegPos.y);
			
	// Neck + hip
	var _rideDX = lengthdir_x(2, ride.imageAngle), _rideDY = lengthdir_y(2, ride.imageAngle);
	neckPosition.x = lerp(neckPosition.x, ride.x + _rideDX - _xDrag, 0.75);
	neckPosition.y = lerp(neckPosition.y, ride.y + _rideDY - _yDrag, 0.75);
	hipPosition.x = lerp(hipPosition.x, ride.x - _rideDX - _xDrag, 0.75);
	hipPosition.y = lerp(hipPosition.y, ride.y - _rideDY - _yDrag, 0.75);
}