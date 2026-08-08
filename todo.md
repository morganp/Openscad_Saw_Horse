# Openscad Saw Horse - todo

Model: `saw_horse_bracket.scad` (v0.2.0, BOSL2). Renders in `renders/`.
v0.2.0: timber-to-timber load path, open leg channels, single-bolt hinge,
cord holds the splay (no printed stop). Solid volume per bracket 307 cm3
vs 816 cm3 in v0.1 (62 percent less).

## Print and fit testing
- [ ] Test print one fixed body + one swing leaf in Tough PLA, lying on the
      side face as in the `print` show_mode (layers parallel to the fold
      plane). 4-5 perimeters, 25-40 percent infill.
- [ ] Check timber fit in the open channels and rail slot with real sawn
      stock; tune `timber_clr` (0.5 per face). Measure the batch first and
      set `timber_w` / `timber_t` to actuals.
- [ ] Check M8 x 50 bolt through the clevis (`bolt_hole_clr` 0.4); leaf must
      swing freely with the nyloc snugged.
- [ ] Assemble one A-frame: legs screwed in channels, rail dropped in,
      confirm both rail bottom corners land on the leg end grain and the
      plastic blade below stays 1.5 mm clear (`rail_relief`).
- [ ] Fit the cord tie and load test gradually: legs are in compression,
      cord in tension. THE CORD IS REQUIRED, without it the legs over-splay.
- [ ] Fold test: legs must swing to parallel, tips clearing the rail.

## Design follow-ups
- [ ] Decide cord anchoring: 8 mm hole drilled through each leg at the tie
      height (simple, but a drilling op), or tied clove hitches around the
      legs, or a screwed-on batten (blocks folding unless removed).
- [ ] Bearing check after load test: the rail's bottom corners bite into
      the leg end grain; some bedding-in is expected and fine. If crushing
      is excessive, increase `bear_inset` to move the contact further onto
      the face.
- [ ] Legs bend about their weak axis in the fold plane (conventional
      commercial-bracket orientation); watch the legs in the load test.
- [ ] Notch spans: outer faces of the two heads 480 apart (`
      notch_outside_span`), head is 98 wide, inner faces 284 apart.
- [ ] Export STLs and tag v0.2.0 once the test print passes (semver).

## Hardware list (per horse = 2 brackets)
- [ ] 2x M8 x 50 hex bolt + nyloc nut, 4x 25 mm OD penny washers
- [ ] 20x 4.5 x 40 countersunk wood screws (16 legs + 4 rail)
- [ ] ~2 m of 4-6 mm cord (one tie per A-frame, ~1 m each with knots)
- [ ] Timber: 2x 2.4 m of 86 x 37 covers 4 legs (788) + rail (480) with
      3 mm kerf allowance (3 legs from one length, leg + rail from the other)

## Cut list (working height 850, splay 15 deg)
| Part | Qty | L x W x T (mm) | Cut |
|------|-----|----------------|-----|
| Rail | 1 | 480 x 86 x 37 | square both ends, flush with notch heads |
| Leg  | 4 | 788 x 86 x 37 | square both ends |
| Cord | 2 | ~341 span + knots | tie between leg pair at 150 above floor |

Leg length = (top-face-centre drop 765.7 - heel corner rise 18.5*sin 15) /
cos 15 = 787.7, cut 788 and trim to sit. Cord span between leg inner faces
at height h above the floor:
  span(h) = 2 * (24.8 + (765.7 - h) * tan 15 - 19.15)
= 341 mm at the default h = 150 (`cord_tie_h`, echoed by the model).
Footprint in the fold plane 498. Height fine-tuning: trim legs,
1 mm leg = ~0.97 mm height.
