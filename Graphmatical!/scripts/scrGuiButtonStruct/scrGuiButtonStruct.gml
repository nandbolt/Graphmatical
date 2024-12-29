/// @func	GuiButton({string} name, {real} x, {real} y, {func} onClick);
function GuiButton(_name, _x, _y, _onClick=function(){}) : GuiElement() constructor
{
	// Values
	name = _name;
	x = _x;
	y = _y;
	onClick = _onClick;
	
	/// @func	click();
	static click = function()
	{
		setFocus();
		audio_play_sound(sfxButtonPressed, 2, false);
		onClick();
	}
	
	/// @func	drawGui();
	static drawGui = function()
	{
		if (hovering)
		{
			// Border
			draw_set_alpha(0.8);
			draw_sprite_stretched(sBorder2, 0, x - hoverSizeIncrease, y - hoverSizeIncrease, width + hoverSizeIncrease * 2, height + hoverSizeIncrease * 2);
		}
		else
		{
			// Border
			draw_set_alpha(0.5);
			draw_sprite_stretched(sBorder1, 0, x, y, width, height);
		}
		draw_set_alpha(1);
		
		// Text
		draw_text(x + width * 0.5 - string_width(name) * 0.5, y + height * 0.5, name);
	}
}