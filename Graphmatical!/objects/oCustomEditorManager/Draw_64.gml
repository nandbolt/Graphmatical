// Show edit mode in the corner
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_set_color(c_white);
var _x = 8, _y = display_get_gui_height() - 20;
draw_text(_x, _y, "save level: ctrl + s");
_y -= 16;
draw_text(_x, _y, "edit mode");