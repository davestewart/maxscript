-------------------------------------------------------------------------------
-- RandomMat.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.10
-- Created On: 03/09/01
-- Modified On: 02/02/02
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes a set of materials and randomly applies them to your current scene
-- selection.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Takes a set of materials and randomly applies them to your current scene
-- selection.
--
-- v 1.01 Fixed a bug that would happen if you tried to copy and apply a map 
-- instead of a material.
--
-- v 1.10 Added a stat to tell you how many objects you currently have selected.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global rm_copy_from_matlib
global rm_copy_from_medit
global randomly_dist_to_selection
global rm_calculate_start_end
global start_rm

global rm_rollout
global rm_floater

-- Variables

rm_mats = #()

rm_from_type_value = 2
rm_from_fr_value = true
rm_from_start_value = 1
rm_from_end_value = 24

rm_dont_copy_paste = false

rm_fs = 1
rm_fe = 24

-- Functions

fn rm_copy_from_matlib a b = 
	(
	rm_mats = #()
	for i = a to b do
		(
		if i > currentMaterialLibrary.count then exit
		else 
			(
			if superclassof currentMaterialLibrary[i] == Material then append rm_mats currentMaterialLibrary[i]
			)
		)
	)
	
fn rm_copy_from_medit a b = 
	(
	rm_mats = #()
	for i = a to b do
		(
		if i > 24 then exit
		else 
			(
			if superclassof meditMaterials[i] == Material then append rm_mats meditMaterials[i]
			)
		)
	)
	
fn randomly_dist_to_selection = 
	(
	for i in selection do
		(
		i.material = rm_mats[random 1 rm_mats.count]
		)
	)

fn rm_calculate_start_end = 
	(
	rm_dont_copy_paste = false
	if rm_from_fr_value == true then
		(
		if rm_from_type_value == 1 then
			(
			if currentMaterialLibrary.count != 0 then
				(
				rm_fs = 1
				rm_fe = currentMaterialLibrary.count
				)
			else rm_dont_copy_paste = true
			)
		else if rm_from_type_value == 2 then
			(
			rm_fs = 1
			rm_fe = 24
			)
		)
	else
		(
		if rm_from_start_value > rm_from_end_value then
			(
			rm_fs = rm_from_end_value
			rm_fe = rm_from_start_value
			)
		else
			(
			rm_fs = rm_from_start_value
			rm_fe = rm_from_end_value
			)
		)
	)

fn start_rm = 
	(
	rm_calculate_start_end()
	if rm_dont_copy_paste == false then
		(
		if rm_from_type_value == 1 then 
			(
			rm_copy_from_matlib rm_fs rm_fe
			if rm_mats.count != 0 then randomly_dist_to_selection()
			)
		else if rm_from_type_value == 2 then 
			(
			rm_copy_from_medit rm_fs rm_fe
			if rm_mats.count != 0 then randomly_dist_to_selection()
			)
		medit.UpdateMtlEditorBrackets()
		)
	)
	
-- The Script

rollout rm_rollout "RandomMat"
	(
	group "From"
	(
	dropdownlist rm_from_type "" items:#("Material Library", "Medit") selection:2
	checkbox rm_from_fr "Full Range" checked:true align:#left across:2
	spinner rm_from_start "Start: " range:[1,999999,1] type:#integer fieldWidth:50 align:#right enabled:false
	spinner rm_from_end "End: " range:[1,999999,24] type:#integer fieldWidth:50 align:#right enabled:false
	Label rm_label1 "Medit" align:#left across:2
	Label rm_label2 "0" align:#right
	)
	
	group "To"
	(
	Label rm_label3 "Objects Selected" align:#left across:2
	Label rm_label4 "0" align:#right
	)
	
	on rm_from_type selected i do 
		(
		if i == 1 then 
			(
			rm_from_type_value = 1
			rm_label1.text = "Material Library"
			rm_label2.text = (currentMaterialLibrary.count as string)
			)
		else if i == 2 then 
			(
			rm_from_type_value = 2
			rm_label1.text = "Medit"
			rm_label2.text = (24 as string)
			)
		)
	on rm_from_fr changed state do 
		(
		if rm_from_fr.checked == true then 
			(
			rm_from_fr_value = true
			rm_from_start.enabled = false
			rm_from_end.enabled = false			
			)
		else 
			(
			rm_from_fr_value = false
			rm_from_start.enabled = true
			rm_from_end.enabled = true
			)
		)
	on rm_from_start changed val do rm_from_start_value = val
	on rm_from_end changed val do rm_from_end_value = val
	
	button rm_update_stats "Update Stats" width:215 align:#center toolTip:"Update Stats"
	button rm_perform_stuff "Randomly Apply To Scene Selection" width:215 align:#center toolTip:"Randomly Apply To Scene Selection"
	
	on rm_update_stats pressed do 
		(
		if rm_from_type_value == 1 then rm_label2.text = (currentMaterialLibrary.count as string)
		else if rm_from_type_value == 2 then rm_label2.text = (24 as string)
		rm_label4.text = (selection.count as string)
		)
	on rm_perform_stuff pressed do 
		(
		start_rm()
		)
	
	on rm_rollout open do
		(
		rm_label2.text = (24 as string)
		rm_label4.text = (selection.count as string)
		)
	)

if rm_floater != undefined then CloseRolloutFloater rm_floater
rm_floater = newRolloutFloater "RandomMat v1.10" 250 276
addRollout rm_rollout rm_floater
)
-------------------------------------------------------------------------------