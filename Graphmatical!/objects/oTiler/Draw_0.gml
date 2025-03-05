// Draw sprite if current index is not a tile
if (currentIdx > lastTileIdx) draw_sprite(currentSprite, 0, x, y);

// Cross
draw_self();

// AWSD
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(x - TILE_SIZE, y, "A", 0.5, 0.5, 0);
draw_text_transformed(x + TILE_SIZE, y, "D", 0.5, 0.5, 0);
draw_text_transformed(x, y - TILE_SIZE, "W", 0.5, 0.5, 0);
draw_text_transformed(x, y + TILE_SIZE, "S", 0.5, 0.5, 0);
draw_text_transformed(x - TILE_SIZE, y - TILE_SIZE, "Q", 0.5, 0.5, 0);
draw_text_transformed(x + TILE_SIZE, y - TILE_SIZE, "E", 0.5, 0.5, 0);
draw_text_transformed(x, y + TILE_SIZE * 2, "Space", 0.5, 0.5, 0);