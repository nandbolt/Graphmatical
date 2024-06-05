// Particle systems
partSystem = part_system_create();

// Dust
partTypeDust = part_type_create();
part_type_sprite(partTypeDust, sSquareCenter, false, false, false);
part_type_speed(partTypeDust, 0.2, 0.2, -0.005, 0);
part_type_direction(partTypeDust, 0, 359, 0, 0);
part_type_alpha2(partTypeDust, 1, 0);
part_type_life(partTypeDust, 45, 45);

// Dirt
partTypeDirt = part_type_create();
part_type_sprite(partTypeDirt, sDot, false, false, false);
part_type_speed(partTypeDirt, 0.5, 1, 0, 0);
part_type_gravity(partTypeDirt, 0.1, 270);
part_type_direction(partTypeDirt, 60, 120, 0, 0);
part_type_alpha2(partTypeDirt, 1, 0);
part_type_life(partTypeDirt, 10, 30);