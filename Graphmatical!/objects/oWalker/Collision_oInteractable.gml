// Glitched
if (!glitched && other.glitched) dead = true;
else if (other.object_index == oBallLauncher && alarm[2] == -1)
{
	with (other)
	{
		loadCannon(other.id);
	}
}