// Rotate
if (playerNear)
{
	var _rotation = keyboard_check(vk_right) - keyboard_check(vk_left);
	if (_rotation != 0)
	{
		image_angle -= _rotation;
		if (image_angle < 0) image_angle += 360;
		image_angle = image_angle % 360;
	}
}