/// @desc Init Game

// Managers
instance_create_layer(0, 0, "Instances", oGameManager);
instance_create_layer(0, 0, "Instances", oDisplayManager);
instance_create_layer(0, 0, "Instances", oParticleManager);
instance_create_layer(0, 0, "Instances", oSaveManager);
instance_create_layer(0, 0, "Instances", oSteamManager);

// Load game
with (oSaveManager)
{
	load();
}