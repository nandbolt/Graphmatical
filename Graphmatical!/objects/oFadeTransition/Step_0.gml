// Player spawn particles
with (oParticleManager)
{
	part_particles_create(partSystem, oLevel.spawnPoint.x + irandom_range(-2, 2),
		oLevel.spawnPoint.y + irandom_range(-4, 4), partTypeDust, 1);
}