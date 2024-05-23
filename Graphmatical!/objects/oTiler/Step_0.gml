// Toggle tile
if (keyboard_check_pressed(vk_space)) toggleTile();

// Menu
if (currentMenu != undefined) currentMenu.update();