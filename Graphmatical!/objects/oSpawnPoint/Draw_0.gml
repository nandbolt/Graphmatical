// Inherit the parent event
event_inherited();

// Spawn point text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(x, y, "SP", 0.5, 0.5, 0);

// Charge bar + angle
if (promptAlpha > 0)
{
	draw_set_alpha(promptAlpha);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text_transformed(x, y+12, "<-" + string_format(image_angle, 3, 0) + " deg ->", 0.5, 0.5, 0);
	draw_set_alpha(1);
}