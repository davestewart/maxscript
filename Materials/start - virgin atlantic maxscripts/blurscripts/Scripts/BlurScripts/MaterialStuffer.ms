-------------------------------------------------------------------------------
-- MaterialStuffer.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.22
-- Created On: 02/10/01
-- Modified On: 05/30/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Moves groups of materials to and from the current material library, the scene
-- selection, the scene materials and medit. For example, with one click you can 
-- put up to 24 scene materials and place them in medit.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Moves groups of materials to and from the current material library, 
-- the scene selection, the scene materials and medit. For example, with one 
-- click you can put up to 24 scene materials and place them in medit.
--
-- v 1.10 Re-did the interface. Also now lets you tell the script what range of 
-- materials you want to copy, and what range you want to place them in. Cleaned
-- the code. Added a Full Range checkbox to let the user just use the full range
-- instead of specifying a range.
--
-- v 1.20 Now you can sort what you stuff alphabetically, as ooposed to whatever
-- order it started in. Fixed a bug that would happen if you tried to apply a 
-- map to an object instead of a material.
--
-- v 1.21 Changed a default, now it defaults to copies from Scene Materials.
--
-- v 1.22 Replaced the SceneMaterials array with a BSLib function 
-- get_scene_materials()
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global materials_in_selected_objects
global ms_sort
global copy_from_material_library
global copy_from_medit
global copy_from_scene_selection
global copy_from_scenematerials
global copy_to_material_library
global copy_to_medit
global copy_to_scene_selection
global calculate_start_end
global start_ms

global ms_rollout
global ms_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

ms_mats = #()

from_type_value = 4
from_fr_value = true
from_start_value = 1
from_end_value = 24
to_type_value = 2
to_fr_value = true
to_start_value = 1
to_end_value = 24
to_sort_value = true

dont_copy_paste = false

ms_fs = 1
ms_fe = 24
ms_ts = 1
ms_ts = 24

-- Functions

fn materials_in_selected_objects = 
	(
	sel_array = #()
	for i in selection do
		(
		if i.material != undefined then
			(
			if findItem sel_array i.material == 0 then append sel_array i.material
			)
		)
	return sel_array
	)
	
fn ms_sort = 
	(
	if to_sort_value == true then qsort ms_mats name_compare_case_insensitive
	)
	
fn copy_from_material_library a b = 
	(
	ms_mats = #()
	for i = a to b do
		(
		if i > currentMaterialLibrary.count then exit
		else 
			(
			if superclassof currentMaterialLibrary[i] == Material then append ms_mats currentMaterialLibrary[i]
			)
		)
	)
	
fn copy_from_medit a b = 
	(
	ms_mats = #()
	for i = a to b do
		(
		if i > 24 then exit
		else 
			(
			append ms_mats meditMaterials[i]
			)
		)
	)
	
fn copy_from_scene_selection a b = 
	(
	ms_mats = #()
	for i = a to b do
		(
		if i > (materials_in_selected_objects()).count then exit
		else 
			(
			append ms_mats (materials_in_selected_objects())[i]
			)
		)
	)
	
fn copy_from_scenematerials a b = 
	(
	ms_mats = #()
	for i = a to b do
		(
		if i > (get_scene_materials()).count then exit
		else 
			(
			append ms_mats (get_scene_materials())[i]
			)
		)
	)
	
fn copy_to_material_library a = 
	(
	for i = 1 to ms_mats.count do
		(
		append currentMaterialLibrary ms_mats[i]
		)
	)
	
fn copy_to_medit a = 
	(
	for i = 1 to ms_mats.count do
		(
		if (i + a - 1) > 24 then exit
		else meditMaterials[i + a - 1] = ms_mats[i]
		)
	)
	
fn copy_to_scene_selection a = 
	(
	for i = 1 to ms_mats.count do
		(
		if (i + a - 1) > selection.count then exit
		else 
			(
			if superclassof ms_mats[i] == material then selection[i + a - 1].material = ms_mats[i]
			)
		)
	)

fn calculate_start_end = 
	(
	dont_copy_paste = false
	if from_fr_value == true then
		(
		if from_type_value == 1 then
			(
			if currentMaterialLibrary.count != 0 then
				(
				ms_fs = 1
				ms_fe = currentMaterialLibrary.count
				)
			else dont_copy_paste = true
			)
		else if from_type_value == 2 then
			(
			ms_fs = 1
			ms_fe = 24
			)
		else if from_type_value == 3 then
			(
			if (materials_in_selected_objects()).count != 0 then
				(
				ms_fs = 1
				ms_fe = (materials_in_selected_objects()).count
				)
			else dont_copy_paste = true
			)
		else if from_type_value == 4 then
			(
			if (get_scene_materials()).count != 0 then
				(
				ms_fs = 1
				ms_fe = (get_scene_materials()).count
				)
			else dont_copy_paste = true
			)
		)
	else
		(
		if from_start_value > from_end_value then
			(
			ms_fs = from_end_value
			ms_fe = from_start_value
			)
		else
			(
			ms_fs = from_start_value
			ms_fe = from_end_value
			)
		)
	if to_fr_value == true then
		(
		if to_type_value == 2 then
			(
			ms_ts = 1
			ms_te = 24
			)
		else if to_type_value == 3 then
			(
			if selection.count != 0 then
				(
				ms_ts = 1
				ms_te = selection.count
				)
			else dont_copy_paste = true
			)
		)
	else
		(
		if to_start_value > to_end_value then
			(
			ms_ts = to_end_value
			ms_te = to_start_value
			)
		else
			(
			ms_ts = to_start_value
			ms_te = to_end_value
			)
		)
	)

fn start_ms = 
	(
	calculate_start_end()
	if dont_copy_paste == false then
		(
		if from_type_value == 1 then 
			(
			if to_type_value == 1 then 
				(
				if (queryBox "Do you really want to copy from and to the same thing?" title:"MaterialStuffer") == true then 
					(
					copy_from_material_library ms_fs ms_fe
					ms_sort()
					if ms_mats.count != 0 then copy_to_material_library ms_ts
					)
				)
			else if to_type_value == 2 then
				(
				copy_from_material_library ms_fs ms_fe
				ms_sort()
				if ms_mats.count != 0 then copy_to_medit ms_ts
				)
			else if to_type_value == 3 then
				(
				copy_from_material_library ms_fs ms_fe
				ms_sort()
				if ms_mats.count != 0 then copy_to_scene_selection ms_ts
				)
			)
		else if from_type_value == 2 then 
			(
			if to_type_value == 1 then
				(
				copy_from_medit ms_fs ms_fe
				ms_sort()
				if ms_mats.count != 0 then copy_to_material_library ms_ts
				)
			else if to_type_value == 2 then 
				(
				if (queryBox "Do you really want to copy from and to the same thing?" title:"MaterialStuffer") == true then 
					(
					copy_from_medit ms_fs ms_fe
					ms_sort()
					if ms_mats.count != 0 then copy_to_medit ms_ts
					)
				)
			else if to_type_value == 3 then
				(
				copy_from_medit ms_fs ms_fe
				ms_sort()
				if ms_mats.count != 0 then copy_to_scene_selection ms_ts
				)
			)
		else if from_type_value == 3 then 
			(
			if to_type_value == 1 then
				(
				copy_from_scene_selection ms_fs ms_fe
				ms_sort()
				if ms_mats.count != 0 then copy_to_material_library ms_ts
				)
			else if to_type_value == 2 then 
				(
				copy_from_scene_selection ms_fs ms_fe
				ms_sort()
				if ms_mats.count != 0 then copy_to_medit ms_ts
				)
			else if to_type_value == 3 then
				(
				if (queryBox "Do you really want to copy from and to the same thing?" title:"MaterialStuffer") == true then 
					(
					copy_from_scene_selection ms_fs ms_fe
					ms_sort()
					if ms_mats.count != 0 then copy_to_scene_selection ms_ts
					)
				)
			)
		else if from_type_value == 4 then 
			(
			if to_type_value == 1 then
				(
				copy_from_scenematerials ms_fs ms_fe
				ms_sort()
				if ms_mats.count != 0 then copy_to_material_library ms_ts
				)
			else if to_type_value == 2 then 
				(
				copy_from_scenematerials ms_fs ms_fe
				ms_sort()
				if ms_mats.count != 0 then copy_to_medit ms_ts
				)
			else if to_type_value == 3 then
				(
				copy_from_scenematerials ms_fs ms_fe
				ms_sort()
				if ms_mats.count != 0 then copy_to_scene_selection ms_ts
				)
			)
		medit.UpdateMtlEditorBrackets()
		)
	)
	
-- The Script

rollout ms_rollout "MaterialStuffer"
	(
	group "From"
	(
	dropdownlist from_type "" items:#("Material Library", "Medit", "Scene Selection", "Scene Materials") selection:4
	checkbox from_fr "Full Range" checked:true align:#left across:2
	spinner from_start "Start: " range:[1,999999,1] type:#integer fieldWidth:50 align:#right enabled:false
	spinner from_end "End: " range:[1,999999,24] type:#integer fieldWidth:50 align:#right enabled:false
	Label label1 "Scene Materials" align:#left across:2
	Label label2 "0" align:#right
	)
	
	on from_type selected i do 
		(
		if i == 1 then 
			(
			from_type_value = 1
			label1.text = "Material Library"
			label2.text = (currentMaterialLibrary.count as string)
			)
		else if i == 2 then 
			(
			from_type_value = 2
			label2.text = (24 as string)
			label1.text = "Medit"
			)
		else if i == 3 then 
			(
			from_type_value = 3
			label1.text = "Materials In Scene Selection"
			label2.text = ((materials_in_selected_objects()).count as string)
			)
		else if i == 4 then 
			(
			from_type_value = 4
			label1.text = "Scene Materials"
			label2.text = ((get_scene_materials()).count as string)
			)
		)
	on from_fr changed state do 
		(
		if from_fr.checked == true then 
			(
			from_fr_value = true
			from_start.enabled = false
			from_end.enabled = false			
			)
		else 
			(
			from_fr_value = false
			from_start.enabled = true
			from_end.enabled = true
			)
		)
	on from_start changed val do from_start_value = val
	on from_end changed val do from_end_value = val
	
	group "To"
	(
	dropdownlist to_type "" items:#("Material Library", "Medit", "Scene Selection") selection:2
	checkbox to_fr "Full Range" checked:true align:#left across:2
	spinner to_start "Start: " range:[1,999999,1] type:#integer fieldWidth:50 align:#right enabled:false
	spinner to_end "End: " range:[1,999999,24] type:#integer fieldWidth:50 align:#right enabled:false
	checkbox to_sort "Sort Materials Alphabetically" checked:true align:#left
	Label label3 "Medit" align:#left across:2
	Label label4 "0" align:#right
	)
	
	on to_type selected i do 
		(
		if i == 1 then 
			(
			to_type_value = 1
			label3.text = "Material Library"
			label4.text = (currentMaterialLibrary.count as string)
			to_start.enabled = false
			to_end.enabled = false
			to_fr.enabled = false
			)
		else if i == 2 then 
			(
			to_type_value = 2
			label3.text = "Medit"
			label4.text = (24 as string)
			to_fr.enabled = true
			if to_fr_value != true then
				(
				to_start.enabled = true
				to_end.enabled = true
				)
			)
		else if i == 3 then 
			(
			to_type_value = 3
			label3.text = "Objects Selected"
			label4.text = (selection.count as string)
			to_fr.enabled = true
			if to_fr_value != true then
				(
				to_start.enabled = true
				to_end.enabled = true
				)
			)
		)
	on to_fr changed state do 
		(
		if to_fr.checked == true then 
			(
			to_fr_value = true
			to_start.enabled = false
			to_end.enabled = false			
			)
		else 
			(
			to_fr_value = false
			to_start.enabled = true
			to_end.enabled = true
			)
		)
	on to_start changed val do to_start_value = val
	on to_end changed val do to_end_value = val
	
	on to_sort changed state do 
		(
		if to_sort.checked == true then 
			(
			to_sort_value = true
			)
		else 
			(
			to_sort_value = false
			)
		)
	
	button update_stats "Update Stats" width:180 align:#center toolTip:"Update Stats"
	button perform_stuff "Stuffit!" width:180 align:#center toolTip:"Stuffit!"
	
	on update_stats pressed do 
		(
		if from_type_value == 1 then label2.text = (currentMaterialLibrary.count as string)
		else if from_type_value == 2 then label2.text = (24 as string)
		else if from_type_value == 3 then label2.text = ((materials_in_selected_objects()).count as string)
		else if from_type_value == 4 then label2.text = ((get_scene_materials()).count as string)
		
		if to_type_value == 1 then label4.text = (currentMaterialLibrary.count as string)
		else if to_type_value == 2 then label4.text = (24 as string)
		else if to_type_value == 3 then label4.text = (selection.count as string)
		)
	on perform_stuff pressed do 
		(
		start_ms()
		)
	
	on ms_rollout open do
		(
		label2.text = ((get_scene_materials()).count as string)
		label4.text = (24 as string)
		)
	)

if ms_floater != undefined then CloseRolloutFloater ms_floater
ms_floater = newRolloutFloater "MaterialStuffer v1.22" 240 365
addRollout ms_rollout ms_floater
)
-------------------------------------------------------------------------------