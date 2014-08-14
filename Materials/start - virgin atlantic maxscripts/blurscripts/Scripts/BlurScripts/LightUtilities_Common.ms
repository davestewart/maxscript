-------------------------------------------------------------------------------
-- LightUtilities_Common.ms
-- v 2.91
-- Required File For LightUtilities.ms and LightControl.ms
-------------------------------------------------------------------------------
(
-- Functions

fn has_scene_changed = 
(
	luct_update_scene()
	if compare_array current_lights previous_lights == false then 
	(
		MessageBox "Scene lights have changed since you last updated. LightUtilities will now update itself and your last operation will be canceled." title:"LightUtilities"
		luct_full_update()
		return true
	)
	else return false
)
	
fn lu_operation_on_what = 
(
	if lu_onwhat_value == 1 then return all_lights "scene"
	else if lu_onwhat_value == 2 then return all_lights "selected"
	else if lu_onwhat_value == 3 then return o_selected_lights
)

-- Rollouts

rollout luw_rollout "On What?"
(
	dropdownlist lu_onwhat_list "" items:#("All", "Selected", "O-Selected") selection:2
	on lu_onwhat_list selected i do lu_onwhat_value = i
)
)
-------------------------------------------------------------------------------