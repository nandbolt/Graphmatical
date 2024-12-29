// Win screen
if (levelComplete)
{
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_color(#59c135);
	draw_text(display_get_gui_width() * 0.5, display_get_gui_height() * 0.5, "Level complete\nTime: " + string(endTime) + " s\n\nPress Esc + R to restart OR\nGo back to the starting flag to reset the timer");
	draw_set_color(c_white);
}

// Version
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_set_color(#b3b9d1);
draw_text(8, display_get_gui_height() - 4, "Graphmatical! v" + string(GM_version));
draw_set_color(c_white);