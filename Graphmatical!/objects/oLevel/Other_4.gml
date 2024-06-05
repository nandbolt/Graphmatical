/// @desc	Start Level

// Camera
instance_create_layer(0, 0, "Instances", oCamera);

// Player
instance_create_layer(spawnPoint.x, spawnPoint.y, "ForegroundInstances", oPlayer);