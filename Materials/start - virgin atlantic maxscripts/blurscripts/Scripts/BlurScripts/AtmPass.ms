-------------------------------------------------------------------------------
-- AtmPass.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.03
-- Created On: 06/29/01
-- Modified On: 10/14/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Lets you create several different kinds of atmospheric passes. For example,
-- you can saves an image sequence that represents the current environment 
-- ranges in the scene by changing all objects in the scene to a matte material
-- and rendering the scene with white fog. Good for doing postprocess fog and 
-- postprocess depth of field.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Known Bugs and Issues:
--
-- To get the renderer dialogue to update when you hit the Prepare Renderer
-- button, the dialogue must be closed (there is no way in maxscript to close
-- the dialogue). You are provided a warning, so this limitation isn't too bad
-- as long as you follow the instructions the warning message provides.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Lets you create several different kinds of atmospheric passes. For 
-- example, you can saves an image sequence that represents the current environment
-- ranges in the scene by changing all objects in the scene to a matte material
-- and rendering the scene with white fog. Good for doing postprocess fog and 
-- postprocess depth of field.
--
-- v 1.01 When you load a file it now remembers the last place you put the floater.
--
-- v 1.02 Now it will apply a blur matte material instead of a regular matte material
-- if you have that plugin installed. The main advantage is the blur matte material
-- has a 2 sided option. Also the path label has been replaced with a path
-- editbox.
--
-- v 1.03 Changed the file format slightly that the script writes out to, sorry 
-- for the inconvenience. If you have a bunch of old files saved, email me and 
-- I'll tell you how to convert them.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global apply_matte_func
global check_the_fog
global do_fog_func
global turn_shadows_off
global prepare_renderer_func

global ap_loadsettings
global ap_savesettings

global ap_rollout
global ap_floater

-- Includes

include "$scripts/BlurScripts/BSLib.ms"

-- Variables

ap_fog_type_value = 1
ap_fog_near_value = 0
ap_fog_far_value = 100
ap_usefog_index_value = 1
ap_disable_atm_value = true

ap_out_dir = undefined
ap_out_filename = "AtmPass"
ap_out_filetype = ".jpg"
ap_disable_effects_value = true
ap_disable_shadows_value = true

ap_floater_pos = [400,400]

-- Functions

fn apply_matte_func =
	(
	if (blur_matte_test()) == true then m = get_blurmat "BlurMatte_Atmosphere"
	else m = get_blurmat "Matte_Atmosphere"
	for i in $* do i.material = m
	)

fn check_the_fog =
	(
	if ap_usefog_index_value > numAtmospherics then (MessageBox "That is not a valid Atmosphere index" title:"AtmPass")
	else
		(
		if numAtmospherics != 0 then 
			(
			if classof (getAtmospheric ap_usefog_index_value) != fog then (MessageBox "The atmospheric you have choosen is not fog" title:"AtmPass")
			else (setActive (getAtmospheric ap_usefog_index_value) true)
			)
		)
	)

fn do_fog_func =
	(
	if ap_disable_atm_value == true then
		(
		for j = 1 to numAtmospherics do setActive (getAtmospheric j) false
		)
	if ap_fog_type_value == 1 then 
		(
		addAtmospheric (Fog ())
		(getAtmospheric numAtmospherics).near = ap_fog_near_value
		(getAtmospheric numAtmospherics).far = ap_fog_far_value
		)
	else if ap_fog_type_value == 2 then check_the_fog()
	else if ap_usefog_value == 3 then ()
	)

fn turn_shadows_off =
	(
	for l in (all_lights "scene") do l.baseobject.castshadows = false
	)

fn prepare_renderer_func =
	(
	the_question = (queryBox "Make sure the render scene dialogue is closed. Is it closed?" title:"AtmPass")
	if the_question == true then
		(
		if ap_out_dir[ap_out_dir.count] != "\\" then ap_out_dir = ap_out_dir + "\\"
		rendOutputFilename = ap_out_dir + ap_out_filename + ap_out_filetype
		rendSaveFile = true
		if ap_disable_effects_value == true then renderEffects = false
		if ap_disable_shadows_value == true then turn_shadows_off()
		max render scene
		)
	)

fn ap_loadsettings = 
	(
	ap_file_name = getOpenFileName "Load AtmPass Settings" types:"AtmPass Settings(*.atp)"
	if ap_file_name != undefined then
		(
		if ap_floater != undefined then 
			(
			ap_floater_pos = ap_floater.pos
			CloseRolloutFloater ap_floater
			)
			
		ap_fog_type_value = execute (getINISetting ap_file_name "AtmPass" "ap_fog_type_value")
		ap_fog_near_value = execute (getINISetting ap_file_name "AtmPass" "ap_fog_near_value")
		ap_fog_far_value = execute (getINISetting ap_file_name "AtmPass" "ap_fog_far_value")
		ap_usefog_index_value = execute (getINISetting ap_file_name "AtmPass" "ap_usefog_index_value")
		ap_disable_atm_value = execute (getINISetting ap_file_name "AtmPass" "ap_disable_atm_value")
		
		ap_out_dir = getINISetting ap_file_name "AtmPass" "ap_out_dir"
		ap_out_filename = getINISetting ap_file_name "AtmPass" "ap_out_filename"
		ap_out_filetype = getINISetting ap_file_name "AtmPass" "ap_out_filetype"
		ap_disable_effects_value = execute (getINISetting ap_file_name "AtmPass" "ap_disable_effects_value")
		ap_disable_shadows_value = execute (getINISetting ap_file_name "AtmPass" "ap_disable_shadows_value")
		
		ap_floater = newRolloutFloater "AtmPass v1.03" 210 571 ap_floater_pos.x ap_floater_pos.y
		addRollout ap_rollout ap_floater
		)
	)
	
fn ap_savesettings = 
	(
	ap_file_name = getSaveFileName "Save AtmPass Settings" filename:"atmpass.atp" types:"AtmPass Settings(*.atp)"
	if ap_file_name != undefined then
		(
		if (substring ap_file_name (ap_file_name.count-3) 4) != ".atp" then ap_file_name += ".atp"

		setINISetting ap_file_name "AtmPass" "ap_fog_type_value" (ap_fog_type_value as string)
		setINISetting ap_file_name "AtmPass" "ap_fog_near_value" (ap_fog_near_value as string)
		setINISetting ap_file_name "AtmPass" "ap_fog_far_value" (ap_fog_far_value as string)
		setINISetting ap_file_name "AtmPass" "ap_usefog_index_value" (ap_usefog_index_value as string)
		setINISetting ap_file_name "AtmPass" "ap_disable_atm_value" (ap_disable_atm_value as string)
		
		setINISetting ap_file_name "AtmPass" "ap_out_dir" (ap_out_dir as string)
		setINISetting ap_file_name "AtmPass" "ap_out_filename" (ap_out_filename as string)
		setINISetting ap_file_name "AtmPass" "ap_out_filetype" (ap_out_filetype as string)
		setINISetting ap_file_name "AtmPass" "ap_disable_effects_value" (ap_disable_effects_value as string)
		setINISetting ap_file_name "AtmPass" "ap_disable_shadows_value" (ap_disable_shadows_value as string)
		)
	)

-- The Script

rollout ap_rollout "AtmPass"
	(
	group "Prepare Fog"
	(
	dropdownlist ap_fog_type "" items:#("New Fog", "Existing Fog", "No Fog") selection:ap_fog_type_value
	spinner ap_fog_near "Near %:" range:[0,100,ap_fog_near_value] type:#integer fieldWidth:60 align:#right
	spinner ap_fog_far "Far %: " range:[0,100,ap_fog_far_value] type:#integer fieldWidth:60 align:#right
	spinner ap_usefog_index "Use Index:" range:[1,999999,ap_usefog_index_value] type:#integer fieldWidth:60 align:#right
	checkbox ap_disable_atm "Disable Other Atmospherics" checked:ap_disable_atm_value
	)
	
	on ap_fog_type selected i do
		(
		if i == 1 then 
			(
			ap_fog_type_value = 1
			ap_fog_near.enabled = true
			ap_fog_far.enabled = true
			ap_usefog_index.enabled = false
			ap_disable_atm.enabled = true
			)
		else if i == 2 then 
			(
			ap_fog_type_value = 2
			ap_fog_near.enabled = false
			ap_fog_far.enabled = false
			ap_usefog_index.enabled = true
			ap_disable_atm.enabled = true
			)
		else if i == 3 then 
			(
			ap_fog_type_value = 3
			ap_fog_near.enabled = false
			ap_fog_far.enabled = false
			ap_usefog_index.enabled = false
			ap_disable_atm.enabled = false
			ap_disable_atm.checked = false
			ap_disable_atm_value = false
			)
		)

	on ap_fog_near changed val do ap_fog_near_value = val
	on ap_fog_far changed val do ap_fog_far_value = val
	on ap_usefog_index changed val do ap_usefog_index_value = val
	on ap_disable_atm changed state do 
		(
		if ap_disable_atm.checked == true then ap_disable_atm_value = true
		else ap_disable_atm_value = false
		)

	group "Prepare Renderer"
	(
	button ap_getpath "Path" align:#left across:2
	edittext ap_pathlabel "" fieldWidth:115 offset:[-40,4] text:"undefined"
	edittext ap_filename "   Name: " fieldWidth:115 text:ap_out_filename align:#right
	edittext ap_filetype "   Type: " fieldWidth:115 text:ap_out_filetype align:#right
	checkbox ap_disable_effects "Disable Effects" checked:ap_disable_effects_value
	checkbox ap_disable_shadows "Disable Shadows" checked:ap_disable_shadows_value
	)

	on ap_getpath pressed do
		(
		ap_out_dir = getSavePath()
		ap_pathlabel.text = (ap_out_dir as string)
		)
	on ap_pathlabel entered text do 
		(
		if ap_pathlabel.text == "undefined" then ap_out_dir = undefined
		else ap_out_dir = ap_pathlabel.text
		)
	on ap_filename changed text do ap_out_filename = ap_filename.text
	on ap_filetype changed text do ap_out_filetype = ap_filetype.text
	on ap_disable_effects changed state do 
		(
		if ap_disable_effects.checked == true then ap_disable_effects_value = true
		else ap_disable_effects_value = false
		)
	on ap_disable_shadows changed state do 
		(
		if ap_disable_shadows.checked == true then ap_disable_shadows_value = true
		else ap_disable_shadows_value = false
		)

	group "Open / Save Settings"
	(
	button ap_settings_open "Open" width:150 align:#center toolTip:"Open"
	button ap_settings_save "Save" width:150 align:#center toolTip:"Save"
	)
	
	on ap_settings_open pressed do ap_loadsettings()
	on ap_settings_save pressed do ap_savesettings()

	group "To Do"
	(
	button hold_max_file "Hold" width:150 align:#center toolTip:"Hold"
	button apply_matte "Apply Matte" width:150 align:#center toolTip:"Apply Matte"
	button do_fog "Prepare Fog" width:150 align:#center toolTip:"Prepare Fog"
	button prepare_renderer "Prepare Renderer" width:150 align:#center toolTip:"Prepare Renderer"
	button fetch_max_file "Fetch" width:150 align:#center toolTip:"Fetch"
	)

	on hold_max_file pressed do HoldMaxFile()
	on apply_matte pressed do apply_matte_func()
	on do_fog pressed do do_fog_func()
	on prepare_renderer pressed do
		(
		if ap_out_dir != undefined then prepare_renderer_func()
		else (MessageBox "Please pick a valid path" title:"AtmPass")
		)
	on fetch_max_file pressed do fetchMaxFile()
	
	on ap_rollout open do
		(
		ap_pathlabel.text = (ap_out_dir as string)
		if ap_fog_type_value == 1 then
			(
			ap_fog_near.enabled = true
			ap_fog_far.enabled = true
			ap_usefog_index.enabled = false
			ap_disable_atm.enabled = true
			)
		else if ap_fog_type_value == 2 then 
			(
			ap_fog_near.enabled = false
			ap_fog_far.enabled = false
			ap_usefog_index.enabled = true
			ap_disable_atm.enabled = true
			)
		else if ap_fog_type_value == 3 then 
			(
			ap_fog_near.enabled = false
			ap_fog_far.enabled = false
			ap_usefog_index.enabled = false
			ap_disable_atm.enabled = false
			ap_disable_atm.checked = false
			ap_disable_atm_value = false
			)
		)
	)

if ap_floater != undefined then CloseRolloutFloater ap_floater
ap_floater = newRolloutFloater "AtmPass v1.03" 210 571
addRollout ap_rollout ap_floater
)
-------------------------------------------------------------------------------