-------------------------------------------------------------------------------
-- RenderSettingsControl.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.10
-- Created On: 08/23/01
-- Modified On: 10/14/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Allows you to change various parameters in the rendering dialogue. Also lets
-- you save these parameters out as files to be used later.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Allows you to change various parameters in the rendering dialogue. Also 
-- lets you save these parameters out as files to be used later.
--
-- v 1.10 Added ability to affect the render output. Fixed a typo that would
-- return in inproper dialogue title when loading settings. Fixed a bug that
-- would not save the aa_checkbox value properly. Changed the file format
-- slightly that the script writes out to, sorry for the inconvenience. If you
-- have a bunch of old files saved, email me and I'll tell you how to convert them.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global rsc_change_dialogue
global rsc_start_script
global rsc_loadsettings
global rsc_savesettings

global rsc_rollout
global rsc_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

do_rend_width_value = false
do_rend_height_value = false
do_rend_aspect_value = false
do_atm_value = false
do_effects_value = false
do_renderoutput_value = false
do_aa_value = false

rend_width_spinner_value = 720
rend_height_spinner_value = 486
rend_aspect_spinner_value = 1.0
atm_checkbox_value = true
effects_checkbox_value = true
rsc_out_dir = undefined
rsc_out_filename = "myrender"
rsc_out_filetype = ".tga"
aa_dropdown_value = 7

rend1_value = true
rend2_value = true

-- Functions

fn rsc_change_dialogue = 
(
	if do_rend_width_value == true then 
	(
		renderWidth = rend_width_spinner_value
	)
	if do_rend_height_value == true then 
	(
		renderHeight = rend_height_spinner_value
	)
	if do_rend_aspect_value == true then 
	(
		renderPixelAspect = rend_aspect_spinner_value
	)
	if do_atm_value == true then 
	(
		rendAtmosphere = atm_checkbox_value
	)
	if do_effects_value == true then 
	(
		renderEffects = effects_checkbox_value
	)
	if do_renderoutput_value == true then 
	(
		rendOutputFilename = rsc_out_dir + rsc_out_filename + rsc_out_filetype
		rendSaveFile = true		
	)
	if do_aa_value == true then 
	(
		scanlineRender.enablePixelSampler = true
		if aa_dropdown_value == 1 then scanlineRender.antiAliasFilter = Area()
		else if aa_dropdown_value == 2 then scanlineRender.antiAliasFilter = Blackman()
		else if aa_dropdown_value == 3 then scanlineRender.antiAliasFilter = Blendfilter()
		else if aa_dropdown_value == 4 then scanlineRender.antiAliasFilter = Catmull_Rom()
		else if aa_dropdown_value == 5 then scanlineRender.antiAliasFilter = Cook_Variable()
		else if aa_dropdown_value == 6 then scanlineRender.antiAliasFilter = cubic()
		else if aa_dropdown_value == 7 then scanlineRender.antiAliasFilter = Mitchell_Netravali()
		else if aa_dropdown_value == 8 then scanlineRender.antiAliasFilter = Plate_Match_MAX_R2()
		else if aa_dropdown_value == 9 then scanlineRender.antiAliasFilter = Quadratic()
		else if aa_dropdown_value == 10 then scanlineRender.antiAliasFilter = Sharp_Quadratic()
		else if aa_dropdown_value == 11 then scanlineRender.antiAliasFilter = Soften()
		else if aa_dropdown_value == 12 then scanlineRender.antiAliasFilter = Video()
	)
)

fn rsc_start_script =
(
	if rend1_value == true then 
	(
		renderer = #production
		rsc_change_dialogue()
	)
	if rend2_value == true then 
	(
		renderer = #draft
		rsc_change_dialogue()
	)
)
	
fn rsc_loadsettings = 
(
	rsc_file_name = getOpenFileName "Load RenderSettingsControl Settings" types:"RenderSettingsControl Settings(*.rsc)"
	if rsc_file_name != undefined then
	(
		if rsc_floater != undefined then 
		(
			rsc_floater_pos = rsc_floater.pos
			CloseRolloutFloater rsc_floater
		)
			
		do_rend_width_value = execute (getINISetting rsc_file_name "RenderSettingsControl" "do_rend_width_value")
		do_rend_height_value = execute (getINISetting rsc_file_name "RenderSettingsControl" "do_rend_height_value")
		do_rend_aspect_value = execute (getINISetting rsc_file_name "RenderSettingsControl" "do_rend_aspect_value")
		do_atm_value = execute (getINISetting rsc_file_name "RenderSettingsControl" "do_atm_value")
		do_effects_value = execute (getINISetting rsc_file_name "RenderSettingsControl" "do_effects_value")
		do_aa_value = execute (getINISetting rsc_file_name "RenderSettingsControl" "do_aa_value")
		do_renderoutput_value = execute (getINISetting rsc_file_name "RenderSettingsControl" "do_renderoutput_value")
		
		rend_width_spinner_value = execute (getINISetting rsc_file_name "RenderSettingsControl" "rend_width_spinner_value")
		rend_height_spinner_value = execute (getINISetting rsc_file_name "RenderSettingsControl" "rend_height_spinner_value")
		rend_aspect_spinner_value = execute (getINISetting rsc_file_name "RenderSettingsControl" "rend_aspect_spinner_value")
		atm_checkbox_value = execute (getINISetting rsc_file_name "RenderSettingsControl" "atm_checkbox_value")
		effects_checkbox_value = execute (getINISetting rsc_file_name "RenderSettingsControl" "effects_checkbox_value")
		aa_dropdown_value = execute (getINISetting rsc_file_name "RenderSettingsControl" "aa_dropdown_value")
		rsc_out_dir = getINISetting rsc_file_name "RenderSettingsControl" "rsc_out_dir"
		rsc_out_filename = getINISetting rsc_file_name "RenderSettingsControl" "rsc_out_filename"
		rsc_out_filetype = getINISetting rsc_file_name "RenderSettingsControl" "rsc_out_filetype"
		
		rend1_value = execute (getINISetting rsc_file_name "RenderSettingsControl" "rend1_value")
		rend2_value = execute (getINISetting rsc_file_name "RenderSettingsControl" "rend2_value")
		
		rsc_floater = newRolloutFloater "RenderSettingsControl v1.10" 280 513 rsc_floater_pos.x rsc_floater_pos.y
		addRollout rsc_rollout rsc_floater
	)
)
	
fn rsc_savesettings = 
(
	rsc_file_name = getSaveFileName "Save RenderSettingsControl Settings" filename:"render1.rsc" types:"RenderSettingsControl Settings(*.rsc)"
	if rsc_file_name != undefined then
	(
		if (substring rsc_file_name (rsc_file_name.count-3) 4) != ".rsc" then rsc_file_name += ".rsc"

		setINISetting rsc_file_name "RenderSettingsControl" "do_rend_width_value" (do_rend_width_value as string)
		setINISetting rsc_file_name "RenderSettingsControl" "do_rend_height_value" (do_rend_height_value as string)
		setINISetting rsc_file_name "RenderSettingsControl" "do_rend_aspect_value" (do_rend_aspect_value as string)
		setINISetting rsc_file_name "RenderSettingsControl" "do_atm_value" (do_atm_value as string)
		setINISetting rsc_file_name "RenderSettingsControl" "do_effects_value" (do_effects_value as string)
		setINISetting rsc_file_name "RenderSettingsControl" "do_aa_value" (do_aa_value as string)
		setINISetting rsc_file_name "RenderSettingsControl" "do_renderoutput_value" (do_renderoutput_value as string)
		
		setINISetting rsc_file_name "RenderSettingsControl" "rend_width_spinner_value" (rend_width_spinner_value as string)
		setINISetting rsc_file_name "RenderSettingsControl" "rend_height_spinner_value" (rend_height_spinner_value as string)
		setINISetting rsc_file_name "RenderSettingsControl" "rend_aspect_spinner_value" (rend_aspect_spinner_value as string)
		setINISetting rsc_file_name "RenderSettingsControl" "atm_checkbox_value" (atm_checkbox_value as string)
		setINISetting rsc_file_name "RenderSettingsControl" "effects_checkbox_value" (effects_checkbox_value as string)
		setINISetting rsc_file_name "RenderSettingsControl" "aa_dropdown_value" (aa_dropdown_value as string)
		setINISetting rsc_file_name "RenderSettingsControl" "rsc_out_dir" (rsc_out_dir as string)
		setINISetting rsc_file_name "RenderSettingsControl" "rsc_out_filename" (rsc_out_filename as string)
		setINISetting rsc_file_name "RenderSettingsControl" "rsc_out_filetype" (rsc_out_filetype as string)

		setINISetting rsc_file_name "RenderSettingsControl" "rend1_value" (rend1_value as string)
		setINISetting rsc_file_name "RenderSettingsControl" "rend2_value" (rend2_value as string)
	)
)

-- Script

rollout rsc_rollout "RenderSettingsControl"
(
	group "Common Parameters:"
(
	checkbox do_rend_width "" across:2 checked:do_rend_width_value
	spinner rend_width_spinner "Width: " range:[1,32768,rend_width_spinner_value] fieldWidth:50 enabled:do_rend_width_value type:#integer
	checkbox do_rend_height "" across:2 checked:do_rend_height_value
	spinner rend_height_spinner "Height: " range:[1,32768,rend_height_spinner_value] fieldWidth:50 enabled:do_rend_height_value type:#integer
	checkbox do_rend_aspect "" across:2 checked:do_rend_aspect_value
	spinner rend_aspect_spinner "Pixel Aspect: " range:[0.001,1000,rend_aspect_spinner_value] fieldWidth:50 enabled:do_rend_aspect_value type:#float
	checkbox do_atm "" across:2 checked:do_atm_value
	checkbox atm_checkbox "Atmosphere" enabled:do_atm_value checked:atm_checkbox_value align:#right
	checkbox do_effects "" across:2 checked:do_effects_value
	checkbox effects_checkbox "Effects" enabled:do_effects_value checked:effects_checkbox_value align:#right
)

	group "Render Output Parameters:"
(
	checkbox do_renderoutput "" across:3 checked:do_renderoutput_value offset:[0,4]
	button rsc_getpath "Path" align:#left offset:[-58,0] enabled:do_renderoutput_value
	edittext rsc_pathlabel "" fieldWidth:165 offset:[2,4] text:(rsc_out_dir as string) align:#right enabled:do_renderoutput_value
	edittext rsc_filename "Name: " fieldWidth:165 text:rsc_out_filename align:#right enabled:do_renderoutput_value
	edittext rsc_filetype "Type: " fieldWidth:165 text:rsc_out_filetype align:#right enabled:do_renderoutput_value
)
	
	group "Scanline Parameters:"
(	
	checkbox do_aa "" across:2 checked:do_aa_value
	dropdownlist aa_dropdown "" items:#("Area", "Blackman", "Blend", "Catmull-Rom", "Cook Variable", "Cubic", "MitNet", "maxr2", "Quadratic", "Sharp Quadratic", "Soften", "Video") selection:aa_dropdown_value enabled:do_aa_value
)
	
	on do_rend_width changed state do 
	(
		rend_width_spinner.enabled = state
		do_rend_width_value = state
	)
	on rend_width_spinner changed val do rend_width_spinner_value = val
	on do_rend_height changed state do 
	(
		rend_height_spinner.enabled = state
		do_rend_height_value = state
	)
	on rend_height_spinner changed val do rend_height_spinner_value = val
	on do_rend_aspect changed state do 
	(
		rend_aspect_spinner.enabled = state
		do_rend_aspect_value = state
	)
	on rend_aspect_spinner changed val do rend_aspect_spinner_value = val
	on do_atm changed state do 
	(
		atm_checkbox.enabled = state
		do_atm_value = state
	)
	on atm_checkbox changed state do atm_checkbox_value = state
	on do_effects changed state do 
	(
		effects_checkbox.enabled = state
		do_effects_value = state
	)
	on effects_checkbox changed state do effects_checkbox_value = state
	
	on do_renderoutput changed state do 
	(
		rsc_getpath.enabled = state
		rsc_pathlabel.enabled = state
		rsc_filename.enabled = state
		rsc_filetype.enabled = state
		do_renderoutput_value = state
	)
	on rsc_getpath pressed do
	(
		rsc_out_dir = getSavePath()
		rsc_pathlabel.text = (rsc_out_dir as string)
	)
	on rsc_pathlabel entered text do 
	(
		if rsc_pathlabel.text == "undefined" then rsc_out_dir = undefined
		else rsc_out_dir = rsc_pathlabel.text
	)
	on rsc_filename changed text do rsc_out_filename = rsc_filename.text
	on rsc_filetype changed text do rsc_out_filetype = rsc_filetype.text
	
	on do_aa changed state do 
	(
		aa_dropdown.enabled = state
		do_aa_value = state
	)
	on aa_dropdown selected i do aa_dropdown_value = i
	
	group "Renderers:"
(
	checkbox rend1 "Production" checked:rend1_value
	checkbox rend2 "Draft" checked:rend2_value
)
	
	on rend1 changed state do (if rend1.checked == true then rend1_value = true else rend1_value = false)
	on rend2 changed state do (if rend2.checked == true then rend2_value = true else rend2_value = false)

	group "Open / Save Settings"
(
	button rsc_settings_open "Open" width:175 align:#center toolTip:"Open"
	button rsc_settings_save "Save" width:175 align:#center toolTip:"Save"
)
	
	on rsc_settings_open pressed do rsc_loadsettings()
	on rsc_settings_save pressed do rsc_savesettings()
		
	button rsc_button "Change Settings" width:240 align:#center toolTip:"Change Settings"
	on rsc_button pressed do 
	(
		the_question = (queryBox "This script will only work if the render scene dialogue is closed. Is it closed?" title:"RenderSettingsControl")
		if the_question == true then
		(
			if rsc_out_dir[rsc_out_dir.count] != "\\" then rsc_out_dir = rsc_out_dir + "\\"
			rsc_start_script()
		)
	)
)

if rsc_floater != undefined then CloseRolloutFloater rsc_floater
rsc_floater = newRolloutFloater "RenderSettingsControl v1.10" 280 513
addRollout rsc_rollout rsc_floater
)
-------------------------------------------------------------------------------