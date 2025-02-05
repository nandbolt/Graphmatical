// Move + scale
var _dx = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left);
var _dy = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
var _shift = keyboard_check(vk_shift);
if (!instance_exists(currentTerminal) && (_dx != 0 || _dy != 0))
{
	if (_shift) scaleAxes(_dx, _dy);
	else moveAxes(_dx, _dy);
}

// Menu
if (currentMenu != undefined) currentMenu.update();