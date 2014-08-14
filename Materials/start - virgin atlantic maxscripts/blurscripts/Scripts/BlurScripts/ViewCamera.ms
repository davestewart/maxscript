-------------------------------------------------------------------------------
-- ViewCamera.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.14
-- Created On: 05/08/01
-- Modified On: 02/11/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Lets you change your active view to any camera you wish. This has several
-- advantages over the current change viewport to camera options in max. First,
-- the list it offers is alphebetical. There's also more room horizontally
-- to see the full name of the camera. And it also resizes itself to the number
-- of cameras present, so avoiding unnecessary scrolling.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Lets you change your active view to any camera you wish. This has several
-- advantages over the current change viewport to camera options in max. First,
-- the list it offers is alphebetical. There's also more room horizontally
-- to see the full name of the camera. And it also resizes itself to the number
-- of cameras present, so avoiding unnecessary scrolling.
--
-- v 1.10 Now defaults to the camera currently in your viewport when it brings
-- up the list. Also uses the BSLib function all_cameras.
--
-- v 1.11 A bug was fixed in 4.2 that lets the dialogue box be modal now.
--
-- v 1.12 Cleaned some code.
--
-- v 1.13 Now if there's only one camera in the scene, running the script
-- will automatically switch to that camera view.
--
-- v 1.14 Added an apply button that will switch the camera view but not 
-- destroy the dialogue.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global collect_cams
global dialogue_height
global find_cur_cam
global vc_ok
global vc_cancel
global vc_apply

global vc_rollout

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

scene_cams = #()
scene_cams_names = #()
cam_to_use = 1
height_value = undefined

-- Functions

fn collect_cams = 
	(
	for c in all_cameras() do
		(
		if camera_filter c == true then append scene_cams c
		)
	qsort scene_cams name_compare_case_insensitive
	for c in scene_cams do append scene_cams_names c.name
	)
	
fn dialogue_height = 
	(
	height_value = ((13*scene_cams_names.count) + 40)
	if height_value > systemTools.GetScreenHeight() then height_value = (systemTools.GetScreenHeight() - 20)
	)
	
fn find_cur_cam = 
	(
	if viewport.getCamera() != undefined then cam_to_use = finditem scene_cams (viewport.getCamera())
	)
	
fn vc_ok = 
	(
	disableSceneRedraw()
	viewport.setCamera scene_cams[cam_to_use]
	destroydialog vc_rollout
	enableSceneRedraw()
	redrawViews()
	)
	
fn vc_cancel = 
	(
	destroydialog vc_rollout
	)
	
fn vc_apply = 
	(
	disableSceneRedraw()
	viewport.setCamera scene_cams[cam_to_use]
	enableSceneRedraw()
	redrawViews()
	)

-- Rollouts

rollout vc_rollout "ViewCamera v1.14" 
	(
	listbox selc items:scene_cams_names height:scene_cams_names.count selection:cam_to_use

	on selc selected i do cam_to_use = i
	on selc doubleClicked i do vc_ok()

	button vc_button_ok "Ok" width:72 align:#center toolTip:"Ok" across:3
	button vc_button_cancel "Cancel" width:72 align:#center toolTip:"Cancel"
	button vc_button_apply "Apply" width:72 align:#center toolTip:"Apply"
	
	on vc_button_ok pressed do vc_ok()
	on vc_button_cancel pressed do vc_cancel()
	on vc_button_apply pressed do vc_apply()
	)

-- Script

collect_cams()
dialogue_height()
find_cur_cam()
if scene_cams.count == 0 then (MessageBox "No Cameras In Scene" title:"ViewCamera")
else 
	(
	if scene_cams.count == 1 then vc_ok()
	else createDialog vc_rollout width:250 height:height_value modal:true
	)
)
-------------------------------------------------------------------------------