// Particle systems
partSystem = part_system_create();

// Dust
partTypeDust = part_type_create();
part_type_sprite(partTypeDust, sSquareCenter, false, false, false);
part_type_speed(partTypeDust, 0.2, 0.2, -0.005, 0);
part_type_direction(partTypeDust, 0, 359, 0, 0);
part_type_alpha2(partTypeDust, 1, 0);
part_type_life(partTypeDust, 45, 45);