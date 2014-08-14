-------------------------------------------------------------------------------
-- Renamer.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.50
-- Created On: 04/28/00
-- Modified On: 06/28/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Allows you to rename the materials, objects, xrefs, maps, etc in various 
-- ways (prefix, total rename, append number, etc).
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Allows you to rename the materials or objects in your scene in various 
-- ways (prefix, total rename, append number, etc). Originally called 
-- MaterialRenamer, now the name has changed and functionality includes the
-- ability to rename selections of objects as well.
--
-- v 1.01 Replaced the sceneMaterials code with my own BSlib function 
-- get_scene_materials()
--
-- v 1.02 BSLib is now accessed using an include instead of getting loaded
-- at max startup.
--
-- v 1.03 Increased the amount of text that can be added to the Text To Use box.
--
-- v 1.04 Removed the special code that lets more text be used in the Text To 
-- Use box. Made the box physically bigger. Function append_num_array_members
-- has been replaced with the new function append_number_to_array_members.
--
-- v 1.05 Cleaned some code in the two main functions.
--
-- v 1.06 Added a active material slot option.
--
-- v 1.10 Can now affect bitmaps texture names and xref files. Cleaned some code.
--
-- v 1.20 Added an option to only rename group heads instead of all objects
-- in the group. Works on Xref Objects now too, thanks to Emmanuel Quentric
-- for the original code. Also saves out to an ini file the last text you used.
--
-- v 1.30 Now gives you the option of renaming the materials on selected objects.
-- Moved the code that generates the material array to BSlib.
--
-- v 1.31 Replaced get_all_scene_bitmaps with the new function get_bitmaps_from_maps.
--
-- v 1.32 Now if you're in the modify panel when you run this script, it will
-- automatically switch to create mode, to avoid a command panel redraw everytime
-- it changes the name of an object.
--
-- v 1.40 Added a stat to tell you how many members exist in whatever you're
-- trying to rename.
--
-- v 1.50 Changed the UI pretty dramatically. Added all uppercase all lowercase 
-- option. You can now rename point cache's and materials in current matlib.
-- Please note, this script will not work with previous renamer.ini files. So 
-- please go to your 3dsmax\scripts\Blurscripts directory and delete any file
-- called Renamer.ini.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global ren_i
global ren_o
global all_the_things
global do_the_rename
global on_what_things
global rename_func
global append_number_func

global ren_floater
global ren_rollout
global ren_options_rollout

global ahh
global ahh2

-- Includes

include "$scripts/BlurScripts/BSLib.ms"

-- Variables

rename_type_value = 1
find_text_value = ""
repl_text_value = "New"

number_start = 1
number_step = 1

ren_onwhat_value = 11
ren_start_value = 1
ren_end_value = 24

group_members_value = true
group_head_value = false

rename_array = #("Full Rename", "Add Prefix", "Append Postfix", "Find & Replace", "All Uppercase", "All Lowercase")
onwhat_array = #("All Scene Materials", "Materials On Selected Objects", "All Material Editor Slots", "Material Editor Slot Range", "Active Material Slot", "Materials In Current Matlib", "Scene Bitmaps", "All Xref Scene Filenames", "All Xref Objects Filenames", "PointCaches in Selected Objects", "All Selected Objects")

-- Functions

fn ren_i = 
	(
	ren_ini_name = ((getdir #scripts) + "\\BlurScripts\\" + "Renamer.ini")
	if openFile ren_ini_name != undefined then
		(
		ren_ini = openFile ren_ini_name
		inputdata = readLine ren_ini
		inputarray = filterString inputdata "|"
		if classof inputarray[1] == string then find_text_value = inputarray[1] as string
		if classof inputarray[2] == string then repl_text_value = inputarray[2] as string
		close ren_ini
		)
	)

fn ren_o = 
	(
	ren_ini_name = ((getdir #scripts) + "\\BlurScripts\\" + "Renamer.ini")
	if openFile ren_ini_name != undefined then deletefile ren_ini_name
	ren_ini = createFile ren_ini_name
	format (find_text_value as string) to:ren_ini
	format "|" to:ren_ini
	format (repl_text_value as string) to:ren_ini
	close ren_ini
	)

fn do_the_rename on_what =
	(
	undo "Renamer" on
		(
		if getCommandPanelTaskMode() == #modify then max create mode
		for i in on_what do
			(
			if ren_onwhat_value == 9 then
				(
				num_objs = objXRefs.getNumXRefObjects i
				for j = 1 to num_objs do
					(
					k = num_objs - j + 1
					obj = objXRefs.getXRefObject i k
					
					if rename_type_value == 1 then
						(
						obj.fileName = rename_string obj.fileName repl_text_value
						obj.proxyFileName = rename_string obj.proxyFileName repl_text_value
						obj.currentFileName = rename_string obj.currentFileName repl_text_value
						)
					if rename_type_value == 2 then
						(
						obj.fileName = prefix_string obj.fileName repl_text_value
						obj.proxyFileName = prefix_string obj.proxyFileName repl_text_value
						obj.currentFileName = prefix_string obj.currentFileName repl_text_value
						)
					if rename_type_value == 3 then 
						(
						obj.fileName = postfix_string obj.fileName repl_text_value
						obj.proxyFileName = postfix_string obj.proxyFileName repl_text_value
						obj.currentFileName = postfix_string obj.currentFileName repl_text_value
						)					
					if rename_type_value == 4 then 
						(
						obj.fileName = findandreplace_string obj.fileName find_text_value repl_text_value
						obj.proxyFileName = findandreplace_string obj.proxyFileName find_text_value repl_text_value
						obj.currentFileName = findandreplace_string obj.currentFileName find_text_value repl_text_value
						)
					if rename_type_value == 5 then 
						(
						obj.fileName = uppercase obj.fileName
						obj.proxyFileName = uppercase obj.proxyFileName
						obj.currentFileName = uppercase obj.currentFileName
						)
					if rename_type_value == 6 then 
						(
						obj.fileName = lowercase obj.fileName
						obj.proxyFileName = lowercase obj.proxyFileName
						obj.currentFileName = lowercase obj.currentFileName
						)
					)
				)
			else if ren_onwhat_value == 7 or ren_onwhat_value == 8 then
				(
				if rename_type_value == 1 then i.filename = rename_string (i.filename as string) repl_text_value
				if rename_type_value == 2 then i.filename = prefix_string (i.filename as string) repl_text_value
				if rename_type_value == 3 then i.filename = postfix_string (i.filename as string) repl_text_value
				if rename_type_value == 4 then i.filename = findandreplace_string (i.filename as string) find_text_value repl_text_value
				if rename_type_value == 5 then i.filename = uppercase (i.filename as string)
				if rename_type_value == 6 then i.filename = lowercase (i.filename as string)
				)
			else if ren_onwhat_value == 10 then
				(
				if rename_type_value == 1 then i.cacheFile = rename_string (i.cacheFile as string) repl_text_value
				if rename_type_value == 2 then i.cacheFile = prefix_string (i.cacheFile as string) repl_text_value
				if rename_type_value == 3 then i.cacheFile = postfix_string (i.cacheFile as string) repl_text_value
				if rename_type_value == 4 then i.cacheFile = findandreplace_string (i.cacheFile as string) find_text_value repl_text_value
				if rename_type_value == 5 then i.cacheFile = uppercase (i.cacheFile as string)
				if rename_type_value == 6 then i.cacheFile = lowercase (i.cacheFile as string)
				)
			else
				(
				if rename_type_value == 1 then i.name = rename_string (i.name as string) repl_text_value
				if rename_type_value == 2 then i.name = prefix_string (i.name as string) repl_text_value
				if rename_type_value == 3 then i.name = postfix_string (i.name as string) repl_text_value
				if rename_type_value == 4 then i.name = findandreplace_string (i.name as string) find_text_value repl_text_value
				if rename_type_value == 5 then i.name = uppercase (i.name as string)
				if rename_type_value == 6 then i.name = lowercase (i.name as string)
				)
			)
		)
	)

fn on_what_things =
	(
	thing_array = #()
	
	if ren_onwhat_value < 7 then 
		(
		thing_array = get_mat_array ren_onwhat_value ren_start_value ren_end_value
		)
	else if ren_onwhat_value == 7 then 
		(
		a = get_all_scene_maps()
		b = get_misc_scene_maps true true true true true
		join a b
		trim_dups a
		thing_array = get_bitmaps_from_maps a
		)
	else if ren_onwhat_value == 8 then for i = 1 to xrefs.getXRefFileCount() do append thing_array (xrefs.getXRefFile i)
	else if ren_onwhat_value == 9 then
		(
		for i = 1 to 999999 do
			(
			try
				(
				n = objXRefs.getFileName i
				append thing_array n
				)
			catch (exit)
			)
		)
	else if ren_onwhat_value == 10 then
		(
		for i in selection do 
			(
			for m in i.modifiers where 
				(
				(classof m == Point_Cache_2) or
				(classof m == Point_Cache_2SpacewarpModifier)
				) 
			do append thing_array m		
			)
		)
	else if ren_onwhat_value == 11 then
		(
		for i in selection do 
			(
			if group_members_value == true then
				(
				if isgroupmember i == false then append thing_array i
				)
			else append thing_array i
			)
		)
	return thing_array
	)
	
fn rename_func = 
	(
	a = on_what_things()
	do_the_rename a
	)
	
fn append_number_func = 
	(
	a = on_what_things()
	append_number_to_array_members a number_start number_step
	)

-- Script

ren_i()

rollout ren_rollout "Renamer"
	(
	group "Rename:"
	(
	dropdownlist rename_type "" items:rename_array height:15
	edittext find_text "Find:" fieldWidth:158 text:find_text_value align:#right enabled:false
	edittext repl_text "Text:" fieldWidth:158 text:repl_text_value align:#right enabled:true
	button do_rename "Rename" width:190 align:#center toolTip:"Rename"
	)

	on rename_type selected i do 
		(
		if i == 4 then 
			(
			find_text.caption = "Find:"
			repl_text.caption = "Repl:"
			find_text.enabled = true
			)
		else 
			(
			find_text.caption = ""
			repl_text.caption = "Text:"
			find_text.enabled = false
			)
		if i == 5 or i == 6 then repl_text.enabled = false else repl_text.enabled = true
		rename_type_value = i
		)
	on find_text changed text do find_text_value = find_text.text
	on repl_text changed text do repl_text_value = repl_text.text
	on do_rename pressed do 
		(
		rename_func()
		ren_o()
		)

	group "Append Number:"
	(
	spinner append_number_start "Start: " range:[0,9999999,1] type:#integer fieldWidth:50 align:#center
	spinner append_number_step "Step: " range:[0,9999999,1] type:#integer fieldWidth:50 align:#center
	button do_append_number "Append Number" width:190 align:#center toolTip:"Append Number"
	)

	on append_number_start changed val do number_start = val
	on append_number_step changed val do number_step = val
	on do_append_number pressed do 
		(
		append_number_func()
		ren_o()
		)

	group "On What?"
	(
	dropdownlist ren_onwhat "" items:onwhat_array align:#center selection:ren_onwhat_value height:20
	Label ren_label1 "Members" align:#left across:2
	Label ren_label2 "0" align:#right
	spinner ren_start "Slot: " range:[1,24,1] type:#integer fieldWidth:50 align:#center enabled:false across:2
	spinner ren_end "to: " range:[1,24,24] type:#integer fieldWidth:50 align:#center enabled:false
	)

	on ren_onwhat selected i do 
		(
		ren_onwhat_value = i
		a = on_what_things()
		ren_label2.text = (a.count as string)
		if i == 1 then
			(
			ren_start.enabled = false
			ren_end.enabled = false
			do_append_number.enabled = true
			append_number_start.enabled = true
			append_number_step.enabled = true
			)
		if i == 2 then
			(
			ren_start.enabled = false
			ren_end.enabled = false
			do_append_number.enabled = true
			append_number_start.enabled = true
			append_number_step.enabled = true
			)
		if i == 3 then
			(
			ren_start.enabled = false
			ren_end.enabled = false
			do_append_number.enabled = true
			append_number_start.enabled = true
			append_number_step.enabled = true
			)
		if i == 4 then
			(
			ren_start.enabled = true
			ren_end.enabled = true
			do_append_number.enabled = true
			append_number_start.enabled = true
			append_number_step.enabled = true
			)
		if i == 5 then
			(
			ren_start.enabled = false
			ren_end.enabled = false
			do_append_number.enabled = false
			append_number_start.enabled = false
			append_number_step.enabled = false
			)
		if i == 6 then
			(
			ren_start.enabled = false
			ren_end.enabled = false
			do_append_number.enabled = true
			append_number_start.enabled = true
			append_number_step.enabled = true
			)
		if i == 7 then
			(
			ren_start.enabled = false
			ren_end.enabled = false
			do_append_number.enabled = false
			append_number_start.enabled = false
			append_number_step.enabled = false
			)
		if i == 8 then
			(
			ren_start.enabled = false
			ren_end.enabled = false
			do_append_number.enabled = false
			append_number_start.enabled = false
			append_number_step.enabled = false
			)
		if i == 9 then
			(
			ren_start.enabled = false
			ren_end.enabled = false
			do_append_number.enabled = false
			append_number_start.enabled = false
			append_number_step.enabled = false
			)
		if i == 10 then
			(
			ren_start.enabled = false
			ren_end.enabled = false
			do_append_number.enabled = false
			append_number_start.enabled = false
			append_number_step.enabled = false
			)
		if i == 11 then
			(
			ren_start.enabled = false
			ren_end.enabled = false
			do_append_number.enabled = true
			append_number_start.enabled = true
			append_number_step.enabled = true
			)
		)
	on ren_start changed val do 
		(
		ren_start_value = val
		a = on_what_things()
		ren_label2.text = (a.count as string)
		)
	on ren_end changed val do 
		(
		ren_end_value = val
		a = on_what_things()
		ren_label2.text = (a.count as string)
		)
	
	on ren_rollout open do
		(
		find_text.caption = ""
		ren_label2.text = (selection.count as string)
		)
	)

rollout ren_options_rollout "Options"
	(
	checkbox group_members "Don't Rename Group Members" checked:true
	on group_members changed state do 
		(
		if group_members.checked == true then group_members_value = true
		else group_members_value = false
		)
	)

if ren_floater != undefined then CloseRolloutFloater ren_floater
ren_floater = newRolloutFloater "Renamer v1.50" 240 399
addRollout ren_rollout ren_floater
addRollout ren_options_rollout ren_floater rolledup:true
)
-------------------------------------------------------------------------------