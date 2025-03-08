// Slow down power source
if (active && instance_exists(powerSource) && variable_instance_exists(powerSource, "velocity"))
{
	with (powerSource)
	{
		velocity.x *= 0.1;
	}
}