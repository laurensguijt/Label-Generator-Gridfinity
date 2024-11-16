// Custom label generator by Laurens Guijt
// If you make improvements or add features, please contact me to implement them :) 


//List of labels to generate with batch export enabled, edit accordingly. 
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





//Customisation -------------------------------------------------

/* [Part customization] */
Component = "Socket head bolt"; // [Socket head bolt, Hex head bolt, Dome head bolt, Flat Head countersunk, Standard washer, Spring washer, Standard nut, Heat set inserts]
M_size = "M4"; // [M1, M1.2, M1.4, M1.6, M2, M2.5, M3, M3.5, M4, M5, M6, M8, M10, M12]
hardware_length = 8;

/* [Label customization] */
Y_units=1; // [1,2,3]
Label_color = "#000000"; // color
Content_color = "#FFFFFF"; // color

/* [Text customization] */
//Font type
text_font = "Noto Sans SC:Noto Sans China"; // [HarmonyOS Sans, Inter, Inter Tight, Lora, Merriweather Sans, Montserrat, Noto Sans, Noto Sans SC:Noto Sans China, Noto Sans KR, Noto Emoji, Nunito, Nunito Sans, Open Sans, Open Sans Condensed, Oswald, Playfair Display, Plus Jakarta Sans, Raleway, Roboto, Roboto Condensed, Roboto Flex, Roboto Mono, Roboto Serif, Roboto Slab, Rubik, Source Sans 3, Ubuntu Sans, Ubuntu Sans Mono, Work Sans]

//Font Style
Font_Style = "Bold"; // [Regular,Black,Bold,ExtraBol,ExtraLight,Light,Medium,SemiBold,Thin,Italic,Black Italic,Bold Italic,ExtraBold Italic,ExtraLight Italic,Light Italic,Medium Italic,SemiBold Italic,Thin Italic]

//Flush text requires an AMS
text_type = "Raised Text"; // [Raised Text, Flush Text]

//Font size
text_size = 4.2;


/* [Batch exporter] */
//Enable this feature if you want generate a lot of different labels at once. In de code editor on the left side edit the batch_label_data to the parts desired. Make sure to type the names the same as the dropdowns above
batch_export = false; //false


/* [Settings for nerds] */
width=11.5;
height=0.8;
radius= 0.9;
champfer=0.2;
$fs = 0.1;
$fa = 5;


/* [Hidden] */
Font = str(text_font, ":style=", Font_Style);
length = getDimensions(Y_units);
text_height = (text_type == "Raised Text") ? 0.2 : 0.01;


//label(
//    length = length, 
//    width = width, 
//    height = height,
//    radius = radius,
//    champfer = champfer
//);


//generate_multiple_labels();



// Check if single or batch export
if (batch_export) {
    generate_multiple_labels();
} else {
    label(length = length, 
        width = width, 
        height = height,
        radius = radius,
        champfer = champfer,
        Component = Component,
        M_size = M_size,
        hardware_length = hardware_length
    );
}



// Corrected function for setting length based on Y_units
function getDimensions(Y_units) =
    (Y_units == 1) ? 35.8 :
    (Y_units == 2) ? 71.6 :
    (Y_units == 3) ? 107.4 : 0;






// Generate all labels
module generate_multiple_labels(){
    columns = 3;  // Aantal kolommen
    horizontal_offset = length+3;  // Horizontale offset tussen kolommen
    vertical_offset = 12;    // Verticaal offset tussen labels
    
    // Doorloop alle labels in batch_label_data
    for (i = [0 : len(batch_label_data) - 1]) {
        label_parameters = batch_label_data[i];
        
        // Bereken de rij en kolom
        row = i / columns;  // Deel de index i door het aantal kolommen om de rij te bepalen
        col = i % columns;  // Het modulo van i bepaalt de kolom
        
        // Vertaal het label naar de juiste positie
        translate([col * horizontal_offset, row * -vertical_offset, 0])         
            label(
                length = length, 
                width = width, 
                height = height,
                radius = radius,
                champfer = champfer,
                Component = label_parameters[0],
                M_size = label_parameters[1],
                hardware_length = label_parameters[2]
            );
    }
}



module label(length, width, height, radius, champfer, Component, M_size, hardware_length)
{
    color(Label_color) {
        difference() {         
            labelbase(length, width, height, radius, champfer); 

            translate([(length-1)/2, 0, 0])  
            cylinder(h=height+1, d=1.5, center=true); 

            translate([(-length+1)/2, 0, 0])  
            cylinder(h=height+1, d=1.5, center=true);             
        }
    }
    color(Content_color) {
        choose_Part_version(Component, hardware_length, width, height, M_size);
    } 
}



// Function to select the appropriate bolt head module
module choose_Part_version(Part_version, hardware_length, width, height, M_size) {
    if (Part_version == "Socket head bolt") {
        Socket_head(hardware_length, width, height);
        bolt_text(M_size, hardware_length, height);
    } else if (Part_version == "Hex head bolt") {
        Hex_head(hardware_length, width, height);
        bolt_text(M_size, hardware_length, height);
    } else if (Part_version == "Flat Head countersunk") {
        Countersunk_socket_head(hardware_length, width, height);
        bolt_text(M_size, hardware_length, height);
    } else if (Part_version == "Dome head bolt") {
        Dome_head(hardware_length, width, height);
        bolt_text(M_size, hardware_length, height);
    } else if (Part_version == "Standard washer") {
        standard_washer(width, height);
        washer_text(M_size, height);        
    } else if (Part_version == "Spring washer") {
        spring_washer(width, height);
        washer_text(M_size, height);
    } else if (Part_version == "Standard nut") {
        standard_Nut(width, height);
        nut_text(M_size, height);
    } else if (Part_version == "Heat set inserts") {
        Heat_Set_Inserts(hardware_length, width, height);
        bolt_text(M_size, hardware_length, height);
    }
}


module standard_Nut(width, height, vertical_offset = 2.5) {    
    // Center the icon
    translate([-2.5, vertical_offset, height]) {        
    // Top view of the bolt head
    difference() {    
        cylinder(h=text_height, d=5, $fn=6); 
        cylinder(h=text_height, d=3);
    }
    
    translate([4, -2.5, 0])
    cube([2.8, 5, text_height]);

    }
}


module standard_washer(width, height, vertical_offset = 2.5) {    
    // Center the icon
    translate([-1.5, vertical_offset, height]) {        
    // Top view of the bolt head
    difference() {    
        cylinder(h=text_height, d=5); 
        cylinder(h=text_height, d=3);
    }
    
    translate([4, -2.5, 0])
    cube([1, 5, text_height]);

    }
}


module spring_washer(width, height, vertical_offset = 2.5) {    
    // Center the icon
    translate([-1.5, vertical_offset, height]) {      
    // Top view of the bolt head
    difference() {    
        cylinder(h=text_height, d=5); 
        cylinder(h=text_height, d=3);
        cube([5, 0.8, text_height]);
    }
    
    translate([4, -2.5, 0])
    cube([1, 5, text_height]);

    }
}

module Heat_Set_Inserts(hardware_length, width, height, vertical_offset = 2.5) {    
    // Center the icon
    translate([-4, vertical_offset, height]) {      
    // Top view of heat insert
    difference() {
        union() {    
            cylinder(h=text_height, r=2.5, $fn=5);
            rotate (36) cylinder(h=text_height, r=2.5, $fn=5);           
        }
        cylinder (h=text_height, r=1.5, $fn=80);
    }

    translate([4, -2, 0])
    cube([1, 4, text_height]);
    
    translate([5, -2.5, 0])
    cube([2, 5, text_height]);
    
    translate([7, -2, 0])
    cube([1, 4, text_height]);
    
    translate([8, -2.5, 0])
    cube([2, 5, text_height]);   

    }
}

// Bolt icons modules  ------------------------------------------------------

module Socket_head(hardware_length, width, height, vertical_offset = 2.5) {
    
    // Set the display length to 20 if hardware_length exceeds 20
    display_length = (hardware_length > 20) ? 20 : hardware_length;

    // Center the entire icon horizontally based on display_length
    translate([-display_length / 2 - 2, vertical_offset, height]) {
        
        // Top view of the bolt head
        difference() {    
            cylinder(h=text_height, d=5); 
            cylinder(h=text_height, r=1.6, $fn=6);
        }
        
        // Side view of the bolt head
        translate([3, -2.5, 0])
        cube([4, 5, text_height]);
        
        // Side view of the bolt stem, with a gap if hardware_length > 20
        if (hardware_length > 20) {
            // Cap the visible length at 20 units and add a gap in the middle
            translate([7, -1.25, 0])  
            cube([8.5, 2.5, text_height]);  // First half (10 units)

            translate([7 + 12, -1.25, 0])  
            cube([8.5, 2.5, text_height]);  // Second half (10 units)
            
            
        } else {
            // Regular full-length stem if hardware_length <= 20
            translate([7, -1.25, 0])  
            cube([hardware_length, 2.5, text_height]);
        }
    }
}

module Hex_head(hardware_length, width, height, vertical_offset = 2.5) {
    
    // Set the display length to 20 if hardware_length exceeds 20
    display_length = (hardware_length > 20) ? 20 : hardware_length;

    // Center the entire icon horizontally based on display_length
    translate([-display_length / 2 - 2, vertical_offset, height]) {
        
        // Top view of the bolt head         
        cylinder(h=text_height, d=5, $fn=6);      
        
        // Side view of the bolt head
        translate([3, -2.5, 0])
        cube([3, 5, text_height]);
        
        // Side view of the bolt stem, with a gap if hardware_length > 20
        if (hardware_length > 20) {
            // Cap the visible length at 20 units and add a gap in the middle
            translate([6, -1.25, 0])  
            cube([8.5, 2.5, text_height]);  // First half (10 units)

            translate([6 + 12, -1.25, 0])  
            cube([8.5, 2.5, text_height]);  // Second half (10 units)
            
            
        } else {
            // Regular full-length stem if hardware_length <= 20
            translate([6, -1.25, 0])  
            cube([hardware_length, 2.5, text_height]);
        }
    }
}



module Countersunk_socket_head(hardware_length, width, height, vertical_offset = 2.5) {
    
    // Set the display length to 20 if hardware_length exceeds 20
    display_length = (hardware_length > 20) ? 20 : hardware_length;

    // Center the entire icon horizontally based on display_length
    translate([-display_length / 2 - 2, vertical_offset, height]) {
        
        // Top view of the bolt head
        difference() {    
            cylinder(h=text_height, d=5); 
            cylinder(h=text_height, r=1.6, $fn=6);
        }
        
        // Side view of the bolt head
        translate([5, 0, 0])
        //triangle
        cylinder(r=3, h=text_height, $fn=3);
        
        // Side view of the bolt stem, with a gap if hardware_length > 20
        if (hardware_length > 20) {
            // Cap the visible length at 20 units and add a gap in the middle
            translate([5, -1.25, 0])  
            cube([8.5, 2.5, text_height]);  // First half (10 units)

            translate([5 + 12, -1.25, 0])  
            cube([8.5, 2.5, text_height]);  // Second half (10 units)
            
            
        } else {
            // Regular full-length stem if hardware_length <= 20
            translate([5, -1.25, 0])  
            cube([hardware_length, 2.5, text_height]);
        }
    }
}


module Dome_head(hardware_length, width, height, vertical_offset = 2.5) {
    
    // Set the display length to 20 if hardware_length exceeds 20
    display_length = (hardware_length > 20) ? 20 : hardware_length;

    // Center the entire icon horizontally based on display_length
    translate([-display_length / 2 - 2, vertical_offset, height]) {
        
        // Top view of the bolt head
        difference() {    
            cylinder(h=text_height, d=5); 
            cylinder(h=text_height, r=1.6, $fn=6);
        }
        
        // Side view of the bolt head
        translate([6, 0, 0])
        
        difference() {
            cylinder(h=text_height, d=5);
            translate([0, -2.5, 0])
            cube([4, 5, text_height]);
        }
        
        
        
        // Side view of the bolt stem, with a gap if hardware_length > 20
        if (hardware_length > 20) {
            // Cap the visible length at 20 units and add a gap in the middle
            translate([6, -1.25, 0])  
            cube([8.5, 2.5, text_height]);  // First half (10 units)

            translate([6 + 12, -1.25, 0])  
            cube([8.5, 2.5, text_height]);  // Second half (10 units)
            
            
        } else {
            // Regular full-length stem if hardware_length <= 20
            translate([6, -1.25, 0])  
            cube([hardware_length, 2.5, text_height]);
        }
    }
}




// Base text Modules ------------------------------------------------------
module bolt_text(M, Length, height) {
    bolt_text = str(M, "x", Length);

    translate([0, -3, height])
    linear_extrude(height=text_height)
        text(bolt_text, size=text_size, font=Font, valign="center", halign="center");
}

module nut_text(M, height) {
    bolt_text = str(M);

    translate([0, -3, height])
    linear_extrude(height=text_height)
        text(bolt_text, size=text_size, font=Font, valign="center", halign="center");
}


module washer_text(M, height) {
    bolt_text = str(M);

    translate([0, -3, height])
    linear_extrude(height=text_height)
        text(bolt_text, size=text_size, font=Font, valign="center", halign="center");
}




// Base shape Modules ------------------------------------------------------

module labelbase(length, width, height, radius, champfer){   

    translate([(-length-2)/2, -5.7/2, 0])        
        __shapeWithChampfer(
            length+2, 
            5.7, 
            height, 
            0.2, 
            champfer
        );        

    translate([(-length)/2, -width/2, 0])      
        __shapeWithChampfer(
            length, 
            width, 
            height, 
            radius, 
            champfer
        );
}



module __shapeWithChampfer(
    length,
    width,
    height,
    radius,
    champfer
)
{
    // Apply chamfer at the bottom
    translate([0, 0, 0])
    __champfer(length, width, champfer, radius, flip=false); 
    
    // Apply the main shape, reduced in height to account for both chamfers
    translate([0, 0, champfer])
    __shape(length, width, height - 2 * champfer, radius);

    // Apply chamfer at the top
    translate([0, 0, height - champfer])
    __champfer(length, width, champfer, radius, flip=true); 
}


module __shapeWithFillet(
    length,
    width,
    height,
    radius,
    fillet,
    flip=false
)
{
    fillet_size = min(fillet, radius / 2);
    start1 = (flip == true) ? height - fillet_size : 0;
    start2 = (flip == true) ? 0 : fillet_size;
    hull() {
        translate([0, 0, start1])
        __fillet(length, width, fillet_size, radius, flip); 
        translate([0, 0, start2])
        __shape(length, width, height - champfer, radius);
    }
}

module __fillet (
    length=160,
    width=120,
    size=4,
    radius=10,
    flip=false
) {
    start_fillet = (flip == true) ? 0 : size;
    start_cutout = (flip == true) ? - size - 1: size;

    difference() {
        translate([0,0,start_fillet])
        hull () {
            rotate(180)
            translate ([- radius, - radius, 0])
            rotate_extrude(angle = 90)
            translate([radius - size, 0, 0])
            circle(r = size, $fn = 100);

            rotate(90)
            translate ([width - radius, - radius, 0])
            rotate_extrude(angle = 90)
            translate([radius - size, 0, 0])
            circle(r = size, $fn = 100);

            rotate(0)
            translate ([length - radius, width - radius, 0])
            rotate_extrude(angle = 90)
            translate([radius - size, 0, 0])
            circle(r = size, $fn = 100);

            rotate(270)
            translate ([- radius, length - radius, 0])
            rotate_extrude(angle = 90)
            translate([radius - size, 0, 0])
            circle(r = size, $fn = 100);
        }

        translate([0,0,start_cutout])
        hull() {
            translate ([radius, radius, 0]) cylinder (h = size + 1, r=radius);
            translate ([radius, width-radius, 0]) cylinder (h = size + 1, r=radius);
            translate ([length-radius,width-radius, 0]) cylinder (h = size + 1, r=radius);
            translate ([length-radius, radius, 0]) cylinder (h = size + 1, r=radius);
        }
    }
}

module __champfer (
    length=160,
    width=120,
    size=4,
    radius,
    flip=false
) {
    r1 = (flip == true) ? radius : radius - size;
    r2 = (flip == true) ? radius - size : radius;
    hull() {
        translate ([radius, radius, 0]) cylinder (h = size, r1=r1, r2=r2);
        translate ([radius, width-radius, 0]) cylinder (h = size, r1=r1, r2=r2);
        translate ([length-radius,width-radius, 0]) cylinder (h = size, r1=r1, r2=r2);
        translate ([length-radius, radius, 0]) cylinder (h = size, r1=r1, r2=r2);
    }
}

module __shape(
    length,
    width,
    height,
    radius,
){
    hull() {
        translate ([radius, radius, 0]) cylinder (h = height, r=radius);
        translate ([radius, width-radius, 0]) cylinder (h = height, r=radius);
        translate ([length-radius,width-radius, 0]) cylinder (h = height, r=radius);
        translate ([length-radius, radius, 0]) cylinder (h = height, r=radius);
    }
}