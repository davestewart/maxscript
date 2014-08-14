-------------------------------------------------------------------------------
-- LightIncludeExcludeManager.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.20
-- Created On: 09/12/01
-- Modified On: 02/02/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Copies and pastes Include / Exclude lists for lights. Can work on an entire
-- scene (Good if say you copy the values, merge new lights or objects or lights 
-- into your scene, then pastes those values back in) or lets you copy and paste 
-- include exclude list to and from specific lights in your scene. Based off 
-- scene names, not nodes.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Copies and pastes Include / Exclude lists for scene lights. Good if say you
-- copy the values, merge new lights or objects or lights into your scene, then
-- pastes those values back in. Based off scene names, not nodes.
--
-- v 1.10 Added save and load settings functions.
--
-- v 1.20 Now you can save the include / exclude list from a single light and
-- paste it to another light or set of lights.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global liem_scene_copy
global liem_scene_paste
global liem_scene_savesettings
global liem_scene_loadsettings

global liem_single_copy
global liem_single_paste

global liem_rollout
global liem_floater

global lts_info = #()
global lts_single_info = #()

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

-- Functions

fn liem_scene_copy = 
	(
	lts_info = #()
	lts = all_lights "scene"
	for l in lts do
		(
		ielist = #()
		if l.includeList != undefined then 
			(
			for i in l.includeList do
				(
				append ielist i.name
				)			
			ltype = "include"
			)
		else 
			(
			for i in l.excludeList do
				(
				append ielist i.name
				)
			ltype = "exclude"
			)
		append lts_info #(l.name, ltype, ielist)
		)
	)
	
fn liem_scene_paste = 
	(
	if lts_info.count != 0 then
		(
		for l = 1 to lts_info.count do
			(
			for i in lights do
				(
				if i.name == lts_info[l][1] then
					(
					the_list = #()
					if lts_info[l][3].count != 0 then
						(
						for w = 1 to lts_info[l][3].count do
							(
							for p in $* do
								(
								if p.name == lts_info[l][3][w] then
									(
									append the_list p
									)
								)
							)
						)
					if lts_info[l][2] == "include" then i.includeList = the_list
					else i.excludeList = the_list
					)
				)
			)
		)
	)
	
fn liem_scene_savesettings = 
	(
	liem_file_name = getSaveFileName "LightIncludeExcludeManager" filename:"lights.liem" types:"LightIncludeExcludeManager Settings(*.liem)"
	if liem_file_name != undefined then
		(
		if (substring liem_file_name (liem_file_name.count-4) 5) != ".liem" then liem_file_name += ".liem"

		setINISetting liem_file_name "LightIncludeExcludeManager" "lts_info" (lts_info as string)
		)
	)
	
fn liem_scene_loadsettings = 
	(
	liem_file_name = getOpenFileName "LightIncludeExcludeManager" types:"LightIncludeExcludeManager Settings(*.liem)"
	if liem_file_name != undefined then
		(
		lts_info = execute (getINISetting liem_file_name "LightIncludeExcludeManager" "lts_info")
		)
	)
	
fn liem_single_copy = 
	(
	lts_single_info = #()
	if selection.count == 1 and superclassof $ == light then
		(
		ielist = #()
		if $.includeList != undefined then 
			(
			for i in $.includeList do
				(
				append ielist i.name
				)			
			ltype = "include"
			)
		else 
			(
			for i in $.excludeList do
				(
				append ielist i.name
				)
			ltype = "exclude"
			)
		lts_single_info = #(ltype, ielist)
		)
	else (MessageBox "Please select a single light." title:"LightIncludeExcludeManager")
	)

fn liem_single_paste = 
	(
	if lts_single_info.count != 0 then
		(
		lts = (all_lights "selected")
		for i in lts do
			(
			the_list = #()
			if lts_single_info[2].count != 0 then
				(
				for w = 1 to lts_single_info[2].count do
					(
					for p in $* do
						(
						if p.name == lts_single_info[2][w] then
							(
							append the_list p
							)
						)
					)
				)
			if lts_single_info[1] == "include" then i.includeList = the_list
			else i.excludeList = the_list
			)
		)
	)
	
-- The Script

rollout liem_rollout "LightIncludeExcludeManager"
	(
	group "Scene"
	(	
	button liem_copy_scene_button "Copy" width:80 align:#center toolTip:"Copy Scene" enabled:true across:2
	button liem_paste_scene_button "Paste" width:80 align:#center toolTip:"Paste Scene" enabled:true
	button liem_settings_scene_save "Copy & Save" width:80 align:#center toolTip:"Copy & Save Scene" enabled:true across:2
	button liem_settings_scene_open "Open & Paste" width:80 align:#center toolTip:"Open & Paste Scene" enabled:true
	)
	
	on liem_copy_scene_button pressed do liem_scene_copy()
	on liem_paste_scene_button pressed do liem_scene_paste()
	on liem_settings_scene_save pressed do 
		(
		liem_scene_copy()
		liem_scene_savesettings()
		)
	on liem_settings_scene_open pressed do 
		(
		liem_scene_loadsettings()
		liem_scene_paste()
		)
	
	group "Single"
	(	
	button liem_copy_single_button "Copy" width:80 align:#center toolTip:"Copy Single" enabled:true across:2
	button liem_paste_single_button "Paste" width:80 align:#center toolTip:"Paste Single" enabled:true
	)
	
	on liem_copy_single_button pressed do liem_single_copy()
	on liem_paste_single_button pressed do liem_single_paste()	
	)

if liem_floater != undefined then CloseRolloutFloater liem_floater
liem_floater = newRolloutFloater "LightIncludeExcludeManager v1.20" 220 197
addRollout liem_rollout liem_floater
)
-------------------------------------------------------------------------------