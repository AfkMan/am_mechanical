use <tangent_motor.scad>
use <MCAD/boxes.scad>

axle_length=30;
axle_radius=2;
axle_stop_width = 1;
axle_stop_offset = 0.27*axle_length;
wheel_width=4;
wheel_radius=8;
fastening_width=4;
fastening_tongue_length = 3;

function AxleStopOffset() = axle_stop_offset;
function AxleFasteningWidth() = fastening_width;
function AxleRadius() = axle_radius;

module tangent_axle(draw_axle=true, draw_gear=true,
                    draw_wheels=true, draw_stops=true) {
    if(draw_gear)
        translate([GetTangentMotorProperty("GearRadius"), 0, 0])
            tangent_reductor_gear();

    if(draw_axle)
        translate([0, 0, -axle_length/2]) {
            cylinder(axle_length, axle_radius, axle_radius, $fn=100);
        }

    if(draw_wheels) {
        translate([0,0, -wheel_width/2 + axle_length/2])
            cylinder(wheel_width, wheel_radius, wheel_radius, $fn=100);

        translate([0,0, -wheel_width/2 - axle_length/2])
            cylinder(wheel_width, wheel_radius, wheel_radius, $fn=100);
    }

    module tangent_axle_stop() {
        scale = 1.35;
        translate([0,0,-fastening_width*scale/2])
            cylinder(axle_stop_width, axle_radius, axle_radius+1, center=true,$fn=100);
        translate([0,0,fastening_width*scale/2])
            cylinder(axle_stop_width, axle_radius+1, axle_radius, center=true,$fn=100);
    }

    if(draw_stops){
        translate([0,0,axle_stop_offset])
            tangent_axle_stop();
        translate([0,0,-axle_stop_offset])
            tangent_axle_stop();
    }
}
