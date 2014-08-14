-------------------------------------------------------------------------------
-- CameraControl.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 03/01/02
-- Modified On: 03/01/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Changes Camera settings for several cameras at the same time.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global ccon_update_cameras
global ccon_do_to_selected_cameras

global ccon_rollout
global ccon_floater

-- Variables

do_envshow_value = false
do_nearrange_value = false
do_farrange_value = false
do_clip_value = false
do_nearclip_value = false
do_farclip_value = false

envshow_value = false
nearrange_spinner_value = 0
farrange_spinner_value = 1000
clip_value = true
nearclip_spinner_value = 1
farclip_spinner_value = 1000

-- Functions

fn ccon_update_cameras the_cam = 
(
	if do_envshow_value == true then the_cam.showRanges = envshow_value
		if do_nearrange_value == true then the_cam.nearrange = nearrange_spinner_value
		if do_farrange_value == true then the_cam.farrange = farrange_spinner_value	
		
		if farclip_spinner_value < nearclip_spinner_value then 
		(
			temp = nearclip_spinner_value
			nearclip_spinner_value = farclip_spinner_value
			farclip_spinner_value = temp
		)
		if do_clip_value == true then the_cam.clipManually = clip_value
		if do_nearclip_value == true then the_cam.nearclip = nearclip_spinner_value
		if do_farclip_value == true then the_cam.farclip = farclip_spinner_value
)

fn ccon_do_to_selected_cameras = 
(
	if $ == undefined then (MessageBox "Please select at least one camera" title:"CameraControl")
	else
	(
		for i in selection do
		(
			if superclassof i == Camera then ccon_update_cameras i
		)
	)
)

-- The Script

rollout ccon_rollout "CameraControl"
(
	group "Environment Ranges"
(
	checkbox do_envshow "" across:2
	checkbox envshow_checkbox "Show" enabled:do_envshow_value checked:envshow_value
	checkbox do_nearrange "" across:2
	spinner nearrange_spinner "Near Range:" range:[0,999999,nearrange_spinner_value] fieldWidth:65 enabled:do_nearrange_value type:#worldunits
	checkbox do_farrange "" across:2
	spinner farrange_spinner "Far Range:" range:[0,999999,farrange_spinner_value] fieldWidth:65 enabled:do_farrange_value type:#worldunits
)
	
	on do_envshow changed state do 
	(
		envshow_checkbox.enabled = state
		do_envshow_value = state
	)
	on envshow_checkbox changed state do 
	(
		envshow_value = state
	)
	on do_nearrange changed state do 
	(
		nearrange_spinner.enabled = state
		do_nearrange_value = state
	)
	on nearrange_spinner changed val do nearrange_spinner_value = val
	on do_farrange changed state do 
	(
		farrange_spinner.enabled = state
		do_farrange_value = state
	)
	on farrange_spinner changed val do farrange_spinner_value = val
	
	group "Clipping Planes"
(
	checkbox do_clip "" across:2
	checkbox clip_checkbox "Clip Manually?" enabled:do_clip_value checked:clip_value
	checkbox do_nearclip "" across:2
	spinner nearclip_spinner "Near Clip:" range:[0,10000000,nearclip_spinner_value] fieldWidth:65 enabled:do_nearclip_value type:#worldunits
	checkbox do_farclip "" across:2
	spinner farclip_spinner "Far Clip:" range:[0,10000000,farclip_spinner_value] fieldWidth:65 enabled:do_farclip_value type:#worldunits
)
	
	on do_clip changed state do 
	(
		clip_checkbox.enabled = state
		do_clip_value = state
	)
	on clip_checkbox changed state do 
	(
		clip_value = state
	)
	on do_nearclip changed state do 
	(
		nearclip_spinner.enabled = state
		do_nearclip_value = state
	)
	on nearclip_spinner changed val do nearclip_spinner_value = val
	on do_farclip changed state do 
	(
		farclip_spinner.enabled = state
		do_farclip_value = state
	)
	on farclip_spinner changed val do farclip_spinner_value = val

	group "Update Parameters"
	(
		button buttonupdate "Update Parameters" width:170 align:#center toolTip:"Update Parameters"
	)
		on buttonupdate pressed do 
		(
--			print envshow_value
--			print nearrange_spinner_value
--			print farrange_spinner_value
--			print clip_value
--			print nearclip_spinner_value
--			print farclip_spinner_value
			ccon_do_to_selected_cameras()
		)
)

if ccon_floater != undefined then CloseRolloutFloater ccon_floater
ccon_floater = newRolloutFloater "CameraControl v1.00" 230 295
addRollout ccon_rollout ccon_floater
)
-------------------------------------------------------------------------------