// Charge
if (!charging && charge > 0) charge--;

// Rotate
if (playerNear)
{
	var _rotation = keyboard_check(vk_right) - keyboard_check(vk_left);
	if (_rotation != 0)
	{
		image_angle = clamp(image_angle - _rotation, -20, 200);
		loadOffset.set(lengthdir_x(loadOffsetLength, image_angle), lengthdir_y(loadOffsetLength, image_angle));
	}
}