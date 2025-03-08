/// @desc	Start Level

// Camera
instance_create_layer(0, 0, "Instances", oCamera);

// Fade Transition
instance_create_layer(0, 0, "Instances", oFadeTransition);

// Count cubes
totalCubes = instance_number(oCube);
with (oBall)
{
	// Ignore glitched balls
	if (object_index == oBall) oLevel.totalBalls++;
}