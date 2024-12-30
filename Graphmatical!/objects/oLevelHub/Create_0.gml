// Inherit the parent event
event_inherited();

// Spawn point
var _sx = room_width * 0.5 - HALF_TILE_SIZE, _sy = 1064 - TILE_SIZE * 8;
if (global.previousHubPortalIdx > -1)
{
	var _inst = instance_find(oPortal, global.previousHubPortalIdx);
	if (instance_exists(_inst)) moveSpawnPoint(_inst.x, _inst.y);
	else moveSpawnPoint(_sx, _sy);
}
else moveSpawnPoint(_sx, _sy);