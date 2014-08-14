-------------------------------------------------------------------------------
-- BSRun.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.05
-- Created On: 02/24/01
-- Modified On: 08/01/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Allows you to quickly choose a blurscript from a dropdown list and run it.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Allows you to quickly choose a blurscript from a dropdown list and run it.
--
-- v 1.01 Now the script closes itself before running the chosen blurscript.
-- This stops the floater from not closing if an error occurs in the script
-- you're trying to run.
--
-- v 1.02 Now defaults to the last script you ran when you run bsrun by using
-- an bsrun.ini file.
--
-- v 1.03 Fixed a bug where it would not run a previously run script unless
-- you picked it from the list again.
--
-- v 1.04 Cleaned up the ini file code.
--
-- v 1.05 Replaced get_file_name with max standard filenameFromPath.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global bsrun_update
global bsr_io

global bsr_rollout
global bsr_floater

global script_names
global script_files

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

last_script_index = 1
the_script = 1

-- Functions

fn bsrun_update = 
	(
	script_names = #()
	script_files = get_all_files_in_dir ((getdir #scripts) + "\\BlurScripts\\") false "ms"
	if script_files.count != 0 then
		(
		for i = 1 to script_files.count do
			(
			the_name = (filenameFromPath script_files[i])
			append script_names (strip_file_extension the_name)
			)
		)
	)
	
fn bsr_io = 
	(
	bsr_ini_name = ((getdir #scripts) + "\\BlurScripts\\" + "BSRun.ini")
	if openFile bsr_ini_name != undefined then
		(
		bsr_ini = openFile bsr_ini_name
		inputdata = readLine bsr_ini
		my_index = findItem script_names inputdata
		if my_index == 0 then my_index = 1
		last_script_index = my_index
		close bsr_ini
		)
	else
		(
		bsr_ini = createFile bsr_ini_name
		format (strip_file_extension (filenameFromPath (script_files[the_script] as string))) to:bsr_ini
		close bsr_ini
		)
	)

-- Script

rollout bsr_rollout "BSRun"
	(
	on bsr_rollout open do
		(
		the_script = last_script_index
		)
		
	dropdownlist the_scripts "" items:script_names selection:last_script_index height:40
	button the_scripts_run "Run The Script" width:200 align:#center toolTip:"Run The Script"

	on the_scripts selected i do 
		(
		the_script = i
		)
	on the_scripts_run pressed do 
		(
		CloseRolloutFloater bsr_floater

		bsr_ini_name = ((getdir #scripts) + "\\BlurScripts\\" + "BSRun.ini")
		if openFile bsr_ini_name != undefined then deletefile bsr_ini_name
		bsr_ini = createFile bsr_ini_name
		format (strip_file_extension (filenameFromPath (script_files[the_script] as string))) to:bsr_ini
		close bsr_ini
		
		execute (openfile (script_files[the_script] as string))
		)
	)
	
bsrun_update()
bsr_io()

if bsr_floater != undefined then CloseRolloutFloater bsr_floater
bsr_floater = newRolloutFloater "BSRun v1.05" 300 123 130 130
addRollout bsr_rollout bsr_floater
)
-------------------------------------------------------------------------------