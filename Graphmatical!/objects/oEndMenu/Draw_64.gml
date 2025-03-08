// Win screen
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(#59c135);
var _x = display_get_gui_width() * 0.5, _y = display_get_gui_height() * 0.4;
draw_text(_x, _y, "Level complete!");
_y += 16;
draw_text(_x, _y, "Time: " + string(oLevel.endTime) + " s");
_y += 16;
draw_text(_x, _y, "Cubes: " + string(oLevel.cubesCollected) + "/" + string(oLevel.totalCubes));
_y -= 48;
draw_text(_x, _y, "by " + global.currentLevelCreator);
_y -= 16;
draw_text(_x, _y, "\"" + global.currentLevelName + "\"");
draw_set_color(c_white);

// Menu
if (currentMenu != undefined) currentMenu.drawGui();