// If visible to camera
if (visibleToCamera(self))
{
	// Bounding box
	if (bboxVisible) draw_self();

	// Axes
	if (axesVisible || instance_exists(oGrapher))
	{
		draw_sprite_ext(sDot, 0, x - image_xscale, y, image_xscale * 2, 1, 0, image_blend, 1); // X axis
		draw_sprite_ext(sDot, 0, x, y + image_yscale, image_yscale * 2, 1, 90, image_blend, 1); // Y axis
	
		// Origin
		draw_sprite(sDot, 0, x, y);
		
		// X + Y
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		draw_text_transformed(bbox_right + 4, y, "x", 0.5, 0.5, 0);
		draw_set_halign(fa_center);
		draw_set_valign(fa_bottom);
		draw_text_transformed(x, bbox_top - 4, "y", 0.5, 0.5, 0);
		
		// Numbers
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_text_transformed(x + TILE_SIZE, y - 4, "1", 0.5, 0.5, 0);
		draw_text_transformed(x - TILE_SIZE, y - 4, "-1", 0.5, 0.5, 0);
		draw_text_transformed(x - 6, y - TILE_SIZE, "1", 0.5, 0.5, 0);
		draw_text_transformed(x - 6, y + TILE_SIZE, "-1", 0.5, 0.5, 0);
	}

	// Graphs
	for (var _i = 0; _i < array_length(equations); _i++)
	{
		equations[_i].draw();
	}
}