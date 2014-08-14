global libraryIcons=#(	
/*   Edit  */
	#("Editable_mesh",	"Max_Edit_Modifiers",	1),
	#("Patch",	"Max_Edit_Modifiers",	2),
	#("SplineShape",	"Max_Edit_Modifiers",	11),
	
	
/*   Cameras  */
	#("FreeCamera",	"Cameras",	2),
	#("TargetCamera",	"Cameras",	1),
	
	
/*   Compunds  */
	#("Morph",	"Compound",	1),
	#("Conform",	"Compound",	2),
	#("ShapeMerge",	"Compound",	3),
	#("Terrain",	"Compound",	4),
	#("Loft",	"Compound",	8),
	#("Scatter",	"Compound",	5),
	#("Connect",	"Compound",	6),
	#("Boolean2",	"Compound",	7),
	
	
/*   Helpers  */
	#("Targetobject",	"Helpers",	1),
	#("Dummy",	"Helpers",	1),
	#("Point",	"Helpers",	2),
	#("Protractor",	"Helpers",	3),
	#("Grid",	"Helpers",	4),
	#("Tape",	"Helpers",	5),
	#("Compass",	"Helpers",	6),
	#("BoxGizmo",	"AtmosApp",	1),
	#("CylGizmo",	"AtmosApp",	2),
	#("SphereGizmo",	"AtmosApp",	3),
	#("CamPoint",	"CamP",	1),
	
	
/*   Lights  */
	#("OmniLight",	"Lights",	3),
	#("Targetspot",	"Lights",	1),
	#("TargetDirectionalLight",	"Lights",	2),
	#("FreeSpot",	"Lights",	4),
	#("DirectionalLight",	"Lights",	5),
	#("Sunlight",	"Systems",	2),
	
	
/*   Modifiers  */
	#("Displace_NURBS",	"Max_Edit_Modifiers",	18),
	#("Displace_Mesh",	"Standard_Modifiers",	18),
	#("Bend",	"Standard_Modifiers",	1),
	#("Taper",	"Standard_Modifiers",	2),
	#("MeshSmooth",	"Standard_Modifiers",	19),
	#("Ripple",	"Standard_Modifiers",	9),
	#("Wave",	"Standard_Modifiers",	8),
	#("Edit_Mesh",	"Max_Edit_Modifiers",	1),
	#("Edit_Spline",	"Max_Edit_Modifiers",	11),
	#("Relax",	"Standard_Modifiers",	21),
	#("Edit_Patch",	"Max_Edit_Modifiers",	2),
	#("Twist",	"Standard_Modifiers",	4),
	#("Extrude",	"Standard_Modifiers",	13),
	#("Lathe",	"Standard_Modifiers",	14),
	#("Bevel",	"Standard_Modifiers",	17),
	#("Stretch",	"Standard_Modifiers",	5),
	#("Face_Extrude",	"Max_Edit_Modifiers",	5),
	#("optimize",	"Standard_Modifiers",	34),
	#("Displace",	"Standard_Modifiers",	18),
	#("Linked_xform",	"Standard_Modifiers",	32),
	#("Affect_Region",	"Standard_Modifiers",	15),
	#("Uvwmap",	"Material_Modifiers",	4),
	#("VolumeSelect",	"Max_Edit_Modifiers",	4),
	#("Materialmodifier",	"Material_Modifiers",	2),
	#("smooth",	"Standard_Modifiers",	23),
	#("Normalmodifier",	"Max_Edit_Modifiers",	6),
	#("Skin",	"Standard_Modifiers",	26),
	#("Unwrap_UVW",	"Material_Modifiers",	6),
	#("Push",	"Standard_Modifiers",	36),
	#("Trim_Extend",	"Max_Edit_Modifiers",	14),
	#("Squeeze",	"Standard_Modifiers",	5),
	#("DeleteSplineModifier",	"Max_Edit_Modifiers",	12),
	#("CrossSection",	"Surface_Tools",	1),
	#("surface",	"Surface_Tools",	2),
	#("Lattice",	"Max_Edit_Modifiers",	8),
	#("Fillet_Chamfer",	"Max_Edit_Modifiers",	13),
	#("Morpher",	"Standard_Modifiers",	24),
	#("Normalize_Spline",	"Max_Edit_Modifiers",	13),
	#("FFD_2x2x2",	"Standard_Modifiers",	10),
	#("FFD_4x4x4",	"Standard_Modifiers",	10),
	#("FFD_3x3x3",	"Standard_Modifiers",	10),
	#("CameraMap",	"Deform_Modifiers",	1),
	#("XForm",	"Standard_Modifiers",	31),
	#("slice",	"Standard_Modifiers",	30),
	#("FFD_Select",	"Standard_Modifiers",	12),
	#("Melt",	"Standard_Modifiers",	20),
	#("STL_Check",	"Standard_Modifiers",	33),
	#("Cap_Holes",	"Standard_Modifiers",	29),
	#("Preserve",	"Standard_Modifiers",	35),
	#("SplineSelect",	"Max_Edit_Modifiers",	10),
	#("MaterialByElement",	"Material_Modifiers",	3),
	#("UVW_Xform",	"Material_Modifiers",	5),
	#("PatchDeform",	"Deform_Modifiers",	3),
	#("NSurf_Sel",	"Max_Edit_Modifiers",	16),
	#("NCurve_Sel",	"Max_Edit_Modifiers",	15),
	#("VertexPaint",	"Standard_Modifiers",	37),
	#("Skew",	"Standard_Modifiers",	3),
	#("Mesh_Select",	"Max_Edit_Modifiers",	3),
	#("SurfDeform",	"Deform_Modifiers",	5),
	#("Disp_Approx",	"Max_Edit_Modifiers",	18),
	#("Bevel_Profile",	"Standard_Modifiers",	16),
	#("PathDeform",	"Deform_Modifiers",	7),
	#("FFDBox",	"Standard_Modifiers",	10),
	#("FFDCyl",	"Standard_Modifiers",	11),
	#("Tessellate",	"Max_Edit_Modifiers",	7),
	#("Spherify",	"Standard_Modifiers",	22),
	#("Flex",	"Standard_Modifiers",	27),
	#("Mirror",	"Standard_Modifiers",	28),
	#("DeleteMesh",	"Max_Edit_Modifiers",	9),
	#("Noisemodifier",	"Standard_Modifiers",	7),
	#("Surface_Mapper",	"NurbsSurface",	1),
	
	
/*   Nurbs  */
	#("Point_Curve",	"NURBScurve",	1),
	#("CV_Curve",	"NURBScurve",	2),
	
	
/*   Objects  */
	#("XrefObject",	"Helpers",	1),
	#("Spring",	"DynObj",	1),
	#("Damper",	"DynObj",	2),
	#("GeoSphere",	"Standard",	7),
	#("Box",	"standard",	 1),
	#("Sphere",	"standard",	 2),
	#("Cylinder",	"Standard",	3),
	#("Torus",	"Standard",	4),
	#("Torus_Knot",	"Extended",	7),
	#("Quadpatch",	"Patches",	1),
	#("Tripatch",	"Patches",	2),
	#("Tube",	"Standard",	8),
	#("Plane",	"Standard",	10),
	#("L_Ext",	"Extended",	10),
	#("Spindle",	"Extended",	4),
	#("ChamferBox",	"Extended",	2),
	#("OilTank",	"Extended",	3),
	#("RingWave",	"Extended",	6),
	#("C_Ext",	"Extended",	11),
	#("Gengon",	"Extended",	5),
	#("Prism",	"Extended",	12),
	#("Capsule",	"Extended",	9),
	#("Point_Surf",	"NURBSSurface",	1),
	#("CV_Surf",	"NURBSSurface",	2),
	#("Pyramid",	"Standard",	9),
	#("ChamferCyl",	"Extended",	8),
	#("Cone",	"Standard",	6),
	#("Teapot",	"Standard",	5),
	#("Hedra",	"Extended",	1),
	#("PArray",	"Particles",	3),
	#("PCloud",	"Particles",	6),
	#("Blizzard",	"Particles",	5),
	#("SuperSpray",	"Particles",	2),
	#("Spray",	"Particles",	1),
	#("Snow",	"Particles",	4),
	#("NURBSSurf",	"NurbsSurface",	1),
	
	
/*  Shapes  */
	#("Line",	"Splines",	1),
	#("Circle",	"Splines",	2),
	#("Arc",	"Splines",	3),
	#("Ngon",	"Splines",	4),
	#("Text",	"Splines",	5),
	#("Rectangle",	"Splines",	7),
	#("Ellipse",	"Splines",	8),
	#("Donut",	"Splines",	9),
	#("Star",	"Splines",	10),
	#("Helix",	"Splines",	11),
	#("Section",	"Splines",	6),
	
	
/*  SpaceWarps  */
	#("SpaceBend",	"SW_ModBased",	1),
	#("SpaceTaper",	"SW_ModBased",	2),
	#("SpaceNoise",	"SW_ModBased",	3),
	#("SpaceTwist",	"SW_ModBased",	4),
	#("SpaceSkew",	"SW_ModBased",	5),
	#("SpaceStretch",	"SW_ModBased",	6),
	#("SpaceRipple",	"SW_GeoDef",	6),
	#("Motor",	"SW_PartDyn",	3),
	#("PBomb",	"SW_PartDyn",	4),
	#("PushSpaceWarp",	"SW_PartDyn",	5),
	#("Pin",	"SW_DynInt",	1),
	#("SDynaFlect",	"SW_DynInt",	2),
	#("PDynaFlect",	"SW_DynInt",	3),
	#("UDynaFlect",	"SW_DynInt",	4),
	#("POmniFlect",	"SW_PartOnly",	1),
	#("UOmniFlect",	"SW_PartOnly",	2),
	#("SOmniFlect",	"SW_PartOnly",	5),
	#("SDeflector",	"SW_PartOnly",	6),
	#("UDeflector",	"SW_PartOnly",	7),
	#("SpaceWave",	"SW_GeoDef",	2),
	#("SpacePathDeform",	"SW_PartOnly",	3),
	#("Gravity",	"SW_PartDyn",	1),
	#("Wind",	"SW_PartDyn",	2),
	#("SpaceDisplace",	"SW_GeoDef",	3),
	#("Deflector",	"SW_Partonly",	4),
	#("Bomb",	"SW_PartDyn",	4),
	#("MapScaler",	"Material_modifiers",	5),
	#("SpaceCameraMap",	"Deform_Modifiers",	2),
	#("ConformSpacewarp",	"SW_GeoDef",	7),
	#("SpacePatchDeform",	"Deform_Modifiers",	3),
	#("SpaceSurfDeform",	"Deform_Modifiers",	6),
	#("NURBS_Mesher",	"Max_Edit_Modifiers",	18),
	#("SurfaceMapper",	"Max_Edit_Modifiers",	17),
	#("Path_Follow",	"SW_Partonly",	3),
	
	
/*  Systems  */
	#("Bone",	"Systems",	1),
	#("BoneGeometry",	"Systems",	1),
	#("IK_Chain_Object",	"Systems",	1),
	
	
/*   Controllers  */
	#("prs",	"TrackViewIcons",	26),
	#("IKControl",	"TrackViewIcons",	28),
	#("IKChainControl",	"TrackViewIcons",	28),
	#("lookat",	"TrackViewIcons",	29),
	
	
	#("linear_float",	"TrackViewIcons",	23),
	#("bezier_float",	"TrackViewIcons",	22),
	#("tcb_float",	"TrackViewIcons",	30),
	#("float_list",	"TrackViewIcons",	31),
	#("boolean_float",	"TrackViewIcons",	32),
	#("boolean_controller",	"TrackViewIcons",	32),
	#("on_Off",	"TrackViewIcons",	32),
	
	
	#("bezier_point3",	"TrackViewIcons",	21),
	#("tcb_point3",	"TrackViewIcons",	30),
	#("point3_list",	"TrackViewIcons",	31),
	#("bezier_color",	"TrackViewIcons",	25),
	#("point3_XYZ",	"TrackViewIcons",	21),
	#("Color_RGB",	"TrackViewIcons",	25),
	
	
	#("linear_position",	"TrackViewIcons",	18),
	#("bezier_position",	"TrackViewIcons",	18),
	#("tcb_position",	"TrackViewIcons",	30),
	#("position_list",	"TrackViewIcons",	31),
	#("surface_position",	"TrackViewIcons",	29),
	#("Attachment",	"TrackViewIcons",	29),
	#("Position_XYZ",	"TrackViewIcons",	18),
	
	
	
	#("linear_rotation",	"TrackViewIcons",	19),
	#("bezier_rotation",	"TrackViewIcons",	19),
	#("tcb_rotation",	"TrackViewIcons",	30),
	#("rotation_list",	"TrackViewIcons",	31),
	#("Euler_XYZ",	"TrackViewIcons",	19),
	#("Smooth_Rotation",	"TrackViewIcons",	19),
	
	
	#("linear_scale",	"TrackViewIcons",	20),
	#("bezier_scale",	"TrackViewIcons",	20),
	#("tcb_scale",	"TrackViewIcons",	30),
	#("scale_list",	"TrackViewIcons",	31),
	#("ScaleXYZ",	"TrackViewIcons",	21),
	
	
	#("noise_float",	"TrackViewIcons",	34),
	#("noise_pos",	"TrackViewIcons",	34),
	#("noise_point3",	"TrackViewIcons",	34),
	#("noise_scale",	"TrackViewIcons",	34),
	#("noise_rotation",	"TrackViewIcons",	34),
	#("noise_position",	"TrackViewIcons",	34),
	
	
	#("float_script",	"TrackViewIcons",	35),
	#("position_script",	"TrackViewIcons",	35),
	#("point3_script",	"TrackViewIcons",	35),
	#("rotation_script",	"TrackViewIcons",	35),
	#("scale_script",	"TrackViewIcons",	35),
	#("transform_script",	"TrackViewIcons",	35),
	
	
	#("float_reactor",	"TrackViewIcons",	36),
	#("position_reactor",	"TrackViewIcons",	36),
	#("rotation_reactor",	"TrackViewIcons",	36),
	#("point3_reactor",	"TrackViewIcons",	36),
	#("scale_reactor",	"TrackViewIcons",	36),
	
	
	#("PositionSpring",	"TrackViewIcons",	37),
	#("Point3Spring",	"TrackViewIcons",	37),
	
	
	#("position_Constraint",	"TrackViewIcons",	29),
	#("orientation_constraint",	"TrackViewIcons",	29),
	#("lookat_constraint",	"TrackViewIcons",	29),
	#("link_constraint",	"TrackViewIcons",	29),
	#("path_constraint",	"TrackViewIcons",	29),
	
	
	#("Position_expression",	"TrackViewIcons",	38),
	#("Point3_Expression",	"TrackViewIcons",	38),
	#("Float_Expression",	"TrackViewIcons",	38),
	#("Scale_Expression",	"TrackViewIcons",	38),
	
	
	#("AudioPosition",	"TrackViewIcons",	39),
	#("AudioRotation",	"TrackViewIcons",	39),
	#("Audiofloat",	"TrackViewIcons",	39),
	#("AudioPoint3",	"TrackViewIcons",	39),
	#("AudioScale",	"TrackViewIcons",	39),
	
	
	#("Rotation_Wire",	"TrackViewIcons",	40),
	#("Point3_Wire",	"TrackViewIcons",	40),
	#("Float_Wire",	"TrackViewIcons",	40),
	#("Position_Wire",	"TrackViewIcons",	40),
	#("Scale_Wire ",	"TrackViewIcons",	40),
	
	
	#("Point3_Motion_Capture",	"TrackViewIcons",	41),
	#("Float_Motion_Capture",	"TrackViewIcons",	41),
	#("Scale_Motion_Capture",	"TrackViewIcons",	41),
	#("Rotation_Motion_Capture",	"TrackViewIcons",	41),
	#("Position_Motion_Capture",	"TrackViewIcons",	41),
	
	
	#("Waveform_Float",	"TrackViewIcons",	42)
)
/*
fn listIconCats =
(
	local cat, catArr=#()
	for d in libraryIcons do
	(
		cat = d[2]
		if findItem catArr cat == 0 then append catArr cat
	)
	catArr = sort catArr
	for c in catArr do format "%\n" c
)
*/