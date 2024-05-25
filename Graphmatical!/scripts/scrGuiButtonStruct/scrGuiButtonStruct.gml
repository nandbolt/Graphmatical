/// @func	GuiButton({string} name, {real} x, {real} y, {func} onClick=function(){});
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
		// Border
		draw_sprite_stretched(sBorder1, 0, x, y, width, height);
		//draw_rectangle_color(x, y, x + width - 1, y + height - 1, c_red, c_red, c_red, c_red, true);
		
		// Text
		draw_text(x + width * 0.5 - string_width(name) * 0.5, y + height * 0.5, name);
	}
}