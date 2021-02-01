use <dotSCAD/src/bezier_curve.scad>
use <tangent_motor.scad>
use <axle.scad>

debug = ["Body"];
gear_radius = GetGearRadius();
eps = 0.1;

module MouseBody() {
    axle_y_offset = 20;
    surface_height = 2;
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
        module TangentAxleHolder()
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

            translate([AxleStopOffset(),
                       axle_y_offset,
                       holder_height/2+surface_height])
                StaticPart();
            translate([-AxleStopOffset(),
                       axle_y_offset,
                       holder_height/2+surface_height])
                StaticPart();
        }
        Surface();
        TangentAxleHolder();
    }

    module TangentAxle() {

        translate([0, axle_y_offset, axle_height])
            rotate([0, 90, 0])
            tangent_axle();

        translate([0,13,18])
            rotate([0, 90, 90])
            tangent_motor();
    }

    LowSurface();
    TangentAxle();


//translate([5,53,8])
//rotate([270, 0, 0])
//import("./Servo_PZ-15320.stl");

//translate([-10,17,12])
//cube([18, 53, 2]);

//translate([0,71,7])
//rotate([90, 0, 0])
//cylinder(44.5,5.25, 5.25);
}

for(val = debug){
    if(val =="Body")
        MouseBody();
    if(val == "Holder")
        TangentAxleHolder();
}
