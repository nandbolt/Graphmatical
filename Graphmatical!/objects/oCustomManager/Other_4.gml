/// @desc Load Level
loadLevel();

// Recount cubes + balls
oLevel.totalCubes = instance_number(oCube);
with (oBall)
{
	// Ignore glitched balls
	if (object_index == oBall) oLevel.totalBalls++;
}