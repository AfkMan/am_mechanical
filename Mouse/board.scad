use <dotSCAD/src/bezier_curve.scad>
use <tangent_motor/motor_assembled.scad>
include <axle.scad>

difference() {
    // подложка
    height=40;
    length=80;
    eggLine = [[0, 0],
               [0.5*height, 0],
               [height, 0.1*length],
               [0.5*height,length],
               [0,length]];

    linear_extrude(1) {
        polygon(bezier_curve(0.05, eggLine));
        mirror(0,1,0) polygon(bezier_curve(0.05, eggLine));
    }

    // отверстия под колесики
    translate([0, 0, -1])
        linear_extrude(3)
        for(i = [-0.5, 0.5], j = [-0.5, 0.5])
            translate([i, j, 0])
                projection()
                translate([0, 20, gear_radius+2])
                rotate([0, 90, 0])
                tangent_axle(false, false);
}

// ось с колесами
translate([0, 20, gear_radius+2])
rotate([0, 90, 0])
tangent_axle();

//крепления оси
translate([50, 16, 0])

//cube([6,8,10]);
