// Folding saw horse hinge bracket, v0.2.0
//
// A pair of these brackets turns straight cut 86x37 timber into a folding
// A-frame trestle saw horse. Each bracket is two printed parts joined by a
// single M8 bolt hinge:
//   fixed body  : rail notch head, open three-sided channel for one leg at
//                 -splay, and a two-lug clevis for the hinge bolt
//   swing leaf  : central hinge lug, arm to an inner bar on the leg, and a
//                 mirrored open channel for the second leg at +splay
//
// v0.2.0 design rules:
//   TIMBER-TO-TIMBER LOAD PATH. Each leg's square-cut top face bears
//   directly against the rail's bottom edges: the leg top is inset
//   bear_inset under the rail, so the rail's bottom corner lands on the
//   flat end grain and the leg tip rises beside the rail's side face.
//   Vertical load runs rail -> leg end grain -> floor. The printed parts
//   only locate the parts, hold the splay angle, carry the fold hinge and
//   take screws. All plastic under the rail is relieved 1.5 mm so the rail
//   can never sit on plastic.
//   OPEN CHANNELS. Each leg sits in a three-sided channel: two side walls
//   (screwed to the leg's wide faces) and an outer wall. The inner face,
//   toward the centre of the horse, is open to save filament.
//   NO PRINTED STOP. The open position is held by a cord, rope or webbing
//   tie between the two legs of each A-frame near the floor (the horse is
//   a truss: legs in compression, cord in tension). The cord is REQUIRED
//   in use; without it the legs can over-splay. Cord length is echoed and
//   in the cut list. A screwed-on timber batten is an alternative if the
//   horse can stay assembled.
//   Every timber part is a plain square cross-cut, no miters, no notches.
//   Legs sit in the conventional orientation: wide 86 face along the horse,
//   37 edge in the fold plane. Notch outer span 480, rail on edge, ends
//   flush with the notch heads.
//
// Library: BOSL2 (anchored primitives, diff/tag booleans).
//
// Print notes (Tough PLA):
//   Print each part lying on a side face (the "print" show_mode lays them
//   down). Layer planes are then parallel to the fold plane: channel walls,
//   plates and lugs are loaded in-plane, and the hinge bore prints as a
//   vertical hole. Mostly plate geometry, little to no support needed.
//   4-5 perimeters, 25-40 percent infill.
//
// Hardware per bracket:
//   1x M8 x 50 bolt + nyloc nut + 2 penny washers (25 mm OD). The steel
//     bolt is the pivot bearing; the hinge carries only fold and carry
//     loads, not the working load.
//   8x 4.5 x 40 countersunk wood screws (4 per leg through the side walls).
//   2x 4.5 x 40 countersunk wood screws for the rail (through the cheeks).
// Per horse additionally: ~2 m of 4-6 mm cord (one tie per A-frame).
//
// show_mode: "open" (default, one bracket + ghost timber), "fixed", "swing",
//            "folded", "horse" (full trestle), "print" (parts laid flat)

include <BOSL2/std.scad>
$fn = 64;

show_mode = "open";

// ---------- timber and overall geometry (mm, deg) ----------
working_height     = 850;  // floor to top of rail
notch_outside_span = 480;  // outer faces of the two notch heads, rail length
rail_length        = notch_outside_span; // rail ends flush with head faces
timber_w           = 86;   // timber wide face
timber_t           = 37;   // timber thin face
timber_clr         = 0.5;  // channel clearance per face, sawn stock varies
splay              = 15;   // leg angle from vertical, each side, fold plane

// ---------- printed part parameters ----------
wall_side      = 5.5;   // channel side walls, take the leg screws
wall_outer     = 5;     // channel outer wall
cheek_wall     = 6;     // rail notch cheek walls
bolt_d         = 8;     // hinge pivot bolt, M8
bolt_hole_clr  = 0.4;   // radial clearance per side of bolt hole
screw_d        = 4.5;   // wood screw shank clearance
screw_cs_d     = 10.5;  // countersink mouth diameter
lug_r          = 12;    // hinge lug radius
lug_t_fixed    = 10;    // each fixed clevis lug thickness
lug_t_swing    = 16;    // central swing lug thickness
lug_gap        = 0.5;   // side clearance per lug face
hinge_drop     = 40;    // rail underside height above the pivot axis
bear_inset     = 12;    // rail bottom corner inset from leg's inner top edge
rail_relief    = 1.5;   // plastic relieved below rail so timber bears first
ch_len         = 105;   // leg channel length along the leg
ch_top_gap     = 15;    // channel starts this far below the leg top face
cord_tie_h     = 150;   // cord tie height above the floor

// ---------- derived ----------
cav_x       = timber_t + 2*timber_clr;   // 38, channel width in fold plane
cav_y       = timber_w + 2*timber_clr;   // 87, channel width along the bolt
head_w      = cav_y + 2*wall_side;       // 98, notch head width along horse
slot_w      = timber_t + 2*timber_clr;   // 38, rail slot width, rail on edge
a_bear      = timber_t/2 - bear_inset;   // bearing point offset from leg axis
leg_top_x   = timber_t/2 + a_bear*cos(splay);  // leg top face centre, from pivot
leg_top_z   = hinge_drop + a_bear*sin(splay);
leg_tip_z   = hinge_drop + (a_bear + timber_t/2)*sin(splay); // tip beside rail
cheek_z0    = leg_tip_z + 1;             // cheeks start above the leg tips
cheek_z1    = hinge_drop + 30;           // rail captured 30 above its base
floor_web_z = hinge_drop - rail_relief;  // top of all plastic under the rail
rail_top_z  = hinge_drop + timber_w;
floor_z     = rail_top_z - working_height;
bracket_y   = notch_outside_span/2 - head_w/2;  // bracket station centres
lug_pitch   = lug_t_swing/2 + lug_gap + lug_t_fixed/2; // fixed lug centres
// Legs are square cut; the heel corner touches the floor, the top face
// centre sits at leg_top_z. The 37 edge is in the tilt plane.
leg_len_exact = (leg_top_z - floor_z - (timber_t/2)*sin(splay))/cos(splay);
leg_len       = round(leg_len_exact);
foot_span     = 2*(leg_top_x + (leg_top_z - floor_z)*tan(splay)
                   + (timber_t/2)/cos(splay));
// Cord between the legs' inner faces at the tie height (per A-frame).
z_tie      = floor_z + cord_tie_h;
cord_len   = 2*(leg_top_x + (leg_top_z - z_tie)*tan(splay)
                - (timber_t/2)/cos(splay));

echo(str("CUT LIST per horse: 1 rail ", rail_length, " x ", timber_w, " x ",
         timber_t, ", 4 legs ", leg_len, " x ", timber_w, " x ", timber_t,
         ", all square cuts"));
echo(str("leg length exact = ", leg_len_exact, " mm"));
echo(str("footprint in fold plane = ", foot_span, " mm"));
echo(str("cord tie, inner face to inner face at ", cord_tie_h,
         " above floor = ", cord_len, " mm per A-frame"));

// ---------- helpers ----------

// Through hole along X with countersinks both ends. One screw per hole,
// drive from either side.
module cs_xhole(l) {
    xcyl(d=screw_d, l=l+2);
    translate([ l/2 - 1.4, 0, 0]) xcyl(d1=screw_d, d2=screw_cs_d, l=3.2);
    translate([-l/2 + 1.4, 0, 0]) xcyl(d1=screw_cs_d, d2=screw_d, l=3.2);
}

// Same along Y, for the leg screws through the channel side walls.
module cs_yhole(l) {
    ycyl(d=screw_d, l=l+2);
    translate([0,  l/2 - 1.4, 0]) ycyl(d1=screw_d, d2=screw_cs_d, l=3.2);
    translate([0, -l/2 + 1.4, 0]) ycyl(d1=screw_cs_d, d2=screw_d, l=3.2);
}

// Open three-sided leg channel, local frame: leg axis -Z, leg top face
// centre at origin. Outer wall on local -X, inner face (+X) open except for
// one low strap that boxes the channel and joins the walls into one printed
// body. The channel starts ch_top_gap below the top face so nothing printed
// reaches the rail contact zone.
module leg_channel() {
    for (sy = [-1, 1])
        translate([0, sy*(cav_y + wall_side)/2, -ch_top_gap])
            cuboid([cav_x + 2*wall_outer, wall_side, ch_len], anchor=TOP);
    translate([-(cav_x + wall_outer)/2, 0, -ch_top_gap])
        cuboid([wall_outer, cav_y + 2*wall_side, ch_len], anchor=TOP);
    // inner strap, low on the channel to stay clear of the hinge lugs
    translate([(cav_x + wall_outer)/2, 0, -ch_top_gap - 30])
        cuboid([wall_outer, cav_y + 2*wall_side, 35], anchor=TOP);
}

module leg_channel_screws() {
    for (i = [0:3])
        translate([(i%2 == 0 ? -9 : 9), 0, -35 - i*23])
            cs_yhole(cav_y + 2*wall_side);
}

// ---------- fixed body ----------
module fixed_body() {
    diff() {
        union() {
            // notch cheeks, above the leg tips, guide the rail in X
            for (sx = [-1, 1])
                translate([sx*(slot_w/2 + cheek_wall/2), 0,
                           (cheek_z0 + cheek_z1)/2])
                    cuboid([cheek_wall, head_w, cheek_z1 - cheek_z0]);
            // end plates at both Y faces, tie cheeks to the lower structure
            for (sy = [-1, 1])
                translate([0, sy*(cav_y + wall_side)/2, (30 + cheek_z1)/2])
                    cuboid([slot_w + 2*cheek_wall, wall_side, cheek_z1 - 30]);
            // central blade under the rail (relieved), ties everything in Y
            translate([0, 0, (30 + floor_web_z)/2])
                cuboid([10, head_w, floor_web_z - 30]);
            // clevis lugs
            for (sy = [-1, 1])
                translate([0, sy*lug_pitch, 0]) hull() {
                    ycyl(r=lug_r, l=lug_t_fixed);
                    translate([0, 0, 31]) cuboid([2*lug_r, lug_t_fixed, 6]);
                }
            // risers join the channel side walls to the head, outboard of
            // the rail
            for (sy = [-1, 1])
                translate([-33.5, sy*(cav_y + wall_side)/2, 45])
                    cuboid([23, wall_side, 50]);
            // fixed leg channel
            translate([-leg_top_x, 0, leg_top_z]) rot([0, splay, 0])
                leg_channel();
        }
        tag("remove") {
            // rail slot down to the relief plane, cuts cheeks + end plates
            translate([0, 0, floor_web_z])
                cuboid([slot_w, head_w + 2, cheek_z1 - floor_web_z + 15],
                       anchor=BOTTOM);
            // rail screws through the cheeks, staggered
            translate([0, -28, cheek_z0 + 8]) cs_xhole(slot_w + 2*cheek_wall);
            translate([0,  28, cheek_z0 + 16]) cs_xhole(slot_w + 2*cheek_wall);
            // hinge bolt bore
            ycyl(d=bolt_d + bolt_hole_clr*2, l=2*(lug_pitch + lug_t_fixed));
            // leg screws
            translate([-leg_top_x, 0, leg_top_z]) rot([0, splay, 0])
                leg_channel_screws();
        }
    }
}

// ---------- swing leaf (modeled in the open position) ----------
module swing_leaf() {
    diff() {
        union() {
            // central hinge lug
            ycyl(r=lug_r, l=lug_t_swing);
            // inner bar on the leg face plus arm back to the lug
            hull() {
                ycyl(r=lug_r, l=lug_t_swing);
                swing_bar();
            }
            swing_bar();
            // mirrored open channel, outer wall outboard
            translate([leg_top_x, 0, leg_top_z]) rot([0, -splay, 0])
                mirror([1, 0, 0]) leg_channel();
        }
        tag("remove") {
            ycyl(d=bolt_d + bolt_hole_clr*2, l=lug_t_swing + 4);
            translate([leg_top_x, 0, leg_top_z]) rot([0, -splay, 0])
                mirror([1, 0, 0]) leg_channel_screws();
        }
    }
}

module swing_bar() {
    translate([leg_top_x, 0, leg_top_z]) rot([0, -splay, 0])
        translate([-(cav_x/2 + 3), 0, -42.5])
            cuboid([6, lug_t_swing, 35]);
}

// ---------- ghost timber ----------
module ghost_leg() {
    %cuboid([timber_t, timber_w, leg_len], anchor=TOP);
}

module ghost_rail(len) {
    %translate([0, 0, hinge_drop])
        cuboid([timber_t, len, timber_w], anchor=BOTTOM);
}

module ghost_cord() {
    %translate([0, 0, z_tie]) xcyl(d=5, l=cord_len + 2*timber_t);
}

// fold = 0 open, 2*splay folded (legs parallel)
module bracket_assembly(fold=0, timber=true, rail_len=240) {
    fixed_body();
    rot([0, fold, 0]) swing_leaf();
    if (timber) {
        if (rail_len > 0) ghost_rail(rail_len);
        translate([-leg_top_x, 0, leg_top_z]) rot([0, splay, 0]) ghost_leg();
        rot([0, fold, 0])
            translate([leg_top_x, 0, leg_top_z]) rot([0, -splay, 0])
                ghost_leg();
        if (fold == 0) ghost_cord();
    }
}

module horse() {
    for (s = [-1, 1]) translate([0, s*bracket_y, 0])
        bracket_assembly(fold=0, timber=true, rail_len=0);
    ghost_rail(rail_length);
    // floor reference
    %translate([0, 0, floor_z - 2])
        cuboid([800, rail_length + 300, 2], anchor=BOTTOM);
}

// ---------- top level ----------
if (show_mode == "fixed") fixed_body();
else if (show_mode == "swing") swing_leaf();
else if (show_mode == "open") bracket_assembly(fold=0);
else if (show_mode == "folded") bracket_assembly(fold=2*splay);
else if (show_mode == "horse") horse();
else if (show_mode == "print") {
    // both parts lying on a side face, layer planes parallel to fold plane
    translate([-70, 0, head_w/2]) rot([90, 0, 0]) fixed_body();
    translate([70, 0, head_w/2]) rot([90, 0, 180]) swing_leaf();
}
