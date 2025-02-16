// Inherit the parent event
event_inherited();

// Add to box engine
fgController = new BETopDownControllerForceGen();
with (be_oBoxEngine)
{
	array_push(boxes, other.box);
	registry.add(other.box, other.fgController);
}