if (fadeToNextRoom) draw_set_alpha(1 - clamp(alarm[0], 0, fadeTime) / fadeTime);
else draw_set_alpha(clamp(alarm[0], 0, fadeTime) / fadeTime);
draw_set_color(#6D758D);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
if (!fadeToNextRoom)
{
	draw_set_color(#E2E2E2);
	draw_text_transformed(display_get_gui_width() * 0.5, display_get_gui_height() * 0.5, global.currentLevelName, 2, 2, 0);
}
draw_set_alpha(1);