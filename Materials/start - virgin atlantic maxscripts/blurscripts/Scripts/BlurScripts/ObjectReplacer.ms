-------------------------------------------------------------------------------
-- ObjectReplacer.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.20
-- Created On: 02/11/02
-- Modified On: 06/28/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes a replacer object and replaces all selected objects with that object.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Takes a replacer object and replaces all selected objects with that object.
--
-- v 1.10 Now can copy the material as well.
--
-- v 1.20 Allows you to use a selection set of objects as replacers now.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global or_sel_sets_names = #()
global replacer_obj

global replace_objects
global choose_objects

global or_floater
global or_rollout

-- Variables

what_replacer_value = 1
what_selectionset_value = 1

match_position_value = true
match_rotation_value = true
match_scale_value = true
match_name_value = true
match_mat_value = true

what_type_value = 2
delete_org_value = true

-- Functions

fn replace_objects o = 
	(
	disableSceneRedraw()
	undo "ObjectReplacer" on
		(
		delete_array = #()
		select_array = #()
		for i in selection do
			(
			ob = o[random 1 o.count]
			
			if what_type_value == 1 then w = copy ob
			else if what_type_value == 2 then w = instance ob
			else if what_type_value == 3 then w = reference ob
			
			if match_rotation_value == true then w.rotation = i.rotation
			if match_scale_value == true then w.scale = i.scale
			if match_position_value == true then w.pos = i.pos
			if match_name_value == true then w.name = i.name
			if match_mat_value == true then w.material = i.material
			
			if delete_org_value == true then append delete_array i
			append select_array w
			)
		if delete_array.count != 0 then delete delete_array
		select select_array
		)
	enableSceneRedraw()
	redrawViews()
	)
	
fn choose_objects = 
	(
	if what_replacer_value == 1 then
		(
		if replacer_obj == undefined then (MessageBox "Please pick a replacer" title:"ObjectReplacer")
		else
			(
			if isdeleted replacer_obj == true then (MessageBox "Your replacer object no longer seems to exist, please pick a new object" title:"ObjectReplacer")
			else
				(
				if selection.count == 0 then (MessageBox "Please select some objects to be replaced" title:"ObjectReplacer")
				else 
					(
					replace_objects #(replacer_obj)
					)
				)
			)
		)
	else
		(
		if or_sel_sets_names.count == 0 then (MessageBox "Please pick a valid selectionset" title:"ObjectReplacer")
		else
			(
			if selection.count == 0 then (MessageBox "Please select some objects to be replaced" title:"ObjectReplacer")
			else 
				(
				replace_objects selectionSets[or_sel_sets_names[what_selectionset_value]]
				)
			)
		)
	)
	
-- Script

or_sel_sets_names = get_scene_ss_names()
sort or_sel_sets_names

rollout or_rollout "ObjectReplacer"
	(
	group "Replacer"
	(
	dropdownlist what_replacer "" items:#("Single Object", "SelectionSet") selection:1
	label what_obj "None" align:#center
	pickbutton pick_replacer "Pick The Object To Replace With" width:220 toolTip:"Pick The Object To Replace With" align:#center
	dropdownlist what_selectionset "" items:or_sel_sets_names enabled:false selection:1
	)
	
	on what_replacer selected i do 
		(
		what_replacer_value = i
		if i == 1 then 
			(
			pick_replacer.enabled = true
			what_obj.enabled = true
			what_selectionset.enabled = false
			)
		else
			(
			pick_replacer.enabled = false
			what_obj.enabled = false
			what_selectionset.enabled = true
			)
		)
	on pick_replacer picked obj do 
		(
		replacer_obj = obj
		what_obj.text = obj.name
		)
	on what_selectionset selected i do what_selectionset_value = i
		
	group "Match"
	(
	checkbox match_position "Position?" checked:true
	checkbox match_rotation "Rotation?" checked:true
	checkbox match_scale "Scale?" checked:true
	checkbox match_name "Name?" checked:true
	checkbox match_mat "Material?" checked:true
	)
	
	on match_position changed state do match_position_value = state
	on match_rotation changed state do match_rotation_value = state
	on match_scale changed state do match_scale_value = state
	on match_name changed state do match_name_value = state
	on match_mat changed state do match_mat_value = state
	
	group "Options"
	(
	dropdownlist what_type "" items:#("Copy", "Instance", "Reference") selection:2
	checkbox delete_org "Delete Originals?" checked:true
	)
	on what_type selected i do what_type_value = i
	on delete_org changed state do delete_org_value = delete_org.checked
		
	button doit "Replace Selected Objects with Replacer(s)" width:226 align:#center toolTip:"Replace Selected Objects with Replacer(s)"
	on doit pressed do choose_objects()
	)

if or_floater != undefined then CloseRolloutFloater or_floater
or_floater = newRolloutFloater "ObjectReplacer v1.20" 270 416
addRollout or_rollout or_floater
)
-------------------------------------------------------------------------------