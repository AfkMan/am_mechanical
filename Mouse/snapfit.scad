debug = ["SnapFitFoot"];
eps=0.01;

module SnapFitFoot(width=8, offset_h = 2, foot_height=30,
                   angle=45, snap_length = 5, snap_height=5) {

    cube([offset_h, width, foot_height], center=true);
    translate([(snap_length-offset_h)/2,
               0,
               -(foot_height+snap_height)/2])
        SnapFitHead(angle, offset_h, [snap_length, snap_height, width]);

}

module SnapFitHead(angle=45, offset_h = 2, box=[5, 5, 8]) {
    render()
    rotate([-90, 0, 180]) {
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
    if(val =="SnapFitFoot")
        SnapFitFoot();
}
