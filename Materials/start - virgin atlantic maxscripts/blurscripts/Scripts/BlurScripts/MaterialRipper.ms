-------------------------------------------------------------------------------
-- MaterialRipper.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.16
-- Created On: 02/09/01
-- Modified On: 09/26/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes any max file in a specified directory (or recursively through a directory
-- tree) and adds all scene materials to a matlib you specify. If the matlib does
-- not exist, it will create it, otherwise, it'll add to the one that's already
-- there.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Takes any max file in a specified directory (or recursively through a 
-- directory tree) and adds all scene materials to a matlib you specify. If the 
-- matlib does not exist, it will create it, otherwise, it'll add to the one 
-- that's already there.
--
-- v 1.10 Now you can write out a log file saying which files it completed.
-- Also allows you to overwrite materials in the library with new materials
-- that have the same name. Changed a few deafults and adjusted the look of the
-- UI. Also added a progress dialogue.
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
-- v 1.14 SceneMaterials code now replaced with get_scene_materials().
--
-- v 1.15 Removed height:18 code now that editboxes have been fixed in r4.2.
--
-- v 1.16 The path label has been replaced with a path editbox.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global rip_materials
global mr_rip_em

global mr_rollout
global mr_floater

-- Includes

include "$scripts/BlurScripts/BSLib.ms"

-- Variables

mr_all_files = #()
mr_recurse_value = false
mr_write_log_value = true
mr_overwrite_mat_value = true
mr_log_name = undefined

mr_in_dir = undefined
mr_out_dir = undefined
mr_out_filename = "matlib01"

-- Functions

fn rip_materials the_files = 
(
	curlib = mr_out_dir + mr_out_filename + ".mat"
	if mr_write_log_value == true then
	(
		mr_log_name = ((mr_in_dir as string) + "mr_log.txt")
		if (getFiles mr_log_name).count != 0 then deletefile mr_log_name
		mr_log_file = createFile mr_log_name
		format "Files completed:" to:mr_log_file
		format "\n" to:mr_log_file
		close mr_log_file
	)
	for w = 1 to the_files.count do
	(
		mr_rollout.mr_start_prog.value = (w as float)/(the_files.count as float)*100
		loadMaxFile the_files[w]
		loadMaterialLibrary curlib
		for i in (get_scene_materials()) do
		(
			same_name = 0
			if mr_overwrite_mat_value == true then
			(
				for x = 1 to currentMaterialLibrary.count do
				(
					if currentMaterialLibrary[x].name == i.name then 
					(
						same_name = x
						exit
					)
				)
				if same_name != 0 then currentMaterialLibrary[same_name] = i
				else append currentMaterialLibrary i
			)
			else append currentMaterialLibrary i
		)
		saveMaterialLibrary curlib
		if mr_write_log_value == true then
		(
			s = openFile mr_log_name mode:"a"
			format (the_files[w] as string) to:s
			format "\n" to:s
			close s
		)
	)
	mr_rollout.mr_start_prog.value = 0
)

fn mr_rip_em = 
(
	mr_all_files = (get_all_files_in_dir mr_in_dir mr_recurse_value "max")
	rip_materials mr_all_files
)

-- The Script

rollout mr_rollout "MaterialRipper"
(
	group "Max Files"
(
	button mr_getinpath "Path" align:#left across:2
	edittext mr_pathinlabel "" fieldWidth:160 offset:[0,4] text:"undefined" align:#right
	checkbox mr_recurse "Recurse Subdirectories" checked:false align:#left
	checkbox mr_write_log "Write Log File" checked:true align:#left
)
	on mr_getinpath pressed do
	(
		mr_in_dir = getSavePath()
		mr_pathinlabel.text = (mr_in_dir as string)
	)
	on mr_pathinlabel entered text do 
	(
		if mr_pathinlabel.text == "undefined" then mr_in_dir = undefined
		else mr_in_dir = mr_pathinlabel.text
	)
	on mr_recurse changed state do 
	(
		if mr_recurse.checked == true then mr_recurse_value = true
		else mr_recurse_value = false
	)
	on mr_write_log changed state do 
	(
		if mr_write_log.checked == true then mr_write_log_value = true
		else mr_write_log_value = false
	)

	group "Material Library"
(
	button mr_getpath "Path" align:#left across:2
	edittext mr_pathlabel "" fieldWidth:160 offset:[0,4] text:"undefined" align:#right
	edittext mr_filename "   Name: " fieldWidth:115 text:mr_out_filename align:#right
	checkbox mr_overwrite_mat "Overwrite Materials With Same Name" checked:true align:#left
)
	
	on mr_getpath pressed do
	(
		mr_out_dir = getSavePath()
		mr_pathlabel.text = (mr_out_dir as string)
	)
	on mr_pathlabel entered text do 
	(
		if mr_pathlabel.text == "undefined" then mr_out_dir = undefined
		else mr_out_dir = mr_pathlabel.text
	)
	on mr_filename changed text do mr_out_filename = mr_filename.text
	on mr_overwrite_mat changed state do 
	(
		if mr_overwrite_mat.checked == true then mr_overwrite_mat_value = true
		else mr_overwrite_mat_value = false
	)
	
	button mr_start "Start" width:205 toolTip:"Start" align:#right
	progressBar mr_start_prog orient:#horizontal color:red value:0
	on mr_start pressed do 
	(
		if mr_in_dir != undefined then
		(
			if mr_out_dir != undefined then
			(
				if mr_in_dir[mr_in_dir.count] != "\\" then mr_in_dir = mr_in_dir + "\\"
				if mr_out_dir[mr_out_dir.count] != "\\" then mr_out_dir = mr_out_dir + "\\"
				mr_rip_em()
			)
			else (MessageBox "Please pick a valid Material Library path" title:"MaterialRipper")
		)
		else (MessageBox "Please pick a valid Max File path" title:"MaterialRipper")			
	)
)

if mr_floater != undefined then CloseRolloutFloater mr_floater
mr_floater = newRolloutFloater "MaterialRipper v1.16" 260 300
addRollout mr_rollout mr_floater
)
-------------------------------------------------------------------------------