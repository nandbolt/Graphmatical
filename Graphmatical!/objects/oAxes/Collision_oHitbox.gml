// If player hitbox
if (instance_exists(oPlayer))
{
	if (oHitbox.x == oPlayer.x && oHitbox.y == oPlayer.y)
	{
		// Glow gold
		image_blend = #92dcba;
		alarm[0] = 1;
	}
}