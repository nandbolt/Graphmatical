// Prompt
if (playerNear && interactable)
{
	// Outline
	
	// Prompt
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	var _y = y - sprite_height * 0.5 - 4;
	draw_text_transformed(x, _y, "E", 0.5, 0.5, 0);
	
	// Name
	if (showName && name != "")
	{
		_y -= 8;
		draw_text_transformed(x, _y, "\"" + name + "\"", 0.5, 0.5, 0);
	}
}

// Self
draw_self();