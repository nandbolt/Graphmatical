// Bounding box
draw_self();

// Axes
draw_sprite_ext(sDot, 0, x - image_xscale, y, image_xscale * 2, 1, 0, c_gray, 1); // X axis
draw_sprite_ext(sDot, 0, x, y + image_yscale, image_yscale * 2, 1, 90, c_gray, 1); // Y axis

// Origin 
draw_sprite(sDot, 0, x, y);