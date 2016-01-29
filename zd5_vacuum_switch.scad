// Vacuum switch for the ZD5 Depowdering station
//
// Copyright (C) 2016, Jason S. McMullan <jason.mcmullan@gmail.com>
// All rights reserved.
//
// Licensed under the MIT License:
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
// All input units are in inches, output STL is in mm.

// Inches to mm
in = 25.4*1;

// Vacuum hose ID
hose_id = 1.25 * in;

// Vacuum hose OD
hose_od = 1.5 * in;

// Port diameter
port_id = (hose_od - hose_id)/2 + hose_id;
port_height = 1 * in;

// Case wall thickness
case_wall = 1/8 * in;

// Switch plate width
plate_width = 3/16 * in;

// Switch pin diameter
pin_diameter = 1/4 * in;

// Part tolerance
tolerance = 1/64 * in;

fn = 120;

/////// Calculated values 

case_diameter = case_wall + hose_od + case_wall*3 + pin_diameter + case_wall*3 + hose_od + case_wall;

plate_diameter = case_diameter - case_wall * 2 - tolerance * 2;

case_height = case_wall + port_id / 2 + plate_width + tolerance + case_wall;

module zd5_vacuum_switch_lid_fab(carve = false)
{
    if (!carve) {
        cylinder(d = case_diameter, h = case_wall*2, $fn = fn);
    } else {
        translate([0, 0, -0.1]) {
            cylinder(d = case_diameter - case_wall, h = case_wall + 0.1);
            // Vent hole A
            rotate([0, 0, 45]) translate([case_diameter / 4, 0, 0]) cylinder(d = port_id, h = case_wall*2 + 0.2, $fn = fn);
            // Vent hole A
            rotate([0, 0, 90+45]) translate([case_diameter / 4, 0, 0]) cylinder(d = port_id, h = case_wall*2 + 0.2, $fn = fn);

            // Carve out wedge
            translate([-case_diameter/2 - 0.1, (pin_diameter + case_wall)/2, 0]) {
                cube([case_diameter, case_diameter, case_wall + 0.1]);
            }   
        }
    }
}

module zd5_vacuum_switch_lid()
{
    difference() {
        zd5_vacuum_switch_lid_fab(carve = false);
        zd5_vacuum_switch_lid_fab(carve = true);
    }
}

module zd5_vacuum_switch_plate_fab(carve = false)
{
    if (!carve) {
        cylinder(d = plate_diameter, h = plate_width, $fn = fn);
        translate([(pin_diameter + case_wall)/2, (pin_diameter + case_wall)/2, 0])
            cube([case_diameter, case_diameter, plate_width + 0.1]);
    } else {
        translate([0, 0, -0.1]) {
            cylinder(d = pin_diameter + tolerance*2, h = plate_width + 0.2,$fn = fn);
            // Vent hole
            rotate([0, 0, 45]) translate([case_diameter / 4, 0, 0]) cylinder(d = port_id, h = plate_width + 0.3, $fn = fn);

            difference() {
                cylinder(d = case_diameter *3, h = plate_width + 0.3, $fn = fn);
                translate([0, 0, -0.1]) cylinder(d = case_diameter + case_wall * 8, h = plate_width + 0.4, $fn = fn);
            }
        }
    }
}

module zd5_vacuum_switch_plate()
{
    difference() {
        zd5_vacuum_switch_plate_fab(carve = false);
        zd5_vacuum_switch_plate_fab(carve = true);
    }
}

module zd5_vacuum_switch_case_fab(carve = false)
{
    if (!carve) {
        // Bulk
        cylinder(d = case_diameter, h = case_height - case_wall, $fn = fn);
        // Pin
        cylinder(d = pin_diameter, h = case_height + case_wall, $fn = fn);
    } else {
        // Vent hole
        rotate([0, 0, 45]) translate([case_diameter / 4, 0, -0.1]) cylinder(d = port_id, h = case_wall*2 + 0.2, $fn = fn);

        // Carve out pin
        translate([0, 0, case_wall]) difference() {
            cylinder(d = case_diameter - case_wall * 2, h = case_height - case_wall + 0.1, $fn = fn);
            cylinder(d = pin_diameter + case_wall, h = case_height - case_wall*2 - tolerance - plate_width, $fn = fn);
            // Insert into lid
            cylinder(d = pin_diameter, h = case_height + case_wall + 0.2, $fn = fn);
        }
        // Carve out lip
        translate([0, 0, case_height - 2*case_wall]) difference() {
            cylinder(d = case_diameter+0.1, h = case_wall + 0.1, $fn = fn);
            cylinder(d = case_diameter - case_wall, h = case_wall + 0.1, $fn = fn);
        }
        // Carve out wedge
        translate([-case_diameter/2 - 0.1, sqrt(pin_diameter + case_wall*2), case_height - case_wall - plate_width - tolerance*2]) {
            cube([case_diameter, case_diameter, plate_width + tolerance*2 + 0.1]);
        }
            
    }
}

module zd5_vacuum_switch_case()
{
    difference() {
        zd5_vacuum_switch_case_fab(carve = false);
        zd5_vacuum_switch_case_fab(carve = true);
    }
}

module zd5_vacuum_switch()
{
    translate([0, 0, case_height - case_wall*2])
        zd5_vacuum_switch_lid();
    translate([0, 0, case_height - plate_width - tolerance - case_wall])
        zd5_vacuum_switch_plate();
    zd5_vacuum_switch_case();
}

module zd5_vacuum_switch_port()
{
    difference() {
        cylinder(d1 = hose_od, d2 = hose_od - tolerance*2, h = port_height, $fn = fn);
        translate([0, 0, -0.1]) {
            cylinder(d1 = hose_id, d2 = hose_id + tolerance*2, h = port_height + 0.2, $fn = fn);
            difference() {
                cylinder(d = hose_od + 0.1, h = case_wall + 0.1, $fn = fn);
                translate([0, 0, -0.1]) cylinder(d = port_id - tolerance, h = case_wall + 0.3, $fn = fn);
            }
        }
    }
}

module zd5_vacuum_switch_adapter()
{
    difference() {
        cylinder(d1 = hose_od, d2 = hose_od + case_wall, h = port_height, $fn = fn);
        translate([0, 0, -0.1]) {
            cylinder(d1 = hose_id, d2 = hose_od + tolerance*2, h = port_height + 0.2, $fn = fn);
            difference() {
                cylinder(d = hose_od * 2, h = case_wall + 0.1, $fn = fn);
                translate([0, 0, -0.1]) cylinder(d = port_id - tolerance, h = case_wall + 0.3, $fn = fn);
            }
        }
    }
}

module zd5_vacuum_switch_assembly()
{
    zd5_vacuum_switch();

    translate([0, case_diameter, 0]) zd5_vacuum_switch_port();
    translate([case_diameter, 0, 0]) zd5_vacuum_switch_port();
    translate([-case_diameter, 0, 0]) zd5_vacuum_switch_adapter();
}

module zd5_vacuum_switch_plated()
{
    translate([0, 0, case_wall]*2) rotate([0, 180, 0]) zd5_vacuum_switch_lid();
    translate([case_diameter + case_wall, 0, 0]) zd5_vacuum_switch_plate();
    translate([-case_diameter - case_wall, 0, 0]) zd5_vacuum_switch_case();
    translate([0, 0, port_height]) rotate([0, 180, 0]) {
        translate([-case_diameter/2, case_diameter/2 + case_wall + hose_od/2, 0]) zd5_vacuum_switch_port();
        translate([case_diameter/2, case_diameter/2 + case_wall + hose_od/2, 0]) zd5_vacuum_switch_port();
        translate([0, case_diameter/2 + case_wall + hose_od/2, 0]) zd5_vacuum_switch_adapter();
    }
}


zd5_vacuum_switch_plated();


// vim: set shiftwidth=4 expandtab: //
