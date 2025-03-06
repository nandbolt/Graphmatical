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
	var _y = bbox_top - 4;
	if (altPromptString != "")
	{
		draw_text_transformed(x, _y, "Shift + E: " + altPromptString, 0.5, 0.5, 0);
		_y -= 8;
	}
	draw_text_transformed(x, _y, "E: " + promptString, 0.5, 0.5, 0);
	
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
	shader_set_uniform_f(uAlphaOutline, promptAlpha);
}

// Self
if (!rotates) draw_self();
else draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, imageAngle, image_blend, image_alpha);
shader_reset();