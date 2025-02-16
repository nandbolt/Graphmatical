// Detection
owner = noone;
target = noone;
onDetect = function(_inst)
{
	with (be_oBoxEngine)
	{
		removeBox(_inst.box);
	}
	instance_destroy(_inst);
}