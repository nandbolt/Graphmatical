// Inherit the parent event
event_inherited();

// Set box
box.setMass(4);
box.setDamping(0.1);

// Add to box engine
with (be_oBoxEngine)
{
	array_push(boxes, other.box);
	registry.add(other.box, oLevel.fgGravity);
}