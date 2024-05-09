// Update inputs
inputRunDirection = keyboard_check(ord("D")) - keyboard_check(ord("A"));
inputJump = keyboard_check(vk_space);
inputJumpPressed = keyboard_check_pressed(vk_space);
inputCrouch = keyboard_check(ord("S"));

// Move input
velocity.x = inputRunDirection;

// Jump
if (grounded && keyboard_check_pressed(vk_space)) velocity.y = -jumpStrength;

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