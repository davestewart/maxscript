-------------------------------------------------------------------------------
-- GradientUtilities.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.10
-- Created On: 05/27/01
-- Modified On: 10/01/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Does several things related to Gradients. First, Coverts a standard Gradient 
-- texmap to a Gradient Ramp with similar parameters. Second, lets you make 
-- several Gradient Ramp Presets that I've needed from time to time.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Does several things related to Gradients. First, Coverts a standard 
-- Gradient texmap to a Gradient Ramp with similar parameters. Second, lets you 
-- make several Gradient Ramp Presets that I've needed from time to time. Only one
-- preset exists at the current time.
--
-- v 1.10 Added a bunch of new Gradient Presets. Now requires BSLib.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global grad_to_ramp
global gc_convert
global gradient_preset_update
global gradient_preset

global gc_rollout
global gpr_rollout
global gu_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

gu_toslot_value = 2
gpr = 1
gu_names = #()

-- Functions

fn grad_to_ramp a = 
(
	b = Gradient_Ramp ()
	b.name = a.name
	if a.gradientType == 0 then 
	(
		b.Gradient_Type = 4
		b.gradient_ramp.flag__1.color = a.color1
		b.gradient_ramp.flag__2.color = a.color3
		b.gradient_ramp.flag__3.color = a.color2
		b.gradient_ramp.flag__3.position = (1 - a.color2Pos)*100
	)
	else 
	(
		b.Gradient_Type = 8
		b.gradient_ramp.flag__1.color = a.color3
		b.gradient_ramp.flag__2.color = a.color1
		b.gradient_ramp.flag__3.color = a.color2
		b.gradient_ramp.flag__3.position = (a.color2Pos)*100
	)
		
	b.coordinates.mappingType = a.coordinates.mappingType
	b.coordinates.mapping = a.coordinates.mapping
	b.coordinates.mapChannel = a.coordinates.mapChannel
	b.coordinates.U_Offset = a.coordinates.U_Offset
	b.coordinates.V_Offset = a.coordinates.V_Offset
	b.coordinates.U_Tiling = a.coordinates.V_Tiling
	b.coordinates.V_Tiling = a.coordinates.U_Tiling
	b.coordinates.U_Angle = a.coordinates.U_Angle
	b.coordinates.V_Angle = a.coordinates.V_Angle
	b.coordinates.W_Angle = a.coordinates.W_Angle + 90
	b.coordinates.Blur = a.coordinates.Blur
	b.coordinates.Blur_Offset = a.coordinates.Blur_Offset
	b.coordinates.Phase = a.coordinates.Phase
	b.coordinates.Noise_Amount = a.coordinates.Noise_Amount
	b.coordinates.Noise_Levels = a.coordinates.Noise_Levels
	b.coordinates.Noise_Size = a.coordinates.Noise_Size
	
	b.Noise_Type = a.noiseType
	b.amount = a.noiseAmount
	b.size = a.noiseSize
	b.phase = a.noisePhase
	b.Levels = a.noiseLevels
	b.Low_Threshold = a.noiseThresholdLow
	b.High_Threshold = a.noiseThresholdHigh
	b.Threshold_Smoothing = a.noiseThresholdSMooth
	
	b.output.Output_Amount = a.output.Output_Amount
	b.output.RGB_Offset = a.output.RGB_Offset
	b.output.RGB_Level = a.output.RGB_Level
	b.output.Bump_Amount = a.output.Bump_Amount
	
	return b
)
	
fn gc_convert cur_mat = 
(
	if classof cur_mat == Gradient then
	(
		meditMaterials[gu_toslot_value] = grad_to_ramp cur_mat
	)
	else (MessageBox "Your active material slot must be a Gradient for the script to work." title:"GradientUtilities")
)
	
fn gradient_preset_update = 
(
	gu_names = #()
	mat_files = get_all_files_in_dir "$scripts/BlurMats/" false "mat"
	grad_files = #()
	for i in mat_files do
	(
		if substring (filenameFromPath i) 1 8 == "Gradient" then append grad_files i
	)
	if grad_files.count != 0 then
	(
		for i = 1 to grad_files.count do
		(
			the_name = (filenameFromPath grad_files[i])
			append gu_names (strip_file_extension the_name)
		)
	)
)

fn gradient_preset = 
(
	undo "GradientUtilities" on
	(
		m = get_blurmat (gu_names[gpr] as string)
		if m != false then meditMaterials[medit.GetActiveMtlSlot()] = copy m
	)
)
		
-- Script

rollout gc_rollout "Gradient Converter"
(
	spinner gc_toslot "Output Slot: " range:[1,24,2] type:#integer fieldWidth:27 align:#center
	button gc_convert_button "Convert Gradient To Gradient Ramp" width:200 align:#center toolTip:"Convert Gradient To Gradient Ramp"

	on gc_toslot changed val do gu_toslot_value = val
	on gc_convert_button pressed do 
	(
		gc_convert (medit.GetCurMtl())
	)
)
	
rollout gpr_rollout "Gradient Ramp Presets"
(
	dropdownlist gpr_list "" items:gu_names height:20
	on gpr_list selected i do gpr = i
		
	button do_gpr "Place Preset In Active Slot" width:200 align:#center toolTip:"Place Preset In Active Slot"
	on do_gpr pressed do gradient_preset()
)
	
gradient_preset_update()

if gu_floater != undefined then CloseRolloutFloater gu_floater
gu_floater = newRolloutFloater "GradientUtilities v1.10" 250 200
addRollout gc_rollout gu_floater
addRollout gpr_rollout gu_floater
)
-------------------------------------------------------------------------------