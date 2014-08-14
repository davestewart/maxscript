-------------------------------------------------------------------------------
-- ThreePoint.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.11
-- Created On: 10/16/00
-- Modified On: 02/02/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Quickly sets up a 3-point lighting setup in your scene.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Quickly sets up a 3-point lighting setup in your scene.
--
-- v 1.01 Made it so the lights created have properly named targets (although
-- the name of the target does not remain synched with the light if you rename
-- the light later).
--
-- v 1.02 Moved some of the code out to BSLib. Also names the lights as to what
-- they are.
--
-- v 1.10 Changed interface a bit. Added the "Always Cube" code. Added tint
-- parameter.
--
-- v 1.11 Modified the light presets slightly.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global add_3_lights
global tp_man
global tp_scene_or_sel
global tp_start

global threep_rollout
global threep_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

dimtype = 1
themultiplier = 3
always_cube_value = true
md = 100
light_1_value = true
light_2_value = true
light_3_value = true
tint_color_value = color 255 251 232

mymin = [0,0,0]
mymax = [0,0,0]
myc = [0,0,0]

-- Functions

fn add_3_lights themin themax thecenter = 
	(
	undo "ThreePoint" on
		(
		light_1_pos = [themin.x,themin.y,themax.z]
		light_2_pos = [themax.x,themin.y,themin.z]
		light_3_pos = [themin.x,themax.y,(themax.z+themin.z)/2]
		
		if light_1_value == true then 
			(
			tar1 = targetSpot rgb:white multiplier:1 contrast:20 softenDiffuseEdge:70 hotspot:40 falloff:50 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] light_1_pos) target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] thecenter)) name:"Light Key"
			tar1.target.name = tar1.name + ".Target"
			tar1.color = hsv_to_rgb tint_color_value.h 15 255
			)
		if light_2_value == true then 
			(
			tar2 = targetSpot rgb:white multiplier:0.35 contrast:20 softenDiffuseEdge:70 hotspot:40 falloff:50 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] light_2_pos) target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] thecenter)) name:"Light Fill"
			tar2.target.name = tar2.name + ".Target"
			tar2.color = hsv_to_rgb tint_color_value.h 45 255
			)
		if light_3_value == true then 
			(
			tar3 = targetSpot rgb:white multiplier:2 contrast:20 softenDiffuseEdge:70 hotspot:40 falloff:50 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] light_3_pos) target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] thecenter)) name:"Light Kicker"
			tar3.target.name = tar3.name + ".Target"
			tar3.color = hsv_to_rgb tint_color_value.h 10 255
			)
		)
	)

fn tp_man =
	(
	mymax = [md,md,md]
	mymin = [-md,-md,-md]
	myc = box_center mymax mymin
	add_3_lights mymin mymax myc
	)
	
fn tp_scene_or_sel = 
	(
	if dimtype == 1 then w = get_scene_bbox()
	else w = get_sel_bbox()
	
	if w == #([0,0,0], [0,0,0]) then tp_man()
	else
		(
		mymax = [0,0,0]
		mymin = [0,0,0]
		myc = box_center w[1] w[2]

		mymax.x = (themultiplier*(w[1].x-myc.x)) + myc.x
		mymax.y = (themultiplier*(w[1].y-myc.y)) + myc.y
		mymax.z = (themultiplier*(w[1].z-myc.z)) + myc.z
		mymin.x = (themultiplier*(w[2].x-myc.x)) + myc.x
		mymin.y = (themultiplier*(w[2].y-myc.y)) + myc.y
		mymin.z = (themultiplier*(w[2].z-myc.z)) + myc.z
		
		if always_cube_value == true then
			(
			a = amax #(mymax.x, mymax.y, mymax.z)
			b = amin #(mymin.x, mymin.y, mymin.z)
			mymax.x = mymax.y = mymax.z = a
			mymin.x = mymin.y = mymin.z = b
			)

		add_3_lights mymin mymax myc
		)
	)
	
fn tp_start =
	(
	if dimtype == 3 then tp_man()
	else tp_scene_or_sel()
	)

-- Script

rollout threep_rollout "ThreePoint"
	(
	group "Scene Dimensions:"
	(
	dropdownlist sd "" items:#("Auto-Detect Scene", "Auto-Detect Selected", "Manual") selection:dimtype align:#right
	)
	
	group "Auto-Detect:"
	(
	label label1 "Multiplier:" align:#left across:2
	spinner mul_spin "" range:[1,999,3] type:#integer fieldWidth:60 enabled:true align:#right
	checkbox always_cube "Always Cube" checked:true align:#left
	)
	
	group "Manual:"
	(
	label label2 "Manual Dim:" align:#left across:2
	spinner md_spin "" range:[0.000001,99999999,100] type:#worldunits fieldWidth:60 enabled:false align:#right
	)

	on sd selected i do 
		(
		dimtype = i
		if i == 1 then
			(
			mul_spin.enabled = true
			always_cube.enabled = true
			md_spin.enabled = false
			)
		else if i == 2 then
			(
			mul_spin.enabled = true
			always_cube.enabled = true
			md_spin.enabled = false
			)
		else if i == 3 then
			(
			mul_spin.enabled = false
			always_cube.enabled = false
			md_spin.enabled = true
			)
		)
	on mul_spin changed val do themultiplier = val
	on always_cube changed state do always_cube_value = always_cube.checked
	on md_spin changed val do md = val

	group "Lights:"
	(
	checkbox light_1 "Key" checked:true align:#left across:3
	checkbox light_2 "Fill" checked:true align:#left
	checkbox light_3 "Kicker" checked:true align:#left
	ColorPicker tint_color "Tint: " color:tint_color_value fieldwidth:30 height:16 enabled:true align:#left
	)

	on light_1 changed state do light_1_value = light_1.checked
	on light_2 changed state do light_2_value = light_2.checked
	on light_3 changed state do light_3_value = light_3.checked
	on tint_color changed new_col do tint_color_value = new_col

	button buttondoit "Make Lights" width:160 align:#center toolTip:"Make Lights"
	on buttondoit pressed do tp_start()
	)

if threep_floater != undefined then CloseRolloutFloater threep_floater
threep_floater = newRolloutFloater "ThreePoint v1.11" 210 326
addRollout threep_rollout threep_floater
)
-------------------------------------------------------------------------------