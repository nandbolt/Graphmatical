// Radius
if (active)
{
	var _c = c_white;
	if (sprite_index == sCrystalPowered)
	{
		_c = #F7C5C5;
		draw_sprite_ext(sCrystalRadiusBack, 0, x, y - 8, 1, 1, 0, _c, 1);
	}
	draw_sprite_ext(sCrystalRadiusOutline, round(image_index * 0.5) % 2, x, y - 8, 1, 1, 0, _c, 1);
}

// Inherit the parent event
event_inherited();