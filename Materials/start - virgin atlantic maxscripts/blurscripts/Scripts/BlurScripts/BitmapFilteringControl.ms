-------------------------------------------------------------------------------
-- BitmapFilteringControl.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.01
-- Created On: 02/15/02
-- Modified On: 06/28/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Allows you to change the filtering type ons everal bitmaps at the same time.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Allows you to change the filtering type ons everal bitmaps at the same 
-- time.
--
-- v 1.01 Can now perform script on the current Material Library.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global bfc_change_bitmap_filtering
global bfc_change_which_bitmaps

global bfc_rollout
global bfc_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

bfc_filtertype_value = 1

bfc_onwhat_value = 1
bfc_start_value = 1
bfc_end_value = 24

bfc_total = 0
bfc_change_total = 0

-- Functions

fn bfc_change_bitmap_filtering onwhat = 
(
	if onwhat.numsubs != 0 then
	(
		for i = 1 to onwhat.numsubs do
		(
			if onwhat[i] != undefined then
			(
				if iskindof onwhat[i] bitmaptexture == true then
				(
					bfc_total += 1
					if onwhat[i].filtering != bfc_filtertype_value then 
					(
						onwhat[i].filtering = bfc_filtertype_value
						bfc_change_total += 1
					)
				)
			)
			bfc_change_bitmap_filtering onwhat[i]
		)
	)
)

fn bfc_change_which_bitmaps = 
(
	bfc_total = 0
	bfc_change_total = 0
	mat_array = get_mat_array bfc_onwhat_value bfc_start_value bfc_end_value
	
	progressStart "Change The Bitmaps"
	escapeEnable = false
	itemnum = mat_array.count
	if itemnum != 0 then
	(
		for i = 1 to itemnum do
		(
			bfc_change_bitmap_filtering mat_array[i]
			m = ((i as float)/(itemnum as float))*100
			progressUpdate m
		)
	)
	progressEnd()
	
	print "BitmapFilteringControl Report:"
	print ("Total number of bitmaps: " + (bfc_total as string))
	print ("Total number of bitmaps changed: " + (bfc_change_total as string))
)
	
-- Script

rollout bfc_rollout "BitmapFilteringControl"
(
	group "Filtering"
(
	dropdownlist bfc_filtertype "" items:#("Pyramidal", "Summed Area", "None") align:#center selection:2
)

	on bfc_filtertype selected i do bfc_filtertype_value = (i-1)

	group "On What?"
(
	dropdownlist bfc_onwhat "" items:#("All Scene Materials", "Materials On Selected Objects", "All Material Editor Slots", "Material Editor Slot Range", "Active Material Slot", "Materials In Current Matlib") align:#center selection:1
	spinner bfc_start "Slot: " range:[1,24,1] type:#integer fieldWidth:50 align:#center enabled:false across:2
	spinner bfc_end "to: " range:[1,24,24] type:#integer fieldWidth:50 align:#center enabled:false
)

	on bfc_onwhat selected i do 
	(
		bfc_onwhat_value = i
		if i == 1 then
		(
			bfc_start.enabled = false
			bfc_end.enabled = false
		)
		if i == 2 then
		(
			bfc_start.enabled = false
			bfc_end.enabled = false
		)
		if i == 3 then
		(
			bfc_start.enabled = false
			bfc_end.enabled = false
		)
		if i == 4 then
		(
			bfc_start.enabled = true
			bfc_end.enabled = true
		)
		if i == 5 then
		(
			bfc_start.enabled = false
			bfc_end.enabled = false
		)
	)
	on bfc_start changed val do bfc_start_value = val
	on bfc_end changed val do bfc_end_value = val
	
	button bfc_do "Change Filter Type" width:180 align:#center toolTip:"Change Filter Type"
	on bfc_do pressed do bfc_change_which_bitmaps()
)

if bfc_floater != undefined then CloseRolloutFloater bfc_floater
bfc_floater = newRolloutFloater "BitmapFilteringControl v1.01" 230 220
addRollout bfc_rollout bfc_floater
)
-------------------------------------------------------------------------------