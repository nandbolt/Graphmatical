// Inherit the parent event
event_inherited();

// Increase alpha if show
if (displayTextShown) textAlpha = clamp(textAlpha + textAlphaSpeed, 0, 1);
// Decrease alpha if greater than 0
else if (textAlpha > 0) textAlpha = clamp(textAlpha - textAlphaSpeed, 0, 1);

// Textbox
if (textAlpha > 0)
{
	draw_set_alpha(textAlpha);
	var _x = clamp(x - boxWidth * 0.5, 0, room_width - boxWidth);
	var _y = clamp(y - boxHeight - boxOffset, 0, room_height);
	draw_sprite_stretched(sBorder1, 0, _x, _y, boxWidth, boxHeight);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	_x += boxPadding;
	_y += boxPadding;
	draw_text_ext_transformed(_x, _y, displayText , displayTextSeparation, boxWidth * 2 - boxPadding * 4, displayTextScale, displayTextScale, 0);
	draw_set_alpha(1);
}