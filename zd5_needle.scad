// ZD5 airgun needle
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
// All units in mm

// Cylinder faces
fn = 60;

barb_od = 5;
barb_id = 2.75;

nozzle = 0.4;

module zd5_hose_barb(height = 10)
{
    barb_notch_diameter = 4;
    barb_notch_width = 2.5;
    barb_notch_offset = 3;
    barb_notch_ramp = (barb_notch_width - 1) / 2;
    
    difference() {
        cylinder(d = barb_od, h = height, $fn = fn);
        translate([0, 0, -0.1])
            cylinder(d = barb_id, h = 0.1 + height + 0.1, $fn = fn);
        translate([0, 0, barb_notch_offset])
            difference() {
                cylinder(d = barb_od + 0.2, h = barb_notch_width, $fn = fn);
                
                union() {
                    cylinder(d1 = barb_od, d2 = barb_notch_diameter, h = barb_notch_ramp, $fn = fn);
                    translate([0, 0, barb_notch_width - barb_notch_ramp])
                        cylinder(d1 = barb_notch_diameter, d2 = barb_od, h = barb_notch_ramp, $fn = fn);
                    translate([0, 0, -0.2]) cylinder(d = barb_notch_diameter, h = barb_notch_width + 0.4, $fn = fn);
                }
            }
    }
    translate([0, 0, height * 0.99]) children();
}

module zd5_needle()
{
    zd5_hose_barb() {
        difference() {
            cylinder(d1 = barb_od, d2 = barb_id/2 + nozzle*2, h = 20, $fn = fn);
            translate([0, 0, -0.1]) cylinder(d1 = barb_id, d2 = barb_id/2, h = 20 + 0.2, $fn = fn);
        }
    }
}

zd5_needle();           
    
// vim: set shiftwidth=4 expandtab: //
