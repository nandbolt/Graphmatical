// Check trigger
var _instList = ds_list_create();
var _instCount = instance_place_list(x, y, target, _instList, false);
for (var _i = _instCount - 1; _i >= 0; _i--)
{
	var _inst = _instList[| _i];
	if (_inst != owner) onDetect(_inst);
}
ds_list_destroy(_instList);