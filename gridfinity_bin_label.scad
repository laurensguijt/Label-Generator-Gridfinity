/////////////////////////////////////////////
// Custom label generator by Laurens Guijt //
/////////////////////////////////////////////

//////////////////////////////////////////////////////////////
//                   BATCH LABEL DATA                      //
//////////////////////////////////////////////////////////////

// Each entry is [part, diameter, length]. The part is a list of the dropdown
// values below: [category, type] for nuts, washers, standoffs and others, and
// [category, head, drive, tip] for bolts (drive and tip are optional).
// The old component names like "Dome head bolt" still work as well.
batch_label_data = [
    [["Bolt", "Pan head", "Hex socket"], "M2", 8],
    [["Bolt", "Pan head", "Hex socket"], "M2", 12],
    [["Bolt", "Pan head", "Hex socket"], "M2", 16],
    [["Bolt", "Pan head", "Hex socket"], "M2", 20],
    [["Bolt", "Pan head", "Hex socket"], "M3", 8],
    [["Bolt", "Pan head", "Hex socket"], "M3", 12],
    [["Bolt", "Pan head", "Hex socket"], "M3", 16],
    [["Bolt", "Pan head", "Hex socket"], "M3", 20],
    [["Bolt", "Pan head", "Hex socket"], "M4", 8],
    [["Bolt", "Pan head", "Hex socket"], "M4", 12],
    [["Bolt", "Pan head", "Hex socket"], "M4", 16],
    [["Bolt", "Pan head", "Hex socket"], "M4", 20],
    [["Bolt", "Pan head", "Hex socket"], "M5", 8],
    [["Bolt", "Pan head", "Hex socket"], "M5", 12],
    [["Bolt", "Pan head", "Hex socket"], "M5", 16],
    [["Bolt", "Pan head", "Hex socket"], "M5", 20],
    [["Nut", "Standard"], "M2", 0],
    [["Nut", "Standard"], "M3", 0],
    [["Nut", "Standard"], "M4", 0],
    [["Nut", "Standard"], "M5", 0],
    [["Washer", "Standard"], "M2", 0],
    [["Washer", "Standard"], "M3", 0],
    [["Washer", "Standard"], "M4", 0],
    [["Washer", "Standard"], "M5", 0],
];

// Adding a part? Add it to the matching dropdown below and run
// "python3 tools/generate_gallery.py" to update the pictures in README.md.

/* [Part customization] */
// Pick the category here, then refine it in the matching section below
Category = "Bolt"; // [Bolt, Nut, Washer, Standoff, Furniture, Other]
diameter = "M4";  // free text, e.g. "1/4-20", "#8-32"
// Used for bolts, standoffs (body without the thread stud), spacer washers (height),
// wall anchors, heat set inserts, furniture hardware and threaded rods (0 = no length shown).
// In mm, in 0.1 steps
hardware_length = 24; // [0:0.1:150]
// Fixed draws every part at a size that always fits the label (the length only shows in the text).
// Real length scales the icon with hardware_length, long parts get a split icon.
Icon_length = "Fixed"; // [Fixed, Real length]

/* [Bolt (only used when Category is Bolt)] */
Head  = "Pan head";  // [Socket head, Pan head, Mushroom head, Flat head, Countersunk, Hex head, Grub screw]
// Ignored for hex head bolts
Drive = "Phillips";  // [Hex socket, Phillips, Torx, Torx TR, Slotted]
// Wood adds a pointed tip, ignored for grub screws
Tip   = "Machine";   // [Machine, Wood]

/* [Nut (only used when Category is Nut)] */
Nut_type = "Standard"; // [Standard, Tall, Square, Lock, Castle, Cap, Eye, Disc, Wing, Slide-in T-nut, Hammer]

/* [Washer (only used when Category is Washer)] */
// Spacer uses hardware_length as its height
Washer_type = "Standard"; // [Standard, Spring, Spacer]

/* [Standoff (only used when Category is Standoff)] */
// Hex spacers like the brass M3 ones for mainboards, male = thread stud
Standoff_type = "Male-female"; // [Male-female, Female-female, Male-male]

/* [Furniture (only used when Category is Furniture)] */
Furniture_type = "Wooden dowel"; // [Wooden dowel, Expansion sleeve, Cam lock nut, Cam lock bolt]

/* [Other (only used when Category is Other)] */
Other_type = "Wall anchor"; // [Wall anchor, Heat set insert, Threaded rod, Compression spring, Custom text, None]
// Custom text, first line (only used when Other type is set to "Custom text")
custom_text = "Custom";
// Custom text, second line (leave empty to show the first line full size and centered)
custom_text_line2 = "";

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
// Raised Text Height, also sets how far the icons stand off the label
raised_text_height = 0.2; // [0.05:0.05:1]

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

/* [Legacy] */
// Old single dropdown name (e.g. "Dome head bolt"). Leave empty to use the
// dropdowns above. Kept so presets saved with older versions keep working.
Component = "";

/* [Hidden] */
// Every part the generator can draw, in one place.
//
//     [category, type, icon, text, gallery]
//
// type     the value in the category's dropdown, or "*" for every type in the
//          category. An exact type wins over the category's "*" row, so a part
//          only needs its own row when it differs from the rest of its category
// icon     the size in mm the icon is drawn at when Icon_length is "Fixed", or
//          undef to always draw it at the real hardware_length
// text     what is written under the icon:
//            "size"      M5x16
//            "diameter"  M5
//            "optional"  M5x16, or M5 when hardware_length is 0
//            "centered"  M5x16 in the middle, for parts without an icon
//            "custom"    the custom text lines
// gallery  the size the README picture is rendered at, [diameter] or
//          [diameter, length]
parts = [
    ["Bolt",      "*",                   16,    "size",     ["M5", 16]],
    ["Nut",       "*",                   undef, "diameter", ["M5"]],
    ["Washer",    "*",                   undef, "diameter", ["M5"]],
    ["Washer",    "Spacer",               5,    "size",     ["M5", 5]],
    ["Standoff",  "*",                   10,    "size",     ["M3", 10]],
    ["Furniture", "*",                   16,    "size",     ["8", 30]],
    ["Other",     "Wall anchor",         undef, "size",     ["M6", 30]],
    ["Other",     "Heat set insert",     undef, "size",     ["M3", 5]],
    ["Other",     "Threaded rod",        1000,  "optional", ["M8", 1000]],
    ["Other",     "Compression spring",   16,   "size",     ["6", 20]],
    ["Other",     "Custom text",         undef, "custom",   []],
    ["Other",     "None",                undef, "centered", ["M5", 16]],
];
Font        = str(text_font, ":style=", Font_Style);
length      = getDimensions(Y_units);
text_height = (text_type == "Raised Text") ? raised_text_height : 0.01;

selected_part =
    (Category == "Bolt")   ? ["Bolt", Head, Drive, Tip] :
    (Category == "Nut")    ? ["Nut", Nut_type] :
    (Category == "Washer") ? ["Washer", Washer_type] :
    (Category == "Standoff") ? ["Standoff", Standoff_type] :
    (Category == "Furniture") ? ["Furniture", Furniture_type] :
    ["Other", Other_type];

part = (Component == "") ? selected_part : resolve_part(Component);


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
        part            = part,
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
//          PART LOOKUP (incl. old component names)        //
//////////////////////////////////////////////////////////////
// Old single dropdown names mapped to [category, ...] parts
// (a function, so it can be used by the assignments above it)
function legacy_components() = [
    ["Socket head bolt",           ["Bolt", "Socket head", "Hex socket", "Machine"]],
    ["Torx head bolt",             ["Bolt", "Socket head", "Torx",       "Machine"]],
    ["Dome head bolt",             ["Bolt", "Pan head",    "Hex socket", "Machine"]],
    ["phillips head bolt",         ["Bolt", "Pan head",    "Phillips",   "Machine"]],
    ["Torx pan head bolt",         ["Bolt", "Pan head",    "Torx",       "Machine"]],
    ["Flat Head countersunk",      ["Bolt", "Countersunk", "Hex socket", "Machine"]],
    ["Phillips head countersunk",  ["Bolt", "Countersunk", "Phillips",   "Machine"]],
    ["Countersunk Torx head bolt", ["Bolt", "Countersunk", "Torx",       "Machine"]],
    ["Hex head bolt",              ["Bolt", "Hex head",    "Hex socket", "Machine"]],
    ["Grub screw",                 ["Bolt", "Grub screw",  "Hex socket", "Machine"]],
    ["phillips wood screw",        ["Bolt", "Countersunk", "Phillips",   "Wood"]],
    ["Torx wood screw",            ["Bolt", "Countersunk", "Torx",       "Wood"]],
    ["Torx panhead wood screw",    ["Bolt", "Pan head",    "Torx",       "Wood"]],
    ["Standard nut",               ["Nut", "Standard"]],
    ["Square nut",                 ["Nut", "Square"]],
    ["Lock nut",                   ["Nut", "Lock"]],
    ["Cap nut",                    ["Nut", "Cap"]],
    ["Disc nut",                   ["Nut", "Disc"]],
    ["Wing nut",                   ["Nut", "Wing"]],
    ["Slide-in T-nut",             ["Nut", "Slide-in T-nut"]],
    ["Hammer nut",                 ["Nut", "Hammer"]],
    ["Standard washer",            ["Washer", "Standard"]],
    ["Spring washer",              ["Washer", "Spring"]],
    ["Wall Anchor",                ["Other", "Wall anchor"]],
    ["Heat set inserts",           ["Other", "Heat set insert"]],
    ["Wooden dowel",               ["Furniture", "Wooden dowel"]],
    ["Expansion sleeve",           ["Furniture", "Expansion sleeve"]],
    ["Cam lock nut",               ["Furniture", "Cam lock nut"]],
    ["Cam lock bolt",              ["Furniture", "Cam lock bolt"]],
    ["Custom Text",                ["Other", "Custom text"]],
    ["None",                       ["Other", "None"]],
];

// Accepts a part list like ["Bolt", "Pan head", "Torx"] or an old component name
function resolve_part(p) =
    is_list(p)
        ? ((p[0] == "Bolt")
            ? ["Bolt", p[1], len(p) > 2 ? p[2] : "Hex socket", len(p) > 3 ? p[3] : "Machine"]
            : p)
        : legacy_part(p);

function legacy_part(name) =
    let (i = search([name], legacy_components())[0])
    (i == []) ? ["Unknown", name] : legacy_components()[i][1];


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
                part            = resolve_part(label_parameters[0]),
                diameter        = label_parameters[1],
                hardware_length = label_parameters[2]
            );
        }
    }
}


//////////////////////////////////////////////////////////////
//         MAIN LABEL MODULE (base + icons/text)           //
//////////////////////////////////////////////////////////////
module label(length, width, height, radius, champfer, part, diameter, hardware_length) {
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
        choose_Part_version(part, hardware_length, width, height, diameter);
    }
}


//////////////////////////////////////////////////////////////
//           DISPATCH: Which Part Icon to Draw?            //
//////////////////////////////////////////////////////////////
module choose_Part_version(part, hardware_length, width, height, diameter) {
    category = part[0];
    type     = part[1];
    // the icon is drawn at icon_len, the text always shows the real hardware_length
    icon_len = icon_length(category, type, hardware_length);

    draw_icon(part, icon_len, width, height);
    part_text(category, type, diameter, hardware_length, height);
}


//////////////////////////////////////////////////////////////
//          DISPATCH: WHICH PART ICON TO DRAW              //
//////////////////////////////////////////////////////////////
// One line per part. Every icon module takes (icon_len, width, height) first,
// whatever a part needs on top of that follows.
module draw_icon(part, icon_len, width, height) {
    category = part[0];
    type     = part[1];
    key      = str(category, "/", type);

    if (category == "Bolt") Bolt(icon_len, width, height, type, part[2], part[3]);

    else if (key == "Nut/Standard")               standard_Nut(icon_len, width, height);
    else if (key == "Nut/Tall")                   Tall_Nut(icon_len, width, height);
    else if (key == "Nut/Square")                 Square_Nut(icon_len, width, height);
    else if (key == "Nut/Lock")                   lock_Nut(icon_len, width, height);
    else if (key == "Nut/Castle")                 Castle_Nut(icon_len, width, height);
    else if (key == "Nut/Cap")                    Cap_Nut(icon_len, width, height);
    else if (key == "Nut/Eye")                    Eye_Nut(icon_len, width, height);
    else if (key == "Nut/Disc")                   Disc_Nut(icon_len, width, height);
    else if (key == "Nut/Wing")                   Wing_Nut(icon_len, width, height);
    else if (key == "Nut/Slide-in T-nut")         Slide_in_T_Nut(icon_len, width, height);
    else if (key == "Nut/Hammer")                 Hammer_Nut(icon_len, width, height);
    else if (key == "Washer/Standard")            standard_washer(icon_len, width, height);
    else if (key == "Washer/Spring")              spring_washer(icon_len, width, height);
    else if (key == "Washer/Spacer")              spacer_washer(icon_len, width, height);
    else if (key == "Standoff/Male-female")       Standoff(icon_len, width, height, type);
    else if (key == "Standoff/Female-female")     Standoff(icon_len, width, height, type);
    else if (key == "Standoff/Male-male")         Standoff(icon_len, width, height, type);
    else if (key == "Furniture/Wooden dowel")     Wooden_Dowel(icon_len, width, height);
    else if (key == "Furniture/Expansion sleeve") Expansion_Sleeve(icon_len, width, height);
    else if (key == "Furniture/Cam lock nut")     cam_lock_Nut(icon_len, width, height);
    else if (key == "Furniture/Cam lock bolt")    Cam_Lock_Bolt(icon_len, width, height);
    else if (key == "Other/Wall anchor")          Wall_Anchor(icon_len, width, height);
    else if (key == "Other/Heat set insert")      Heat_Set_Inserts(icon_len, width, height);
    else if (key == "Other/Threaded rod")         Threaded_Rod(icon_len, width, height);
    else if (key == "Other/Compression spring")   Compression_Spring(icon_len, width, height);
    else if (key == "Other/Custom text")          ;  // the custom text is the whole label
    else if (key == "Other/None")                 ;  // no icon, just the text

    else echo(str("WARNING: unknown part: ", key));
}


//////////////////////////////////////////////////////////////
//             TEXT UNDER THE ICON (from "parts")          //
//////////////////////////////////////////////////////////////
module part_text(category, type, diameter, hardware_length, height) {
    row   = part_row(category, type);
    style = (row == undef) ? "none" : row[3];

    if      (style == "none")     ;  // not a known part, draw_icon already warned
    else if (style == "size")     size_text(diameter, hardware_length, height);
    else if (style == "diameter") diameter_text(diameter, height);
    else if (style == "optional") {
        if (hardware_length > 0) size_text(diameter, hardware_length, height);
        else                     diameter_text(diameter, height);
    }
    else if (style == "centered") centered_text(str(diameter, "x", hardware_length), height);
    else if (style == "custom")   custom_text_lines(custom_text, custom_text_line2, height);
    else echo(str("WARNING: unknown text style: ", style));
}

//////////////////////////////////////////////////////////////
//    NUTS / WASHERS / INSERTS (Top View + Side View)      //
//////////////////////////////////////////////////////////////
module standard_Nut(icon_len, width, height, vertical_offset = 2.5) {
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

// Tall hex nut (DIN 6330 / ISO 4033): like the standard nut, drawn twice as high so it stands out
module Tall_Nut(icon_len, width, height, vertical_offset = 2.5) {
    translate([-3.9, vertical_offset, height]) {
        // top view
        difference() {
            cylinder(h=text_height, d=5, $fn=6);
            cylinder(h=text_height, d=3);
        }
        // side view: hex body with the edges between its faces
        difference() {
            translate([4, -2.5, 0])
                cube([5.6, 5, text_height]);
            for (y = [-1.05, 0.65])
                translate([4, y, 0])
                    cube([5.6, 0.4, text_height]);
        }
    }
}

// Square nut (DIN 557 / DIN 562)
module Square_Nut(icon_len, width, height, vertical_offset = 2.5) {
    translate([-2.5, vertical_offset, height]) {
        // top view: square body with threaded hole
        difference() {
            translate([-2.2, -2.2, 0])
                cube([4.4, 4.4, text_height]);
            cylinder(h=text_height, d=2.6);
        }
        // side view
        translate([4, -2.2, 0])
            cube([2.8, 4.4, text_height]);
    }
}

module lock_Nut(icon_len, width, height, vertical_offset = 2.5) {
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

// Castle nut / slotted nut (DIN 935): hex body with a slotted crown for a split pin
module Castle_Nut(icon_len, width, height, vertical_offset = 2.5) {
    translate([-3.3, vertical_offset, height]) {
        // top view: hex with threaded hole and the three slots across the crown
        difference() {
            cylinder(h=text_height, d=5, $fn=6);
            cylinder(h=text_height, d=2.4);
            for (a = [0, 60, 120])
                rotate(a)
                    translate([-2.1, -0.35, 0])
                        cube([4.2, 0.7, text_height]);
        }
        // side view: hex body with the narrower crown, slots cut into its top
        translate([4, -2.5, 0])
            cube([2.2, 5, text_height]);
        difference() {
            translate([6.2, -2.1, 0])
                cube([2.2, 4.2, text_height]);
            translate([7.2, -0.4, 0])
                cube([1.2, 0.8, text_height]);
        }
    }
}

// Cap nut / acorn nut (DIN 1587): hex body closed by a dome
module Cap_Nut(icon_len, width, height, vertical_offset = 2.5) {
    translate([-2.5, vertical_offset, height]) {
        // top view: closed hex with the outline of the dome
        difference() {
            cylinder(h=text_height, d=5, $fn=6);
            difference() {
                cylinder(h=text_height, d=3.8);
                cylinder(h=text_height, d=2.8);
            }
        }
        // side view: short hex body with the dome on top
        translate([4, -2.5, 0])
            cube([2.2, 5, text_height]);
        translate([6.2, 0, 0])
            intersection() {
                cylinder(h=text_height, r=2);
                translate([0, -2, 0])
                    cube([2, 4, text_height]);
            }
    }
}

// Eye nut / ring nut (DIN 582): lifting eye on a round collar with threaded hole
module Eye_Nut(icon_len, width, height, vertical_offset = 2.5) {
    translate([-4, vertical_offset, height])
        linear_extrude(height=text_height) {
            // top view: round collar with the eye seen edge-on across it
            difference() {
                circle(d=5);
                circle(d=3.8);
            }
            translate([-0.6, -2.5])
                square([1.2, 5]);
            // side view: collar tapering into the eye
            hull() {
                translate([4, -2])
                    square([1.2, 4]);
                translate([5.2, -1])
                    square([1, 2]);
            }
            translate([8.2, 0])
                difference() {
                    circle(d=5);
                    circle(d=2.8);
                }
        }
}

// Disc nut: hex nut captive on a large round washer
module Disc_Nut(icon_len, width, height, vertical_offset = 2.5) {
    translate([-3, vertical_offset, height]) {
        // top view: hex nut with threaded hole, framed by the washer
        difference() {
            cylinder(h=text_height, d=5.6);
            cylinder(h=text_height, d=4.8, $fn=6);
        }
        difference() {
            cylinder(h=text_height, d=4, $fn=6);
            cylinder(h=text_height, d=2.2);
        }
        // side view: thin washer with the hex body on top
        translate([4, -2.8, 0])
            cube([0.8, 5.6, text_height]);
        translate([4.8, -2, 0])
            cube([2.2, 4, text_height]);
    }
}

// Wing nut (DIN 315): round hub with two wings for turning by hand
module Wing_Nut(icon_len, width, height, vertical_offset = 2.5) {
    translate([-4.25, vertical_offset, height])
        linear_extrude(height=text_height) {
            // top view: hub with threaded hole, wings as a thin bar
            difference() {
                union() {
                    circle(d=3.2);
                    hull() {
                        translate([-3, 0]) circle(r=0.5);
                        translate([3, 0]) circle(r=0.5);
                    }
                }
                circle(d=1.8);
            }
            // side view: tapered hub with both wings rising outwards
            translate([8.5, 0]) {
                polygon(points=[[-1.5, -2.5], [1.5, -2.5], [1.1, 0.3], [-1.1, 0.3]]);
                for (side = [-1, 1])
                    mirror([side < 0 ? 1 : 0, 0])
                        hull() {
                            translate([0.9, -2.2]) square([0.5, 1.5]);
                            translate([2.8, 1.9]) circle(r=0.6);
                        }
            }
        }
}

// Slide-in T-nut for aluminium profiles (inserted from the profile end)
module Slide_in_T_Nut(icon_len, width, height, vertical_offset = 2.5) {
    translate([-4, vertical_offset, height]) {
        // top view: rectangular block with threaded hole
        difference() {
            translate([-3.5, -2, 0])
                cube([7, 4, text_height]);
            cylinder(h=text_height, d=2.5);
        }
        // side view: T profile, flange at the bottom, neck into the slot
        translate([5, -2.5, 0])
            cube([6, 2, text_height]);
        translate([6.75, -0.5, 0])
            cube([2.5, 1.5, text_height]);
    }
}

// Hammer nut for aluminium profiles (dropped into the slot, turned 90°)
module Hammer_Nut(icon_len, width, height, vertical_offset = 2.5) {
    translate([-4, vertical_offset, height]) {
        // top view: two opposite corners rounded so it can rotate in the slot
        difference() {
            hull() {
                translate([1.5, 0, 0])
                    cylinder(h=text_height, r=2);
                translate([-1.5, 0, 0])
                    cylinder(h=text_height, r=2);
                translate([3, -2, 0])
                    cube([0.5, 0.5, text_height]);
                translate([-3.5, 1.5, 0])
                    cube([0.5, 0.5, text_height]);
            }
            cylinder(h=text_height, d=2.5);
        }
        // side view: tapered body with neck on top
        linear_extrude(height=text_height)
            polygon(points=[[6.5, -2.5], [9.5, -2.5], [11, 0.5], [5, 0.5]]);
        translate([6.75, 0.5, 0])
            cube([2.5, 1.5, text_height]);
    }
}

module standard_washer(icon_len, width, height, vertical_offset = 2.5) {
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

module spring_washer(icon_len, width, height, vertical_offset = 2.5) {
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

// Hex standoff / spacer (e.g. brass M3 for mainboards), male ends get a thread stud
module Standoff(icon_len, width, height, type, vertical_offset = 2.5) {
    display_length = min(icon_len, 20 * Y_units);
    stud_length    = 2.5;
    male_start     = (type == "Male-male");
    male_end       = (type != "Female-female");
    body_x         = 4 + (male_start ? stud_length : 0);
    right_end      = body_x + display_length + (male_end ? stud_length : 0);

    // center the icon between the left edge of the top view and the right end
    translate([-(right_end - 2.5)/2, vertical_offset, height]) {
        // top view: hexagon, with a hole or the stud seen from above
        difference() {
            cylinder(h=text_height, d=5, $fn=6);
            cylinder(h=text_height, d=male_start ? 3.4 : 2.6);
        }
        if (male_start)
            cylinder(h=text_height, d=2.4);

        // side view: hex body with the edges between its faces
        difference() {
            drawBoltStem(icon_len, text_height, [body_x, -2, 0], thickness=4);
            for (y = [-1.05, 0.65])
                translate([body_x, y, 0])
                    cube([display_length, 0.4, text_height]);
        }
        if (male_start)
            translate([body_x - stud_length, -1, 0])
                cube([stud_length, 2, text_height]);
        if (male_end)
            translate([body_x + display_length, -1, 0])
                cube([stud_length, 2, text_height]);
    }
}

// Spacer washer / spacer sleeve: a washer with a given height, the side view grows with it
module spacer_washer(icon_len, width, height, vertical_offset = 2.5) {
    display_length = min(icon_len, 20 * Y_units);
    translate([-(display_length + 1.5)/2, vertical_offset, height]) {
        // top view
        difference() {
            cylinder(h=text_height, d=5);
            cylinder(h=text_height, d=3);
        }
        // side view, split like a bolt stem when it is too long for the label
        drawBoltStem(icon_len, text_height, [4, -2.5, 0], thickness=5);
    }
}

// The wire of the helix, seen from the side
function compression_spring_path(turns, pitch, radius_x, radius_y, samples_per_turn = 20) =
    let(
        steps = turns * samples_per_turn,
        start_x = -turns * pitch / 2
    )
    [for (i = [0 : steps])
        let(t = 360 * turns * i / steps)
        [start_x + pitch * t / 360 + radius_x * sin(t), -radius_y * cos(t)]];

// A closed end coil, seen from the side
function compression_spring_end_ellipse(center_x, radius_x, radius_y, center_y = 0, samples = 36) =
    [for (i = [0 : samples])
        let(t = 360 * i / samples)
        [center_x + radius_x * cos(t), center_y + radius_y * sin(t)]];

// A path drawn as a ribbon of the given thickness. The hulls are done in 2D
// and extruded once, which renders far faster than hulling cylinders in 3D.
module rounded_stroke(points, thickness, height) {
    linear_extrude(height = height)
        for (i = [0 : len(points) - 2]) {
            hull() {
                translate(points[i])     circle(d = thickness);
                translate(points[i + 1]) circle(d = thickness);
            }
        }
}

// Compression spring: a helix with a closed coil at each end
module Compression_Spring(icon_len, width, height, vertical_offset = 2.5) {
    spring_turns = 7;
    spring_radius_x = 1.30;
    spring_radius_y = 2.25;
    terminal_gap = 0.25;
    // clamped like the other icons, the text keeps showing the real length
    display_length = min(icon_len, 20 * Y_units);
    // the floor keeps the coils apart on a short spring instead of piling them up
    spring_pitch = max((display_length - 2 * (terminal_gap + 2 * spring_radius_x)) / spring_turns, 0.9);
    spring_start_x = -spring_turns * spring_pitch / 2;
    spring_end_x = spring_start_x + spring_turns * spring_pitch;
    left_terminal_x = spring_start_x - terminal_gap - spring_radius_x;
    right_terminal_x = spring_end_x + terminal_gap + spring_radius_x;
    connector_x_offset = spring_radius_x * 0.50;
    connector_y = -spring_radius_y * 0.87;
    stroke = 0.60;

    translate([0, vertical_offset, height]) {
        rounded_stroke(
            compression_spring_end_ellipse(
                center_x = left_terminal_x,
                radius_x = spring_radius_x,
                radius_y = spring_radius_y
            ),
            thickness = stroke,
            height = text_height
        );

        rounded_stroke(
            [[left_terminal_x + connector_x_offset, connector_y],
             [spring_start_x, -spring_radius_y]],
            thickness = stroke,
            height = text_height
        );

        rounded_stroke(
            compression_spring_path(
                turns = spring_turns,
                pitch = spring_pitch,
                radius_x = spring_radius_x,
                radius_y = spring_radius_y,
                samples_per_turn = 20
            ),
            thickness = stroke,
            height = text_height
        );

        rounded_stroke(
            [[spring_end_x, -spring_radius_y],
             [right_terminal_x - connector_x_offset, connector_y]],
            thickness = stroke,
            height = text_height
        );

        rounded_stroke(
            compression_spring_end_ellipse(
                center_x = right_terminal_x,
                radius_x = spring_radius_x,
                radius_y = spring_radius_y
            ),
            thickness = stroke,
            height = text_height
        );
    }
}

module Heat_Set_Inserts(icon_len, width, height, vertical_offset = 2.5) {
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

// Threaded rod (DIN 976): thread over the full length, drawn split when it is long or has no length
module Threaded_Rod(icon_len, width, height, vertical_offset = 2.5) {
    rod_length     = (icon_len > 0) ? icon_len : 1000;
    display_length = min(rod_length, 20 * Y_units);
    pitch          = 1.2;

    translate([-(display_length + 1.5)/2, vertical_offset, height]) {
        // top view: round end with the thread groove
        difference() {
            cylinder(h=text_height, d=5);
            difference() {
                cylinder(h=text_height, d=4.2);
                cylinder(h=text_height, d=3.4);
            }
        }
        // side view: rod with thread notches on both edges
        difference() {
            drawBoltStem(rod_length, text_height, [4, -1.5, 0], thickness=3);
            for (x = [4 + pitch/2 : pitch : 4 + display_length - pitch/2])
                for (y = [-1.5, 1])
                    translate([x - 0.25, y, 0])
                        cube([0.5, 0.5, text_height]);
        }
    }
}

module Wall_Anchor(icon_len, width, height, vertical_offset = 2.5) {
    translate([-4, vertical_offset, height]) {
        difference() {
            // 1) The main geometry, combined via union()
            union() {
                // The extruded polygons
                linear_extrude(height = text_height)
                    translate([-2,  0, 0])
                    polygon(points=[[0,2],[-2,1],[-2,-1],[0,-2]], paths=[[0,1,2,3]]);
                linear_extrude(height = text_height)
                    translate([-0.5, 0, 0])
                    polygon(points=[[0,2],[-1.5,1.5],[-1.5,-1.5],[0,-2]], paths=[[0,1,2,3]]);
                linear_extrude(height = text_height)
                    translate([1,    0, 0])
                    polygon(points=[[0,2],[-1.5,1.5],[-1.5,-1.5],[0,-2]], paths=[[0,1,2,3]]);
                linear_extrude(height = text_height)
                    translate([2.5,  0, 0])
                    polygon(points=[[0,2],[-1.5,1.5],[-1.5,-1.5],[0,-2]], paths=[[0,1,2,3]]);
                linear_extrude(height = text_height)
                    translate([4,    0, 0])
                    polygon(points=[[0,2],[-1.5,1.5],[-1.5,-1.5],[0,-2]], paths=[[0,1,2,3]]);

                // A couple more cubes for shape
                translate([4, -1.5, 0])
                    cube([7, 3, text_height]);
                translate([11, -2, 0])
                    cube([1, 4, text_height]);
            }

            // 2) The cutting object: this is subtracted (removed) from the union above
            translate([-4, -0.25, 0])
                cube([10, 0.5, 3]);
        }
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


// Bolts and screws, built from a head (side view), a drive (top view) and a tip
module Bolt(icon_len, width, height, head, drive, tip, vertical_offset = 2.5) {
    display_length = min(icon_len, 20 * Y_units);
    translate([-display_length/2 - 2, vertical_offset, height]) {
        bolt_top_view(head, drive);

        if (head == "Grub screw") {
            // side view: full diameter threaded body with the drive at one end
            difference() {
                drawBoltStem(icon_len, text_height, [4, -2, 0], thickness=4);
                translate([4, -0.8, 0])
                    cube([1.5, 1.6, text_height]);
            }
        } else {
            stem_x = bolt_stem_start(head);
            bolt_side_view(head);

            if (tip == "Wood") {
                // stem shortened by 1.5 for the tip, clamped like in drawBoltStem
                stem_length = max(icon_len - 1.5, 0);
                drawBoltStem(stem_length, text_height, [stem_x, -1.25, 0]);
                translate([stem_x + min(stem_length, 20 * Y_units), 0, 0])
                    linear_extrude(height=text_height)
                        polygon(points=[[0, 1.25], [2, 0], [0, -1.25]]);
            } else {
                drawBoltStem(icon_len, text_height, [stem_x, -1.25, 0]);
            }
        }
    }
}

// The row in "parts" for a part: its own row if it has one, else the "*" row
// of its category, else undef for a part that is not in the table
function part_row(category, type) =
    let (own = [for (p = parts) if (p[0] == category && p[1] == type) p],
         any = [for (p = parts) if (p[0] == category && p[1] == "*")  p])
    (len(own) > 0) ? own[0] : (len(any) > 0) ? any[0] : undef;

// Length an icon is drawn with: the real length, or the fixed size from the table
function icon_length(category, type, real_length) =
    let (row = part_row(category, type))
    (Icon_length == "Real length" || row == undef || row[2] == undef)
        ? real_length : row[2];

// Where the stem starts, right after the head's side view
function bolt_stem_start(head) =
    (head == "Socket head") ? 7 :
    (head == "Countersunk") ? 5 :
    6;

// Top view: round head with the drive recess, or a plain hexagon for hex heads
module bolt_top_view(head, drive) {
    if (head == "Hex head") {
        cylinder(h=text_height, d=5, $fn=6);
    } else {
        difference() {
            cylinder(h=text_height, d=5);
            drive_recess(drive);
        }
        // tamper resistant Torx: security pin in the middle of the star
        if (drive == "Torx TR")
            cylinder(h=text_height, d=1.2);
    }
}

module drive_recess(drive) {
    if (drive == "Phillips") {
        translate([-0.5, -2, 0])
            cube([1, 4, text_height]);
        translate([-2, -0.5, 0])
            cube([4, 1, text_height]);
    } else if (drive == "Torx" || drive == "Torx TR") {
        Torx_star(6, 2, height=2, rnd=0.1);
    } else if (drive == "Slotted") {
        translate([-0.5, -2, 0])
            cube([1, 4, text_height]);
    } else {
        cylinder(h=text_height, r=1.6, $fn=6);
    }
}

// Side view of the head
module bolt_side_view(head) {
    if (head == "Socket head") {
        translate([3, -2.5, 0])
            cube([4, 5, text_height]);
    } else if (head == "Hex head") {
        translate([3, -2.5, 0])
            cube([3, 5, text_height]);
    } else if (head == "Countersunk") {
        translate([5, 0, 0])
            cylinder(r=3, h=text_height, $fn=3);
    } else if (head == "Pan head") {
        translate([6, 0, 0]) {
            difference() {
                cylinder(h=text_height, d=5);
                translate([0, -2.5, 0])
                    cube([4, 5, text_height]);
            }
        }
    } else if (head == "Mushroom head") {
        // flatter and wider dome than the pan head
        translate([6, 0, 0]) {
            difference() {
                scale([0.55, 1.1, 1])
                    cylinder(h=text_height, d=5);
                translate([0, -3, 0])
                    cube([4, 6, text_height]);
            }
        }
    } else if (head == "Flat head") {
        // low cylindrical head as wide as the mushroom head, flat top
        translate([4.6, -2.75, 0])
            linear_extrude(height=text_height)
                hull() {
                    translate([0.3, 0.3]) circle(r=0.3);
                    translate([0.3, 5.2]) circle(r=0.3);
                    translate([1, 0])     square([0.4, 5.5]);
                }
    } else {
        echo(str("WARNING: unknown head: ", head));
    }
}

//////////////////////////////////////////////////////////////
//        FURNITURE HARDWARE (Top View + Side View)        //
//////////////////////////////////////////////////////////////

// 45 degree corner cuts for one end of a plain bar.
// dir = 1 chamfers the left end, dir = -1 the right end.
module bar_end_chamfer(x, half_height, size, dir = 1) {
    linear_extrude(height = text_height) {
        polygon(points = [[x,  half_height], [x + dir*size,  half_height], [x,  half_height - size]]);
        polygon(points = [[x, -half_height], [x + dir*size, -half_height], [x, -half_height + size]]);
    }
}

// Wooden dowel: round face plus a fluted body with chamfered ends
module Wooden_Dowel(icon_len, width, height, vertical_offset = 2.5) {
    display_length = min(icon_len, 20 * Y_units);

    // Same clamping as drawBoltStem, so the chamfers and flutes stay on the body
    maxLen    = 20 * Y_units;
    finalLen  = (icon_len > maxLen) ? maxLen : icon_len;
    bodyStart = [4, -2, 0];
    bodyEnd   = bodyStart[0] + finalLen;
    fluteLen  = (finalLen > 3) ? finalLen - 2 : 0;

    translate([-display_length/2 - 2, vertical_offset, height]) {
        // top view (round face with its chamfered edge)
        difference() {
            cylinder(h=text_height, d=5);
            difference() {
                cylinder(h=text_height, d=4.4);
                cylinder(h=text_height, d=3.6);
            }
        }

        // side view
        difference() {
            drawBoltStem(icon_len, text_height, bodyStart, thickness=4);

            // chamfered ends
            bar_end_chamfer(bodyStart[0], 2, 0.7,  1);
            bar_end_chamfer(bodyEnd,      2, 0.7, -1);

            // glue flutes running along the dowel
            if (fluteLen > 0) {
                translate([bodyStart[0] + 1,  0.6, 0])
                    cube([fluteLen, 0.4, text_height]);
                translate([bodyStart[0] + 1, -1.0, 0])
                    cube([fluteLen, 0.4, text_height]);
            }
        }
    }
}

// Expansion sleeve: hollow sleeve with a collar and a split expansion end
module Expansion_Sleeve(icon_len, width, height, vertical_offset = 2.5) {
    display_length = min(icon_len, 20 * Y_units);

    maxLen    = 20 * Y_units;
    finalLen  = (icon_len > maxLen) ? maxLen : icon_len;
    bodyStart = [4, -2, 0];
    bodyEnd   = bodyStart[0] + finalLen;
    slotStart = bodyStart[0] + finalLen * 0.4;

    translate([-display_length/2 - 2, vertical_offset, height]) {
        // top view (open end of the sleeve)
        difference() {
            cylinder(h=text_height, d=5);
            cylinder(h=text_height, d=2.6);
        }

        difference() {
            union() {
                // collar
                translate([3, -2.5, 0])
                    cube([1.2, 5, text_height]);
                // sleeve body
                drawBoltStem(icon_len, text_height, bodyStart, thickness=4);
            }

            // slot the sleeve expands along
            translate([slotStart, -0.5, 0])
                cube([bodyEnd - slotStart, 1, text_height]);

            // chamfered free end
            bar_end_chamfer(bodyEnd, 2, 0.7, -1);
        }
    }
}

// Cam lock nut (cam / eccentric): drive face plus a side view showing the
// keyhole the connecting bolt hooks into. The housing is drawn at a fixed
// size, the length only shows up in the text.
module cam_lock_Nut(icon_len, width, height, vertical_offset = 2.5) {
    translate([-3, vertical_offset, height]) {
        // top view
        difference() {
            cylinder(h=text_height, d=5);
            // phillips drive recess
            translate([-0.5, -2, 0])
                cube([1, 4, text_height]);
            translate([-2, -0.5, 0])
                cube([4, 1, text_height]);
        }
        // side view
        translate([4, -2.5, 0]) {
            difference() {
                cube([4, 5, text_height]);
                // seat for the bolt head plus the slot it slides in through
                translate([2, 2.5, 0])
                    cylinder(h=text_height, d=2.4);
                translate([1.4, 0, 0])
                    cube([1.2, 2.5, text_height]);
            }
        }
    }
}

// Cam lock bolt (connecting bolt): mushroom head, neck and collar plus the
// shank that screws into the panel
module Cam_Lock_Bolt(icon_len, width, height, vertical_offset = 2.5) {
    display_length = min(icon_len, 20 * Y_units);

    translate([-display_length/2 - 2, vertical_offset, height]) {
        // top view (phillips drive recess in the head)
        difference() {
            cylinder(h=text_height, d=5);
            translate([-0.5, -2, 0])
                cube([1, 4, text_height]);
            translate([-2, -0.5, 0])
                cube([4, 1, text_height]);
        }

        // side view: mushroom head that hooks into the cam
        translate([5.5, 0, 0]) {
            difference() {
                cylinder(h=text_height, d=5);
                translate([0, -2.5, 0])
                    cube([4, 5, text_height]);
            }
        }
        // neck
        translate([5.5, -0.9, 0])
            cube([1.2, 1.8, text_height]);
        // collar
        translate([6.7, -2.2, 0])
            cube([1, 4.4, text_height]);

        // shank
        drawBoltStem(icon_len, text_height, [7.7, -1.25, 0]);
    }
}


//////////////////////////////////////////////////////////////
//                       TEXT MODULES                      //
//////////////////////////////////////////////////////////////
module centered_text(content, height) {
    translate([0, 0, height])
        linear_extrude(height=text_height)
            text(content,
                 size   = text_size,
                 font   = Font,
                 valign = "center",
                 halign = "center");
}

// The size under the icon, "M5x16"
module size_text(diameter, Length, height) {
    translate([0, -3, height])
        linear_extrude(height=text_height)
            text(str(diameter, "x", Length),
                 size   = text_size,
                 font   = Font,
                 valign = "center",
                 halign = "center");
}

// Just the diameter, "M5"
module diameter_text(diameter, height) {
    translate([0, -3, height])
        linear_extrude(height=text_height)
            text(diameter,
                 size   = text_size,
                 font   = Font,
                 valign = "center",
                 halign = "center");
}

// Custom text on one or two lines.
// A single line is centered and full size, two lines use the same rows as the
// icon/text layout of the hardware labels.
module custom_text_lines(line1, line2, height) {
    if (!is_blank(line1) && !is_blank(line2)) {
        custom_text_line(line1, 2.5, height);
        custom_text_line(line2, -3, height);
    } else if (is_blank(line1)) {
        custom_text_line(line2, 0, height);
    } else {
        custom_text_line(line1, 0, height);
    }
}

module custom_text_line(line, vertical_offset, height) {
    translate([0, vertical_offset, height])
        linear_extrude(height=text_height)
            text(line,
                 size   = text_size,
                 font   = Font,
                 valign = "center",
                 halign = "center");
}

// true for an empty string or a string containing only spaces
function is_blank(s, i = 0) =
    (i >= len(s)) ? true :
    (s[i] != " ") ? false :
    is_blank(s, i + 1);


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
