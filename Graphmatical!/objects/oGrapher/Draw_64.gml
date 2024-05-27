// Title
draw_set_halign(fa_center);
draw_set_valign(fa_top);
var _x = display_get_gui_width() * 0.5, _y = 16;
var _stringWidth = string_width("Grapher") + 8;
draw_sprite_stretched(sBorder2, 0, _x - _stringWidth * 0.5, _y, _stringWidth, 16);
draw_text(_x, _y, "Grapher");

// Menu
if (currentMenu != undefined) currentMenu.drawGui();