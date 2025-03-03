// Inherit the parent event
event_inherited();

// Creator
if (promptAlpha > 0 && creator != "")
{
	draw_set_alpha(promptAlpha);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text_transformed(x, y+14, "by " + creator, 0.5, 0.5, 0);
	draw_set_alpha(1);
}