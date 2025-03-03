// Inherit the parent event
event_inherited();

// Spawn point
var _sx = room_width * 0.5, _sy = room_height * 0.5 + TILE_SIZE * 4 + HALF_TILE_SIZE;
if (global.previousHubPortalIdx > -1)
{
	var _inst = instance_find(oPortal, global.previousHubPortalIdx);
	if (instance_exists(_inst)) moveSpawnPoint(_inst.x, _inst.y);
	else moveSpawnPoint(_sx, _sy);
}
else moveSpawnPoint(_sx, _sy);

// Set state
globalGraphing = false;
globalTiling = false;

// Set globals
global.editMode = false;