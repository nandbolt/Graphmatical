// Prompt
if (playerNear && interactable)
{
	// Outline
	
	// Prompt
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	draw_text_transformed(x, bbox_top - 4, "E", 0.5, 0.5, 0);
}

// Self
draw_self();