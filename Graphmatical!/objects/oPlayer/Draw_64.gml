// Tab
if (canMove)
{
	// Title
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	var _editorString = "Tab: Pauser";
	if (currentEditor == oGrapher) _editorString = "Tab: Grapher";
	else if (currentEditor == oTiler) _editorString = "Tab: Tiler";
	var _stringWidth = string_width(_editorString) + 8;
	var _x = 8, _y = 4;
	draw_sprite_stretched(sBorder1, 0, _x - 4, _y, _stringWidth, 16);
	draw_text(_x, _y, _editorString);
}