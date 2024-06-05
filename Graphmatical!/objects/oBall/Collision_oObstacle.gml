// Death
with (oParticleManager)
{
	part_particles_create(partSystem, other.x, other.y, partTypeDust, 3);
}
audio_play_sound(sfxHurt, 2, false);
instance_destroy();