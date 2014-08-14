-------------------------------------------------------------------------------
-- MapCollector.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.10
-- Created On: 08/01/01
-- Modified On: 08/23/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Lets you collector all the bitmaps from your scene, place them into a directory,
-- and change your scene to reflect the new location of the maps. Several utilities 
-- already do this, however, this one affects all maps, including backgrounds,
-- fog, light projector maps, etc.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Lets you collector all the bitmaps from your scene, place them into a 
-- directory, and change your scene to reflect the new location of the maps. 
-- Several utilities already do this, however, this one affects all maps, 
-- including backgrounds, fog, light projector maps, etc.
--
-- v 1.01 Replaced get_all_medit_bitmaps and get_all_scene_bitmaps with the
-- new function get_bitmaps_from_maps.
--
-- v 1.10 Now you can collect only materials that are applied to your selected 
-- objects.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global start_mapc

global mapc_rollout
global mapc_floater

-- Includes

include "$scripts/BlurScripts/BSLib.ms"

-- Variables

mapc_out_dir = undefined
i1_value = true
i2_value = false
i3_value = true
i4_value = true
i5_value = true
i6_value = true
i7_value = true
i8_value = false
copy_move_value = 1
update_mats_value = true
overwrite_value = false

-- Functions

fn start_mapc =
(
	if mapc_out_dir[mapc_out_dir.count] != "\\" then mapc_out_dir = mapc_out_dir + "\\"

	print "Collecting bitmap info"
	
	a = #()
	b = #()
	c = #()
	d = #()
	all_maps = #()
	all_bm = #()
	total_files_copied = 0
	
	if i1_value == true then a = get_all_scene_maps()
	if i2_value == true then b = get_all_medit_maps()
	c = get_misc_scene_maps i3_value i4_value i5_value i6_value i7_value
	if i8_value == true then d = get_all_maps_in_selected_objs()
	
	all_maps = a + b + c + d
	all_bm = get_bitmaps_from_maps all_maps
	
	trim_dups all_bm
	
	print "Bitmap info collected, collecting bitmaps."
	
	progressStart "MapCollector"
	escapeEnable = false
	
	for i = 1 to all_bm.count do
	(
		m = ((i as float)/(all_bm.count as float))*100
		
		filein = all_bm[i].filename
		fileout = (mapc_out_dir + (filenameFromPath filein))
		
		if overwrite_value == true then
		(
			copyfile filein fileout
			total_files_copied += 1
		)
		else 
		(
			if file_exist fileout == false then 
			(
				answer = copyfile filein fileout
				if answer != false then total_files_copied += 1
			)
		)
		
		if update_mats_value == true then all_bm[i].filename = fileout
		if copy_move_value == 2 then deletefile filein
		
		progressUpdate m
	)
		
	progressEnd()
	
	print "Map Collector Results"
	print ("Bitmaps Copied: " + (total_files_copied as string))
)

-- The Script

rollout mapc_rollout "MapCollector"
(
	group "Path To Collect Maps To"
(
	button mapc_getpath "Path" align:#left across:2
	edittext mapc_pathlabel "" fieldWidth:158 offset:[-60,4] text:"undefined"
)
	
	on mapc_getpath pressed do
	(
		mapc_out_dir = getSavePath()
		mapc_pathlabel.text = (mapc_out_dir as string)
	)
	on mapc_pathlabel entered text do 
	(
		if mapc_pathlabel.text == "undefined" then mapc_out_dir = undefined
		else mapc_out_dir = mapc_pathlabel.text
	)
	
	group "Include"
(
	checkbox i1 "Maps In Scene Materials" checked:i1_value
	checkbox i2 "Material Editor" checked:i2_value
	checkbox i3 "Background" checked:i3_value
	checkbox i4 "Displace Modifiers" checked:i4_value
	checkbox i5 "Displace Spacewarps" checked:i5_value
	checkbox i6 "Projector Lights" checked:i6_value
	checkbox i7 "Fog" checked:i7_value
	checkbox i8 "Maps Applied to Selected Objects" checked:i8_value
)
	
	on i1 changed state do (if i1.checked == true then i1_value = true else i1_value = false)
	on i2 changed state do (if i2.checked == true then i2_value = true else i2_value = false)
	on i3 changed state do (if i3.checked == true then i3_value = true else i3_value = false)
	on i4 changed state do (if i4.checked == true then i4_value = true else i4_value = false)
	on i5 changed state do (if i5.checked == true then i5_value = true else i5_value = false)
	on i6 changed state do (if i6.checked == true then i6_value = true else i6_value = false)
	on i7 changed state do (if i7.checked == true then i7_value = true else i7_value = false)
	on i8 changed state do (if i8.checked == true then i8_value = true else i8_value = false)

	group "Options"
(
	dropdownlist copy_move "" items:#("Copy Maps", "Move Maps") selection:copy_move_value
	checkbox update_mats "Update Scene" checked:update_mats_value
	checkbox overwrite_checkbox "Overwrite Existing Bitmaps" checked:overwrite_value
)
	
	on copy_move selected i do copy_move_value = i
	on update_mats changed state do (if update_mats.checked == true then update_mats_value = true else update_mats_value = false)
	on overwrite_checkbox changed state do (if overwrite_checkbox.checked == true then overwrite_value = true else overwrite_value = false)
	
	button domapcollection "Collect Maps" width:200 align:#center toolTip:"Collect Maps"
	on domapcollection pressed do 
	(
		if mapc_out_dir != undefined then 
		(
			if copy_move_value == 2 then 
			(
				if (queryBox "Are you SURE you want to move the maps?" title:"MapCollector") == true then start_mapc()
			)
			else start_mapc()
		)
		else (MessageBox "Please pick a valid path" title:"MapCollector")
	)
)

if mapc_floater != undefined then CloseRolloutFloater mapc_floater
mapc_floater = newRolloutFloater "MapCollector v1.10" 250 424
addRollout mapc_rollout mapc_floater
)
-------------------------------------------------------------------------------