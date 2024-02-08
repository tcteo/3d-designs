//triange(20,20,5);

glass_thickness = 2.5;
holder_thickness = 7;
holder_width = 40;
holder_border = 15;
hole_diameter = 5; // should be smaller than holder_border
hole_chamfer_horizontal = 3;
hole_chamfer_vertical = 2; // set to 0 for no chamfer
zfe=0.01;

module triangle(xpos, ypos, zpos, xlen, ylen, zheight) {
    translate([xpos, ypos, zpos])
    linear_extrude(height=zheight)
    polygon([[0, 0],[0, xlen],[ylen, 0]]);
}

module body1() {
    linear_extrude(height=holder_thickness)
    //square(size=[holder_width, holder_width]);
    polygon([        
        [0,0],
        [holder_width, 0],
        [holder_width, holder_border],
        //[holder_border, holder_border],
        [holder_border, holder_width],
        [0, holder_width]
    ]);
}

round_radius=2;

module body2_roundpost() {
    translate([0,0,round_radius]) sphere(r=round_radius,$fn=36);
    translate([0,0,round_radius]) cylinder(r=round_radius, h=holder_thickness-round_radius, $fn=36);
}

module body2() {
    hull() {
        translate([0+round_radius,0+round_radius]) body2_roundpost();
        translate([holder_width-round_radius,0+round_radius]) body2_roundpost();
        translate([holder_width-round_radius, holder_border]) body2_roundpost();
        translate([holder_border, holder_width-round_radius]) body2_roundpost();
        translate([0+round_radius, holder_width-round_radius]) body2_roundpost();
    }
}

difference() {
    body2();

    translate([holder_border, holder_border, holder_thickness-glass_thickness])
    linear_extrude(height=glass_thickness+zfe)
    square(size=[holder_width-holder_border, holder_width-holder_border]);

    /*
    triangle(
        0, 0, 0,
        holder_width, holder_width, holder_thickness);
    triangle(
        holder_border, holder_border, holder_thickness-glass_thickness,
        holder_width-2*holder_border, holder_width-2*holder_border, glass_thickness);
    */

    translate([holder_border/2, holder_border/2, hole_chamfer_vertical-zfe])
    cylinder(r=hole_diameter/2, h=holder_thickness-hole_chamfer_vertical+2*zfe, center=false, $fn=36);

    translate([holder_border/2, holder_border/2, -zfe])
        cylinder(
            r2=hole_diameter/2,
            r1=hole_diameter/2 + hole_chamfer_horizontal,
            h=hole_chamfer_vertical+zfe,
            center=false, $fn=36);
}

// for devel
// translate([100,0,0]) body1();
// translate([150,0,0]) body2();