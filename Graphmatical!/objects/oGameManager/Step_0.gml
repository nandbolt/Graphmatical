// Debug mode
if (keyboard_check_pressed(vk_f9))
{
	if (instance_exists(oDebugManager)) instance_destroy(oDebugManager);
	else instance_create_layer(0, 0, "Instances", oDebugManager);
}