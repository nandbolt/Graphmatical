// Toggle tile
if (keyboard_check_pressed(vk_space)) toggleTile();
else if (keyboard_check_pressed(ord("E"))) cycleIdx(currentIdx+1);
else if (keyboard_check_pressed(ord("Q"))) cycleIdx(currentIdx-1);

// Menu
if (currentMenu != undefined) currentMenu.update();