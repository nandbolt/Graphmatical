if (fadeToNextRoom) draw_set_alpha(1 - clamp(alarm[0], 0, fadeTime) / fadeTime);
else draw_set_alpha(clamp(alarm[0], 0, fadeTime) / fadeTime);
draw_set_color(#6D758D);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
if (!fadeToNextRoom)
{
	draw_set_color(#E2E2E2);
	var _x = display_get_gui_width() * 0.5, _y = display_get_gui_height() * 0.5;
	draw_text_transformed(_x, _y, global.currentLevelName, 2, 2, 0);
	if (global.currentLevelCreator != "") draw_text(_x, _y + 20, "by "+ global.currentLevelCreator);
}
draw_set_alpha(1);