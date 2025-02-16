// Debug overlay
show_debug_overlay(true);

// Init display
window_set_size(1280, 720);
display_set_gui_size(1280, 720);
surface_resize(application_surface, 1280, 720);

// Create box engine
boxEngine = instance_create_layer(0, 0, "Instances", be_oBoxEngine);

// Init scene
cgTiles = new BETileContactGen();
cgBoxes = new BEBoxContactGen();
fgGravity = new BEGravityForceGen();
fgBuoyancy = new BEBuoyancyForceGen();
with (boxEngine)
{
	array_push(contactGens, other.cgTiles);
	array_push(contactGens, other.cgBoxes);
}