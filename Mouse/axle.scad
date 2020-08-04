include <tangent_motor/reductor.scad>;

axle_length=30;
axle_radius=2;
wheel_width=4;
wheel_radius=8;

module tangent_axle(draw_axle=true, draw_gear=true, draw_wheels=true) {
    if(draw_gear)
        translate([gear_radius, 0, 0])
            tangent_reductor_gear();

    if(draw_axle)
        translate([0, 0, -axle_length/2])
            cylinder(axle_length, axle_radius, axle_radius, $fn=100);

    if(draw_wheels) {
        translate([0,0, -wheel_width/2 + axle_length/2])
            cylinder(wheel_width, wheel_radius, wheel_radius, $fn=100);

        translate([0,0, -wheel_width/2 - axle_length/2])
            cylinder(wheel_width, wheel_radius, wheel_radius, $fn=100);
    }
}
