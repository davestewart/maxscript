-------------------------------------------------------------------------------
-- StitchBatch.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.01
-- Created On: 05/06/02
-- Modified On: 05/10/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-- Stitch, http://www.digimation.com
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Lets you run stitch simulations on a bunch of objects over a bunch of
-- files in a batch process.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Instructions:
-- You specify a starting directory, it will collect all the files, open them
-- one by one, find any objects with a stitch modifier, run the simulation on
-- all of them, and save the file.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Lets you run stitch simulations on a bunch of objects over a bunch of
-- files in a batch process.
--
-- v 1.01 Now defaults to save with Postfix, and to "Process These Maxfiles". 
-- You can now save even in "Process Current Maxfile" mode. Added a time to the 
-- logfile so it now tells you when it started and ended the process. Some code 
-- reorganization.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global stba_find_and_run_stitch
global stba_maxsave
global stba_filessingle
global stba_filesbatch
global stba_start

global stba_rollout
global stba_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

stba_mode_value = 2
stba_in_dir = undefined
stba_recurse_value = false
stba_write_log_value = true
stba_save_mode_value = 4
stba_appendpostfix_name_value = "_simmed"

-- Functions

fn stba_find_and_run_stitch = 
	(
	if getCommandPanelTaskMode() != #modify then max modify mode
	disableSceneRedraw()
	num_sim_run = 0
	for i in $* do
		(
		if i.modifiers.count == 0 then continue
		else
			(
			for j = 1 to i.modifiers.count do
				(
				if classof i.modifiers[j] == Stitch then 
					(
					num_sim_run += 1
					select i
					stitchOps.simulate i.modifiers[j] true
					)
				else continue
				)
			)
		)
	enableSceneRedraw()
	completeRedraw()
	return num_sim_run
	)

fn stba_maxsave sfile = 
	(
	-- Save Max File
	if stba_save_mode_value == 1 then 
		(
		)
	else if stba_save_mode_value == 2 then 
		(
		SaveMaxFile sfile
		)
	else if stba_save_mode_value == 3 then 
		(
		max saveplus
		)
	else if stba_save_mode_value == 4 then 
		(
		if (substring sfile (sfile.count-3) 4) == ".max" then sfile = substring sfile 1 (sfile.count-4)
		sfile += stba_appendpostfix_name_value + ".max"
		SaveMaxFile sfile
		)
	)
	
fn stba_filessingle = 
	(
	stba_find_and_run_stitch()
	cur_file = maxFilePath + maxFileName
	if cur_file != "" then stba_maxsave cur_file
	)
	
fn stba_filesbatch = 
	(
	stba_all_files = (get_all_files_in_dir stba_in_dir stba_recurse_value "max")
	if stba_write_log_value == true then
		(
		stba_log_name = ((stba_in_dir as string) + "stba_log.txt")
		if (getFiles stba_log_name).count != 0 then deletefile stba_log_name
		stba_log_file = createFile stba_log_name
		format "Process started: " to:stba_log_file
		format localtime to:stba_log_file
		format "\n" to:stba_log_file
		format "Files completed:" to:stba_log_file
		format "\n" to:stba_log_file
		close stba_log_file
		)
	for w = 1 to stba_all_files.count do
		(
		-- Update progress bar
		stba_rollout.stba_start_prog.value = (w as float)/(stba_all_files.count as float)*100
		
		-- Load Max File
		loadMaxFile stba_all_files[w]
		
		-- Perform Stitch Batch
		sim_num = stba_find_and_run_stitch()
		
		-- Save Max File
		stba_maxsave stba_all_files[w]
		
		-- Write log
		if stba_write_log_value == true then
			(
			s = openFile stba_log_name mode:"a"
			the_string = (stba_all_files[w] as string) + " : " + (sim_num as string) + " sim(s) completed"
			format (the_string as string) to:s
			format "\n" to:s
			close s
			)
		)

	-- Write completition time
	s = openFile stba_log_name mode:"a"
	format "Process completed: " to:s
	format localtime to:s
	format "\n" to:s
	close s
	
	stba_rollout.stba_start_prog.value = 0
	)

fn stba_start = 
	(
	if stba_appendpostfix_name_value == "" and stba_save_mode_value == 4 then (MessageBox "Please pick a valid Postfix" title:"StitchBatch")
	else
		(
		if stba_mode_value == 1 then stba_filessingle()
		else 
			(
			if stba_in_dir != undefined then
				(
				if stba_in_dir[stba_in_dir.count] != "\\" then stba_in_dir += "\\"
				if stba_save_mode_value == 1 then
					(
					if (queryBox "You have chosen not to save the maxfiles after process. Are you sure this is what you want to do?" title:"StitchBatch") == true then 
						(
						stba_filesbatch()
						)
					)
				else 
					(
					stba_filesbatch()
					)
				)
			else (MessageBox "Please pick a valid Max File path" title:"StitchBatch")
			)
		)
	)

-- The Script

rollout stba_rollout "StitchBatch"
	(
	dropdownlist stba_mode "" items:#("Process Current Maxfile", "Process These Maxfiles") selection:stba_mode_value

	group "Max Files"
	(
	button stba_getinpath "Path" align:#left across:2 enabled:true
	edittext stba_pathinlabel "" fieldWidth:160 offset:[0,4] text:"undefined" align:#right enabled:true
	checkbox stba_recurse "Recurse Subdirectories" checked:false align:#left enabled:true
	checkbox stba_write_log "Write Log File" checked:true align:#left enabled:true
	)
		
	group "Save"
	(
	dropdownlist stba_save_mode "" items:#("No Save", "Save with Same Filename", "Save Plus", "Save with Postfix") selection:stba_save_mode_value enabled:true
	edittext stba_appendpostfix_name "" fieldWidth:206 offset:[-5,0] text:"_simmed" align:#left enabled:true
	)

	button run_batch "Run Batch Process" width:205 align:#center toolTip:"Run Batch Process"
	progressBar stba_start_prog orient:#horizontal color:red value:0
	
	on stba_mode selected i do
		(
		stba_mode_value = i
		if i == 1 then 
			(
			stba_getinpath.enabled = false
			stba_pathinlabel.enabled = false
			stba_recurse.enabled = false
			stba_write_log.enabled = false
			)
		else if i == 2 then 
			(
			stba_getinpath.enabled = true
			stba_pathinlabel.enabled = true
			stba_recurse.enabled = true
			stba_write_log.enabled = true
			)
		)
	on stba_getinpath pressed do
		(
		stba_in_dir = getSavePath()
		stba_pathinlabel.text = (stba_in_dir as string)
		)
	on stba_pathinlabel entered text do 
		(
		if stba_pathinlabel.text == "undefined" then stba_in_dir = undefined
		else stba_in_dir = stba_pathinlabel.text
		)
	on stba_recurse changed state do 
		(
		if stba_recurse.checked == true then stba_recurse_value = true
		else stba_recurse_value = false
		)
	on stba_write_log changed state do 
		(
		if stba_write_log.checked == true then stba_write_log_value = true
		else stba_write_log_value = false
		)
	on stba_save_mode selected i do
		(
		stba_save_mode_value = i
		if i == 4 then stba_appendpostfix_name.enabled = true
		else stba_appendpostfix_name.enabled = false
		)
	on stba_appendpostfix_name entered text do 
		(
		stba_appendpostfix_name_value = text
		)
	on run_batch pressed do 
		(
		stba_start()
		)
	)
	
if stba_floater != undefined then CloseRolloutFloater stba_floater
stba_floater = newRolloutFloater "StitchBatch v1.01" 260 307
addRollout stba_rollout stba_floater
)
-------------------------------------------------------------------------------