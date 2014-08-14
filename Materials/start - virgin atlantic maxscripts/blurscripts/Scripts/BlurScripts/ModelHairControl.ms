-------------------------------------------------------------------------------
-- ModelHairControl.ms
-- By Brandon Davis (brandon@blur.com)
-- v 1.00
-- Created On: 01/19/01
-- Modified On:
-- tested using Max 3.1 and 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- Shag:Hair, http://www.digimation.com/
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Allows you to change parameters among selected Shag:Hair model hairs
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Variables

global ModelHairControl_floater
global CoordinateSystems_rollout
global InfluenceOptions_rollout

haircoordsys_value = 1
vert_transform_value = 0
gizmo_size_value = 20

check_mode = false

do_haircoordsys = false
do_vert_transform = false
do_gizmo_size = false




influence_value = 0
near_range_value = 20
far_range_value = 50
use_offset_value = false
absolute_value = 0
attraction_value = false

do_influence = false
do_near_range = false
do_far_range = false
do_use_offset = false
do_absolute = false
do_attraction = false



-- Functions

fn makeChanges obj =
(
	i = obj.modifiers[#Model_Hair]
	if the_index != 0 then
	(
		if check_mode == true then
		(
			if do_haircoordsys == true then i.Hair_Coordsys = haircoordsys_value
			if do_vert_transform == true then i.XForm_Type = vert_transform_value
			if do_gizmo_size == true then i.Gizmo_Size = gizmo_size_value
			if do_influence == true then i.Influence_Type = influence_value
			if do_near_range == true then i.Local_Inf_Near_Range = near_range_value
			if do_far_range == true then i.Local_Inf_Far_Range = far_range_value
			if do_use_offset == true then i.Use_Offset = use_offset_value
			if do_absolute == true then i.Mix_With_Absolute = absolute_value
			if do_attraction == true then i.Use_Attraction = attraction_value
		)
		else
		(		
			if do_haircoordsys == true then i.Hair_Coordsys = haircoordsys_value
			if do_vert_transform == true then i.XForm_Type = vert_transform_value
			if do_gizmo_size == true then i.Gizmo_Size = i.Gizmo_Size + gizmo_size_value
			if do_influence == true then i.Influence_Type = influence_value
			if do_near_range == true then i.Local_Inf_Near_Range = i.Local_Inf_Near_Range + near_range_value
			if do_far_range == true then i.Local_Inf_Far_Range = i.Local_Inf_Far_Range + far_range_value
			if do_use_offset == true then i.Use_Offset = use_offset_value
			if do_absolute == true then i.Mix_With_Absolute = i.Mix_With_Absolute + absolute_value
			if do_attraction == true then i.Use_Attraction = attraction_value
		)

	)
		
		
)		

-- The Script

rollout CoordinateSystems_rollout "Coordinate Systems"
(
	
	group "Hair Coordsys (Center, Oz)" 
(
	checkbutton pickhaircoordsys "" pos:[13,26] width:10 height:10 align:#left highlightColor:(color 0 255 0) across:2
	radiobuttons haircoordsys "" pos:[29,24] width:124 height:32 enabled:false labels:#("Mesh Vertex, Normal", "Curve Base, Tangent") columns:1
)
	
	Group "Hair -> Vertex Transform" 
(
	checkbutton pickvert_transform "" pos:[13,86] width:10 height:10 align:#left highlightColor:(color 0 255 0) across:2
	radiobuttons vert_transform "" pos:[31,84] width:63 height:32 enabled:false labels:#("XForm", "Rotation") columns:1 align:#left
)
	
	checkbutton pickgizmo_size "" pos:[13,127] width:10 height:10 align:#left highlightColor:(color 0 255 0) across:2 
	spinner gizmo_size "Gizmo Size" pos:[41,127] width:104 height:16 enabled:false range:[0,9999,20] fieldwidth:40 align:#left
	
	checkbutton absolutemode "Absolute Mode" width:150 highlightcolor:red
	button apply_changes "Apply" width:150 height:25
	
	
	on pickhaircoordsys changed state do
	(
		haircoordsys.enabled = state
		if pickhaircoordsys.checked == true then do_haircoordsys = true
		else do_haircoordsys = false
	)

	
	on haircoordsys changed state do 
	(
		if haircoordsys.state == 1 then haircoordsys_value = 1
		if haircoordsys.state == 2 then haircoordsys_value = 0
	)


	on pickvert_transform changed state do
	(
		vert_transform.enabled = state
		if pickvert_transform.checked == true then do_vert_transform = true
		else do_vert_transform = false
	)
		
	on vert_transform changed state do
	(
		if vert_transform.state == 1 then vert_transform_value = 0
		if vert_transform.state == 2 then vert_transform_value = 1
	)

	on pickgizmo_size changed state do
	(
		gizmo_size.enabled = state
		if pickgizmo_size.checked == true then do_gizmo_size = true
		else do_gizmo_size = false
	)	
		
	on gizmo_size changed val do
	(
		gizmo_size_value = val
	)	
	
	
	on absolutemode changed state do
	(
		check_mode = absolutemode.state
	)
	
	
	on apply_changes pressed do
	(
		for i in selection do
		(
			makeChanges i
		)
	)	
	
	
)	

rollout InfluenceOptions_rollout "Influence, Options, Align" 
(
	group "Influence"
(
	checkbutton pickinfluence "" pos:[13,26] width:10 height:10 highlightColor:(color 0 255 0) across:2 align:#left
	radiobuttons influence "" pos:[32,26] width:49 height:32 labels:#("Auto", "Local") default:1 columns:1 enabled:false
	
	
	label lab1 "Near Range" pos:[14,61] width:58 height:13 align:#left across:2
	label lab2 "Far Range" pos:[90,61] width:50 height:13 
	checkbutton pickranges "" pos:[13,79] width:10 height:10 highlightColor:(color 0 255 0) across:3 align:#left
	spinner near_range "" pos:[29,79] width:52 height:16 range:[0,9999,20] align:#left across:2 fieldwidth:40 enabled:false
	spinner far_range "" pos:[91,79] width:52 height:16 range:[0,9999,50] fieldwidth:40 enabled:false
)
	
	group "Options" 
(
	checkbutton pickoffset "" pos:[13,125] width:10 height:10 highlightColor:(color 0 255 0) across:2 align:#left
	checkbox use_offset "Use Offset" pos:[32,125] width:74 height:15 checked:false enabled:false
	checkbutton pickabsolute "" pos:[13,145] width:10 height:10 highlightColor:(color 0 255 0) across:2 align:#left
	spinner absolute_dir "Absolute Dir    " range:[-1,1,0] pos:[41,145] width:108 height:16 align:#right fieldwidth:40 enabled:false	
	checkbutton pickattraction "" pos:[13,166] width:10 height:10 highlightColor:(color 0 255 0) across:2 align:#left
	checkbox attraction "Attraction" pos:[32,166] width:69 height:15 checked:false enabled:false
	
)
	
	
	on pickinfluence changed state do
	(
		influence.enabled = state
		if pickinfluence.checked == true then do_influence = true
		else do_influence = false
	)

	
	on influence changed state do 
	(
		if influence.state == 1 then influence_value = 0
		if influence.state == 2 then influence_value = 2
	)

	on pickranges changed state do
	(
		near_range.enabled = state
		far_range.enabled = state
		if pickranges.checked == true then 
		(
			do_near_range = true
			do_far_range = true
		)
		else
		(
			do_near_range = false
			do_far_range = false
		)											
	)	
		
	on near_range changed val do
	(
		near_range_value = val
	)	

	on far_range changed val do
	(
		far_range_value = val
	)
		
		
		
	on pickoffset changed state do
	(
		use_offset.enabled = state
		if pickoffset.checked == true then do_use_offset = true
		else do_use_offset = false
	)
		
	on use_offset changed state do
	(
		use_offset_value = state
	)	
	
	on pickabsolute changed state do
	(
		absolute_dir.enabled = state
		if pickabsolute.checked == true then do_absolute = true
		else do_absolute = false
	)
	
	on absolute_dir changed val do
	(
		absolute_value = val
	)
		
	on pickattraction changed state do
	(
		attraction.enabled = state
		if pickattraction.checked == true then do_attraction = true
		else do_attraction = false
	)

	on attraction changed state do
	(
		attraction_value = state
	)
		
)

	
if ModelHairControl_floater != undefined then CloseRolloutFloater ModelHairControl_floater
ModelHairControl_floater = newRolloutFloater "ModelHairControl v1.00" 180 480
addRollout CoordinateSystems_rollout ModelHairControl_floater
addRollout InfluenceOptions_rollout ModelHairControl_floater
)
-------------------------------------------------------------------------------






