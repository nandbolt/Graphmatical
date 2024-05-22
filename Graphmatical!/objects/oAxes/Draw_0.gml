// Bounding box
if (bboxVisible) draw_self();

// Axes
if (axesVisible || instance_exists(oGrapher))
{
	draw_sprite_ext(sDot, 0, x - image_xscale, y, image_xscale * 2, 1, 0, c_gray, 1); // X axis
	draw_sprite_ext(sDot, 0, x, y + image_yscale, image_yscale * 2, 1, 90, c_gray, 1); // Y axis
	
	// Origin
	draw_sprite(sDot, 0, x, y);
}

// Graphs
for (var _i = 0; _i < array_length(equations); _i++)
{
	equations[_i].draw();
}