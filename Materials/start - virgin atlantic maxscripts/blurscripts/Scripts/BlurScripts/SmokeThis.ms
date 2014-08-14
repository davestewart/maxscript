-------------------------------------------------------------------------------
-- SmokeThis.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 2.11
-- Created On: 10/29/99
-- Modified On: 08/01/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Makes a superspray, or pcloud with a material that simulates smoke. This is a 
-- quick way to create some smoke for your scene, go into the material afterwards 
-- to tweak its color, density, etc manually.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Known Bugs and Issues:
--
-- If you have the plugin Illustrate installed, it will stop this script
-- from functioning. Unfortunately, we don't have a copy of illustrate in
-- the studio for testing, so I can't fix the bug. In the meantime, remove
-- illustrate from your plugin.ini when you want to run this script.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Makes a superspray with a material that simulates smoke. This is a 
-- quick way to create some smoke for your scene, go into the material 
-- afterwards to tweak its color, density, etc manually.
--
-- v 1.10 Now if you put the smoke material into the material editor, it's a 
-- cube instead of a sphere, making adjusting the effect easier.
--
-- v 1.20 Now the particle system has Shadow casting and receiving turned off
-- by default.
--
-- v 2.00 Added a whole bunch of functionality, now you can create a superspray,
-- or pcloud system, or just get the material to use on something else.
--
-- v 2.10 Compatible with R4.0. Now places the material in your currently 
-- selected slot if you hit the material button.
--
-- v 2.11 The material definitions have been moved into BSLib.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global do_superspray
global do_pcloud
global do_material

global st_floater
global st_rollout

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

-- Functions

fn do_superspray =
(
	undo "SmokeThis" on
	(
		ss = SuperSpray speed:3 Speed_Variation:20 Off_Axis:0 Axis_Spread:10 Off_Plane:0 Plane_Spread:5 Birth_Rate:1 Total_Number:100 quantityMethod:0 viewPercent:100 Emitter_Start:0f Emitter_Stop:100f Display_Until:100f life:100f Life_Variation:0f subsampleEmitterTranslation:on subsampleCreationTime:on subsampleEmitterRotation:off size:36 Size_Variation:30 Growth_Time:10f Fade_Time:0f seed:2283 standardParticle:3 Metaparticle_Tension:1 Metaparticle_Tension_Variation:0 metaballAutoCoarsness:on metaballRenderCoarsness:0.5 viewType:1 mappingType:0 Mapping_Time_Base:30f Mapping_Distance_Base:100 Spin_Time:330f Spin_Time_Variation:40 Spin_Phase:0 Spin_Phase_Variation:0 spinAxisType:2 X_Spin_Vector:0 Y_Spin_Vector:2 Z_Spin_Vector:0 Spin_Axis_Variation:0 motionInfluence:100 motionMultiplier:1 motionVariation:0 Bubble_Amplitude:0 Bubble_Amplitude_Variation:0 Bubble_Period:100000f Bubble_Period_Variation:0 Bubble_Phase:0 Bubble_Phase_Variation:0 iconsize:45 iconHidden:off metaballViewCoarsness:1 Spawn_Affects:100 Spawn_Multiplier_Variation:0 Die__X_frames_after_collision:0f Interparticle_Collisions_On:0 Interparticle_Collision_Steps:2 Interparticle_Collision_Bounce:100 Interparticle_Collision_Bounce_Variation:0 pos:[0,0,0] isSelected:on
		ss.material = copy (get_blurmat "Smoke")
		ss.castShadows = off
		ss.receiveshadows = off
	)
)

fn do_pcloud =
(
	undo "SmokeThis" on
	(
		pc = PCloud speed:3 Speed_Variation:20 Birth_Rate:4 Total_Number:100 quantityMethod:0 viewPercent:100 Emitter_Start:0f Emitter_Stop:100f Display_Until:100f life:100f Life_Variation:0f size:36 Size_Variation:30 Growth_Time:10f Fade_Time:0f seed:666 standardParticle:3 Metaparticle_Tension:1 Metaparticle_Tension_Variation:0 metaballAutoCoarsness:on metaballRenderCoarsness:0.5 metaballViewCoarsness:1 viewType:1 mappingType:0 Mapping_Time_Base:30f Mapping_Distance_Base:100 Spin_Time:330f Spin_Time_Variation:40 Spin_Phase:0 Spin_Phase_Variation:0 spinAxisType:0 X_Spin_Vector:1 Y_Spin_Vector:0 Z_Spin_Vector:0 Spin_Axis_Variation:0 motionType: 1 Direction_Vector_X:0 Direction_Vector_Y:1 Direction_Vector_Z:0 motionInfluence:100 motionMultiplier:1 motionVariation:0 Bubble_Amplitude:0 Bubble_Amplitude_Variation:0 Bubble_Period:100000f Bubble_Period_Variation:0 Bubble_Phase:0 Bubble_Phase_Variation:0 Emitter_Rad_Len:20 emitterHidden:off Spawn_Generations:1 Spawn_Multiplier:1 formation:0 Die__X_frames_after_collision:0f Die__X_frames_after_collision_variation:0 Interparticle_Collisions_On:0 Interparticle_Collision_Steps:2 Interparticle_Collision_Bounce:100 Interparticle_Collision_Bounce_Variation:0 Emitter_Width:90 Emitter_Height:90 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:on
		pc.material = copy (get_blurmat "Smoke")
		pc.castShadows = off
		pc.receiveshadows = off
	)
)

fn do_material =
(
	undo "SmokeThis" on
	(
		meditMaterials[medit.GetActiveMtlSlot()] = copy (get_blurmat "Smoke")
	)
)

-- The Script

rollout st_rollout "SmokeThis"
(
	button superspray_button "SuperSpray" width:170 align:#center toolTip:"SuperSpray"
	on superspray_button pressed do do_superspray()

	button pcloud_button "PCloud" width:170 align:#center toolTip:"PCloud"
	on pcloud_button pressed do do_pcloud()
	
	button material_button "Material" width:170 align:#center toolTip:"Material"
	on material_button pressed do do_material()
)

if st_floater != undefined then CloseRolloutFloater st_floater
st_floater = newRolloutFloater "SmokeThis v2.11" 220 148
addRollout st_rollout st_floater
)
-------------------------------------------------------------------------------