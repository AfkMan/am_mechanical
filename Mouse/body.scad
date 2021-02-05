use <dotSCAD/src/bezier_curve.scad>
use <tangent_motor.scad>
use <axle.scad>

debug = ["Body"];
gear_radius = GetTangentMotorProperty("GearRadius");
surface_height = 2;
eps = 0.1;

module MouseBody() {
    axle_y_offset = 20;
    motor_y_offset = axle_y_offset-gear_radius-
        GetTangentMotorProperty("WormRadius")*1.8;
    motor_length = GetTangentMotorProperty("MotorFullLength");
    motor_offset_from_surface = 1;
    motor_z_offset = motor_offset_from_surface+surface_height+motor_length/2;
    axle_height = surface_height+gear_radius-1;
    module LowSurface()
    {
        module Surface()
        {
            difference() {
                height=40;
                length=80;
                eggLine = [[0, 0],
                           [0.5*height, 0],
                           [height, 0.1*length],
                           [0.5*height,length],
                           [0,length]];

                linear_extrude(surface_height) {
                    polygon(bezier_curve(0.01, eggLine));
                    mirror([1, 0, 0])
                        polygon(bezier_curve(0.01, eggLine));
                }

                // отверстия под колесики
                translate([0, 0, -eps])
                    linear_extrude(surface_height+1)
                    for(i = [-0.5, 0.5], j = [-0.5, 0.5])
                        translate([i, j, 0])
                            projection()
                            translate([0, axle_y_offset, 0])
                            rotate([0, 90, 0])
                            tangent_axle(draw_axle=false, draw_stops=false);
            }
        }
        module Holders()
        {
            holder_width = 4*AxleRadius();
            holder_height = axle_height-AxleRadius();
            hole_scale = 1.2;

            module StaticPart() {
                difference() {
                    cube([AxleFasteningWidth(),
                          holder_width, holder_height], center=true);
                    translate([0,0,AxleRadius()])
                        rotate([0, 90, 0])
                        cylinder((1+eps)*AxleFasteningWidth(),
                                 hole_scale*AxleRadius(),
                                 hole_scale*AxleRadius(),
                                 center=true,$fn=100);
                }
            }

            module LowPart() {
                translate([AxleStopOffset(),
                           axle_y_offset,
                           holder_height/2+surface_height])
                    StaticPart();
                translate([-AxleStopOffset(),
                           axle_y_offset,
                           holder_height/2+surface_height])
                    StaticPart();
            }

            module MiddlePart() {
                middle_height = motor_offset_from_surface+
                    GetTangentMotorProperty("Axle")[1]+
                    GetTangentMotorProperty("FrontCircle")[1]-
                    2*holder_height;

                //upper parts of axle holder
                translate([AxleStopOffset(),
                           axle_y_offset,
                           holder_height/2+holder_height+surface_height]) {
                    rotate([0, 180, 0])
                        StaticPart();
                    translate([0,0,(middle_height+holder_height)/2])
                        cube([AxleFasteningWidth(),
                              holder_width, middle_height], center=true);
                }
                translate([-AxleStopOffset(),
                           axle_y_offset,
                           holder_height/2+holder_height+surface_height]) {
                    rotate([0, 180, 0])
                        StaticPart();
                    translate([0,0,(middle_height+holder_height)/2])
                        cube([AxleFasteningWidth(),
                              holder_width, middle_height], center=true);
                }

                motor_low_point_z = surface_height+
                    motor_offset_from_surface+
                    GetTangentMotorProperty("Axle")[1]+
                    GetTangentMotorProperty("FrontCircle")[1];
                eps_from_gear = 1;
                gear_high_point_z = axle_height+gear_radius;
                cap_height = motor_low_point_z-gear_high_point_z-eps_from_gear;
                cap_length = AxleFasteningWidth()+2*AxleStopOffset();

                //motor holder connected with axle holder
                difference() {
                    motor_box_scaler_big = 1.4;
                    motor_box_scaler_small = motor_box_scaler_big*0.75;
                    union() {
                    translate([0,
                               motor_y_offset,
                               gear_high_point_z+eps_from_gear])
                    //motor holder scale
                    linear_extrude(GetTangentMotorProperty("MotorLength"))
                    scale([for(i = [1:3]) motor_box_scaler_big])
                    projection()
                    rotate([0, 90, 90])
                    dc_motor_draw();

                    //crossbar for axle holder
                    translate([0,
                               axle_y_offset,
                               gear_high_point_z+eps_from_gear+cap_height/2])
                        cube([cap_length, holder_width, cap_height],
                             center=true);
                    }

                    translate([0,
                               motor_y_offset,
                               gear_high_point_z+eps_from_gear+cap_height])
                        //motor holder scale
                        linear_extrude(GetTangentMotorProperty("MotorLength"))
                        scale([for(i = [1:3]) motor_box_scaler_small])
                        projection()
                        rotate([0, 90, 90])
                        dc_motor_draw();

                    translate([0,
                               motor_y_offset,
                               gear_high_point_z+
                               eps_from_gear+
                               cap_height-
                               GetTangentMotorProperty("FrontCircle")[1]])
                        //motor holder scale
                        cylinder(d=GetTangentMotorProperty("FrontCircle")[0]*1.2,
                                 h=GetTangentMotorProperty("FrontCircle")[1],
                            $fn=100);
                    translate([0,
                               motor_y_offset,
                               gear_high_point_z+eps_from_gear])
                        //motor holder scale
                        cylinder(d=GetTangentMotorProperty("Axle")[0]*1.4,
                                 h=cap_height-
                                 GetTangentMotorProperty("FrontCircle")[1],
                                 $fn=100);
                }
                //snap fit foots
                foot_width = cap_length/2;
                foot_length = 0.6*holder_width;
                foot_height = cap_height;
                translate([0,
                           axle_y_offset+holder_width/2+foot_length/2,
                           gear_high_point_z+eps_from_gear+cap_height/2])
                    cube([foot_width, foot_length, foot_height],
                         center=true);
            }
            LowPart();
            MiddlePart();
        }
        Surface();
        Holders();
    }

    module TangentAxle() {
        translate([0, axle_y_offset, axle_height])
            rotate([0, 90, 0])
            tangent_axle();

        translate([0,
                   motor_y_offset,
                   motor_z_offset])
            rotate([0, 90, 90])
            tangent_motor();
    }

    LowSurface();
    TangentAxle();
}

for(val = debug){
    if(val =="Body")
        MouseBody();
}
