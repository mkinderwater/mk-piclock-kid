// mk-piclock-kids case V3.46 FDM-safe bump and crescent touch features
// Base geometry retained from mk-piclock-case-v2.51.scad
// Lid geometry retained from mk-piclock-case-v2.52F-marked.scad
//
// Released: 2026-07-26
//
// Production overview:
// 1. Fixed component coordinates replace historical movement-offset chains.
// 2. Shared self-tapping pilot and control-screw dimensions are centralized.
// 3. Touch sensor retains three blind pilots and two hidden tool-access holes.
// 4. The touch exterior returns to one round bump and a short right-side
//    crescent shaped like a right parenthesis.
// 5. Both touch features are designed for printing with the speaker face on the
//    build plate: the bump uses a full 45-degree frustum and the crescent has a
//    45-degree rising lower termination.
// 6. The touch PCB, sensing recess, screw locations, and tool-access holes remain
//    unchanged.
// 7. The v3.17 transparent charm cap is integrated as the charm insert.
// 8. Its hollow 6.4mm cap projects outward for LED diffusion while the 18mm
//    exterior flange overlaps the straight 14mm wall opening by 2mm per side.
// 9. Four crush ribs and a slotted, tapered two-petal snap collar lock behind
//    the 3mm wall.
// 10. The matching insert prints face-down without supports.
// 11. Only the touch recess uses concealed roof relief.
// 12. Rubber-foot recesses remain 21mm with equal front-to-back spacing.
// 13. The same restrained cleanup is applied to the remaining case geometry:
//     rounded support fins, softer lid-mount edges, rounded speaker arms, and
//     cleaner LED and USB-C support transitions.
// 14. All component coordinates, wall thicknesses, openings, pilot locations,
//     and functional clearances remain unchanged.
// 15. The bump and crescent retain safe screw-tip clearance while using
//     layer-aligned, support-free FDM transitions.
// 16. No include or use statements are required.
// 17. Separate 4mm-tall NinjaFlex feet are included as printable parts.
// 18. Each foot is retained by an off-centre M2.5 self-tapping screw.
// 19. The screw engages only a short pilot in the existing case wall; no
//     internal guide, web, tube, or receiver geometry is added.
// 20. Decorative music notes are removed from the touch-sensor exterior.
// 21. All four feet use one identical off-centre screw-hole position, so
//     only one foot design is required for printing and replacement.
// 22. Left feet are rotated 180 degrees during installation so all four screw
//     holes point inward with mirror symmetry across the case centreline.
// 23. Retention bumps are removed because the screw provides final retention.
// 24. A shallow diagonal recessed tread improves floor grip without supports.
// 25. The locating layer has a 0.5mm lead-in chamfer for easier installation.
// 26. Pebble pads are removed; the original bump and short crescent return.
//
// Units: mm

$fn = 64;

// Select: "base", "lid", "lid_print", "assembly", "charm_insert",
// "rubber_foot", or "rubber_feet".
part = "base";

// Set true to flip the whole component layout left-to-right (speaker, touch
// bump/crescent, charm insert, feet, etc. — everything moves together as a
// rigid mirror, so all existing clearances stay valid). USB-C power is the
// one exception: it switches sides via a plain coordinate swap
// (usb_c_panel_x) rather than being geometrically mirrored, since it's a
// keyed connector that should relocate, not flip. Applies to "base", "lid",
// "lid_print", and "assembly" only.
layout_mirror = false;

fit_fudge = 0.3;

// Shared production hardware.
self_tap_pilot_d = 1.8;
control_screw_length = 5.0;
control_screw_head_d = 5.0;
control_screw_head_h = 1.6;
control_screw_shank_d = 2.5;
control_pilot_wall_stop = 0.20;

// FDM values used by actual geometry.
fdm_layer_h = 0.20;
fdm_union_overlap = 0.40;
fdm_pilot_lead_in = 0.60;

// Restrained cleanup values. These only soften support geometry and do not
// move any component, opening, pilot, or case wall.
clean_support_fn = 32;
clean_lid_mount_r = 0.90;
clean_led_mount_r = 0.80;
clean_usb_support_r = 0.80;

// -----------------------------------------------------------------------------
// Case
// -----------------------------------------------------------------------------

case_w = 114;
case_h = 60;
case_d = 50;

wall = 3;
corner_r = 4;

lid_t = 3;
lip_depth = 6;
lip_clearance = 0.35;
lip_wall = 2.2;

assembly_lid_lift = 8;

// -----------------------------------------------------------------------------
// OLED module
// -----------------------------------------------------------------------------

oled_pcb_w = 100.5;
oled_pcb_h = 33.5;

oled_screen_w = 81.5;
oled_screen_h = 24.0;

oled_view_w = 76.7;
oled_view_h = 19.2;

oled_pcb_t = 1.6;

oled_hole_span_x = 95;
oled_hole_span_y = 28.5;

oled_x = (case_w - oled_pcb_w) / 2;
oled_y = (case_h - oled_pcb_h) / 2;

oled_screen_x = oled_x + (oled_pcb_w - oled_screen_w) / 2;
oled_screen_y = oled_y + (oled_pcb_h - oled_screen_h) / 2 + 2;

oled_view_x = oled_x + (oled_pcb_w - oled_view_w) / 2;
oled_view_y = oled_y + (oled_pcb_h - oled_view_h) / 2 + 2;

oled_hole_x_offset = (oled_pcb_w - oled_hole_span_x) / 2;
oled_hole_y_offset = (oled_pcb_h - oled_hole_span_y) / 2;

oled_m3_clearance_d = 3.0 + fit_fudge;
oled_m3_head_preview_d = 5.8;

oled_solder_joint_padding = 3.0;
oled_solder_padding_d = 6.4;

// -----------------------------------------------------------------------------
// Raspberry Pi Zero and amplifier
// -----------------------------------------------------------------------------

pi_w = 65;
pi_h = 30;
pi_corner_r = 3;

// Final production coordinates. Historical movement offsets are retired.
pi_x = 41.5;
pi_y = 24.5;

pi_holes = [
    [3.5, 3.5],
    [61.5, 3.5],
    [3.5, 26.5],
    [61.5, 26.5]
];

pi_standoff_h = 6;
pi_standoff_od = 5.8;
pi_standoff_pilot_d = self_tap_pilot_d;

pi_gusset_h = 4.5;
pi_gusset_w = 1.6;
pi_gusset_len = 6;

amp_w = 20;
amp_h = 19;
amp_corner_r = 2;
amp_hole_span = 12.5;
amp_x = 49.5;
amp_y = 5.0;
amp_hole_x = 59.5;

amp_standoff_h = pi_standoff_h;
amp_standoff_od = pi_standoff_od;
amp_standoff_pilot_d = self_tap_pilot_d;

amp_holes = [
    [amp_w / 2, amp_h / 2 - amp_hole_span / 2],
    [amp_w / 2, amp_h / 2 + amp_hole_span / 2]
];

amp_lower_hole_y = 8.25;
amp_upper_hole_y = 20.75;

// -----------------------------------------------------------------------------
// Speaker
// -----------------------------------------------------------------------------

speaker_w = 31;
speaker_h = 28;
speaker_center_x = 20.5;
speaker_center_y = 30.0;

speaker_baffle_h = 7;
speaker_mount_h = speaker_baffle_h;
speaker_mount_w = pi_standoff_od;
speaker_mount_pilot_d = self_tap_pilot_d;
speaker_mount_span = 38.0;

speaker_mount_support_w = speaker_mount_w;
speaker_mount_support_h = speaker_baffle_h;
speaker_support_wall_overlap = 0.8;

speaker_slot_w = 2.2;
speaker_slot_h = 22.0;
speaker_slot_gap = 1.25;
speaker_slot_count = 7;

speaker_baffle_wall = 1.4;
speaker_pocket_clearance = 1.0;
speaker_pocket_w = speaker_w + speaker_pocket_clearance;
speaker_pocket_h = speaker_h + speaker_pocket_clearance;
speaker_baffle_outer_w = speaker_pocket_w + speaker_baffle_wall * 2;
speaker_baffle_outer_h = speaker_pocket_h + speaker_baffle_wall * 2;
speaker_baffle_inner_w = speaker_pocket_w;
speaker_baffle_inner_h = speaker_pocket_h;
speaker_baffle_corner_r = 2.0;

speaker_wire_relief_w = 4.0;
speaker_wire_relief_depth = speaker_baffle_wall + 0.8;
speaker_wire_relief_h = speaker_baffle_h * 0.5;

// -----------------------------------------------------------------------------
// Pi connector preview coordinates
// -----------------------------------------------------------------------------

usb_centers_x = [52.5, 65.1];
micro_hdmi_center_x = 94.1;

// All external Pi-side openings, including microSD, remain closed.

// -----------------------------------------------------------------------------
// USB-C power insert
// -----------------------------------------------------------------------------

usb_c_panel_w = 20;
usb_c_panel_h = 7;
usb_c_panel_depth = 2.2;
usb_c_header_cutout_w = 12.2;
usb_c_header_cutout_h = 7;
usb_c_hole_span = 16;
usb_c_mount_pilot_d = pi_standoff_pilot_d;

usb_c_recess_fudge = 0.25;
usb_c_clearance_from_walls = 10.0;

// Right side by default; swaps to the left side under layout_mirror. This is
// a plain coordinate swap, not a mirror() of the connector geometry itself —
// USB-C is a keyed part, so it relocates rather than flips.
usb_c_panel_x = layout_mirror
    ? wall + usb_c_clearance_from_walls
    : case_w - wall - usb_c_clearance_from_walls - usb_c_panel_w;
usb_c_panel_y = wall + usb_c_clearance_from_walls;
usb_c_panel_center_x = usb_c_panel_x + usb_c_panel_w / 2;
usb_c_panel_center_y = usb_c_panel_y + usb_c_panel_h / 2;
usb_c_panel_z = 0;

usb_c_hole_centers = [
    [usb_c_panel_center_x - usb_c_hole_span / 2, usb_c_panel_center_y],
    [usb_c_panel_center_x + usb_c_hole_span / 2, usb_c_panel_center_y]
];

usb_c_support_rail_w = 1.4;
usb_c_support_rail_h = 5.0;
usb_c_support_end_w = 1.4;

usb_c_connector_preview_w = usb_c_header_cutout_w;
usb_c_connector_preview_d = usb_c_header_cutout_h;
usb_c_connector_preview_h = 6.0;

// -----------------------------------------------------------------------------
// Markings and rubber feet
// -----------------------------------------------------------------------------

base_part_number = "mk-piclock-kids v3.46";
base_part_number_size = 4.0;
base_part_number_h = 0.45;
base_part_number_x = pi_x + pi_w / 2;
base_part_number_y = pi_y + pi_h / 2;

// Raised on the lid underside, below the OLED PCB footprint.
// Mirrored so it reads correctly when viewing the removed lid from inside.
lid_part_number = "MK-PiClock-V2.3R";
lid_part_number_size = 3.4;
lid_part_number_h = 0.55;
lid_text_overlap = 0.05;
lid_part_number_x = case_w / 2;
lid_part_number_y = 11.0;

// Lid orientation marks, raised on the underside and clear of the OLED PCB.
lid_orientation_text_size = 3.6;
lid_orientation_text_h = 0.55;
lid_top_text_x = case_w / 2;
lid_top_clear_edge_y = case_h - (wall + lip_clearance + lip_wall);
lid_top_text_y = (oled_y + oled_pcb_h + lid_top_clear_edge_y) / 2;

usb_c_polarity_mark_size = 4.0;
usb_c_polarity_mark_h = 0.45;
usb_c_polarity_mark_y = usb_c_panel_y - 4.0;
usb_c_polarity_plus_x =
    usb_c_panel_center_x - usb_c_hole_span / 2;

rubber_foot_size = 21;
rubber_foot_recess_depth = 1.2;

// Separate TPU / NinjaFlex insert. The 4mm cap remains outside the case while
// the upper locating layer seats in the existing 21mm recess. The M2.5 screw
// provides final retention, so no side bumps are required.
rubber_foot_cap_size = 21.8;
rubber_foot_cap_h = 4.0;
rubber_foot_cap_corner_r = 2.2;
rubber_foot_insert_size = 20.5;
rubber_foot_insert_h = 1.05;
rubber_foot_insert_corner_r = 1.2;
rubber_foot_insert_chamfer = 0.50;
rubber_foot_print_gap = 5.0;

// Shallow recessed diagonal tread on the floor-facing surface. The tread is
// clipped inside the cap perimeter and kept clear of the screw-head pocket.
rubber_foot_grip_groove_w = 0.85;
rubber_foot_grip_groove_pitch = 4.0;
rubber_foot_grip_groove_depth = 0.45;
rubber_foot_grip_inset = 1.5;
rubber_foot_grip_screw_clearance = 1.25;

// M2.5 self-tapping foot fastener. The TPU foot has full shank clearance and
// a recessed pan-head pocket. The screw taps only into the existing 3mm case
// wall at the off-centre mounting point.
rubber_foot_screw_nominal_d = 2.5;
rubber_foot_screw_clearance_d = 2.9;
rubber_foot_screw_head_d = 5.4;
rubber_foot_screw_head_depth = 2.0;
rubber_foot_case_pilot_d = self_tap_pilot_d;

// Equal front-to-back spacing: bottom margin = centre gap = lid-side margin.
rubber_foot_z_gap =
    (case_d - 2 * rubber_foot_size) / 3;

// Long-driver openings hidden beneath the right rubber feet.
rubber_foot_tool_access_d = 6.975;

rubber_foot_x_positions = [10, 83];

rubber_foot_z_positions = [
    rubber_foot_z_gap,
    rubber_foot_z_gap * 2 + rubber_foot_size
];

rubber_foot_recess_centres = [
    [rubber_foot_x_positions[0] + rubber_foot_size / 2,
     rubber_foot_z_positions[0] + rubber_foot_size / 2],
    [rubber_foot_x_positions[0] + rubber_foot_size / 2,
     rubber_foot_z_positions[1] + rubber_foot_size / 2],
    [rubber_foot_x_positions[1] + rubber_foot_size / 2,
     rubber_foot_z_positions[0] + rubber_foot_size / 2],
    [rubber_foot_x_positions[1] + rubber_foot_size / 2,
     rubber_foot_z_positions[1] + rubber_foot_size / 2]
];

// One shared local M2.5 axis for every printed foot. The hole is 7mm from
// centre. Right feet install as printed; left feet rotate 180 degrees so every
// fastener sits toward the case centreline while all four feet remain identical.
rubber_foot_screw_offset = [-7.0, 0.0];

function rubber_foot_inward_x_offset(c) =
    c[0] < case_w / 2
        ? -rubber_foot_screw_offset[0]
        :  rubber_foot_screw_offset[0];

rubber_foot_mount_points = [
    for (c = rubber_foot_recess_centres)
        [
            c[0] + rubber_foot_inward_x_offset(c),
            c[1] + rubber_foot_screw_offset[1]
        ]
];

// -----------------------------------------------------------------------------
// Transparent charm insert with exterior light-blocking flange
// -----------------------------------------------------------------------------

// Restored static charm location on the left side of the control wall.
charm_center_x = 22.0;
charm_center_z = 29.0;
charm_wall_y = case_h;

// Straight case opening. The flange fully covers the bore edge from outside.
charm_bore_d = 14.0;
charm_bore_overshoot = 0.15;

// V3.17 transparent charm cap, integrated as the production charm insert.
// Local insert axis: Z=0 is the outside case face and positive Z enters the
// case. The visible cap occupies negative Z and prints face-down.
charm_insert_cap_height = 6.40;
charm_insert_top_d = 15.20;
charm_insert_body_d = 16.00;
charm_insert_flange_d = 18.00;
charm_insert_flange_t = 1.20;
charm_insert_top_t = 0.80;
charm_insert_wall_t = 1.00;

// Hollow light chamber.
charm_insert_inner_front_d =
    charm_insert_top_d - 2 * charm_insert_wall_t;
charm_insert_stem_inner_d = 11.20;

// Tight stem and crush ribs from the confirmed v3.17 snap fit.
charm_insert_stem_d = 13.65;
charm_insert_stem_len = wall + 1.80;
charm_insert_rib_w = 0.75;
charm_insert_rib_h = 0.22;
charm_insert_rib_z0 = 0.18;
charm_insert_rib_len = 2.00;
charm_insert_rib_effective_d =
    charm_insert_stem_d + 2 * charm_insert_rib_h;

// Flexible snap collar.
charm_snap_slot_w = 0.90;
charm_snap_slot_start = 1.55;
charm_snap_shoulder_start = 2.25;
charm_snap_peak_z = 3.25;
charm_snap_max_d = 14.45;
charm_snap_tip_d = 13.00;

// Flange overlap blocks the direct sight line around the clear insert.
charm_flange_overlap =
    (charm_insert_flange_d - charm_bore_d) / 2;

assert(
    charm_flange_overlap >= 2.0,
    "Charm flange must overlap the opening by at least 2mm per side."
);
assert(
    charm_insert_stem_d < charm_bore_d,
    "Charm insert stem must remain smaller than the case opening."
);
assert(
    charm_insert_rib_effective_d > charm_bore_d,
    "Charm insert ribs must create a snug crush fit in the case opening."
);
assert(
    charm_insert_rib_effective_d <= charm_bore_d + 0.15,
    "Charm insert ribs must not exceed the confirmed v3.17 crush fit."
);
assert(
    charm_snap_max_d > charm_bore_d,
    "Charm snap collar must expand beyond the case opening."
);
assert(
    charm_snap_peak_z > wall,
    "Charm snap collar peak must sit behind the inner wall."
);
assert(
    charm_insert_top_t >= fdm_layer_h * 4,
    "Charm cap top must have at least four printed layers."
);

// -----------------------------------------------------------------------------
// LED PCB mount on inside face of bottom wall
// -----------------------------------------------------------------------------

led_pcb_w = 19.0;
led_pcb_h = 15.0;
led_pcb_t = 1.6;
led_pcb_hole_span = 10.0;

led_pcb_center_x = 16.5;
led_pcb_center_z = 29.0;
led_actual_center_x = 11.5;
led_actual_center_z = 29.0;

led_pcb_hole_positions = [
    [led_pcb_center_x, led_pcb_center_z - led_pcb_hole_span / 2],
    [led_pcb_center_x, led_pcb_center_z + led_pcb_hole_span / 2]
];

led_pcb_standoff_h = 4.0;
led_pcb_pilot_d = pi_standoff_pilot_d;
led_pcb_mount_overlap = fdm_union_overlap;

led_pcb_mount_w = 7.0;
led_pcb_mount_h = led_pcb_h;
led_pcb_grille_ramp_run = led_pcb_standoff_h;
led_pcb_hull_slice_h = max(fdm_layer_h * 2, 0.40);

led_pcb_mount_face_left =
    led_pcb_center_x - led_pcb_mount_w / 2;
led_pcb_mount_face_right =
    led_pcb_center_x + led_pcb_mount_w / 2;
led_pcb_mount_bottom =
    led_pcb_center_z - led_pcb_mount_h / 2;
led_pcb_mount_top =
    led_pcb_center_z + led_pcb_mount_h / 2;

led_pcb_pilot_lead_d = led_pcb_pilot_d + 0.50;
led_pcb_pilot_lead_h = fdm_pilot_lead_in;

led_preview_d = 4.0;
led_preview_h = 1.2;
led_header_w = 3.0;
led_header_h = 8.0;
led_header_depth = 3.0;
led_wire_preview_len = 6.0;
led_wire_preview_d = 0.8;

// -----------------------------------------------------------------------------
// Touch sensor
// -----------------------------------------------------------------------------

touch_pcb_size = 24.0;
touch_pcb_t = 1.6;

touch_center_x = 87.0;
touch_center_z = 29.0;
touch_pad_center_x = 92.0;
touch_pad_center_z = 29.0;

// Final screw coordinates: upper-left, upper-right, lower-right.
touch_mount_points = [
    [77.0, 39.0],
    [97.0, 39.0],
    [97.0, 19.0]
];

// Right-side screwdriver bores are shifted 1mm toward the speaker side.
touch_tool_access_points = [
    [97.0, 38.0],
    [97.0, 18.0]
];

touch_mount_pilot_d = self_tap_pilot_d;
touch_screw_head_d = control_screw_head_d;
touch_screw_head_h = control_screw_head_h;
touch_screw_shank_d = control_screw_shank_d;

touch_pad_d = 14.0;
touch_solder_x_size = 3.0;
touch_solder_z_size = 8.0;
touch_solder_clearance = 1.7;
touch_solder_center_x = 77.7;
touch_solder_center_z = 29.0;

touch_panel_inner_y = case_h - wall;
touch_pcb_outer_face_y = touch_panel_inner_y;

touch_sensing_skin_thickness = 1.0;
touch_circle_recess_depth = wall - touch_sensing_skin_thickness;

touch_button_d = 14.0;
touch_chamfer_width = 0.4;
touch_chamfer_depth = 0.4;
touch_chamfer_outer_d = touch_button_d + 2 * touch_chamfer_width;
touch_circle_fn = 96;

// Existing pilot and driver-access geometry remains unchanged.
touch_mount_pilot_depth = wall - control_pilot_wall_stop;
touch_tool_access_d = rubber_foot_tool_access_d;

// FDM-safe sensing recess. touch_recess_roof_rise must be tall enough that
// the roof ridge (from [+-roof_half_w, roof_base_z] to [0, roof_peak_z])
// rises at least as fast as it runs, i.e. a true <=45-degree overhang, the
// same convention enforced elsewhere for the bump and crescent.
control_feature_roof_half_w = 4.0;
control_feature_seed_d = 0.18;
control_feature_slice_depth = 0.16;
touch_recess_roof_rise = 3.00;

touch_recess_roof_base_z_offset =
    sqrt(max(pow(touch_button_d / 2, 2) - pow(control_feature_roof_half_w, 2), 0));
touch_recess_roof_run = control_feature_roof_half_w;
touch_recess_roof_rise_actual =
    touch_button_d / 2 + touch_recess_roof_rise - touch_recess_roof_base_z_offset;

assert(
    touch_recess_roof_rise_actual >= touch_recess_roof_run - 0.001,
    "Touch recess roof must retain a taper of at least 45 degrees."
);

// Restored round bump and short right-side crescent. These dimensions are
// explicitly tied to the speaker-side-down print orientation.
//
// The circular bump is a 45-degree frustum: its radius decreases by exactly
// its outward projection. This prevents a horizontal underside from forming.
touch_bump_h = 1.60;
touch_bump_face_d = touch_screw_head_d - 0.20;
touch_bump_root_d = touch_bump_face_d + 2 * touch_bump_h;
touch_bump_slice = fdm_layer_h;
touch_bump_fn = 64;
touch_bump_x = touch_mount_points[0][0];
touch_bump_z = touch_mount_points[0][1];

// The right-side crescent retains the original 3mm projection and narrow face.
// Its outer wall already contracts at 45 degrees. The cropped lower end uses a
// rising 45-degree mask so each new layer advances outward no faster than it
// rises from the build plate.
touch_surround_h = 3.00;
touch_surround_slice = fdm_layer_h;
touch_surround_fn = 96;
touch_band_face_w = 2.40;
touch_crescent_print_angle = 45;
touch_crescent_print_slope = tan(touch_crescent_print_angle);

touch_right_screw_r = sqrt(
    pow(touch_mount_points[1][0] - touch_pad_center_x, 2)
    + pow(touch_mount_points[1][1] - touch_pad_center_z, 2)
);

touch_outer_r_root = touch_right_screw_r + 2.80;
touch_outer_r_face = touch_outer_r_root - touch_surround_h;
touch_inner_r_root = touch_chamfer_outer_d / 2 + 0.60;
touch_inner_r_face = touch_outer_r_face - touch_band_face_w;

touch_screw_required_r = touch_screw_shank_d / 2 + 0.25;
touch_crescent_end_margin = 0.50;
touch_crescent_z_min = min([
    touch_mount_points[1][1],
    touch_mount_points[2][1]
]) - touch_screw_required_r - touch_crescent_end_margin;
touch_crescent_z_max = max([
    touch_mount_points[1][1],
    touch_mount_points[2][1]
]) + touch_screw_required_r + touch_crescent_end_margin;

// Screw penetration beyond the 3mm wall is only 0.4mm with the specified
// 5mm screw and 1.6mm PCB. Both restored features leave over 1mm extra cover.
touch_screw_tip_projection =
    max(control_screw_length - touch_pcb_t - wall, 0);

// Printability and screw-shielding checks.
assert(
    abs((touch_bump_root_d - touch_bump_face_d) / 2 - touch_bump_h) < 0.001,
    "Touch bump must retain a 45-degree FDM taper."
);
assert(
    touch_bump_face_d >= touch_screw_shank_d + 0.50,
    "Touch bump face is too small."
);
assert(
    touch_bump_h - touch_screw_tip_projection >= 1.00,
    "Touch bump does not provide 1mm screw-tip clearance."
);
assert(
    abs(touch_bump_x - touch_mount_points[0][0]) < 0.001
        && abs(touch_bump_z - touch_mount_points[0][1]) < 0.001,
    "Touch bump is not centred over its screw."
);
assert(
    abs(touch_outer_r_root - touch_outer_r_face - touch_surround_h) < 0.001,
    "Touch crescent outer wall must retain a 45-degree FDM taper."
);
assert(
    touch_inner_r_face >= touch_inner_r_root,
    "Touch opening must widen toward the exterior."
);
assert(
    touch_crescent_print_angle >= 45,
    "Touch crescent lower termination is too shallow for support-free FDM."
);

// Check crescent screw coverage at the actual screw-tip depth. The lower FDM
// mask rises with outward depth, so it is included in the coverage check.
touch_screw_fraction = min(
    touch_screw_tip_projection / touch_surround_h,
    1
);
touch_inner_r_at_tip =
    touch_inner_r_root
    + touch_screw_fraction * (touch_inner_r_face - touch_inner_r_root);
touch_outer_r_at_tip =
    touch_outer_r_root
    + touch_screw_fraction * (touch_outer_r_face - touch_outer_r_root);
touch_crescent_lower_at_tip =
    touch_crescent_z_min
    + touch_screw_tip_projection * touch_crescent_print_slope;

for (i = [1 : 2]) {
    screw_r = sqrt(
        pow(touch_mount_points[i][0] - touch_pad_center_x, 2)
        + pow(touch_mount_points[i][1] - touch_pad_center_z, 2)
    );

    assert(
        touch_mount_points[i][0] >= touch_pad_center_x
            && screw_r - touch_screw_required_r >= touch_inner_r_at_tip
            && screw_r + touch_screw_required_r <= touch_outer_r_at_tip
            && touch_mount_points[i][1] - touch_screw_required_r
                >= touch_crescent_lower_at_tip
            && touch_mount_points[i][1] + touch_screw_required_r
                <= touch_crescent_z_max,
        "FDM-safe touch crescent does not shield a right-side screw."
    );
}

assert(
    touch_surround_h - touch_screw_tip_projection >= 1.50,
    "Touch crescent does not provide enough screw-tip clearance."
);

// -----------------------------------------------------------------------------
// Lid fasteners and supports
// -----------------------------------------------------------------------------

lid_screw_margin = 7;
lid_screw_d = 3.0;
lid_screw_head_d = 6.8;
lid_screw_head_recess_h = 1.8;

lid_mount_pilot_d = 2.65;
lid_mount_pilot_entry_d = 3.05;
lid_mount_pilot_entry_h = 2.2;

lid_mount_top_h = 3.4;
lid_mount_grow_h = 14.4;
lid_mount_h = lid_mount_grow_h + lid_mount_top_h;

lid_mount_base_reach = 1.2;
lid_mount_wall_overlap = 0.55;
lid_mount_inner_extra = 3.5;
lid_mount_reach_scale = 1.30;
lid_mount_lip_clearance = 1.2;
lid_mount_hull_slice_h = 0.25;
lid_mount_blind_pilot_depth = 10.0;

function lid_points() = [
    [lid_screw_margin, lid_screw_margin],
    [case_w - lid_screw_margin, lid_screw_margin],
    [lid_screw_margin, case_h - lid_screw_margin],
    [case_w - lid_screw_margin, case_h - lid_screw_margin]
];

function lid_mount_reach_x(p) =
    (
        p[0] < case_w / 2
        ? p[0] - wall + lid_mount_inner_extra
        : case_w - wall - p[0] + lid_mount_inner_extra
    ) * lid_mount_reach_scale;

function lid_mount_reach_y(p) =
    (
        p[1] < case_h / 2
        ? p[1] - wall + lid_mount_inner_extra
        : case_h - wall - p[1] + lid_mount_inner_extra
    ) * lid_mount_reach_scale;

// -----------------------------------------------------------------------------
// General geometry helpers
// -----------------------------------------------------------------------------

module rounded_cube(size, r) {
    hull() {
        translate([r, r, 0])
            cylinder(h = size[2], r = r);
        translate([size[0] - r, r, 0])
            cylinder(h = size[2], r = r);
        translate([r, size[1] - r, 0])
            cylinder(h = size[2], r = r);
        translate([size[0] - r, size[1] - r, 0])
            cylinder(h = size[2], r = r);
    }
}

// Rounded rectangle extruded along Y. Useful for wall-mounted supports where
// the visible profile lies in X/Z rather than X/Y.
module rounded_rect_prism_xz(size, r) {
    safe_r = min([r, size[0] / 2 - 0.01, size[2] / 2 - 0.01]);

    hull() {
        for (x = [safe_r, size[0] - safe_r]) {
            for (z = [safe_r, size[2] - safe_r]) {
                translate([x, 0, z])
                    rotate([-90, 0, 0])
                        cylinder(
                            h = size[1],
                            r = safe_r,
                            $fn = clean_support_fn
                        );
            }
        }
    }
}

// Capsule-ended support arm with the same overall bounding box as a plain
// rectangular arm. The rounded ends disappear cleanly into adjoining bodies.
module capsule_y_prism(x_center, y0, y1, diameter, height, z0) {
    assert(y1 - y0 >= diameter, "Capsule support is shorter than its width.");

    hull() {
        translate([x_center, y0 + diameter / 2, z0])
            cylinder(
                h = height,
                d = diameter,
                $fn = clean_support_fn
            );

        translate([x_center, y1 - diameter / 2, z0])
            cylinder(
                h = height,
                d = diameter,
                $fn = clean_support_fn
            );
    }
}

module oled_holes() {
    translate([
        oled_x + oled_hole_x_offset,
        oled_y + oled_hole_y_offset,
        0
    ]) children();

    translate([
        oled_x + oled_pcb_w - oled_hole_x_offset,
        oled_y + oled_hole_y_offset,
        0
    ]) children();

    translate([
        oled_x + oled_hole_x_offset,
        oled_y + oled_pcb_h - oled_hole_y_offset,
        0
    ]) children();

    translate([
        oled_x + oled_pcb_w - oled_hole_x_offset,
        oled_y + oled_pcb_h - oled_hole_y_offset,
        0
    ]) children();
}

module pi_mount_holes() {
    for (p = pi_holes)
        translate([pi_x + p[0], pi_y + p[1], 0])
            children();
}

module amp_mount_holes() {
    for (p = amp_holes)
        translate([amp_x + p[0], amp_y + p[1], 0])
            children();
}

// -----------------------------------------------------------------------------
// OLED lid geometry
// -----------------------------------------------------------------------------

module oled_screen_cutout() {
    translate([
        oled_screen_x - fit_fudge / 2,
        oled_screen_y - fit_fudge / 2,
        -1
    ])
        cube([
            oled_screen_w + fit_fudge,
            oled_screen_h + fit_fudge,
            lid_t + 2
        ]);
}

module oled_m3_lid_holes() {
    oled_holes() {
        translate([0, 0, -oled_solder_joint_padding - 1])
            cylinder(
                h = lid_t + oled_solder_joint_padding + 2,
                d = oled_m3_clearance_d
            );
    }
}

module oled_half_moon_padding_pad(keep_angle) {
    intersection() {
        translate([0, 0, -oled_solder_joint_padding])
            cylinder(
                h = oled_solder_joint_padding,
                d = oled_solder_padding_d
            );

        rotate([0, 0, keep_angle])
            translate([
                0,
                -oled_solder_padding_d / 2,
                -oled_solder_joint_padding - 0.05
            ])
                cube([
                    oled_solder_padding_d / 2,
                    oled_solder_padding_d,
                    oled_solder_joint_padding + 0.1
                ]);
    }
}

module oled_solder_padding_pads() {
    oled_screen_cx = oled_screen_x + oled_screen_w / 2;
    oled_screen_cy = oled_screen_y + oled_screen_h / 2;

    ll_x = oled_x + oled_hole_x_offset;
    lr_x = oled_x + oled_pcb_w - oled_hole_x_offset;
    ly = oled_y + oled_hole_y_offset;
    uy = oled_y + oled_pcb_h - oled_hole_y_offset;

    translate([ll_x, ly, 0])
        oled_half_moon_padding_pad(
            atan2(ly - oled_screen_cy, ll_x - oled_screen_cx)
        );

    translate([lr_x, ly, 0])
        oled_half_moon_padding_pad(
            atan2(ly - oled_screen_cy, lr_x - oled_screen_cx)
        );

    translate([ll_x, uy, 0])
        oled_half_moon_padding_pad(
            atan2(uy - oled_screen_cy, ll_x - oled_screen_cx)
        );

    translate([lr_x, uy, 0])
        oled_half_moon_padding_pad(
            atan2(uy - oled_screen_cy, lr_x - oled_screen_cx)
        );
}

module lid_lip_ring() {
    difference() {
        translate([wall + lip_clearance, wall + lip_clearance, -lip_depth])
            rounded_cube(
                [
                    case_w - 2 * (wall + lip_clearance),
                    case_h - 2 * (wall + lip_clearance),
                    lip_depth
                ],
                max(corner_r - wall, 0.5)
            );

        translate([
            wall + lip_clearance + lip_wall,
            wall + lip_clearance + lip_wall,
            -lip_depth - 0.1
        ])
            rounded_cube(
                [
                    case_w - 2 * (wall + lip_clearance + lip_wall),
                    case_h - 2 * (wall + lip_clearance + lip_wall),
                    lip_depth + 0.2
                ],
                max(corner_r - wall - lip_wall, 0.5)
            );
    }
}

// -----------------------------------------------------------------------------
// Pi and amp supports
// -----------------------------------------------------------------------------

module pi_standoff_gusset_at(x, y, angle) {
    // Same length, width, and height as the original fin, but with rounded
    // ends and a continuous FDM-safe taper into the floor.
    translate([x, y, wall])
        rotate([0, 0, angle])
            hull() {
                cylinder(
                    h = pi_gusset_h,
                    d = pi_gusset_w,
                    $fn = clean_support_fn
                );

                translate([pi_gusset_len, 0, 0])
                    cylinder(
                        h = fdm_layer_h,
                        d = pi_gusset_w,
                        $fn = clean_support_fn
                    );
            }
}

module pi_standoff_gussets() {
    pi_standoff_gusset_at(pi_x + 3.5, pi_y + 3.5, 45);
    pi_standoff_gusset_at(pi_x + 61.5, pi_y + 3.5, 135);
    pi_standoff_gusset_at(pi_x + 3.5, pi_y + 26.5, 315);
    pi_standoff_gusset_at(pi_x + 61.5, pi_y + 26.5, 225);
}

module amp_standoff_gussets() {
    pi_standoff_gusset_at(amp_hole_x, amp_lower_hole_y, 0);
    pi_standoff_gusset_at(amp_hole_x, amp_upper_hole_y, 0);
}

module pi_upper_right_anchor() {
    pi_anchor_d = 2.4;
    pi_anchor_h = 1.8;
    pi_anchor_tip_h = 0.4;
    straight_h = pi_anchor_h - pi_anchor_tip_h;
    anchor_x = pi_x + pi_holes[3][0];
    anchor_y = pi_y + pi_holes[3][1];

    translate([anchor_x, anchor_y, wall + pi_standoff_h]) {
        cylinder(h = straight_h, d = pi_anchor_d);

        translate([0, 0, straight_h])
            cylinder(
                h = pi_anchor_tip_h,
                d1 = pi_anchor_d,
                d2 = pi_anchor_d - 0.6
            );
    }
}

module pi_three_pilot_holes() {
    for (i = [0 : 2]) {
        translate([
            pi_x + pi_holes[i][0],
            pi_y + pi_holes[i][1],
            wall - 1
        ])
            cylinder(
                h = pi_standoff_h + 2,
                d = pi_standoff_pilot_d
            );
    }
}

// -----------------------------------------------------------------------------
// Speaker geometry
// -----------------------------------------------------------------------------

module speaker_mount_points() {
    translate([
        speaker_center_x,
        speaker_center_y - speaker_mount_span / 2,
        0
    ]) children();

    translate([
        speaker_center_x,
        speaker_center_y + speaker_mount_span / 2,
        0
    ]) children();
}

module speaker_support_arm_to_bottom_wall() {
    tab_y0 = wall - speaker_support_wall_overlap;
    tab_y1 = speaker_center_y - speaker_baffle_inner_h / 2 - 0.15;

    capsule_y_prism(
        speaker_center_x,
        tab_y0,
        tab_y1,
        speaker_mount_support_w,
        speaker_mount_support_h,
        wall
    );
}

module speaker_support_arm_to_top_wall() {
    tab_y0 = speaker_center_y + speaker_baffle_inner_h / 2 + 0.15;
    tab_y1 = case_h - wall + speaker_support_wall_overlap;

    capsule_y_prism(
        speaker_center_x,
        tab_y0,
        tab_y1,
        speaker_mount_support_w,
        speaker_mount_support_h,
        wall
    );
}

module speaker_mount_supports() {
    speaker_support_arm_to_bottom_wall();
    speaker_support_arm_to_top_wall();
}

module speaker_pocket_keepout() {
    translate([
        speaker_center_x - speaker_pocket_w / 2,
        speaker_center_y - speaker_pocket_h / 2,
        wall - 0.05
    ])
        rounded_cube(
            [
                speaker_pocket_w,
                speaker_pocket_h,
                speaker_mount_h + 1.0
            ],
            max(speaker_baffle_corner_r - 0.7, 0.5)
        );
}

module rounded_slot_cutout(w, h, depth) {
    hull() {
        translate([0, -h / 2 + w / 2, 0])
            cylinder(h = depth, d = w);

        translate([0, h / 2 - w / 2, 0])
            cylinder(h = depth, d = w);
    }
}

module speaker_grill_holes() {
    total_w =
        speaker_slot_count * speaker_slot_w
        + (speaker_slot_count - 1) * speaker_slot_gap;

    for (i = [0 : speaker_slot_count - 1]) {
        x =
            -total_w / 2
            + speaker_slot_w / 2
            + i * (speaker_slot_w + speaker_slot_gap);

        translate([speaker_center_x + x, speaker_center_y, -1])
            rounded_slot_cutout(
                speaker_slot_w,
                speaker_slot_h,
                wall + 2
            );
    }
}

module speaker_rect_ring(outer_w, outer_h, inner_w, inner_h, h, r) {
    difference() {
        translate([
            speaker_center_x - outer_w / 2,
            speaker_center_y - outer_h / 2,
            wall
        ])
            rounded_cube([outer_w, outer_h, h], r);

        translate([
            speaker_center_x - inner_w / 2,
            speaker_center_y - inner_h / 2,
            wall - 0.1
        ])
            rounded_cube(
                [inner_w, inner_h, h + 0.2],
                max(r - 0.7, 0.5)
            );
    }
}

module speaker_acoustic_baffle() {
    speaker_rect_ring(
        speaker_baffle_outer_w,
        speaker_baffle_outer_h,
        speaker_baffle_inner_w,
        speaker_baffle_inner_h,
        speaker_baffle_h,
        speaker_baffle_corner_r
    );
}

module speaker_wire_relief_cutout() {
    translate([
        speaker_center_x + speaker_baffle_inner_w / 2 - 0.1,
        speaker_center_y - speaker_wire_relief_w / 2,
        wall + speaker_baffle_h - speaker_wire_relief_h - 0.1
    ])
        cube([
            speaker_wire_relief_depth,
            speaker_wire_relief_w,
            speaker_wire_relief_h + 0.2
        ]);
}

// -----------------------------------------------------------------------------
// Port and USB-C geometry
// -----------------------------------------------------------------------------

module usb_c_header_mount_points() {
    for (p = usb_c_hole_centers)
        translate([p[0], p[1], 0])
            children();
}

module usb_c_header_floor_recess() {
    translate([
        usb_c_panel_x - usb_c_recess_fudge / 2,
        usb_c_panel_y - usb_c_recess_fudge / 2,
        -0.05
    ])
        cube([
            usb_c_panel_w + usb_c_recess_fudge,
            usb_c_panel_h + usb_c_recess_fudge,
            usb_c_panel_depth + 0.10
        ]);
}

module usb_c_header_body_cutout() {
    translate([
        usb_c_panel_center_x - usb_c_header_cutout_w / 2,
        usb_c_panel_center_y - usb_c_header_cutout_h / 2,
        -1
    ])
        cube([
            usb_c_header_cutout_w,
            usb_c_header_cutout_h,
            wall + 2
        ]);
}

module usb_c_header_mount_holes() {
    usb_c_header_mount_points() {
        translate([0, 0, usb_c_panel_depth - 0.05])
            cylinder(
                h =
                    wall
                    + usb_c_support_rail_h
                    - usb_c_panel_depth
                    + 0.25,
                d = usb_c_mount_pilot_d
            );
    }
}

module usb_c_header_cutouts() {
    usb_c_header_floor_recess();
    usb_c_header_body_cutout();
    usb_c_header_mount_holes();
}

module usb_c_header_supports() {
    outer_x = usb_c_panel_x - usb_c_support_end_w;
    outer_y = usb_c_panel_y - usb_c_support_rail_w;
    outer_w = usb_c_panel_w + usb_c_support_end_w * 2;
    outer_h = usb_c_panel_h + usb_c_support_rail_w * 2;

    // One continuous rounded cradle replaces four visually separate blocks.
    // The connector opening and PCB support footprint remain identical.
    difference() {
        translate([outer_x, outer_y, wall])
            rounded_cube(
                [outer_w, outer_h, usb_c_support_rail_h],
                clean_usb_support_r
            );

        translate([
            usb_c_panel_center_x - usb_c_header_cutout_w / 2,
            usb_c_panel_y - 0.05,
            wall - 0.05
        ])
            cube([
                usb_c_header_cutout_w,
                usb_c_panel_h + 0.10,
                usb_c_support_rail_h + 0.10
            ]);
    }
}

// -----------------------------------------------------------------------------
// Markings and foot recesses
// -----------------------------------------------------------------------------

module base_part_number_text() {
    translate([base_part_number_x, base_part_number_y, wall])
        linear_extrude(height = base_part_number_h)
            if (layout_mirror) {
                mirror([1, 0, 0])
                    text(
                        base_part_number,
                        size = base_part_number_size,
                        halign = "center",
                        valign = "center"
                    );
            }
            else {
                text(
                    base_part_number,
                    size = base_part_number_size,
                    halign = "center",
                    valign = "center"
                );
            }
}

module lid_part_number_text() {
    translate([
        lid_part_number_x,
        lid_part_number_y,
        -lid_part_number_h + lid_text_overlap
    ])
        linear_extrude(height = lid_part_number_h)
            if (layout_mirror) {
                // The outer layout mirror already supplies the one flip
                // needed to read correctly from inside; skip this one so the
                // two don't cancel out.
                text(
                    lid_part_number,
                    size = lid_part_number_size,
                    halign = "center",
                    valign = "center"
                );
            }
            else {
                mirror([1, 0, 0])
                    text(
                        lid_part_number,
                        size = lid_part_number_size,
                        halign = "center",
                        valign = "center"
                    );
            }
}

module lid_orientation_text() {
    translate([
        lid_top_text_x,
        lid_top_text_y,
        -lid_orientation_text_h + lid_text_overlap
    ])
        linear_extrude(height = lid_orientation_text_h)
            if (layout_mirror) {
                text(
                    "TOP",
                    size = lid_orientation_text_size,
                    halign = "center",
                    valign = "center"
                );
            }
            else {
                mirror([1, 0, 0])
                    text(
                        "TOP",
                        size = lid_orientation_text_size,
                        halign = "center",
                        valign = "center"
                    );
            }
}

module usb_c_polarity_marks() {
    // "+" is left-right symmetric, so it never needs the layout_mirror
    // counter-mirror the other labels use.
    translate([usb_c_polarity_plus_x, usb_c_polarity_mark_y, wall])
        linear_extrude(height = usb_c_polarity_mark_h)
            text(
                "+",
                size = usb_c_polarity_mark_size,
                halign = "center",
                valign = "center"
            );
}

module rubber_foot_recesses() {
    for (x = rubber_foot_x_positions) {
        for (z = rubber_foot_z_positions) {
            translate([x, -0.1, z])
                cube([
                    rubber_foot_size,
                    rubber_foot_recess_depth + 0.1,
                    rubber_foot_size
                ]);
        }
    }
}

// -----------------------------------------------------------------------------
// Separate NinjaFlex rubber feet and case-wall pilots
// -----------------------------------------------------------------------------

module rubber_foot_rounded_square_2d(size, radius) {
    offset(r = radius)
        square([
            size - 2 * radius,
            size - 2 * radius
        ], center = true);
}

function rubber_foot_local_screw_point() = rubber_foot_screw_offset;

module rubber_foot_insert_body() {
    straight_h = rubber_foot_insert_h - rubber_foot_insert_chamfer;
    top_scale =
        (rubber_foot_insert_size - 2 * rubber_foot_insert_chamfer)
        / rubber_foot_insert_size;

    translate([0, 0, rubber_foot_cap_h]) {
        if (straight_h > 0) {
            linear_extrude(height = straight_h)
                rubber_foot_rounded_square_2d(
                    rubber_foot_insert_size,
                    rubber_foot_insert_corner_r
                );
        }

        translate([0, 0, max(straight_h, 0)])
            linear_extrude(
                height = min(
                    rubber_foot_insert_chamfer,
                    rubber_foot_insert_h
                ),
                scale = top_scale
            )
                rubber_foot_rounded_square_2d(
                    rubber_foot_insert_size,
                    rubber_foot_insert_corner_r
                );
    }
}

module rubber_foot_grip_texture_2d() {
    grip_size = rubber_foot_cap_size - 2 * rubber_foot_grip_inset;
    line_span = rubber_foot_cap_size * 2;
    screw_p = rubber_foot_local_screw_point();

    difference() {
        intersection() {
            rubber_foot_rounded_square_2d(
                grip_size,
                max(
                    rubber_foot_cap_corner_r - rubber_foot_grip_inset,
                    0.4
                )
            );

            union() {
                for (angle = [-45, 45]) {
                    rotate(angle)
                        for (
                            offset_y = [
                                -line_span :
                                rubber_foot_grip_groove_pitch :
                                line_span
                            ]
                        ) {
                            translate([-line_span, offset_y])
                                square([
                                    line_span * 2,
                                    rubber_foot_grip_groove_w
                                ]);
                        }
                }
            }
        }

        translate(screw_p)
            circle(
                d = rubber_foot_screw_head_d
                    + 2 * rubber_foot_grip_screw_clearance,
                $fn = 48
            );
    }
}

module rubber_foot_grip_cutout() {
    translate([0, 0, -0.10])
        linear_extrude(height = rubber_foot_grip_groove_depth + 0.10)
            rubber_foot_grip_texture_2d();
}

module rubber_foot_screw_cutout() {
    p = rubber_foot_local_screw_point();
    total_h = rubber_foot_cap_h + rubber_foot_insert_h;

    // Full M2.5 clearance through the TPU foot.
    translate([p[0], p[1], -0.10])
        cylinder(
            h = total_h + 0.20,
            d = rubber_foot_screw_clearance_d,
            $fn = 40
        );

    // Recessed pan-head pocket in the exposed grip face.
    translate([p[0], p[1], -0.10])
        cylinder(
            h = rubber_foot_screw_head_depth + 0.10,
            d = rubber_foot_screw_head_d,
            $fn = 48
        );
}

module rubber_foot() {
    difference() {
        union() {
            linear_extrude(height = rubber_foot_cap_h)
                rubber_foot_rounded_square_2d(
                    rubber_foot_cap_size,
                    rubber_foot_cap_corner_r
                );

            rubber_foot_insert_body();
        }

        rubber_foot_screw_cutout();
        rubber_foot_grip_cutout();
    }
}

module rubber_feet_print() {
    pitch = rubber_foot_cap_size + rubber_foot_print_gap;

    // Four identical copies of the same foot design.
    for (index = [0 : 3]) {
        translate([
            (index % 2) * pitch,
            floor(index / 2) * pitch,
            0
        ])
            rubber_foot();
    }
}

module rubber_feet_installed_preview() {
    color("black", 0.75)
        for (index = [0 : 3]) {
            centre = rubber_foot_recess_centres[index];
            is_left = centre[0] < case_w / 2;

            translate([
                centre[0],
                -rubber_foot_cap_h,
                centre[1]
            ])
                rotate([-90, 0, 0])
                    rotate([0, 0, is_left ? 180 : 0])
                        rubber_foot();
        }
}

module rubber_foot_case_pilots() {
    for (p = rubber_foot_mount_points) {
        // Short pilot through only the existing exterior case wall.
        translate([p[0], -0.10, p[1]])
            rotate([-90, 0, 0])
                cylinder(
                    h = wall + 0.20,
                    d = rubber_foot_case_pilot_d,
                    $fn = 40
                );
    }
}

// Verify the shared fastener position stays inside the common foot, the case
// pilot layout is mirrored, and the right pilots remain clear of tool bores.
local_foot_screw_p = rubber_foot_local_screw_point();
assert(
    rubber_foot_insert_chamfer > 0
        && rubber_foot_insert_chamfer <= rubber_foot_insert_h,
    "The locating-layer chamfer must fit within the locating-layer height."
);
assert(
    rubber_foot_grip_groove_depth > 0
        && rubber_foot_grip_groove_depth < rubber_foot_cap_h,
    "The grip-groove depth must remain within the exposed foot cap."
);
assert(
    abs(local_foot_screw_p[0]) + rubber_foot_screw_head_d / 2
        <= rubber_foot_insert_size / 2,
    "The shared foot screw head pocket exceeds the locating insert boundary."
);
assert(
    abs(local_foot_screw_p[1]) + rubber_foot_screw_head_d / 2
        <= rubber_foot_insert_size / 2,
    "The shared foot screw head pocket exceeds the locating insert boundary."
);

assert(
    abs(
        rubber_foot_mount_points[0][0]
        + rubber_foot_mount_points[2][0]
        - case_w
    ) < 0.001,
    "The lower foot fasteners are not mirrored across the case centreline."
);
assert(
    abs(
        rubber_foot_mount_points[1][0]
        + rubber_foot_mount_points[3][0]
        - case_w
    ) < 0.001,
    "The upper foot fasteners are not mirrored across the case centreline."
);

for (mount_p = [rubber_foot_mount_points[2], rubber_foot_mount_points[3]]) {
    for (tool_p = touch_tool_access_points) {
        separation = sqrt(
            pow(mount_p[0] - tool_p[0], 2)
            + pow(mount_p[1] - tool_p[1], 2)
        );
        assert(
            separation
                > rubber_foot_screw_clearance_d / 2
                    + touch_tool_access_d / 2
                    + 0.50,
            "A foot fastener obstructs a touch-sensor screwdriver bore."
        );
    }
}


// -----------------------------------------------------------------------------
// FDM-safe circular touch helper
// -----------------------------------------------------------------------------

module control_feature_circle_slice(
    x_pos,
    y_pos,
    z_pos,
    slice_depth,
    diameter
) {
    translate([x_pos, y_pos, z_pos])
        rotate([-90, 0, 0])
            cylinder(
                h = slice_depth,
                d = diameter,
                $fn = touch_circle_fn
            );
}

module control_feature_upper_roof_slice(
    x_pos,
    y_pos,
    z_pos,
    slice_depth,
    diameter,
    roof_half_w,
    roof_rise
) {
    radius = diameter / 2;
    roof_base_z =
        z_pos + sqrt(max(pow(radius, 2) - pow(roof_half_w, 2), 0));
    roof_peak_z = z_pos + radius + roof_rise;

    union() {
        control_feature_circle_slice(
            x_pos,
            y_pos,
            z_pos,
            slice_depth,
            diameter
        );

        hull() {
            for (p = [
                [x_pos - roof_half_w, roof_base_z],
                [x_pos + roof_half_w, roof_base_z],
                [x_pos, roof_peak_z]
            ]) {
                translate([p[0], y_pos, p[1]])
                    rotate([-90, 0, 0])
                        cylinder(
                            h = slice_depth,
                            d = control_feature_seed_d,
                            $fn = 12
                        );
            }
        }
    }
}

module fdm_safe_circular_control_cutout(
    x_pos,
    z_pos,
    diameter,
    root_y,
    face_y,
    roof_rise
) {
    hull() {
        control_feature_upper_roof_slice(
            x_pos,
            root_y,
            z_pos,
            control_feature_slice_depth,
            diameter,
            control_feature_roof_half_w,
            roof_rise
        );

        control_feature_circle_slice(
            x_pos,
            face_y,
            z_pos,
            control_feature_slice_depth,
            diameter
        );
    }
}

// -----------------------------------------------------------------------------
// Transparent charm opening and matching flanged snap insert
// -----------------------------------------------------------------------------

module charm_bore_cutout() {
    translate([
        charm_center_x,
        charm_wall_y + charm_bore_overshoot,
        charm_center_z
    ])
        rotate([90, 0, 0])
            cylinder(
                h = wall + charm_bore_overshoot * 2,
                d = charm_bore_d,
                $fn = touch_circle_fn
            );
}

module charm_insert_local() {
    cap_body_h = charm_insert_cap_height - charm_insert_flange_t;
    cavity_start_z = -charm_insert_cap_height + charm_insert_top_t;
    cavity_cap_h = cap_body_h - charm_insert_top_t;

    difference() {
        union() {
            // Hollow visible cap. Front face is support-free when printed down.
            translate([0, 0, -charm_insert_cap_height])
                cylinder(
                    h = cap_body_h,
                    d1 = charm_insert_top_d,
                    d2 = charm_insert_body_d,
                    $fn = touch_circle_fn
                );

            // Broad exterior flange seals the visible bore edge.
            translate([0, 0, -charm_insert_flange_t])
                cylinder(
                    h = charm_insert_flange_t,
                    d1 = charm_insert_body_d,
                    d2 = charm_insert_flange_d,
                    $fn = touch_circle_fn
                );

            // Main locating and light-carrying stem.
            cylinder(
                h = charm_insert_stem_len,
                d = charm_insert_stem_d,
                $fn = touch_circle_fn
            );

            // Four small crush ribs create the confirmed snug v3.17 fit.
            for (angle = [45 : 90 : 315]) {
                rotate([0, 0, angle])
                    translate([
                        charm_insert_stem_d / 2 - 0.04,
                        -charm_insert_rib_w / 2,
                        charm_insert_rib_z0
                    ])
                        cube([
                            charm_insert_rib_h + 0.04,
                            charm_insert_rib_w,
                            charm_insert_rib_len
                        ]);
            }

            // Support-free retaining collar. The first taper supplies the
            // retention slope; the second taper is the insertion lead-in.
            translate([0, 0, charm_snap_shoulder_start])
                cylinder(
                    h = charm_snap_peak_z - charm_snap_shoulder_start,
                    d1 = charm_insert_stem_d,
                    d2 = charm_snap_max_d,
                    $fn = touch_circle_fn
                );

            translate([0, 0, charm_snap_peak_z])
                cylinder(
                    h = charm_insert_stem_len - charm_snap_peak_z,
                    d1 = charm_snap_max_d,
                    d2 = charm_snap_tip_d,
                    $fn = touch_circle_fn
                );
        }

        // Hollow light chamber through the cap and stem.
        translate([0, 0, cavity_start_z])
            cylinder(
                h = cavity_cap_h + 0.02,
                d1 = charm_insert_inner_front_d,
                d2 = charm_insert_stem_inner_d,
                $fn = touch_circle_fn
            );

        translate([0, 0, -charm_insert_flange_t - 0.02])
            cylinder(
                h = charm_insert_flange_t
                    + charm_insert_stem_len
                    + 0.24,
                d = charm_insert_stem_inner_d,
                $fn = touch_circle_fn
            );

        // One full-depth slot creates two flexible snap petals while leaving
        // the flange solid, continuous, and light-blocking.
        translate([
            -charm_snap_slot_w / 2,
            -charm_snap_max_d,
            charm_snap_slot_start
        ])
            cube([
                charm_snap_slot_w,
                charm_snap_max_d * 2,
                charm_insert_stem_len - charm_snap_slot_start + 0.20
            ]);
    }
}

module charm_insert_print() {
    translate([0, 0, charm_insert_cap_height])
        charm_insert_local();
}

module charm_insert_preview() {
    color([0.70, 0.90, 1.00], 0.52)
        translate([charm_center_x, charm_wall_y, charm_center_z])
            rotate([90, 0, 0])
                charm_insert_local();
}

// -----------------------------------------------------------------------------
// LED PCB inside-bottom-wall geometry
// -----------------------------------------------------------------------------

module led_pcb_rect_slice_from_bounds(
    x_left,
    x_right,
    z_bottom,
    z_top,
    y_pos,
    slice_depth
) {
    translate([x_left, y_pos, z_bottom])
        rounded_rect_prism_xz(
            [
                x_right - x_left,
                slice_depth,
                z_top - z_bottom
            ],
            clean_led_mount_r
        );
}

module led_pcb_mount_bodies() {
    render(convexity = 10)
        hull() {
            led_pcb_rect_slice_from_bounds(
                led_pcb_mount_face_left,
                led_pcb_mount_face_right,
                led_pcb_mount_bottom - led_pcb_grille_ramp_run,
                led_pcb_mount_top,
                wall - led_pcb_mount_overlap,
                led_pcb_hull_slice_h + led_pcb_mount_overlap
            );

            led_pcb_rect_slice_from_bounds(
                led_pcb_mount_face_left,
                led_pcb_mount_face_right,
                led_pcb_mount_bottom,
                led_pcb_mount_top,
                wall
                    + led_pcb_standoff_h
                    - led_pcb_hull_slice_h,
                led_pcb_hull_slice_h
            );
        }
}

module led_pcb_pilot_at(x_pos, z_pos) {
    translate([
        x_pos,
        wall + led_pcb_standoff_h + 0.05,
        z_pos
    ])
        rotate([90, 0, 0])
            cylinder(
                h = led_pcb_standoff_h + 1.05,
                d = led_pcb_pilot_d
            );

    translate([
        x_pos,
        wall + led_pcb_standoff_h + 0.10,
        z_pos
    ])
        rotate([90, 0, 0])
            cylinder(
                h = led_pcb_pilot_lead_h,
                d1 = led_pcb_pilot_lead_d,
                d2 = led_pcb_pilot_d
            );
}

module led_pcb_pilot_holes() {
    for (p = led_pcb_hole_positions)
        led_pcb_pilot_at(p[0], p[1]);
}

module led_pcb_preview() {
    pcb_y = wall + led_pcb_standoff_h;

    color("green", 0.35)
        translate([
            led_pcb_center_x - led_pcb_w / 2,
            pcb_y,
            led_pcb_center_z - led_pcb_h / 2
        ])
            cube([
                led_pcb_w,
                led_pcb_t,
                led_pcb_h
            ]);

    color("silver", 0.45)
        for (p = led_pcb_hole_positions) {
            translate([
                p[0],
                pcb_y + led_pcb_t,
                p[1]
            ])
                rotate([-90, 0, 0])
                    cylinder(h = 1.6, d = 4.2);
        }

    color([0.15, 0.45, 1.00], 0.65)
        translate([
            led_actual_center_x,
            pcb_y + led_pcb_t,
            led_actual_center_z
        ])
            rotate([-90, 0, 0])
                cylinder(h = led_preview_h, d = led_preview_d);

    color("black", 0.60)
        translate([
            led_pcb_center_x + led_pcb_w / 2 - led_header_w,
            pcb_y + led_pcb_t,
            led_pcb_center_z - led_header_h / 2
        ])
            cube([
                led_header_w,
                led_header_depth,
                led_header_h
            ]);

    color("gray", 0.55)
        for (z_shift = [-3.0, -1.0, 1.0, 3.0]) {
            translate([
                led_pcb_center_x + led_pcb_w / 2,
                pcb_y + led_pcb_t + led_header_depth / 2,
                led_pcb_center_z + z_shift
            ])
                rotate([0, 90, 0])
                    cylinder(
                        h = led_wire_preview_len,
                        d = led_wire_preview_d
                    );
        }
}


// -----------------------------------------------------------------------------
// Touch-sensor mounting geometry
// -----------------------------------------------------------------------------

module touch_mount_point(index, y_pos = case_h - wall - 1) {
    translate([
        touch_mount_points[index][0],
        y_pos,
        touch_mount_points[index][1]
    ]) children();
}

module touch_blind_pilot_at(x_pos, z_pos) {
    translate([
        x_pos,
        touch_panel_inner_y - 0.05,
        z_pos
    ])
        rotate([-90, 0, 0])
            cylinder(
                h = touch_mount_pilot_depth + 0.05,
                d = touch_mount_pilot_d
            );
}

module touch_sensor_mount_holes() {
    for (p = touch_mount_points)
        touch_blind_pilot_at(p[0], p[1]);
}

module touch_sensor_tool_access() {
    for (p = touch_tool_access_points) {
        translate([p[0], -1, p[1]])
            rotate([-90, 0, 0])
                cylinder(
                    h = wall + 2,
                    d = touch_tool_access_d
                );
    }
}

module touch_sensor_solder_pocket() {
    translate([
        touch_solder_center_x - touch_solder_x_size / 2,
        touch_panel_inner_y - 0.05,
        touch_solder_center_z - touch_solder_z_size / 2
    ])
        cube([
            touch_solder_x_size,
            touch_solder_clearance + 0.05,
            touch_solder_z_size
        ]);
}

module touch_sensor_smooth_recess() {
    // The visible 14mm circle is unchanged. A narrow concealed roof closes
    // progressively during printing while retaining a 1mm sensing skin.
    fdm_safe_circular_control_cutout(
        touch_pad_center_x,
        touch_pad_center_z,
        touch_button_d,
        case_h - touch_circle_recess_depth,
        case_h - touch_chamfer_depth - control_feature_slice_depth / 2,
        touch_recess_roof_rise
    );

    // Preserve the original smooth 0.4mm exterior entry chamfer.
    translate([
        touch_pad_center_x,
        case_h + 0.05,
        touch_pad_center_z
    ])
        rotate([90, 0, 0])
            cylinder(
                h = touch_chamfer_depth + 0.05,
                d1 = touch_chamfer_outer_d,
                d2 = touch_button_d,
                $fn = touch_circle_fn
            );
}

module touch_ring_slice(y_pos, radius, depth) {
    translate([touch_pad_center_x, y_pos, touch_pad_center_z])
        rotate([-90, 0, 0])
            cylinder(
                h = depth,
                r = radius,
                $fn = touch_surround_fn
            );
}

module touch_ring_frustum(root_radius, face_radius, inner = false) {
    // Outer root ends at the case exterior. The inner cutter extends slightly
    // beyond both ends to avoid coplanar CSG faces.
    root_y = inner
        ? case_h - fdm_union_overlap - 0.20
        : case_h - fdm_union_overlap;
    root_depth = inner
        ? fdm_union_overlap + 0.40
        : fdm_union_overlap;
    face_y = inner
        ? case_h + touch_surround_h - touch_surround_slice - 0.20
        : case_h + touch_surround_h - touch_surround_slice;
    face_depth = inner
        ? touch_surround_slice + 0.46
        : touch_surround_slice + 0.06;

    hull() {
        touch_ring_slice(root_y, root_radius, root_depth);
        touch_ring_slice(face_y, face_radius, face_depth);
    }
}

// Convex print mask whose lower face rises in Z as Y moves away from the case.
// It is extruded across X and used to chamfer the lower end of the crescent.
module fdm_rising_mask(
    x_min,
    x_max,
    y_min,
    y_max,
    z_at_wall,
    z_top,
    slope = 1
) {
    z_low_0 = z_at_wall + (y_min - case_h) * slope;
    z_low_1 = z_at_wall + (y_max - case_h) * slope;

    polyhedron(
        points = [
            [x_min, y_min, z_low_0],
            [x_max, y_min, z_low_0],
            [x_max, y_max, z_low_1],
            [x_min, y_max, z_low_1],
            [x_min, y_min, z_top],
            [x_max, y_min, z_top],
            [x_max, y_max, z_top],
            [x_min, y_max, z_top]
        ],
        faces = [
            [0, 3, 2, 1],
            [4, 5, 6, 7],
            [0, 1, 5, 4],
            [1, 2, 6, 5],
            [2, 3, 7, 6],
            [3, 0, 4, 7]
        ],
        convexity = 4
    );
}

module touch_short_crescent_mask() {
    // Keep the right side of the annular surround, stop just past both screws,
    // and slope only the lower end upward at 45 degrees for speaker-side-down
    // printing. The upper end needs no support because it closes upward.
    fdm_rising_mask(
        touch_pad_center_x,
        touch_pad_center_x + touch_outer_r_root + 3,
        case_h - fdm_union_overlap,
        case_h + touch_surround_h + touch_surround_slice,
        touch_crescent_z_min,
        touch_crescent_z_max + 2,
        touch_crescent_print_slope
    );
}

module touch_short_crescent() {
    intersection() {
        difference() {
            touch_ring_frustum(
                touch_outer_r_root,
                touch_outer_r_face
            );

            touch_ring_frustum(
                touch_inner_r_root,
                touch_inner_r_face,
                true
            );
        }

        touch_short_crescent_mask();
    }
}

module touch_bump_slice(y_pos, diameter, depth) {
    translate([touch_bump_x, y_pos, touch_bump_z])
        rotate([-90, 0, 0])
            cylinder(
                h = depth,
                d = diameter,
                $fn = touch_bump_fn
            );
}

module touch_left_screw_bump() {
    // The radius reduces by 1.6mm over a 1.6mm projection, creating a true
    // 45-degree lower surface in the speaker-side-down print orientation.
    hull() {
        touch_bump_slice(
            case_h - fdm_union_overlap,
            touch_bump_root_d,
            fdm_union_overlap
        );

        touch_bump_slice(
            case_h + touch_bump_h - touch_bump_slice,
            touch_bump_face_d,
            touch_bump_slice + 0.06
        );
    }
}

module touch_surround() {
    touch_short_crescent();
    touch_left_screw_bump();
}


// -----------------------------------------------------------------------------
// Case shell and lid supports
// -----------------------------------------------------------------------------

module case_shell() {
    difference() {
        rounded_cube([case_w, case_h, case_d], corner_r);

        translate([wall, wall, wall])
            rounded_cube(
                [
                    case_w - 2 * wall,
                    case_h - 2 * wall,
                    case_d + 1
                ],
                max(corner_r - wall, 0.5)
            );

        speaker_grill_holes();
        rubber_foot_recesses();
    }
}

module lid_corner_mount_block(p, reach_x, reach_y, zpos, block_h) {
    block_w = reach_x + lid_mount_wall_overlap;
    block_d = reach_y + lid_mount_wall_overlap;
    block_x =
        p[0] < case_w / 2
        ? wall - lid_mount_wall_overlap
        : case_w - wall - reach_x;
    block_y =
        p[1] < case_h / 2
        ? wall - lid_mount_wall_overlap
        : case_h - wall - reach_y;
    edge_r = min([
        clean_lid_mount_r,
        block_w / 2 - 0.01,
        block_d / 2 - 0.01
    ]);

    translate([block_x, block_y, zpos])
        rounded_cube(
            [block_w, block_d, block_h],
            max(edge_r, 0.10)
        );
}

module lid_corner_mount(p) {
    z0 = case_d - lid_mount_h;
    full_reach_x = lid_mount_reach_x(p);
    full_reach_y = lid_mount_reach_y(p);

    hull() {
        lid_corner_mount_block(
            p,
            lid_mount_base_reach,
            lid_mount_base_reach,
            z0,
            lid_mount_hull_slice_h
        );

        lid_corner_mount_block(
            p,
            full_reach_x,
            full_reach_y,
            z0 + lid_mount_grow_h - lid_mount_hull_slice_h,
            lid_mount_hull_slice_h
        );
    }

    lid_corner_mount_block(
        p,
        full_reach_x,
        full_reach_y,
        z0 + lid_mount_grow_h,
        lid_mount_top_h
    );
}

module lid_lip_corner_mount_relief(p, z0, zh) {
    reach_x = lid_mount_reach_x(p) + lid_mount_lip_clearance;
    reach_y = lid_mount_reach_y(p) + lid_mount_lip_clearance;

    if (p[0] < case_w / 2 && p[1] < case_h / 2) {
        translate([wall - 1.2, wall - 1.2, z0])
            cube([reach_x + 2.4, reach_y + 2.4, zh]);
    }
    else if (p[0] >= case_w / 2 && p[1] < case_h / 2) {
        translate([case_w - wall - reach_x - 1.2, wall - 1.2, z0])
            cube([reach_x + 2.4, reach_y + 2.4, zh]);
    }
    else if (p[0] < case_w / 2 && p[1] >= case_h / 2) {
        translate([wall - 1.2, case_h - wall - reach_y - 1.2, z0])
            cube([reach_x + 2.4, reach_y + 2.4, zh]);
    }
    else {
        translate([case_w - wall - reach_x - 1.2, case_h - wall - reach_y - 1.2, z0])
            cube([reach_x + 2.4, reach_y + 2.4, zh]);
    }
}

module lid_lip_mount_relief() {
    for (p = lid_points())
        lid_lip_corner_mount_relief(
            p,
            -lip_depth - 0.6,
            lip_depth + 1.2
        );
}

module lid() {
    difference() {
        union() {
            rounded_cube([case_w, case_h, lid_t], corner_r);
            lid_lip_ring();
            oled_solder_padding_pads();
            lid_part_number_text();
            lid_orientation_text();
        }

        lid_lip_mount_relief();

        oled_screen_cutout();
        oled_m3_lid_holes();

        for (p = lid_points()) {
            translate([p[0], p[1], -1])
                cylinder(h = lid_t + 2, d = lid_screw_d);

            translate([p[0], p[1], lid_t - lid_screw_head_recess_h])
                cylinder(
                    h = lid_screw_head_recess_h + 0.3,
                    d1 = lid_screw_d,
                    d2 = lid_screw_head_d
                );
        }
    }
}

// -----------------------------------------------------------------------------
// Base
// -----------------------------------------------------------------------------

module base_cutouts() {
    for (p = lid_points()) {
        translate([
            p[0],
            p[1],
            case_d - lid_mount_blind_pilot_depth
        ])
            cylinder(
                d = lid_mount_pilot_d,
                h = lid_mount_blind_pilot_depth + 0.2
            );

        translate([
            p[0],
            p[1],
            case_d - lid_mount_pilot_entry_h
        ])
            cylinder(
                d = lid_mount_pilot_entry_d,
                h = lid_mount_pilot_entry_h + 0.3
            );
    }

    touch_sensor_mount_holes();
    touch_sensor_tool_access();
    touch_sensor_solder_pocket();
    touch_sensor_smooth_recess();

    rubber_foot_case_pilots();

    charm_bore_cutout();

    led_pcb_pilot_holes();

    pi_three_pilot_holes();

    amp_mount_holes() {
        translate([0, 0, wall - 1])
            cylinder(
                h = amp_standoff_h + 2,
                d = amp_standoff_pilot_d
            );
    }

    speaker_mount_points() {
        translate([0, 0, wall - 1])
            cylinder(
                h = speaker_mount_h + 2,
                d = speaker_mount_pilot_d
            );
    }

    speaker_pocket_keepout();
    speaker_wire_relief_cutout();
}

module base() {
    difference() {
        union() {
            mirror_layout() {
                case_shell();
                touch_surround();
                led_pcb_mount_bodies();

                for (p = lid_points())
                    lid_corner_mount(p);

                speaker_acoustic_baffle();
                speaker_mount_supports();
                pi_standoff_gussets();
                amp_standoff_gussets();
                base_part_number_text();

                pi_mount_holes() {
                    translate([0, 0, wall])
                        cylinder(
                            h = pi_standoff_h,
                            d = pi_standoff_od
                        );
                }

                pi_upper_right_anchor();

                amp_mount_holes() {
                    translate([0, 0, wall])
                        cylinder(
                            h = amp_standoff_h,
                            d = amp_standoff_od
                        );
                }
            }

            // USB-C power is placed at its own coordinate (usb_c_panel_x,
            // which already accounts for layout_mirror) rather than being
            // wrapped in mirror_layout() — it relocates, it doesn't flip.
            usb_c_header_supports();
            usb_c_polarity_marks();
        }

        union() {
            mirror_layout() base_cutouts();
            usb_c_header_cutouts();
        }
    }
}

// -----------------------------------------------------------------------------
// FDM print orientations
// -----------------------------------------------------------------------------

module lid_print_orientation() {
    translate([case_w, 0, lid_t])
        rotate([0, 180, 0])
            lid();
}

// -----------------------------------------------------------------------------
// Assembly previews
// -----------------------------------------------------------------------------

module oled_preview() {
    lid_z = case_d + assembly_lid_lift;

    color("green", 0.35)
        translate([
            oled_x,
            oled_y,
            lid_z - oled_solder_joint_padding - oled_pcb_t
        ])
            cube([oled_pcb_w, oled_pcb_h, oled_pcb_t]);

    color("black", 0.65)
        translate([
            oled_screen_x,
            oled_screen_y,
            lid_z + lid_t - 0.03
        ])
            cube([oled_screen_w, oled_screen_h, 0.06]);

    color("gray", 0.35)
        translate([
            oled_view_x,
            oled_view_y,
            lid_z + lid_t + 0.02
        ])
            cube([oled_view_w, oled_view_h, 0.04]);

    oled_holes() {
        color("silver", 0.45)
            translate([0, 0, lid_z + lid_t + 0.05])
                cylinder(h = 0.6, d = oled_m3_head_preview_d);
    }
}

module pi_zero_preview() {
    color("green", 0.35)
        translate([pi_x, pi_y, wall + pi_standoff_h + 0.3])
            rounded_cube([pi_w, pi_h, 1.6], pi_corner_r);

    for (x = usb_centers_x) {
        color("silver", 0.55)
            translate([
                x - 4.5,
                pi_y + pi_h - 4,
                wall + pi_standoff_h + 2
            ])
                cube([9, 8, 7]);
    }

    color("silver", 0.25)
        translate([
            micro_hdmi_center_x - 5,
            pi_y + pi_h - 4,
            wall + pi_standoff_h + 2
        ])
            cube([10, 8, 5]);
}

module amp_preview() {
    color("blue", 0.35)
        translate([amp_x, amp_y, wall + amp_standoff_h + 0.3])
            rounded_cube([amp_w, amp_h, 1.6], amp_corner_r);
}

module usb_c_header_preview() {
    color("green", 0.35)
        translate([usb_c_panel_x, usb_c_panel_y, usb_c_panel_z])
            cube([
                usb_c_panel_w,
                usb_c_panel_h,
                usb_c_panel_depth
            ]);

    color("silver", 0.45)
        translate([
            usb_c_panel_center_x - usb_c_connector_preview_w / 2,
            usb_c_panel_center_y - usb_c_connector_preview_d / 2,
            usb_c_panel_depth
        ])
            cube([
                usb_c_connector_preview_w,
                usb_c_connector_preview_d,
                usb_c_connector_preview_h
            ]);
}

module touch_sensor_preview() {
    pcb_outer_face_y = touch_pcb_outer_face_y;
    pcb_inner_face_y = pcb_outer_face_y - touch_pcb_t;

    color("green", 0.35)
        translate([
            touch_center_x - touch_pcb_size / 2,
            pcb_inner_face_y,
            touch_center_z - touch_pcb_size / 2
        ])
            cube([
                touch_pcb_size,
                touch_pcb_t,
                touch_pcb_size
            ]);

    color("gold", 0.40)
        translate([
            touch_pad_center_x,
            pcb_outer_face_y + 0.02,
            touch_pad_center_z
        ])
            rotate([-90, 0, 0])
                cylinder(h = 0.08, d = touch_pad_d);

    color("silver", 0.55)
        translate([
            touch_solder_center_x - touch_solder_x_size / 2,
            touch_panel_inner_y,
            touch_solder_center_z - touch_solder_z_size / 2
        ])
            cube([
                touch_solder_x_size,
                touch_solder_clearance,
                touch_solder_z_size
            ]);

    color("silver", 0.45)
        for (i = [0 : len(touch_mount_points) - 1]) {
            touch_mount_point(
                i,
                pcb_inner_face_y - touch_screw_head_h
            ) {
                rotate([-90, 0, 0])
                    cylinder(
                        h = touch_screw_head_h,
                        d = touch_screw_head_d
                    );

                translate([0, touch_screw_head_h - 0.05, 0])
                    rotate([-90, 0, 0])
                        cylinder(
                            h = control_screw_length,
                            d = touch_screw_shank_d
                        );
            }
        }
}

module speaker_preview() {
    color("gray", 0.35)
        translate([
            speaker_center_x - speaker_w / 2,
            speaker_center_y - speaker_h / 2,
            wall + 0.15
        ])
            rounded_cube([speaker_w, speaker_h, 4.0], 2.0);
}

module assembly() {
    base();

    mirror_layout()
        translate([0, 0, case_d + assembly_lid_lift])
            lid();

    mirror_layout() {
        oled_preview();
        pi_zero_preview();
        amp_preview();
        touch_sensor_preview();
        charm_insert_preview();
        speaker_preview();
        led_pcb_preview();
        rubber_feet_installed_preview();
    }

    // USB-C power relocates via usb_c_panel_x, not mirror_layout() — matches
    // base().
    usb_c_header_preview();
}

// -----------------------------------------------------------------------------
// Output
// -----------------------------------------------------------------------------

// Mirrors about the case's own centre plane (not about X=0), so the part
// stays within its normal [0, case_w] footprint instead of jumping to
// negative X. A rigid mirror moves every X-based feature together, so it
// can't introduce new collisions that don't already exist in the unmirrored
// layout.
module mirror_layout() {
    if (layout_mirror) {
        translate([case_w, 0, 0])
            mirror([1, 0, 0])
                children();
    }
    else {
        children();
    }
}

if (part == "base") {
    base();
}

if (part == "lid") {
    mirror_layout() lid();
}

if (part == "lid_print") {
    mirror_layout() lid_print_orientation();
}

if (part == "assembly") {
    assembly();
}

if (part == "charm_insert") {
    charm_insert_print();
}

if (part == "rubber_foot") {
    rubber_foot();
}

if (part == "rubber_feet") {
    rubber_feet_print();
}
