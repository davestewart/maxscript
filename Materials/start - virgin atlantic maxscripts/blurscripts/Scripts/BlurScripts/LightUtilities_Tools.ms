-------------------------------------------------------------------------------
-- LightUtilities_Tools.ms
-- v 2.91
-- Required File For LightUtilities.ms and LightControl.ms
-------------------------------------------------------------------------------
(
-- Functions

fn lut_lights_on_off answer =
	(
	if has_scene_changed() == false then 
		(
		undo "LightUtilities" on
			(
			for s in lu_operation_on_what() do s.enabled = answer
			luct_full_update()
			)
		)
	)
	
fn lut_sselect_oselect =
	(
	if has_scene_changed() == false then 
		(
		undo "LightUtilities" on
			(
			o_selected_lights = all_lights "selected"
			luct_full_update()
			)
		)
	)

fn lut_deletelights = 
	(
	if has_scene_changed() == false then 
		(
		undo "LightUtilities" on
			(
			for s in lu_operation_on_what() do delete s
			luct_full_update()
			)
		)
	)

fn lut_isolate_lights =
	(
	if has_scene_changed() == false then 
		(
		undo "LightUtilities" on
			(
			disableSceneRedraw()
			try
				(
				for l in lights do
					(
					unhide l
					selectmore l
					)
				max hide inv
				max select none
				)
			catch()
			enableSceneRedraw()
			completeRedraw()
			)
		)
	)
	
fn luct_run_seperate_script a = 
	(
	if has_scene_changed() == false then 
		(
		undo "LightUtilities" on
			(
			try
				(
				execute (openfile (((getdir #scripts) + "\\BlurScripts\\" + a + ".ms") as string))
				)
			catch
				(
				MessageBox "Can't find the script you're trying to run, please make sure you have installed the full BSPack." title:"LightUtilities"
				)
			)
		)
	)

-- Rollouts

rollout lut_rollout "LightTools"
	(
	button lights_on_button "On" width:94 align:#left toolTip:"Turn Lights On" across:2
	button lights_off_button "Off" width:94 align:#right toolTip:"Turn Lights Off"
	button sselect_oselect_button "Scene S -> O-S" width:94 align:#left toolTip:"Convert Scene Selection to O-Selection" across:2
	button deletelights_button "Delete" width:94 align:#right toolTip:"Delete Lights"
	button isolate_lights_button "Isolate" width:94 align:#left toolTip:"Isolate Lights" across:2
	button show_lights_button "ShowLights" width:94 align:#right toolTip:"ShowLights"

	button liecp_button "LightIECopyPaste" width:94 align:#left toolTip:"LightIncludeExcludeCopyPaste" across:2
	button sblie_button "SelectByLightIE" width:94 align:#right toolTip:"SelectByLightIncludeExclude"
	button sel_inst_button "SelectInstances" width:94 align:#left toolTip:"SelectInstances" across:2
	button thp_button "Three Point" width:94 align:#right toolTip:"Three Point"
	button tarsync_button "TargetSync" width:94 align:#left toolTip:"TargetSync" across:2
	button wim_button "WhoIncludesMe" width:94 align:#right toolTip:"WhoIncludesMe"

	on lights_on_button pressed do lut_lights_on_off true
	on lights_off_button pressed do lut_lights_on_off false
	on sselect_oselect_button pressed do lut_sselect_oselect()
	on deletelights_button pressed do lut_deletelights()
	on isolate_lights_button pressed do lut_isolate_lights()
	on show_lights_button pressed do show_lights()

	on liecp_button pressed do luct_run_seperate_script "LightIncludeExcludeManager"
	on sblie_button pressed do luct_run_seperate_script "SelectByLightIncludeExclude"
	on sel_inst_button pressed do 
		(
		select (lu_operation_on_what())
		luct_run_seperate_script "SelectInstances"
		)
	on thp_button pressed do luct_run_seperate_script "ThreePoint"
	on tarsync_button pressed do luct_run_seperate_script "TargetSync"
	on wim_button pressed do luct_run_seperate_script "WhoIncludesMe"
	)
)
-------------------------------------------------------------------------------