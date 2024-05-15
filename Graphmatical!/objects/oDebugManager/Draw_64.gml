// Player
if (instance_exists(oPlayer))
{
	with (oPlayer)
	{
		// Rigid body
		rbDrawGui();
	
		// Player stats
		var _x = display_get_gui_width() - 16, _y = display_get_gui_height() * 0.5;
		draw_text(_x, _y, "More player info: ");
		_y += 16;
		draw_text(_x, _y, "Move input: " + string(inputMove));
		_y += 16;
		draw_text(_x, _y, "Coyote: " + string(coyoteBufferCounter));
		_y += 16;
		draw_text(_x, _y, "Jump buffer: " + string(jumpBufferCounter));
		_y += 16;
	}
}

// Grapher
if (instance_exists(oGrapher))
{
	draw_sprite_ext(sSquare, 0, display_get_gui_width() * 0.5, display_get_gui_height() * 0.5, 1, 1, 0, c_red, 1);
}