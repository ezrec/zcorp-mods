// ZCorp 310+ binder tube clip
//
// Copyright (C) 2015, Jason S. McMullan <jason.mcmullan@gmail.com>
// All right reserved.
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

width = 41.3 + 2;
length= 15;
height = 26;
wall=0.4*3;
cut_percent = 0.7;

diameter = 4.7;

module clip_leg()
{
   translate([width/2, length/2, -0.1]) rotate([180, 2, 0]) {
       cube([wall, length, height]);
       for (h = [1.2:2:height]) {
            translate([0, 0, h]) {
                rotate([-90, 60, 0]) cylinder(r = 1, h = length, $fn=3);
            }
        }
        translate([0, length, height/2])
            children();
    }
}

translate([-width/2-wall, -length/2, -wall])
    cube([width+wall*2, length, wall]);
clip_leg();
mirror([1, 0, 0])
    clip_leg() union() {
        translate([wall+diameter/2, 0, 0]) {
              rotate([90, 0, 0]) scale([1, 1, height*0.25]) difference() {
                cylinder(d=diameter+wall*2, h=1, $fn=60);
                translate([0, 0, -0.1]) cylinder(d=diameter, h=1+0.2, $fn=60);
                translate([0, -diameter/2 * cut_percent, -0.1]) cube([diameter, diameter*cut_percent, 1+0.2]);
            }
        }
}
