// States
levelComplete = false;

// Layers
backgroundLayer = layer_get_id("Background");
collisionLayer = layer_get_id("CollisionTiles");

// Spawning
spawnPoint = instance_create_layer(24, 1064, "Instances", oSpawnFlag);

// Background shader
uTime = shader_get_uniform(shdrWorleyNoise, "u_time");
uResolution = shader_get_uniform(shdrWorleyNoise, "u_resolution");

// Timer
startTime = 0;
endTime = 0;

#region Functions

/// @func respawnPlayer();
respawnPlayer = function()
{
	// Player
	instance_create_layer(spawnPoint.x, spawnPoint.y, "Instances", oPlayer);
}

/// @func	completeLevel();
completeLevel = function()
{
	if (!levelComplete)
	{
		levelComplete = true;
		endTime = current_time / 1000 - startTime;
	}
}

#endregion

// Hide collision layer
layer_set_visible(collisionLayer, false);

// Set background shader
layer_script_begin(backgroundLayer, layerWorleyShaderStart);
layer_script_end(backgroundLayer, layerWorleyShaderEnd);