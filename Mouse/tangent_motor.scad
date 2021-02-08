use <gears/gears.scad>;

debug = ["Assembled"];

//l - length
//w - width
//h - height

//motor description
motor_l = 11;
motor_w_cube = 6;
motor_w_full = 9.9;
motor_h = 8;
motor_axle_d = 0.9;
motor_axle_l = 8.8;
motor_back_circle_d = 3.8;
motor_back_circle_h = 1;
motor_front_circle_d = 3.8;
motor_front_circle_h = 0.6;
motor_full_length = motor_l+motor_axle_l+motor_front_circle_h+motor_back_circle_h;
eps = 0.01;

//reductor description
modul=0.5;
worm_radius_scale=1;
worm_length_scale = 0.86;
worm_length=motor_axle_l*worm_length_scale;
worm_hole=motor_axle_d*1.1;
gear_tooth_number=18;
gear_width=6;
gear_hole=2;
gear_teeth_angle=20;
lead_angle=8;
gear_radius=gear_tooth_number*modul/2;

function GetTangentMotorProperty(which) =
    which == "GearRadius" ? gear_radius :
    which == "WormRadius" ? worm_radius_scale :
    which == "MotorFullLength" ? motor_full_length :
    which == "MotorWidth" ? motor_w_full :
    which == "MotorWidthCube" ? motor_w_cube :
    which == "MotorHeight" ? motor_h :
    which == "MotorLength" ? motor_l :
    which == "Axle" ? [motor_axle_d, motor_axle_l] :
    which == "FrontCircle" ? [motor_front_circle_d, motor_front_circle_h] :
    assert(false, str("TangentMotor haven't property ", which));

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

module dc_motor_draw() {
    module cylinder_sector() {
        seg = (motor_w_full-motor_w_cube)/2;
        diameter = (motor_h*motor_h/4+seg*seg)/seg;
        difference() {
            translate([-diameter/2+seg,0,0])
                cylinder(h=motor_l,d=diameter, $fn=100);
            translate([-diameter/2,0,motor_l/2-eps/2])
                cube([diameter, diameter+eps, motor_l+2*eps], center=true);
        }
    }
    //left side of motor semicircle
    translate([-motor_l/2,motor_w_cube/2, 0])
        rotate([90, 0, 90])
        cylinder_sector();

    //motor main side
    cube([motor_l,
          motor_w_cube,
          motor_h], center=true);

    //right side of motor semicircle
    translate([motor_l/2,-motor_w_cube/2, 0])
        rotate([90, 0, 270])
        cylinder_sector();

    //back motor circle
    translate([-motor_l/2, 0, 0])
        rotate([0, 270, 0])
        cylinder(h=motor_back_circle_h, d=motor_back_circle_d, $fn=100);

    //front motor circle
    translate([motor_l/2, 0, 0])
        rotate([0, 90, 0])
        cylinder(h=motor_front_circle_h, d=motor_front_circle_d, $fn=100);

    //motor axle
    translate([motor_front_circle_h+motor_l/2, 0, 0])
        rotate([0, 90, 0])
        cylinder(h=motor_axle_l, d=motor_axle_d, $fn=100);
}


module tangent_motor() {
    //motor in center
    translate([motor_back_circle_h+motor_l/2-
               motor_full_length/2
               ,0,0]) {
        translate([motor_l/2+motor_front_circle_h+
                   motor_axle_l*(1.1-worm_length_scale)/2, 0, 0])
            rotate([0, 0, 90])
            tangent_reductor_worm();
        dc_motor_draw();
    }
}


for(val = debug){
    if(val =="Motor")
        dc_motor_draw();
    if(val == "Worm")
        tangent_reductor_worm();
    if(val == "Assembled")
        tangent_motor();
    if(val == "Gear")
        tangent_reductor_gear();
}
