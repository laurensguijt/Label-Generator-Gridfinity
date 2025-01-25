/////////////////////////////////////////////
// Custom label generator by Laurens Guijt //
/////////////////////////////////////////////

//////////////////////////////////////////////////////////////
//                   BATCH LABEL DATA                      //
//////////////////////////////////////////////////////////////
batch_label_data = [
    ["Dome head bolt", "M2", 8],
    ["Dome head bolt", "M2", 12],
    ["Dome head bolt", "M2", 16],
    ["Dome head bolt", "M2", 20],
    ["Dome head bolt", "M3", 8],
    ["Dome head bolt", "M3", 12],
    ["Dome head bolt", "M3", 16],
    ["Dome head bolt", "M3", 20],
    ["Dome head bolt", "M4", 8],
    ["Dome head bolt", "M4", 12],
    ["Dome head bolt", "M4", 16],
    ["Dome head bolt", "M4", 20],
    ["Dome head bolt", "M5", 8],
    ["Dome head bolt", "M5", 12],
    ["Dome head bolt", "M5", 16],
    ["Dome head bolt", "M5", 20],
    ["Standard nut", "M2", 0],
    ["Standard nut", "M3", 0],
    ["Standard nut", "M4", 0],
    ["Standard nut", "M5", 0],
    ["Standard washer", "M2", 0],
    ["Standard washer", "M3", 0],
    ["Standard washer", "M4", 0],
    ["Standard washer", "M5", 0],
];


/* [Part customization] */
Component = "phillips head bolt"; // [phillips head bolt, phillips wood screw, Torx wood screw, Phillips head countersunk, Socket head bolt, Hex head bolt, Dome head bolt, Flat Head countersunk, Standard washer, Spring washer, Standard nut, Lock nut, Heat set inserts, Torx head bolt, Countersunk Torx head bolt]
diameter = "M4";  // free text, e.g. "1/4-20", "#8-32"
hardware_length = 24;

/* [Label customization] */
Y_units       = 1;          // [1,2,3]
Label_color   = "#000000";  // color
Content_color = "#FFFFFF";  // color

/* [Text customization] */

// Font type
text_font = "Noto Sans SC:Noto Sans China"; // [HarmonyOS Sans, Inter, Inter Tight, Lora, Merriweather Sans, Montserrat, Noto Sans, Noto Sans SC:Noto Sans China, Noto Sans KR, Noto Emoji, Nunito, Nunito Sans, Open Sans, Open Sans Condensed, Oswald, Playfair Display, Plus Jakarta Sans, Raleway, Roboto, Roboto Condensed, Roboto Flex, Roboto Mono, Roboto Serif, Roboto Slab, Rubik, Source Sans 3, Ubuntu Sans, Ubuntu Sans Mono, Work Sans]
// Font Style
Font_Style = "Bold"; // [Regular,Black,Bold,ExtraBol,ExtraLight,Light,Medium,SemiBold,Thin,Italic,Black Italic,Bold Italic,ExtraBold Italic,ExtraLight Italic,Light Italic,Medium Italic,SemiBold Italic,Thin Italic]
// Flush text requires an AMS
text_type  = "Raised Text";                  // [Raised Text, Flush Text]
//Font size
text_size  = 4.2;

/* [Batch exporter] */
// Enable this feature if you want generate a lot of different labels at once.
// In the code editor on the left side edit the batch_label_data to the parts desired.
// Make sure to type the names the same as the dropdowns above
batch_export = false; // false

/* [Settings for nerds] */
width    = 11.5;
height   = 0.8;
radius   = 0.9;
champfer = 0.2;
$fs      = 0.1;
$fa      = 5;

/* [Hidden] */
Font        = str(text_font, ":style=", Font_Style);
length      = getDimensions(Y_units);
text_height = (text_type == "Raised Text") ? 0.2 : 0.01;


//////////////////////////////////////////////////////////////
//               MAIN SWITCH: Single vs. Batch             //
//////////////////////////////////////////////////////////////
if (batch_export) {
    generate_multiple_labels();
} else {
    label(
        length          = length, 
        width           = width, 
        height          = height,
        radius          = radius,
        champfer        = champfer,
        Component       = Component,
        diameter        = diameter,
        hardware_length = hardware_length
    );
}

//////////////////////////////////////////////////////////////
//               Dimension Helper Function                 //
//////////////////////////////////////////////////////////////
function getDimensions(Y_units) =
    (Y_units == 1) ? 35.8 :
    (Y_units == 2) ? 77.8 :
    (Y_units == 3) ? 119.8 :
    0;


//////////////////////////////////////////////////////////////
//            BATCH LABEL GENERATION (Multiple)            //
//////////////////////////////////////////////////////////////
module generate_multiple_labels() {
    columns           = 3;              
    horizontal_offset = length + 3;     
    vertical_offset   = 12;            

    for (i = [0 : len(batch_label_data) - 1]) {
        label_parameters = batch_label_data[i];
        
        row = i / columns;
        col = i % columns;
        
        translate([col * horizontal_offset, row * -vertical_offset, 0]) {
            label(
                length          = length, 
                width           = width, 
                height          = height,
                radius          = radius,
                champfer        = champfer,
                Component       = label_parameters[0],
                diameter        = label_parameters[1],
                hardware_length = label_parameters[2]
            );
        }
    }
}


//////////////////////////////////////////////////////////////
//         MAIN LABEL MODULE (base + icons/text)           //
//////////////////////////////////////////////////////////////
module label(length, width, height, radius, champfer, Component, diameter, hardware_length) {
    color(Label_color) {
        difference() {
            labelbase(length, width, height, radius, champfer);

            // holes at each side
            translate([(length - 1)/2, 0, 0])
                cylinder(h=height+1, d=1.5, center=true);

            translate([(-length + 1)/2, 0, 0])
                cylinder(h=height+1, d=1.5, center=true);
        }
    }
    color(Content_color) {
        choose_Part_version(Component, hardware_length, width, height, diameter);
    }
}


//////////////////////////////////////////////////////////////
//           DISPATCH: Which Part Icon to Draw?            //
//////////////////////////////////////////////////////////////
module choose_Part_version(Part_version, hardware_length, width, height, diameter) {
    if (Part_version == "Socket head bolt") {
        Socket_head(hardware_length, width, height);
        bolt_text(diameter, hardware_length, height);

    } else if (Part_version == "Torx head bolt") {
        Torx_head(hardware_length, width, height);
        bolt_text(diameter, hardware_length, height);

    } else if (Part_version == "Countersunk Torx head bolt") {
        Countersunk_Torx_head(hardware_length, width, height);
        bolt_text(diameter, hardware_length, height);

    } else if (Part_version == "Hex head bolt") {
        Hex_head(hardware_length, width, height);
        bolt_text(diameter, hardware_length, height);

    } else if (Part_version == "Flat Head countersunk") {
        Countersunk_socket_head(hardware_length, width, height);
        bolt_text(diameter, hardware_length, height);

    } else if (Part_version == "Dome head bolt") {
        Dome_head(hardware_length, width, height);
        bolt_text(diameter, hardware_length, height);

    } else if (Part_version == "phillips head bolt") {
        Phillips_head(hardware_length, width, height);
        bolt_text(diameter, hardware_length, height);

    } else if (Part_version == "Phillips head countersunk") {
        Phillips_head_countersunk(hardware_length, width, height);
        bolt_text(diameter, hardware_length, height);

    } else if (Part_version == "Standard washer") {
        standard_washer(width, height);
        washer_text(diameter, height);

    } else if (Part_version == "Spring washer") {
        spring_washer(width, height);
        washer_text(diameter, height);

    } else if (Part_version == "Standard nut") {
        standard_Nut(width, height);
        nut_text(diameter, height);

    } else if (Part_version == "Lock nut") {
        lock_Nut(width, height);
        nut_text(diameter, height);

    } else if (Part_version == "Heat set inserts") {
        Heat_Set_Inserts(hardware_length, width, height);
        bolt_text(diameter, hardware_length, height);

    } else if (Part_version == "phillips wood screw") {
        Phillips_Wood_Screw(hardware_length, width, height);
        bolt_text(diameter, hardware_length, height);

    } else if (Part_version == "Torx wood screw") {
        Torx_Wood_Screw(hardware_length, width, height);
        bolt_text(diameter, hardware_length, height);
    }
}


//////////////////////////////////////////////////////////////
//    NUTS / WASHERS / INSERTS (Top View + Side View)      //
//////////////////////////////////////////////////////////////
module standard_Nut(width, height, vertical_offset = 2.5) {
    translate([-2.5, vertical_offset, height]) {
        // top view
        difference() {    
            cylinder(h=text_height, d=5, $fn=6);
            cylinder(h=text_height, d=3);
        }
        // side view
        translate([4, -2.5, 0])
            cube([2.8, 5, text_height]);
    }
}

module lock_Nut(width, height, vertical_offset = 2.5) {
    translate([-2.5, vertical_offset, height]) {
        // top view
        difference() {    
            cylinder(h=text_height, d=5, $fn=6);
            cylinder(h=text_height, d=3);
        }
        // side view
        translate([4, -2.5, 0])
            cube([2.8, 5, text_height]);

        translate([4, -2, 0])
            cube([3.5, 4, text_height]);
    }
}

module standard_washer(width, height, vertical_offset = 2.5) {
    translate([-1.5, vertical_offset, height]) {
        // top view
        difference() {
            cylinder(h=text_height, d=5);
            cylinder(h=text_height, d=3);
        }
        // side view
        translate([4, -2.5, 0])
            cube([1, 5, text_height]);
    }
}

module spring_washer(width, height, vertical_offset = 2.5) {
    translate([-1.5, vertical_offset, height]) {
        // top view (split ring)
        difference() {
            cylinder(h=text_height, d=5);
            cylinder(h=text_height, d=3);
            cube([5, 0.8, text_height]);
        }
        // side view
        translate([4, -2.5, 0])
            cube([1, 5, text_height]);
    }
}

module Heat_Set_Inserts(hardware_length, width, height, vertical_offset = 2.5) {
    translate([-4, vertical_offset, height]) {
        // top view
        difference() {
            union() {
                cylinder(h=text_height, r=2.5, $fn=5);
                rotate(36) cylinder(h=text_height, r=2.5, $fn=5);
            }
            cylinder(h=text_height, r=1.5, $fn=80);
        }
        // side pattern
        translate([4, -2, 0])    cube([1, 4, text_height]);
        translate([5, -2.5, 0])  cube([2, 5, text_height]);
        translate([7, -2, 0])    cube([1, 4, text_height]);
        translate([8, -2.5, 0])  cube([2, 5, text_height]);
    }
}


//////////////////////////////////////////////////////////////
//            BOLT ICONS (Top View + Side View)            //
//////////////////////////////////////////////////////////////

// "drawBoltStem" for typical bolts/screws
module drawBoltStem(hardware_length, text_height, start=[7, -1.25, 0], thickness=2.5) {
    // The max length scales with Y_units; e.g. Y_units=1 => 20, Y_units=2 => 40, etc.
    maxLen = 20 * Y_units;

    // Final length is either the actual hardware_length or the scaled maxLen
    finalLen = (hardware_length > maxLen) ? maxLen : hardware_length;

    if (hardware_length > maxLen) {
        // For bolts exceeding maxLen, show a "split" icon
        gapBetween    = 2;  // small gap to indicate it's a longer bolt
        segmentLength = (finalLen - gapBetween) / 2;  // split finalLen into two segments

        // First partial segment
        translate(start)
            cube([segmentLength, thickness, text_height]);

        // Second partial segment
        translate([
            start[0] + segmentLength + gapBetween, 
            start[1], 
            start[2]
        ])
            cube([segmentLength, thickness, text_height]);

    } else {
        // If the bolt length is <= maxLen, draw one solid stem
        translate(start)
            cube([finalLen, thickness, text_height]);
    }
}

// Torx star shape for top view
module Torx_star(points, point_len, height=2, rnd=0.1) {
    fn=25;
    point_deg = 360 / points;
    point_deg_adjusted = point_deg + (-point_deg / 2);

    for (i = [0 : points - 1]) {
        rotate([0, 0, i * point_deg])
        translate([0, -point_len, 0])
            point(point_deg_adjusted, point_len, rnd, height, fn);
    }  
    
    module point(deg, leng, rnd, height, fn=25) {
    hull() {
        cylinder(height, d=rnd, $fn=fn); // Base cylinder at the center
        rotate([0, 0, -deg / 2])
            translate([0, leng, 0]) cylinder(height, d=rnd); // Left edge
        rotate([0, 0, deg / 2])
            translate([0, leng, 0]) cylinder(height, d=rnd); // Right edge
    }
}
}


// Torx head bolt
module Torx_head(hardware_length, width, height, vertical_offset = 2.5) {
    display_length = (hardware_length > 20) ? 20 : hardware_length;
    translate([-display_length/2 - 2, vertical_offset, height]) {
        // top view
        difference() {
            cylinder(h=text_height, d=5);
            Torx_star(6, 2, height=2, rnd=0.1);
        }
        // side view
        translate([3, -2.5, 0])
            cube([4, 5, text_height]);

        // stem
        drawBoltStem(hardware_length, text_height, [7, -1.25, 0]);
    }
}

// Countersunk Torx
module Countersunk_Torx_head(hardware_length, width, height, vertical_offset = 2.5) {
    display_length = (hardware_length > 20) ? 20 : hardware_length;
    translate([-display_length/2 - 2, vertical_offset, height]) {
        // top view
        difference() {
            cylinder(h=text_height, d=5);
            Torx_star(6, 2, height=2, rnd=0.1);
        }
        // countersunk side
        translate([6.6, 0, 0])
            cylinder(r=3, h=text_height, $fn=3);

        // stem
        drawBoltStem(hardware_length, text_height, [7, -1.25, 0]);
    }
}

// Socket head
module Socket_head(hardware_length, width, height, vertical_offset = 2.5) {
    display_length = (hardware_length > 20) ? 20 : hardware_length;
    translate([-display_length/2 - 2, vertical_offset, height]) {
        // top view
        difference() {
            cylinder(h=text_height, d=5);
            cylinder(h=text_height, r=1.6, $fn=6);
        }
        // side view
        translate([3, -2.5, 0])
            cube([4, 5, text_height]);

        // stem
        drawBoltStem(hardware_length, text_height, [7, -1.25, 0]);
    }
}

// Hex head
module Hex_head(hardware_length, width, height, vertical_offset = 2.5) {
    display_length = (hardware_length > 20) ? 20 : hardware_length;
    translate([-display_length/2 - 2, vertical_offset, height]) {
        // top view
        cylinder(h=text_height, d=5, $fn=6);
        // side view
        translate([3, -2.5, 0])
            cube([3, 5, text_height]);

        // stem
        drawBoltStem(hardware_length, text_height, [6, -1.25, 0]);
    }
}

// Countersunk socket head
module Countersunk_socket_head(hardware_length, width, height, vertical_offset = 2.5) {
    display_length = (hardware_length > 20) ? 20 : hardware_length;
    translate([-display_length/2 - 2, vertical_offset, height]) {
        // top view
        difference() {
            cylinder(h=text_height, d=5);
            cylinder(h=text_height, r=1.6, $fn=6);
        }
        // countersunk side
        translate([5, 0, 0])
            cylinder(r=3, h=text_height, $fn=3);

        // stem
        drawBoltStem(hardware_length, text_height, [5, -1.25, 0]);
    }
}

// Dome head
module Dome_head(hardware_length, width, height, vertical_offset = 2.5) {
    display_length = (hardware_length > 20) ? 20 : hardware_length;
    translate([-display_length/2 - 2, vertical_offset, height]) {
        // top view
        difference() {
            cylinder(h=text_height, d=5);
            cylinder(h=text_height, r=1.6, $fn=6);
        }
        // side view
        translate([6, 0, 0]) {
            difference() {
                cylinder(h=text_height, d=5);
                translate([0, -2.5, 0])
                    cube([4, 5, text_height]);
            }
        }
        // stem
        drawBoltStem(hardware_length, text_height, [6, -1.25, 0]);
    }
}

// Phillips head
module Phillips_head(hardware_length, width, height, vertical_offset = 2.5) {
    display_length = (hardware_length > 20) ? 20 : hardware_length;
    translate([-display_length/2 - 2, vertical_offset, height]) {
        // top view
        difference() {
            cylinder(h=text_height, d=5);
            translate([-0.5, -2, 0])
                cube([1, 4, text_height]);
            translate([-2, -0.5, 0])
                cube([4, 1, text_height]);
        }
        // side view
        translate([6, 0, 0]) {
            difference() {
                cylinder(h=text_height, d=5);
                translate([0, -2.5, 0])
                    cube([4, 5, text_height]);
            }
        }
        // stem
        drawBoltStem(hardware_length, text_height, [6, -1.25, 0]);
    }
}

// Phillips countersunk
module Phillips_head_countersunk(hardware_length, width, height, vertical_offset = 2.5) {
    display_length = (hardware_length > 20) ? 20 : hardware_length;
    translate([-display_length/2 - 2, vertical_offset, height]) {
        // top view
        difference() {
            cylinder(h=text_height, d=5);
            translate([-0.5, -2, 0])
                cube([1, 4, text_height]);
            translate([-2, -0.5, 0])
                cube([4, 1, text_height]);
        }
        // countersunk side
        translate([5, 0, 0])
            cylinder(r=3, h=text_height, $fn=3);

        // stem
        drawBoltStem(hardware_length, text_height, [5, -1.25, 0]);
    }
}

//////////////////////////////////////////////////////////////
//         PHILLIPS WOOD SCREW (FIXED TIP ALIGNMENT)       //
//////////////////////////////////////////////////////////////
module Phillips_Wood_Screw(hardware_length, width, height, vertical_offset = 2.5) {
    // We'll place everything in "real" X after we clamp a final stem length
    display_length = (hardware_length > 20) ? 20 : hardware_length;
    
    // The start of the main stem
    stemStart = [5, -1.25, 0];

    // We want to shorten the actual stem by 1.5 for the tip
    // Then clamp it to the same maxLen logic used in drawBoltStem
    maxLen    = 20 * Y_units;
    rawStem   = hardware_length - 1.5;  
    finalStem = (rawStem > maxLen) ? maxLen : rawStem;
    
    translate([-display_length/2 - 2, vertical_offset, height]) {
        // Head (top view)
        difference() {
            cylinder(h=text_height, d=5);
            // Phillips "plus"
            translate([-0.5, -2, 0]) cube([1, 4, text_height]);
            translate([-2, -0.5, 0]) cube([4, 1, text_height]);
        }

        // Countersunk side
        translate([5, 0, 0])
            cylinder(r=3, h=text_height, $fn=3);

        // Draw the stem with the same logic as drawBoltStem,
        // but using finalStem (the "shortened" length).
        // That means if rawStem is still bigger than maxLen,
        // it will be split within the function as well.
        drawBoltStem(rawStem, text_height, stemStart);

        // Place the tip exactly at the end of the final stem, not the full hardware_length
        translate([stemStart[0] + finalStem, 0, 0]) {
            linear_extrude(height=text_height)
                polygon(
                    points = [[0, 1.25],[2, 0],[0, -1.25]],
                    paths  = [[0, 1, 2]]
                );
        }
    }
}

//////////////////////////////////////////////////////////////
//          TORX WOOD SCREW (FIXED TIP ALIGNMENT)          //
//////////////////////////////////////////////////////////////
module Torx_Wood_Screw(hardware_length, width, height, vertical_offset = 2.5) {
    // We'll place everything in "real" X after we clamp a final stem length
    display_length = (hardware_length > 20) ? 20 : hardware_length;
    
    // The start of the main stem
    stemStart = [5, -1.25, 0];

    // We want to shorten the actual stem by 1.5 for the tip
    // Then clamp it to the same maxLen logic used in drawBoltStem
    maxLen    = 20 * Y_units;
    rawStem   = hardware_length - 1.5;  
    finalStem = (rawStem > maxLen) ? maxLen : rawStem;
    
    translate([-display_length/2 - 2, vertical_offset, height]) {
        // top view (torx head)
        difference() {
            cylinder(h=text_height, d=5);
            Torx_star(6, 2, height=2, rnd=0.1);
        }

        // Countersunk side
        translate([5, 0, 0])
            cylinder(r=3, h=text_height, $fn=3);

        // Main stem (shortened by 1.5). We pass 'rawStem' so drawBoltStem can do the split if needed.
        drawBoltStem(rawStem, text_height, stemStart);

        // Place tip exactly at the end of that final stem
        translate([stemStart[0] + finalStem, 0, 0]) {
            linear_extrude(height=text_height)
                polygon(
                    points = [[0,  1.25],[2, 0],[0, -1.25]],
                    paths  = [[0, 1, 2]]
                );
        }
    }
}

//////////////////////////////////////////////////////////////
//                       TEXT MODULES                      //
//////////////////////////////////////////////////////////////
module bolt_text(diameter, Length, height) {
    translate([0, -3, height])
        linear_extrude(height=text_height)
            text(str(diameter, "x", Length),
                 size   = text_size,
                 font   = Font,
                 valign = "center",
                 halign = "center");
}

module nut_text(diameter, height) {
    translate([0, -3, height])
        linear_extrude(height=text_height)
            text(diameter, 
                 size   = text_size,
                 font   = Font,
                 valign = "center",
                 halign = "center");
}

module washer_text(diameter, height) {
    translate([0, -3, height])
        linear_extrude(height=text_height)
            text(diameter,
                 size   = text_size,
                 font   = Font,
                 valign = "center",
                 halign = "center");
}


//////////////////////////////////////////////////////////////
//                LABEL BASE SHAPE + CHAMFER               //
//////////////////////////////////////////////////////////////
module labelbase(length, width, height, radius, champfer) {
    // Extra perimeter shape
    translate([(-length - 2)/2, -5.7/2, 0]) {
        __shapeWithChampfer(
            length+2, 
            5.7, 
            height, 
            0.2, 
            champfer
        );
    }
    // Main label shape
    translate([(-length)/2, -width/2, 0]) {
        __shapeWithChampfer(
            length, 
            width, 
            height, 
            radius, 
            champfer
        );
    }
}

// shape with top/bottom chamfer
module __shapeWithChampfer(length, width, height, radius, champfer) {
    // bottom chamfer
    translate([0, 0, 0])
        __champfer(length, width, champfer, radius, flip=false);

    // main shape
    translate([0, 0, champfer])
        __shape(length, width, height - 2*champfer, radius);

    // top chamfer
    translate([0, 0, height - champfer])
        __champfer(length, width, champfer, radius, flip=true);
}

// side chamfer
module __champfer(length, width, size, radius, flip=false) {
    r1 = flip ? radius : radius - size;
    r2 = flip ? radius - size : radius;
    hull() {
        translate([radius, radius, 0])
            cylinder(h=size, r1=r1, r2=r2);
        translate([radius, width-radius, 0])
            cylinder(h=size, r1=r1, r2=r2);
        translate([length-radius, width-radius, 0])
            cylinder(h=size, r1=r1, r2=r2);
        translate([length-radius, radius, 0])
            cylinder(h=size, r1=r1, r2=r2);
    }
}

// main shape with rounded corners
module __shape(length, width, height, radius) {
    hull() {
        translate([radius, radius, 0])
            cylinder(h=height, r=radius);
        translate([radius, width-radius, 0])
            cylinder(h=height, r=radius);
        translate([length-radius, width-radius, 0])
            cylinder(h=height, r=radius);
        translate([length-radius, radius, 0])
            cylinder(h=height, r=radius);
    }
}
