-------------------------------------------------------------------------------
-- ClearMedit.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.60
-- Created On: 10/19/99
-- Modified On: 02/15/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Clears slots in the materials editor with a default standard or raytraced 
-- material. Several options for what materials to clear.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Known Bugs and Issues:
--
-- Maps in material slots will not be recognized as scene materials when you
-- use the used or used + shift options, and will be cleared from medit. But
-- they will of course remain in the scene if they're assigned to a scene 
-- material.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Clears all unused slots in the materials editor (unused is defined as 
-- any slot that is now showing a material currently in your scene) with a default
-- material that I specify in this script, and that those of you with maxscript
-- knowledge may edit to your hearts content.
--
-- v 1.10 adds ability to clear all slots as well as all unused
--
-- v 1.20 adds ability to replace the slots with raytraced materials as well as
-- standard. Added version number in titlebar.
--
-- v 1.21 fixed a bug that stopped the mat editor from refreshing properly.
--
-- v 1.30 Added ability to clear a range of editor slots.
--
-- v 1.40 Pablo Hadis (paulh@planetmail.com) was kind enough to edit the 
-- clearunused function to also shift all the used materials still in medit to 
-- the front of the editor, leaving all the blank materials at the end. The
-- user now has the option of using either method to clear unused textures.
--
-- v 1.50 Compatible with R4.0. Fixed a screen redraw problem using max 4's new 
-- medit.UpdateMtlEditorBrackets() function. Also added ability to clear the
-- selected mat editor slot. Cleaned the interface and code.
--
-- v 1.51 Changed the word "All" to "All Slots" to better define what it does.
-- Changed the default materials slightly.
--
-- v 1.52 BSLib is now accessed using an include instead of getting loaded
-- at max startup.
--
-- v 1.53 Changed the material default for the Raytrace material to no specular.
--
-- v 1.54 Now defaults to the last material type you used last time you ran the
-- script by using a ClearMedit.ini file.
--
-- v 1.55 Cleaned up the ini file code.
--
-- v 1.56 Fixed a bug in declaring the raytrace material that led to crashes in 
-- some instances.
--
-- v 1.57 Cleaned some code in the main functions.
--
-- v 1.58 The material definitions have been moved into BSLib.
--
-- v 1.59 Moved the material definition to a different part of the code to 
-- improve overall speed.
--
-- v 1.60 Cleaned some code.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global change_mat
global clearall
global clear_selected_slot
global clearunused
global clearunused_shift
global clear_range
global cm_io
global clearmedit_start

global cm_rollout
global cm_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

mat_type_value = 1
cm_material = undefined

clear_type_value = 1
slot_from_value = 1
slot_to_value = 24

-- Functions

fn change_mat currentindex =
(
	meditMaterials[currentindex] = copy cm_material
)

fn clearall = 
(
	for i = 1 to 24 do change_mat i
)

fn clear_selected_slot = 
(
	i = medit.GetActiveMtlSlot()
	change_mat i
)

fn clearunused = 
(
	scene_mats = get_scene_materials()
	if scene_mats.count == 0 then clearall()
	else
	(
		for i = 1 to 24 do
		(
			if finditem scene_mats meditmaterials[i] == 0 then change_mat i
			else continue
		)
	)
)

fn clearunused_shift = 
(
	scene_mats = get_scene_materials()
	if scene_mats.count == 0 then clearall()
	else
	(
		m = 1   -- Medit last filled slot counter
		for i = 1 to 24 do
		(
			for j = 1 to scene_mats.count do
			(
				if scene_mats[j] == meditMaterials[i] then
				(
					if m != i then   -- if slot != index then copy from index and call clear fcn
					(
						meditMaterials[m] = meditMaterials[i]
						change_mat i
					)
					m += 1  -- either case inc fill slot counter
					exit
				)
				else
				(
					if j == scene_mats.count then change_mat i
					else continue
				)
			)
		)
	)
)

fn clear_range =
(
	if slot_from_value > slot_to_value then
	(
		for i = slot_to_value to slot_from_value do change_mat i
	)
	else 
	(
		for i = slot_from_value to slot_to_value do change_mat i
	)
)
	
fn cm_io = 
(
	cm_ini_name = ((getdir #scripts) + "\\BlurScripts\\" + "ClearMedit.ini")
	if openFile cm_ini_name != undefined then
	(
		cm_ini = openFile cm_ini_name
		inputdata = readLine cm_ini
		if inputdata == "1" or inputdata == "2" then mat_type_value = (inputdata as integer) else mat_type_value = 1
		close cm_ini
	)
	else
	(
		cm_ini = createFile cm_ini_name
		format (mat_type_value as string) to:cm_ini
		close cm_ini
	)
)
	
fn clearmedit_start = 
(
	undo "ClearMedit" on
	(
		cm_material = undefined
		if mat_type_value == 1 then 
		(
			cm_mat_1 = get_blurmat "Default_Standard"
			if cm_mat_1 != false then cm_material = cm_mat_1
		)
		else 
		(
			cm_mat_2 = get_blurmat "Default_RayTrace"
			if cm_mat_2 != false then cm_material = cm_mat_2
		)
			
		if cm_material != undefined then
		(
			if clear_type_value == 1 then clearall()
			else if clear_type_value == 2 then clear_selected_slot()
			else if clear_type_value == 3 then clearunused()
			else if clear_type_value == 4 then clearunused_shift()
			else if clear_type_value == 5 then clear_range()
		)
		medit.UpdateMtlEditorBrackets()
	)
)

-- Script

cm_io()

rollout cm_rollout "ClearMedit"
(
	dropdownlist clear_type "" items:#("All Slots", "Selected Slot", "Unused", "Unused + Shift", "Range") selection:1
	dropdownlist mat_type "" items:#("Standard", "RayTraced") selection:mat_type_value
	spinner slot_from "Slot From: " range:[1,24,1] type:#integer fieldWidth:50 align:#right enabled:false
	spinner slot_to "to: " range:[1,24,24] type:#integer fieldWidth:50 align:#right enabled:false
	button clearmedit_button "Clear Medit" width:120 align:#center toolTip:"Clear Medit"

	on clear_type selected i do 
	(
		clear_type_value = i
		if i == 1 then 
		(
			slot_from.enabled = false
			slot_to.enabled = false
		)
		else if i == 2 then 
		(
			slot_from.enabled = false
			slot_to.enabled = false
		)
		else if i == 3 then 
		(
			slot_from.enabled = false
			slot_to.enabled = false
		)
		else if i == 4 then 
		(
			slot_from.enabled = false
			slot_to.enabled = false
		)
		else if i == 5 then 
		(
			slot_from.enabled = true
			slot_to.enabled = true
		)
	)
	on mat_type selected i do mat_type_value = i
	on slot_from changed val do slot_from_value = val
	on slot_to changed val do slot_to_value = val
	on clearmedit_button pressed do 
	(
		clearmedit_start()
		
		cm_ini_name = ((getdir #scripts) + "\\BlurScripts\\" + "ClearMedit.ini")
		if openFile cm_ini_name != undefined then deletefile cm_ini_name
		cm_ini = createFile cm_ini_name
		format (mat_type_value as string) to:cm_ini
		close cm_ini
	)
)

if cm_floater != undefined then CloseRolloutFloater cm_floater
cm_floater = newRolloutFloater "ClearMedit v1.60" 190 192
addRollout cm_rollout cm_floater
)
-------------------------------------------------------------------------------