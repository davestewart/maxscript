-------------------------------------------------------------------------------
-- ChangeBitmaps.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.12
-- Created On: 07/09/01
-- Modified On: 06/28/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Allows you to do search and replace in the names of bitmaps in your scene.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Allows you to do search and replace in the names of bitmaps in your scene.
--
-- v 1.10 Now gives you the option of changing the materials on selected objects.
-- Moved the code that generates the material array to BSlib.
--
-- v 1.11 Changed the phrasing in the progress bar to more closely reflect what
-- it's actually doing. Did some minor script cleanup.
--
-- v 1.12 Can now perform script on the current Material Library.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global cb_change_bitmaps
global cb_change_which_bitmaps

global cb_rollout
global cb_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

cb_onwhat_value = 1
cb_start_value = 1
cb_end_value = 24

cb_f_text = "D:\\"
cb_r_text = "G:\\"

-- Functions

fn cb_change_bitmaps onwhat f r = 
	(
	if onwhat.numsubs != 0 then
		(
		for i = 1 to onwhat.numsubs do
			(
			if onwhat[i] != undefined then
				(
				if iskindof onwhat[i] bitmaptexture == true then
					(
					where_to_add = findString onwhat[i].filename f
					if where_to_add != undefined then onwhat[i].filename = replace onwhat[i].filename where_to_add f.count r
					)
				)
			cb_change_bitmaps onwhat[i] f r
			)
		)
	)

fn cb_change_which_bitmaps = 
	(
	mat_array = get_mat_array cb_onwhat_value cb_start_value cb_end_value
	
	progressStart "Change The Bitmaps"
	escapeEnable = false
	itemnum = mat_array.count
	if itemnum != 0 then
		(
		for i = 1 to itemnum do
			(
			cb_change_bitmaps mat_array[i] cb_f_text cb_r_text
			m = ((i as float)/(itemnum as float))*100
			progressUpdate m
			)
		)
	progressEnd()
	)
	
-- Script

rollout cb_rollout "ChangeBitmaps"
	(
	group "Find + Replace"
	(
	edittext cb_f_edit "Find:" fieldWidth:250 text:cb_f_text align:#right
	edittext cb_r_edit "Replace:" fieldWidth:250 text:cb_r_text align:#right
	)

	on cb_f_edit changed text do cb_f_text = cb_f_edit.text
	on cb_r_edit changed text do cb_r_text = cb_r_edit.text

	group "On What?"
	(
	dropdownlist cb_onwhat "" items:#("All Scene Materials", "Materials On Selected Objects", "All Material Editor Slots", "Material Editor Slot Range", "Active Material Slot", "Materials In Current Matlib") align:#center selection:1
	spinner cb_start "Slot: " range:[1,24,1] type:#integer fieldWidth:50 align:#center enabled:false across:2
	spinner cb_end "to: " range:[1,24,24] type:#integer fieldWidth:50 align:#center enabled:false
	)

	on cb_onwhat selected i do 
		(
		cb_onwhat_value = i
		if i == 1 then
			(
			cb_start.enabled = false
			cb_end.enabled = false
			)
		if i == 2 then
			(
			cb_start.enabled = false
			cb_end.enabled = false
			)
		if i == 3 then
			(
			cb_start.enabled = false
			cb_end.enabled = false
			)
		if i == 4 then
			(
			cb_start.enabled = true
			cb_end.enabled = true
			)
		if i == 5 then
			(
			cb_start.enabled = false
			cb_end.enabled = false
			)
		)
	on cb_start changed val do cb_start_value = val
	on cb_end changed val do cb_end_value = val
	
	button cb_do "Change Bitmaps" width:300 align:#center toolTip:"Change Bitmaps"
	on cb_do pressed do cb_change_which_bitmaps()
	)

if cb_floater != undefined then CloseRolloutFloater cb_floater
cb_floater = newRolloutFloater "ChangeBitmaps v1.12" 350 237
addRollout cb_rollout cb_floater
)
-------------------------------------------------------------------------------