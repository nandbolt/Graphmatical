// Layers
collisionLayer = layer_get_id("CollisionTiles");

// Graphing
precedenceMap = ds_map_create();

// Spawning
spawnPoint = noone;

#region Functions

/// @func respawnPlayer();
respawnPlayer = function()
{
	// Player
	instance_create_layer(spawnPoint.x, spawnPoint.y, "Instances", oPlayer);
}

#endregion

// Hide collision layer
layer_set_visible(collisionLayer, false);

// Init precedence map
ds_map_add(precedenceMap, "(", 1);	// Parenthesis
ds_map_add(precedenceMap, "+", 2);	// Addition
ds_map_add(precedenceMap, "-", 2);	// Subtraction
ds_map_add(precedenceMap, "*", 3);	// Multiplication
ds_map_add(precedenceMap, "/", 3);	// Division
ds_map_add(precedenceMap, "s", 3);	// Sine
ds_map_add(precedenceMap, "c", 3);	// Cosine
ds_map_add(precedenceMap, "g", 3);	// Tangent
ds_map_add(precedenceMap, "^", 4);	// Power
ds_map_add(precedenceMap, "l", 5);	// Log
ds_map_add(precedenceMap, "r", 5);	// Root

#region Create Level

// Spawn point
spawnPoint = instance_create_layer(24, 1064, "BackgroundInstances", oSpawnFlag);
instance_create_layer(1896, 1064, "BackgroundInstances", oGoalFlag);
instance_create_layer((1896 - 24) * 0.5, 1064, "BackgroundInstances", oCheckFlag);

// Player
instance_create_layer(spawnPoint.x, spawnPoint.y, "Instances", oPlayer);

// Camera
instance_create_layer(0, 0, "Instances", oCamera);

#endregion