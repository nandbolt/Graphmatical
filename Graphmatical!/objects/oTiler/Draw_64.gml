// Title
draw_set_halign(fa_center);
draw_set_valign(fa_top);
var _x = display_get_gui_width() * 0.5, _y = 16;
draw_text(_x, _y, "Tiler");

// Menu
if (currentMenu != undefined) currentMenu.drawGui();