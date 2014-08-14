-------------------------------------------------------------------------------
-- MaterialControl.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.21
-- Created On: 08/03/01
-- Modified On: 06/28/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Allows you to change various parameters on lots of materials.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Allows you to change various parameters on lots of materials.
--
-- v 1.10 Now gives you the option of changing the materials on selected objects.
-- Moved the code that generates the material array to BSlib.
--
-- v 1.20 Now you can turn on or off anable raytracing if the material is a
-- raytrace material.
--
-- v 1.21 Can now perform script on the current Material Library.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global matc_change_mat
global matc_start_script

global matc_rollout
global matc_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

do_shader_value = false
do_twosided_value = false
do_ambient_color_value = false
do_si_value = false
do_speclevel_value = false
do_glossiness_value = false
do_soften_value = false
do_ss_value = false
do_raytrace_value = false

shader_dropdown_value = 2
twosided_checkbox_value = false
ambient_color_value = [0,0,0]
si_spinner_value = 0
speclevel_spinner_value = 0
glossiness_spinner_value = 0
soften_spinner_value = 0.1
ss_checkbox_value = false
raytrace_checkbox_value = false

matc_onwhat_value = 1
matc_start_value = 1
matc_end_value = 24

-- Functions

fn matc_change_mat mat = 
(
	if classof mat == Multimaterial or classof mat == Toon_Assistant then
	(
		for i = 1 to mat.count do
		(
			matc_change_mat mat[i]
		)
	)
	else if classof mat == Blend or classof mat == Blendmaterial then
	(
		matc_change_mat mat.map1
		matc_change_mat mat.map2
	)
	else if classof mat == Standard or classof mat == Standardmaterial then
	(
		if do_shader_value == true then 
		(
			if shader_dropdown_value == 1 then mat.shaderbyname = "anisotropic"
			else if shader_dropdown_value == 2 then mat.shaderbyname = "blinn"
			else if shader_dropdown_value == 3 then mat.shaderbyname = "metal"
			else if shader_dropdown_value == 4 then mat.shaderbyname = "multi-layer"
			else if shader_dropdown_value == 5 then mat.shaderbyname = "oren-nayar-blinn"
			else if shader_dropdown_value == 6 then mat.shaderbyname = "phong"
			else if shader_dropdown_value == 7 then mat.shaderbyname = "strauss"
		)
		if do_twosided_value == true then 
		(
			mat.twoSided = twosided_checkbox_value
		)
		if do_ambient_color_value == true then 
		(
			mat.adLock = off
			mat.ambient = ambient_color_value
		)
		if do_si_value == true then 
		(
			mat.SelfIllumAmount = si_spinner_value
		)
		if do_speclevel_value == true then 
		(
			mat.specularLevel = speclevel_spinner_value
		)
		if do_glossiness_value == true then 
		(
			mat.glossiness = glossiness_spinner_value
		)
		if do_soften_value == true then 
		(
			try (mat.Soften = soften_spinner_value)
			catch()
		)
		if do_ss_value == true then 
		(
			mat.samplerEnable = ss_checkbox_value
		)
	)
	else if classof mat == RaytraceMaterial or classof mat == Raytrace then
	(
		if do_shader_value == true then 
		(
			try
			(
				if shader_dropdown_value == 2 then mat.shaderType = 3
				else if shader_dropdown_value == 3 then mat.shaderType = 2
				else if shader_dropdown_value == 6 then mat.shaderType = 1
			)
			catch ()
		)
		if do_twosided_value == true then 
		(
			try (mat.twoSided = twosided_checkbox_value)
			catch()
		)
		if do_ambient_color_value == true then 
		(
			mat.ambient = ambient_color_value
		)
		if do_si_value == true then 
		(
			mat.Luminosity_Color_On = off
			mat.Self_Illum_Amount = si_spinner_value
		)
		if do_speclevel_value == true then 
		(
			mat.Specular_Level = speclevel_spinner_value
		)
		if do_glossiness_value == true then 
		(
			mat.glossiness = glossiness_spinner_value
		)
		if do_soften_value == true then 
		(
			try (mat.Soften = soften_spinner_value)
			catch()
		)
		if do_ss_value == true then 
		(
			try (mat.supersample = ss_checkbox_value)
			catch ()
		)
		if do_raytrace_value == true then
		(
			try (mat.Enable_Raytraced_Reflections = raytrace_checkbox_value)
			catch()			
		)
	)
)

fn matc_start_script =
(
	mat_array = get_mat_array matc_onwhat_value matc_start_value matc_end_value
	for i in mat_array do matc_change_mat i
)

-- Script

rollout matc_rollout "MaterialControl"
(
	group "Parameters:"
(
	checkbox do_shader "" across:2
	dropdownlist shader_dropdown "" items:#("Anisotropic", "Blinn", "Metal", "Multi-Layer", "Oren-Nayar-Blinn", "Phong", "Strauss") selection:2 enabled:false
	checkbox do_twosided "" across:2
	checkbox twosided_checkbox "2-Sided" enabled:false checked:false align:#right
	checkbox do_ambient_color "" across:2
	ColorPicker ambient_color "Ambient: " color:[0,0,0] fieldwidth:30 height:16 enabled:false align:#right
	checkbox do_si "" across:2
	spinner si_spinner "Self Illumination: " range:[0,100,0] fieldWidth:50 enabled:false type:#integer
	checkbox do_speclevel "" across:2
	spinner speclevel_spinner "Specular Level: " range:[0,999,0] fieldWidth:50 enabled:false type:#integer
	checkbox do_glossiness "" across:2
	spinner glossiness_spinner "Glossiness: " range:[0,999,0] fieldWidth:50 enabled:false type:#integer
	checkbox do_soften "" across:2
	spinner soften_spinner "Soften: " range:[0,1,0.1] fieldWidth:50 enabled:false type:#float
	checkbox do_ss "" across:2
	checkbox ss_checkbox "SuperSampling" enabled:false checked:false align:#right
	checkbox do_raytrace "" across:2
	checkbox raytrace_checkbox "Enable Raytracing" enabled:false checked:false align:#right
)
	
	on do_shader changed state do 
	(
		shader_dropdown.enabled = state
		do_shader_value = state
	)
	on shader_dropdown selected i do shader_dropdown_value = i
	on do_twosided changed state do 
	(
		twosided_checkbox.enabled = state
		do_twosided_value = state
	)
	on twosided_checkbox changed state do twosided_checkbox_value = state
	on do_ambient_color changed state do
	(
		ambient_color.enabled = state
		do_ambient_color_value = state
	)
	on ambient_color changed new_col do ambient_color_value = new_col
	on do_si changed state do 
	(
		si_spinner.enabled = state
		do_si_value = state
	)
	on si_spinner changed val do si_spinner_value = val
	on do_speclevel changed state do 
	(
		speclevel_spinner.enabled = state
		do_speclevel_value = state
	)
	on speclevel_spinner changed val do speclevel_spinner_value = val
	on do_glossiness changed state do 
	(
		glossiness_spinner.enabled = state
		do_glossiness_value = state
	)
	on glossiness_spinner changed val do glossiness_spinner_value = val
	on do_soften changed state do 
	(
		soften_spinner.enabled = state
		do_soften_value = state
	)
	on soften_spinner changed val do soften_spinner_value = val
	on do_ss changed state do 
	(
		ss_checkbox.enabled = state
		do_ss_value = state
	)
	on ss_checkbox changed state do ss_checkbox_value = state
	on do_raytrace changed state do 
	(
		raytrace_checkbox.enabled = state
		do_raytrace_value = state
	)
	on raytrace_checkbox changed state do raytrace_checkbox_value = state
		
	group "On What?"
(
	dropdownlist matc_onwhat "" items:#("All Scene Materials", "Materials On Selected Objects", "All Material Editor Slots", "Material Editor Slot Range", "Active Material Slot", "Materials In Current Matlib") align:#center selection:1
	spinner matc_start "Slot: " range:[1,24,1] type:#integer fieldWidth:50 align:#center enabled:false across:2
	spinner matc_end "to: " range:[1,24,24] type:#integer fieldWidth:50 align:#center enabled:false
)
	
	button matc_button "Change The Materials" width:192 align:#center toolTip:"Change The Materials"

	on matc_onwhat selected i do 
	(
		matc_onwhat_value = i
		if i == 1 then
		(
			matc_start.enabled = false
			matc_end.enabled = false
		)
		if i == 2 then
		(
			matc_start.enabled = false
			matc_end.enabled = false
		)
		if i == 3 then
		(
			matc_start.enabled = false
			matc_end.enabled = false
		)
		if i == 4 then
		(
			matc_start.enabled = true
			matc_end.enabled = true
		)
		if i == 5 then
		(
			matc_start.enabled = false
			matc_end.enabled = false
		)
	)
	on matc_start changed val do matc_start_value = val
	on matc_end changed val do matc_end_value = val
	on matc_button pressed do matc_start_script()
)

if matc_floater != undefined then CloseRolloutFloater matc_floater
matc_floater = newRolloutFloater "MaterialControl v1.21" 230 387
addRollout matc_rollout matc_floater
)
-------------------------------------------------------------------------------