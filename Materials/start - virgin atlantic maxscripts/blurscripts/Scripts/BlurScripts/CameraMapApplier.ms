-------------------------------------------------------------------------------
-- CameraMapApplier.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 10/17/01
-- Modified On: 10/29/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Applies the camera map modifier to all selected objects, and applies
-- parameters to them. Useful because if you apply an instance of the camera
-- map modifier to a bunch of objects, the map isn't ligned up properly, and
-- it takes too much time assigning individual camera map modifiers to several 
-- objects.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global start_cma

global cma_rollout
global cma_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

the_cam = $Camera01
mapping_channel_value = 1

-- Functions

fn start_cma = 
(
	objects_done = #()
	for i in selection do
	(
		if contains_instance objects_done i == false then
		(
			if superclassof i == GeometryClass then
			(
				if validmodifier i (CameraMap ()) then 
				(
					addmodifier i (CameraMap ())
					i.modifiers[1].cameraNode = the_cam
					i.modifiers[1].channel = mapping_channel_value
				)
			)
		)
		append objects_done i
	)
)

-- The Script

rollout cma_rollout "CameraMapApplier"
(
	group "Parameters"
(
	label what_camera "None" align:#center
	pickbutton pickthecamera "Pick The Camera" width:160 align:#center toolTip:"Pick The Camera" filter:camera_filter
	spinner mapping_channel_value_spinner "Mapping Channel:" range:[1,99,1] fieldWidth:50 type:#integer align:#center
)
	on pickthecamera picked obj do 
	(
		the_cam = obj
		what_camera.text = obj.name
	)
	on mapping_channel_value_spinner changed val do mapping_channel_value = val

	button cma_apply "Apply To Selection" width:160 align:#center toolTip:"Apply To Selection"
	on cma_apply pressed do 
	(
		if isdeleted the_cam == false then start_cma()
		else (MessageBox "Your camera appears to no longer be in this scene, please pick a new camera." title:"CameraMapApplier")
	)
)

if cma_floater != undefined then CloseRolloutFloater cma_floater
cma_floater = newRolloutFloater "CameraMapApplier v1.00" 215 186
addRollout cma_rollout cma_floater
)
-------------------------------------------------------------------------------