-------------------------------------------------------------------------------
-- Planter.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.11
-- Created On: 05/26/01
-- Modified On: 03/26/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes a selection of objects and aligns them to a ground object. Good for
-- taking rocks and scattering them on an uneven ground surface, etc.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Instructions:
-- Take all the objects you want to align to your ground surface, and move them 
-- somewhere above the surface, make sure they're all selected, then pick your
-- ground object and hit the "Plant Selected Objects" button. Objects are placed
-- such that their pivot point matches the position of the first face it sees from
-- the z direction.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Takes a selection of objects and aligns them to a ground object. Good for
-- taking rocks and scattering them on an uneven ground surface, etc.
--
-- v 1.10 Added a progress bar. Also, you can now choose the direction of the
-- plant, for example, if you want to place your selected objects on the ceiling,
-- change the checkbutton to Up, or if you want them on the floor, press Down.
--
-- v 1.11 Fixed a bug, turns out I was calculating the scene bounding box for
-- every object being planted, instead of just once at the beginning which is all
-- that's needed. Thanks to Jeff Hanna for the find. Did some general script 
-- cleanup. Now prints the number of errors that occured.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global ground_obj
global pl_down = true

global plant_em

global pl_floater
global pl_rollout

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

-- Functions

fn plant_em = 
	(
	progressStart "Planter"
	escapeEnable = false
	itemnum = selection.count
	
	pl_errors = 0
	
	curiter = 0
	high_z = (get_scene_bbox())[1].z + 100
	low_z = (get_scene_bbox())[2].z - 100
	
	for i in selection do
		(
		curiter += 1
		m = ((curiter as float)/(itemnum as float))*100
		
		local ray_pos
		local s
		
		if pl_down == true then 
			(
			ray_pos = [i.pos.x, i.pos.y, high_z]
			s = intersectray ground_obj (ray ray_pos [0,0,-1])
			)
		else 
			(
			ray_pos = [i.pos.x, i.pos.y, low_z]
			s = intersectray ground_obj (ray ray_pos [0,0,1])
			)
		
		if s == undefined then pl_errors += 1 else i.pos = s.pos
		progressUpdate m
		)
		
	progressEnd()
	if pl_errors > 0 then 
		(
		to_print = (pl_errors as string) + " object(s) in your selection were not directly above or below the ground object, and their positions were not modified"
		MessageBox to_print title:"Planter"
		print to_print
		)
	)
	
-- Script

rollout pl_rollout "Planter"
	(
	group "Ground Object"
	(
	label what_ground "None" align:#center

	pickbutton pickground "Pick The Ground Object" width:150 toolTip:"Pick The Ground Object" filter:geometry_filter across:2 align:#left
	Checkbutton updown "Down" width:40 highlightcolor:([255,255,0] as color) tooltip:"Up or Down" align:#right
	)
	on pickground picked obj do 
		(
		ground_obj = obj
		what_ground.text = obj.name
		)
		
	on updown changed state do 
		(
		if state == on then 
			(
			pl_down = false
			updown.text = "Up"
			)
		else 
			(
			pl_down = true
			updown.text = "Down"
			)
		)

	button doit "Plant Selected Objects" width:196 align:#center toolTip:"Plant Selected Objects"
	on doit pressed do 
		(
		if ground_obj == undefined then (MessageBox "Please pick a ground object" title:"Planter")
		else
			(
			if selection.count == 0 then (MessageBox "Please select some object to be planted" title:"Planter")
			else 
				(
				if isdeleted ground_obj == true then MessageBox "Your ground object no longer seems to exist, please pick a new object" title:"Planter"
				else plant_em()
				)
			)
		)
	)

if pl_floater != undefined then CloseRolloutFloater pl_floater
pl_floater = newRolloutFloater "Planter v1.11" 250 164
addRollout pl_rollout pl_floater
)
-------------------------------------------------------------------------------