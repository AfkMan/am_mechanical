debug = ["SnapFitHead"];
eps=0.01;

module SnapFitHead(angle=45, offset_h = 3, box=[8, 8, 8]) {
    rotate([180, 180, 180]) {
            side1 = box[0]-offset_h;
            side2 = tan(angle)*side1;
            assert(side1 >= 0);
            assert(side2 <= box[1]);
            difference() {
                cube(box, center=true);
                translate([-box[0]/2,box[1]/2-side2+eps,-box[2]/2])
                    linear_extrude(box[2])
                    polygon(points=[[0,0],
                                    [0,side2],
                                    [side1,side2]]);
            }
            }
}

for(val = debug){
    if(val =="SnapFitHead")
        SnapFitHead();
}
