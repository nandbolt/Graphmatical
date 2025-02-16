// Inherit the parent event
event_inherited();

// Set box
box.setMass(infinity);

// Add to box engine
with (be_oBoxEngine)
{
	array_push(boxes, other.box);
}

// Death area
deathArea = instance_create_layer(x, y, "Instances", be_oBPAreaTrigger);
with (deathArea)
{
	owner = other.id;
	target = be_oBox;
	onDetect = function(_inst)
	{
		with (be_oBoxEngine)
		{
			removeBox(_inst.box);
		}
		instance_destroy(_inst);
	}
	image_xscale = 0.5 * (other.bbox_right - other.bbox_left) + 1;
	image_yscale = 0.5 * (other.bbox_bottom - other.bbox_top) + 1;
}