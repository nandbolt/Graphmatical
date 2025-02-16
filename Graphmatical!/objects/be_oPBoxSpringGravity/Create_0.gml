// Inherit the parent event
event_inherited();

// Set box
box.setMass(4);
box.setDamping(0.1);
anchorX = x;
anchorY = y;
fgSpring = new BEAnchoredSpringForceGen(anchorX, anchorY, 64, 0);

with (be_oBoxEngine)
{
	
}

// Add to box engine
with (be_oBoxEngine)
{
	array_push(boxes, other.box);
	registry.add(other.box, be_oPWorld.fgGravity);
	registry.add(other.box, be_oPWorld.fgBuoyancy);
	registry.add(other.box, other.fgSpring);
}