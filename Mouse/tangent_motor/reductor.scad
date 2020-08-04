use <gears/gears.scad>;

modul=0.4;
worm_radius_scale=1;
worm_length=10;
worm_hole=2;
gear_tooth_number=20;
gear_width=6;
gear_hole=2;
gear_teeth_angle=20;
lead_angle=8;
gear_radius=gear_tooth_number*modul/2;


module tangent_reductor_gear() {
    worm_gear(modul, gear_tooth_number, worm_radius_scale,
              gear_width, worm_length, worm_hole, gear_hole,
              gear_teeth_angle, lead_angle, false, true, 1, 0);
}

module tangent_reductor_worm() {
    worm_gear(modul, gear_tooth_number, worm_radius_scale,
              gear_width, worm_length, worm_hole, gear_hole,
              gear_teeth_angle, lead_angle, false, true, 0, 1);
}
