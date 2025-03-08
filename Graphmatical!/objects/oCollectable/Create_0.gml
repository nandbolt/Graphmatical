// Sfx
collectSfx = sfxFlagActivated;

// Particles
particleColor = #92dcba;
particleFreq = 10;

///	@func	onCollect(inst);
onCollect = function(_inst){}

///	@func	collect(inst);
collect = function(_inst)
{
	onCollect(_inst);
	with (instance_create_layer(x, y, "Instances", oCollectableFade))
	{
		sprite_index = other.sprite_index;
		image_index = other.image_index;
	}
	audio_play_sound(collectSfx, 10, false);
	instance_destroy();
}

// Start alarm
alarm[0] = particleFreq;