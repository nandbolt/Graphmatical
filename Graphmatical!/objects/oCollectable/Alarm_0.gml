/// @desc Particle Timer
if (visibleToCamera(self.id))
{
	with (oParticleManager)
	{
		part_particles_create_color(partSystem, other.x + irandom_range(-4, 4),
			other.y + irandom_range(-4, 4), partTypeDust, other.particleColor, 1);
	}
}
alarm[0] = particleFreq;