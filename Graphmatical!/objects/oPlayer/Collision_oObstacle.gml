// Respawn
with (oWorld)
{
	respawnPlayer();
}

// Hurt sound
audio_play_sound(sfxHurt, 2, false);

// Destroy self
instance_destroy();