// Inherit the parent event
event_inherited();

// Add spring connection
anchorX = x;
anchorY = y;
fgSpring = new BEAnchoredSpringForceGen(anchorX, anchorY, 16, 0);
with (be_oBoxEngine)
{
	registry.add(other.box, other.fgSpring);
}