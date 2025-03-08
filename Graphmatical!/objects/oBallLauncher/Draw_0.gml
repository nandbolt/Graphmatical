// Load
if (loadedSprite == sNoFlag && instance_exists(oPlayer))
{
	with (oPlayer)
	{
		ikhDraw();
	}
}
if (loadedSprite != -1) draw_sprite_ext(loadedSprite, 0, x + loadOffset.x, y + loadOffset.y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

// Inherit the parent event
event_inherited();

// Stand
draw_sprite(sBallCannonStand, 0, x, y);

// Charge bar + angle
if (promptAlpha > 0)
{
	draw_set_alpha(promptAlpha);
	draw_healthbar(x-10, y+10, x+10, y+12, charge / maxCharge * 100, #333941, c_white, c_white, 0, true, false);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text_transformed(x, y+18, "<-" + string_format(image_angle, 3, 0) + " deg ->", 0.5, 0.5, 0);
	draw_set_alpha(1);
}