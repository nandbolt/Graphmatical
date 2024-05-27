// Inherit the parent event
event_inherited();

// Textbox
if (displayTextShown)
{
	var _x = clamp(x - boxWidth * 0.5, 0, room_width - boxWidth);
	var _y = clamp(y - boxHeight - boxOffset, boxHeight, room_height);
	draw_sprite_stretched(sBorder1, 0, _x, _y, boxWidth, boxHeight);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	_x += boxPadding;
	_y += boxPadding;
	draw_text_ext_transformed(_x, _y, displayText , displayTextSeparation, boxWidth * 2 - boxPadding * 4, displayTextScale, displayTextScale, 0);
}