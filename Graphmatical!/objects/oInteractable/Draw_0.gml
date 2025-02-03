// Increase alpha if near
if (playerNear && interactable) promptAlpha = clamp(promptAlpha + promptAlphaSpeed, 0, 1);
// Decrease alpha if greater than 0
else if (promptAlpha > 0) promptAlpha = clamp(promptAlpha - promptAlphaSpeed, 0, 1);

// Prompt
if (promptAlpha > 0)
{
	// Prompt
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	draw_set_alpha(promptAlpha);
	var _y = y - sprite_height * 0.5 - 4;
	draw_text_transformed(x, _y, "E", 0.5, 0.5, 0);
	
	// Name
	if (showName && name != "")
	{
		_y -= 8;
		draw_text_transformed(x, _y, "\"" + name + "\"", 0.5, 0.5, 0);
	}
	draw_set_alpha(1);
	
	// Outline
	shader_set(shdrOutline);
	shader_set_uniform_f_array(uColorOutline, colorOutline);
	shader_set_uniform_f(uTexelWidth, texelWidth);
	shader_set_uniform_f(uTexelHeight, texelHeight);
}

// Self
draw_self();
shader_reset();