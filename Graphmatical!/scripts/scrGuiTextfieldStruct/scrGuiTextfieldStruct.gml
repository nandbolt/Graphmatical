/// @func	GuiTextfield({string} name, {real} x, {real} y, {string} value, {string} placeholder, {func} onEnter);
function GuiTextfield(_name, _x, _y, _value, _placeholder, _onEnter=function(){}) : GuiElement() constructor
{
	// Inner padding
	static padding = 8;
	
	// Values
	name = _name;
	x = _x;
	y = _y;
	onEnter = _onEnter;
	
	// Draw
	placeholder = _placeholder;
	drawValue = "";
	
	/// @func	set({string} text);
	static set = function(_text)
	{
		// Return if value hasn't changed
		if (value == _text) return;
		
		// Set value
		value = _text;
		
		// Keep deleting the first letter of the string until it fits in the textfield box
		draw_set_font(fDefault);
		drawValue = value;
		while (string_width(drawValue) > width - 2 * padding)
		{
			drawValue = string_delete(drawValue, 1, 1);
		}
	}
	
	/// @func	click();
	static click = function()
	{
		// Set focus and set keyboard string to current value
		setFocus();
		audio_play_sound(sfxTextfieldClicked, 2, false);
		keyboard_string = get();
	}
	
	/// @func	listen();
	static listen = function()
	{
		// Set value to whatever is typed
		set(keyboard_string);
		
		// Remove focus on enter
		if (keyboard_check_pressed(vk_enter))
		{
			onEnter();
			audio_play_sound(sfxTextfieldEntered, 2, false);
			removeFocus();
		}
	}
	
	/// @func	drawGui();
	static drawGui = function()
	{
		// Focus
		var _inFocus = hasFocus(), _saveAlpha = draw_get_alpha();
		if (!_inFocus) draw_set_alpha(0.5);
		
		// Border
		draw_sprite_stretched(sBorder1, 0, x, y, width, height);
		//draw_rectangle_color(x, y, x + width - 1, y + height - 1, c_red, c_red, c_red, c_red, true);
		
		// Flashing
		var _ticker = (_inFocus && floor((current_time * 0.002) mod 2) == 0) ? "|" : "";
		
		// If empty string
		if (string_length(get()) < 1)
		{
			// Placeholder text
			draw_set_alpha(0.5);
			draw_text(x + padding, y + height * 0.5, placeholder);
		}
		
		// Input text
		draw_text(x + padding, y + height * 0.5, drawValue + _ticker);
		
		// Reset alpha
		draw_set_alpha(_saveAlpha);
	}
	
	// Set value
	set(_value);
}