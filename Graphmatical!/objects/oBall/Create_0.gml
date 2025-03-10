// Inherit the parent event
event_inherited();

// Rigid body
rbInit();

// Rotation
rotates = true;				// To let parent know to draw using imageAngle rather than image_angle
angularVelocity = 0;
circleRotations = true;		// To let the physics system know to calculate torques

// Bounce
bounciness = 0.9;

// Kick
kicked = false;

#region Functions

/// @func	interact();
interact = function()
{
	// Kick if not kicked
	if (!kicked) kick();
}

/// @func	kick();
kick = function()
{
	// Kick velocity
	if (oPlayer.inputMove.y < 0) velocity.add(0, -3);
	else if (oPlayer.inputMove.y > 0) velocity.add(oPlayer.image_xscale * 3, 0);
	else if (oPlayer.inputMove.x == 0) velocity.add(oPlayer.image_xscale * 2, -2);
	else velocity.add(oPlayer.inputMove.x * 2, -2);
	
	// Add player velocity
	velocity.addVector(oPlayer.velocity);
	
	// Set state
	kicked = true;
	alarm[1] = 10;
	
	// Sound
	audio_play_sound(sfxSignRead, 2, false);
	
	// Kick particles
	with (oParticleManager)
	{
		part_particles_create(partSystem, other.x, other.y, partTypeDust, 3);
	}
}

/// @func	onBounce();
onBounce = function()
{
	// Dirt particles
	if (grounded)
	{
		with (oParticleManager)
		{
			part_particles_create(partSystem, other.bbox_left, other.bbox_bottom, partTypeDirt, 1);
			part_particles_create(partSystem, other.x, other.bbox_bottom, partTypeDirt, 1);
			part_particles_create(partSystem, other.bbox_right, other.bbox_bottom, partTypeDirt, 1);
		}
	}
	
	// Rotate
	angularVelocity = 1;
}

/// @func	die();
die = function()
{
	// Death
	with (oParticleManager)
	{
		part_particles_create(partSystem, other.x, other.y, partTypeDust, 3);
	}
	audio_play_sound(sfxHurt, 2, false);
	oLevel.ballsDestroyed++;
	instance_destroy();
}

#endregion

// Hide name
showName = false;

// Set interactable alarm
alarm[2] = 30;