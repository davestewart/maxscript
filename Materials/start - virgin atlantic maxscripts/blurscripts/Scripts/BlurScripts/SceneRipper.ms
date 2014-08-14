-------------------------------------------------------------------------------
-- SceneRipper.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.14
-- Created On: 02/05/01
-- Modified On: 09/26/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes any max file in a specified directory (or recursively through a directory
-- tree) and merges into your current scene any object with a specified wildcard.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Takes any max file in a specified directory (or recursively through a 
-- directory tree) and merges into your current scene any object with a specified 
-- wildcard.
--
-- v 1.01 Removed get_all_max_files_in_dir to BSLib. Added sr_ prefix to several
-- functions and variables to avoid conflict with other scripts.
--
-- v 1.10 Now you can write out a log file saying which files it completed.
-- Also allows you to overwrite objects in the scene with the new merged objects
-- Changed a few deafults and adjusted the look of the UI. Also added a progress
-- dialogue.
--
-- v 1.11 I changed the function get_all_max_files_in_dir to get_all_files_in_dir
-- in BSLib, so I changed the function in this script to reflect the change.
--
-- v 1.12 BSLib is now accessed using an include instead of getting loaded
-- at max startup.
--
-- v 1.13 Added a standard max path dialogue box instead of the original text 
-- field.
--
-- v 1.14 The path label has been replaced with a path editbox.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global rip_objects
global sr_rip_em

global sr_rollout
global sr_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

sr_all_files = #()
sr_log_name = undefined

sr_in_dir = undefined
sr_search_string = "Cam"
sr_recurse_value = false
sr_write_log_value = true
sr_overwrite_mat_value = true

-- Functions

fn rip_objects the_files = 
(
	obj_names = #()
	final_obj_names = #()
	if sr_write_log_value == true then
	(
		sr_log_name = ((sr_in_dir as string) + "sr_log.txt")
		if (getFiles sr_log_name).count != 0 then deletefile sr_log_name
		sr_log_file = createFile sr_log_name
		format "Files completed:" to:sr_log_file
		format "\n" to:sr_log_file
		close sr_log_file
	)
	for w = 1 to the_files.count do
	(
		sr_rollout.sr_start_prog.value = (w as float)/(the_files.count as float)*100
		obj_names = getmaxfileobjectnames the_files[w]
		if obj_names.count != 0 then 
		(
			final_obj_names = filter_array_string_wildcard obj_names sr_search_string
		)
		if sr_overwrite_mat_value == true then
		(
			if final_obj_names.count != 0 then mergemaxfile the_files[w] final_obj_names #deleteOldDups
		)
		else if final_obj_names.count != 0 then mergemaxfile the_files[w] final_obj_names #mergeDups
		if sr_write_log_value == true then
		(
			s = openFile sr_log_name mode:"a"
			format (the_files[w] as string) to:s
			format "\n" to:s
			close s
		)
	)
	sr_rollout.sr_start_prog.value = 0
)

fn sr_rip_em = 
(
	sr_all_files = (get_all_files_in_dir sr_in_dir sr_recurse_value "max")
	if sr_all_files.count != 0 then rip_objects sr_all_files
)

-- The Script

rollout sr_rollout "SceneRipper"
(
	button sr_getpath "Path" align:#left across:2
	edittext sr_pathlabel "" fieldWidth:210 offset:[0,4] text:"undefined" align:#right

	on sr_getpath pressed do
	(
		sr_in_dir = getSavePath()
		sr_pathlabel.text = (sr_out_dir as string)
	)
	on sr_pathlabel entered text do 
	(
		if sr_pathlabel.text == "undefined" then sr_in_dir = undefined
		else sr_in_dir = sr_pathlabel.text
	)
		
	edittext search_text "Search For:" fieldWidth:170 text:"Cam" align:#right
	on search_text changed text do 
	(
		sr_search_string = search_text.text
	)

	checkbox sr_recurse "Recurse Subdirectories" checked:false align:#right
	on sr_recurse changed state do 
	(
		if sr_recurse.checked == true then sr_recurse_value = true
		else sr_recurse_value = false
	)

	checkbox sr_write_log "Write Log File" checked:true align:#right
	on sr_write_log changed state do 
	(
		if sr_write_log.checked == true then sr_write_log_value = true
		else sr_write_log_value = false
	)

	checkbox sr_overwrite_mat "Overwrite Objects That Have The Same Name" checked:true align:#right
	on sr_overwrite_mat changed state do 
	(
		if sr_overwrite_mat.checked == true then sr_overwrite_mat_value = true
		else sr_overwrite_mat_value = false
	)
	
	button sr_start "Start" width:170 toolTip:"Start" align:#right
	on sr_start pressed do 
	(
		if sr_in_dir != undefined then
		(
			if sr_in_dir[sr_in_dir.count] != "\\" then 
			(
				sr_in_dir = sr_in_dir + "\\"
			)
			sr_rip_em()
		)
		else (MessageBox "Please pick a valid path" title:"SceneRipper")
	)
	progressBar sr_start_prog orient:#horizontal color:red value:0
)

if sr_floater != undefined then CloseRolloutFloater sr_floater
sr_floater = newRolloutFloater "SceneRipper v1.14" 305 222
addRollout sr_rollout sr_floater
)
-------------------------------------------------------------------------------