// Title
draw_set_halign(fa_center);
draw_set_valign(fa_top);
var _x = display_get_gui_width() * 0.5, _y = 16;
var _stringWidth = string_width("Graphmatical!") + 8;
draw_sprite_stretched(sBorder2, 0, _x - _stringWidth * 0.5, _y, _stringWidth, 16);
draw_text(_x, _y, "Graphmatical!");

// Cubes
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(display_get_gui_width() - 8, 4, "Cubes: " + string(oLevel.cubesCollected) + "/" + string(oLevel.totalCubes));

// Menu
if (currentMenu != undefined) currentMenu.drawGui();