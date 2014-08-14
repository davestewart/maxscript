-------------------------------------------------------------------------------
-- WireJumble.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.44
-- Created On: 08/20/00
-- Modified On: 02/02/02
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Makes a user definable number of wires (lines) of variable thickness that 
-- travel through various target objects. Useful for making jumbles of wires 
-- that go from place to place in your scene without the need to model them,
-- and provides more power in placement then the scatter compound object since
-- it can give each wire a random thickness and allows multiple targets, not 
-- just an emitter object.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Makes a user definable number of wires (lines) of variable thickness 
-- that travel through various target objects. Useful for making jumbles of wires 
-- that go from place to place in your scene without the need to model them,
-- and provides more power in placement then the scatter compound object since
-- it can give each wire a random thickness and allows multiple targets, not 
-- just an emitter object.
--
-- v 1.10 Cleaned the code and interface a bit, added ability to affect number 
-- of steps in the generated splines, as well as the apply mapping Coordinates
-- checkbox. Also added two different target intersection methods, vertex and 
-- BBox. BBox works like before, a spline must pass through the bounding box
-- of a target. Now you can also choose vertex, which means a spline must pass
-- through a random vertex on the target. This is in prep of adding a bunch
-- of other intersection methods in the near future.
--
-- v 1.20 You can now delete the previous set of wires you've just created by
-- one button push. This allows you to quickly make a set of wires, and then
-- get rid of them and start again much quicker if you don't like their 
-- placement.
--
-- v 1.30 Added a new target type: Face Center. Added ability to have 10 
-- targets (eventually I'll allow for n targets, but doing so will require
-- a whole bunch of work, and I'll only do it if it becomes a necessity).
-- Cleaned the code a bit and removed some functionality out to the
-- BSLib.ms. Added compatability to max 4.0 and the ability to use several 
-- new features of max4's renderable splines.
--
-- v 1.40 I took a look at generalizing the code to have n targets, and it's
-- WAY more trouble then it's worth, so instead I'm adding 5 more targets for
-- a total of 15, and moving targets 6-15 into a new rollout that's defaulted
-- to closed (since I've found more then 5 targets are not usually used anyways).
--
-- v 1.41 Fixed an r4 bug that stopped the script from setting the splines as
-- renderable. Changed the floater closing code from a try / catch to an 
-- undefined test.
--
-- v 1.42 BSLib is now accessed using an include instead of getting loaded
-- at max startup.
--
-- v 1.43 Removed all code pertaining to selection sets, it uses arrays of scene 
-- objects now instead. Added a "Select Previous Wireset" button.
--
-- v 1.44 Script now gives objects a unique name after creation. Now if you're 
-- in the modify panel when you run this script, it will automatically switch to 
-- create mode, to avoid several command panel redraws during the creation process.
-- Also turns off screen redraw.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global wj_objs = #()

global get_a_point
global make_spline_points
global wire_renderable
global targets_appear_disappear
global start_the_script

global wj_rollout
global wj_tar1_rollout
global wj_tar2_rollout
global wj_do_rollout
global wj_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

wire_num = 10
wire_step_value = 12

num_targets = 0
tt_value_01 = 1
tt_value_02 = 1
tt_value_03 = 1
tt_value_04 = 1
tt_value_05 = 1
tt_value_06 = 1
tt_value_07 = 1
tt_value_08 = 1
tt_value_09 = 1
tt_value_10 = 1
tt_value_11 = 1
tt_value_12 = 1
tt_value_13 = 1
tt_value_14 = 1
tt_value_15 = 1
tar_obj01 = undefined
tar_obj02 = undefined
tar_obj03 = undefined
tar_obj04 = undefined
tar_obj05 = undefined
tar_obj06 = undefined
tar_obj07 = undefined
tar_obj08 = undefined
tar_obj09 = undefined
tar_obj10 = undefined
tar_obj11 = undefined
tar_obj12 = undefined
tar_obj13 = undefined
tar_obj14 = undefined
tar_obj15 = undefined

renderable_yes = true
gen_mapping_value = true
display_mesh_value = true
wire_min_thick = 1.0
wire_max_thick = 2.0
sides_value = 12

nonrend_targ = 1

-- Functions

fn get_a_point target_type n =
	(
	-- BBox
	if target_type == 1 then
		(
		x1 = (random n.max.x n.min.x)
		y1 = (random n.max.y n.min.y)
		z1 = (random n.max.z n.min.z)
		)

	-- FaceC
	if target_type == 2 then
		(
		addmodifier n (Mesh_Select ())
		face_index = random 1 n.faces.count
		x1 = (facecenter n face_index).x
		y1 = (facecenter n face_index).y
		z1 = (facecenter n face_index).z
		deleteModifier n 1
		)

	-- Vertex
	if target_type == 3 then
		(
		addmodifier n (Mesh_Select ())
		vert_index = random 1 n.numverts
		x1 = (getVert n vert_index).x
		y1 = (getVert n vert_index).y
		z1 = (getVert n vert_index).z
		deleteModifier n 1
		)

	-- Surface
	-- Volume
	-- FaceN

	[x1,y1,z1]
	)

fn make_spline_points the_spline = 
	(
	give_me_a_spline = addnewspline the_spline
	if tar_obj01 != undefined then addknot the_spline give_me_a_spline #smooth #curve (get_a_point tt_value_01 tar_obj01)
	if tar_obj02 != undefined then addknot the_spline give_me_a_spline #smooth #curve (get_a_point tt_value_02 tar_obj02)
	if tar_obj03 != undefined then addknot the_spline give_me_a_spline #smooth #curve (get_a_point tt_value_03 tar_obj03)
	if tar_obj04 != undefined then addknot the_spline give_me_a_spline #smooth #curve (get_a_point tt_value_04 tar_obj04)
	if tar_obj05 != undefined then addknot the_spline give_me_a_spline #smooth #curve (get_a_point tt_value_05 tar_obj05)
	if tar_obj06 != undefined then addknot the_spline give_me_a_spline #smooth #curve (get_a_point tt_value_06 tar_obj06)
	if tar_obj07 != undefined then addknot the_spline give_me_a_spline #smooth #curve (get_a_point tt_value_07 tar_obj07)
	if tar_obj08 != undefined then addknot the_spline give_me_a_spline #smooth #curve (get_a_point tt_value_08 tar_obj08)
	if tar_obj09 != undefined then addknot the_spline give_me_a_spline #smooth #curve (get_a_point tt_value_09 tar_obj09)
	if tar_obj10 != undefined then addknot the_spline give_me_a_spline #smooth #curve (get_a_point tt_value_10 tar_obj10)
	if tar_obj11 != undefined then addknot the_spline give_me_a_spline #smooth #curve (get_a_point tt_value_11 tar_obj11)
	if tar_obj12 != undefined then addknot the_spline give_me_a_spline #smooth #curve (get_a_point tt_value_12 tar_obj12)
	if tar_obj13 != undefined then addknot the_spline give_me_a_spline #smooth #curve (get_a_point tt_value_13 tar_obj13)
	if tar_obj14 != undefined then addknot the_spline give_me_a_spline #smooth #curve (get_a_point tt_value_14 tar_obj14)
	if tar_obj15 != undefined then addknot the_spline give_me_a_spline #smooth #curve (get_a_point tt_value_15 tar_obj15)
	updateshape the_spline
	)

fn wire_renderable a_spline = 
	(
	if renderable_yes == true then
		(
		a_spline.baseobject.renderable = true
		a_spline.mapCoords = gen_mapping_value
		a_spline.thickness = random wire_min_thick wire_max_thick
		a_spline.sides = sides_value
		a_spline.DisplayRenderMesh = display_mesh_value
		)
	else a_spline.baseobject.renderable = false
	)

fn targets_appear_disappear = 
	(
	if nonrend_targ == 1 then nrts = false else nrts = true
	if tar_obj01 != undefined then tar_obj01.renderable = nrts
	if tar_obj02 != undefined then tar_obj02.renderable = nrts
	if tar_obj03 != undefined then tar_obj03.renderable = nrts
	if tar_obj04 != undefined then tar_obj04.renderable = nrts
	if tar_obj05 != undefined then tar_obj05.renderable = nrts
	if tar_obj06 != undefined then tar_obj06.renderable = nrts
	if tar_obj07 != undefined then tar_obj07.renderable = nrts
	if tar_obj08 != undefined then tar_obj08.renderable = nrts
	if tar_obj09 != undefined then tar_obj09.renderable = nrts
	if tar_obj10 != undefined then tar_obj10.renderable = nrts
	if tar_obj11 != undefined then tar_obj11.renderable = nrts
	if tar_obj12 != undefined then tar_obj12.renderable = nrts
	if tar_obj13 != undefined then tar_obj13.renderable = nrts
	if tar_obj14 != undefined then tar_obj14.renderable = nrts
	if tar_obj15 != undefined then tar_obj15.renderable = nrts
	)

fn start_the_script = 
	(
	wj_objs = #()
	if getCommandPanelTaskMode() == #modify then max create mode
	disableSceneRedraw()
	try
		(
		for i = 1 to wire_num do
			(
			cur_spline = line pos:[0,0,0]
			make_spline_points cur_spline
			cur_spline.steps = wire_step_value
			wire_renderable cur_spline
			cur_spline.name = uniqueName "WireJumble"
			append wj_objs cur_spline
			)
		)
	catch ()
	enableSceneRedraw()
	completeRedraw()
	targets_appear_disappear()
	)

-- Script

rollout wj_rollout "Wire Parameters"
	(
	group "Wires"
	(
	spinner wire_number_spin "Number Of Wires:" range:[1,999999,10] type:#integer fieldWidth:50 align:#right
	spinner wire_steps "Steps:" range:[0,1000,12] type:#integer fieldWidth:50 align:#right
	)
	on wire_number_spin changed val do wire_num = val
	on wire_steps changed val do wire_step_value = val

	group "Renderable"
	(
	checkbox renderable_check "Renderable?" checked:true align:#left
	checkbox gen_mapping_check "Generate Mapping Coordinates?" align:#left checked:true
	checkbox display_mesh_check "Display Render Mesh?" align:#left checked:true
	spinner wire_min_thick_spin "Min Thickness: " range:[0,99999,1] type:#float fieldWidth:60 enabled:true align:#right
	spinner wire_max_thick_spin "Max Thickness: " range:[0,99999,2] type:#float fieldWidth:60 enabled:true align:#right
	spinner sides_spin "Sides: " range:[3,9999,12] type:#integer fieldWidth:60 enabled:true align:#right
	)
	on renderable_check changed state do 
		(
		display_mesh_check.enabled = state
		wire_min_thick_spin.enabled = state
		wire_max_thick_spin.enabled = state
		sides_spin.enabled = state
		gen_mapping_check.enabled = state
		if renderable_check.checked == true then renderable_yes = true else renderable_yes = false
		)
	on gen_mapping_check changed state do 
		(
		if gen_mapping_check.checked == true then gen_mapping_value = true else gen_mapping_value = false
		)
	on display_mesh_check changed state do 
		(
		if display_mesh_check.checked == true then display_mesh_value = true else display_mesh_value = false
		)
	on wire_min_thick_spin changed val do wire_min_thick = val
	on wire_max_thick_spin changed val do wire_max_thick = val
	on sides_spin changed val do sides_value = val
	)
	
rollout wj_tar1_rollout "Targets"
	(
	group "Targets"
	(
	label t_label_01 "None" align:#left across:4
	pickbutton p_01 "P" width:20 toolTip:"Pick" filter:geometry_filter align:#left offset:[76,0]
	button c_01 "C" width:20 toolTip:"Clear" align:#left offset:[37,0]
	dropdownlist tt_01 "" items:#("BBox", "FaceC", "Vertex") align:#right offset:[0,0]

	label t_label_02 "None" align:#left across:4
	pickbutton p_02 "P" width:20 toolTip:"Pick" filter:geometry_filter align:#left offset:[76,0]
	button c_02 "C" width:20 toolTip:"Clear" align:#left offset:[37,0]
	dropdownlist tt_02 "" items:#("BBox", "FaceC", "Vertex") align:#right offset:[0,0]

	label t_label_03 "None" align:#left across:4
	pickbutton p_03 "P" width:20 toolTip:"Pick" filter:geometry_filter align:#left offset:[76,0]
	button c_03 "C" width:20 toolTip:"Clear" align:#left offset:[37,0]
	dropdownlist tt_03 "" items:#("BBox", "FaceC", "Vertex") align:#right offset:[0,0]

	label t_label_04 "None" align:#left across:4
	pickbutton p_04 "P" width:20 toolTip:"Pick" filter:geometry_filter align:#left offset:[76,0]
	button c_04 "C" width:20 toolTip:"Clear" align:#left offset:[37,0]
	dropdownlist tt_04 "" items:#("BBox", "FaceC", "Vertex") align:#right offset:[0,0]

	label t_label_05 "None" align:#left across:4
	pickbutton p_05 "P" width:20 toolTip:"Pick" filter:geometry_filter align:#left offset:[76,0]
	button c_05 "C" width:20 toolTip:"Clear" align:#left offset:[37,0]
	dropdownlist tt_05 "" items:#("BBox", "FaceC", "Vertex") align:#right offset:[0,0]
	)

	on p_01 picked obj do 
		(
		if tar_obj01 == undefined then num_targets += 1
		tar_obj01 = obj
		t_label_01.text = obj.name		
		)
	on c_01 pressed do 
		(
		if tar_obj01 != undefined then num_targets -= 1
		tar_obj01 = undefined
		t_label_01.text = "None"
		)
	on tt_01 selected i do tt_value_01 = i
	on p_02 picked obj do 
		(
		if tar_obj02 == undefined then num_targets += 1
		tar_obj02 = obj
		t_label_02.text = obj.name		
		)
	on c_02 pressed do 
		(
		if tar_obj02 != undefined then num_targets -= 1
		tar_obj02 = undefined
		t_label_02.text = "None"
		)
	on tt_02 selected i do tt_value_02 = i
	on p_03 picked obj do 
		(
		if tar_obj03 == undefined then num_targets += 1
		tar_obj03 = obj
		t_label_03.text = obj.name		
		)
	on c_03 pressed do 
		(
		if tar_obj03 != undefined then num_targets -= 1
		tar_obj03 = undefined
		t_label_03.text = "None"
		)
	on tt_03 selected i do tt_value_03 = i
	on p_04 picked obj do 
		(
		if tar_obj04 == undefined then num_targets += 1
		tar_obj04 = obj
		t_label_04.text = obj.name		
		)
	on c_04 pressed do 
		(
		if tar_obj04 != undefined then num_targets -= 1
		tar_obj04 = undefined
		t_label_04.text = "None"
		)
	on tt_04 selected i do tt_value_04 = i
	on p_05 picked obj do 
		(
		if tar_obj05 == undefined then num_targets += 1
		tar_obj05 = obj
		t_label_05.text = obj.name		
		)
	on c_05 pressed do 
		(
		if tar_obj05 != undefined then num_targets -= 1
		tar_obj05 = undefined
		t_label_05.text = "None"
		)
	on tt_05 selected i do tt_value_05 = i
	)
	
rollout wj_tar2_rollout "More Targets"
	(
	group "Targets"
	(
	label t_label_06 "None" align:#left across:4
	pickbutton p_06 "P" width:20 toolTip:"Pick" filter:geometry_filter align:#left offset:[76,0]
	button c_06 "C" width:20 toolTip:"Clear" align:#left offset:[37,0]
	dropdownlist tt_06 "" items:#("BBox", "FaceC", "Vertex") align:#right offset:[0,0]

	label t_label_07 "None" align:#left across:4
	pickbutton p_07 "P" width:20 toolTip:"Pick" filter:geometry_filter align:#left offset:[76,0]
	button c_07 "C" width:20 toolTip:"Clear" align:#left offset:[37,0]
	dropdownlist tt_07 "" items:#("BBox", "FaceC", "Vertex") align:#right offset:[0,0]

	label t_label_08 "None" align:#left across:4
	pickbutton p_08 "P" width:20 toolTip:"Pick" filter:geometry_filter align:#left offset:[76,0]
	button c_08 "C" width:20 toolTip:"Clear" align:#left offset:[37,0]
	dropdownlist tt_08 "" items:#("BBox", "FaceC", "Vertex") align:#right offset:[0,0]

	label t_label_09 "None" align:#left across:4
	pickbutton p_09 "P" width:20 toolTip:"Pick" filter:geometry_filter align:#left offset:[76,0]
	button c_09 "C" width:20 toolTip:"Clear" align:#left offset:[37,0]
	dropdownlist tt_09 "" items:#("BBox", "FaceC", "Vertex") align:#right offset:[0,0]

	label t_label_10 "None" align:#left across:4
	pickbutton p_10 "P" width:20 toolTip:"Pick" filter:geometry_filter align:#left offset:[76,0]
	button c_10 "C" width:20 toolTip:"Clear" align:#left offset:[37,0]
	dropdownlist tt_10 "" items:#("BBox", "FaceC", "Vertex") align:#right offset:[0,0]

	label t_label_11 "None" align:#left across:4
	pickbutton p_11 "P" width:20 toolTip:"Pick" filter:geometry_filter align:#left offset:[76,0]
	button c_11 "C" width:20 toolTip:"Clear" align:#left offset:[37,0]
	dropdownlist tt_11 "" items:#("BBox", "FaceC", "Vertex") align:#right offset:[0,0]

	label t_label_12 "None" align:#left across:4
	pickbutton p_12 "P" width:20 toolTip:"Pick" filter:geometry_filter align:#left offset:[76,0]
	button c_12 "C" width:20 toolTip:"Clear" align:#left offset:[37,0]
	dropdownlist tt_12 "" items:#("BBox", "FaceC", "Vertex") align:#right offset:[0,0]

	label t_label_13 "None" align:#left across:4
	pickbutton p_13 "P" width:20 toolTip:"Pick" filter:geometry_filter align:#left offset:[76,0]
	button c_13 "C" width:20 toolTip:"Clear" align:#left offset:[37,0]
	dropdownlist tt_13 "" items:#("BBox", "FaceC", "Vertex") align:#right offset:[0,0]

	label t_label_14 "None" align:#left across:4
	pickbutton p_14 "P" width:20 toolTip:"Pick" filter:geometry_filter align:#left offset:[76,0]
	button c_14 "C" width:20 toolTip:"Clear" align:#left offset:[37,0]
	dropdownlist tt_14 "" items:#("BBox", "FaceC", "Vertex") align:#right offset:[0,0]

	label t_label_15 "None" align:#left across:4
	pickbutton p_15 "P" width:20 toolTip:"Pick" filter:geometry_filter align:#left offset:[76,0]
	button c_15 "C" width:20 toolTip:"Clear" align:#left offset:[37,0]
	dropdownlist tt_15 "" items:#("BBox", "FaceC", "Vertex") align:#right offset:[0,0]
	)

	on p_06 picked obj do 
		(
		if tar_obj06 == undefined then num_targets += 1
		tar_obj06 = obj
		t_label_06.text = obj.name		
		)
	on c_06 pressed do 
		(
		if tar_obj06 != undefined then num_targets -= 1
		tar_obj06 = undefined
		t_label_06.text = "None"
		)
	on tt_06 selected i do tt_value_06 = i
	on p_07 picked obj do 
		(
		if tar_obj07 == undefined then num_targets += 1
		tar_obj07 = obj
		t_label_07.text = obj.name		
		)
	on c_07 pressed do 
		(
		if tar_obj07 != undefined then num_targets -= 1
		tar_obj07 = undefined
		t_label_07.text = "None"
		)
	on tt_07 selected i do tt_value_07 = i
	on p_08 picked obj do 
		(
		if tar_obj08 == undefined then num_targets += 1
		tar_obj08 = obj
		t_label_08.text = obj.name		
		)
	on c_08 pressed do 
		(
		if tar_obj08 != undefined then num_targets -= 1
		tar_obj08 = undefined
		t_label_08.text = "None"
		)
	on tt_08 selected i do tt_value_08 = i
	on p_09 picked obj do 
		(
		if tar_obj09 == undefined then num_targets += 1
		tar_obj09 = obj
		t_label_09.text = obj.name		
		)
	on c_09 pressed do 
		(
		if tar_obj09 != undefined then num_targets -= 1
		tar_obj09 = undefined
		t_label_09.text = "None"
		)
	on tt_09 selected i do tt_value_09 = i
	on p_10 picked obj do 
		(
		if tar_obj10 == undefined then num_targets += 1
		tar_obj10 = obj
		t_label_10.text = obj.name		
		)
	on c_10 pressed do 
		(
		if tar_obj10 != undefined then num_targets -= 1
		tar_obj10 = undefined
		t_label_10.text = "None"
		)
	on tt_10 selected i do tt_value_10 = i
	on p_11 picked obj do 
		(
		if tar_obj11 == undefined then num_targets += 1
		tar_obj11 = obj
		t_label_11.text = obj.name		
		)
	on c_11 pressed do 
		(
		if tar_obj11 != undefined then num_targets -= 1
		tar_obj11 = undefined
		t_label_11.text = "None"
		)
	on tt_11 selected i do tt_value_11 = i
	on p_12 picked obj do 
		(
		if tar_obj12 == undefined then num_targets += 1
		tar_obj12 = obj
		t_label_12.text = obj.name		
		)
	on c_12 pressed do 
		(
		if tar_obj12 != undefined then num_targets -= 1
		tar_obj12 = undefined
		t_label_12.text = "None"
		)
	on tt_12 selected i do tt_value_12 = i
	on p_13 picked obj do 
		(
		if tar_obj13 == undefined then num_targets += 1
		tar_obj13 = obj
		t_label_13.text = obj.name		
		)
	on c_13 pressed do 
		(
		if tar_obj13 != undefined then num_targets -= 1
		tar_obj13 = undefined
		t_label_13.text = "None"
		)
	on tt_13 selected i do tt_value_13 = i
	on p_14 picked obj do 
		(
		if tar_obj14 == undefined then num_targets += 1
		tar_obj14 = obj
		t_label_14.text = obj.name		
		)
	on c_14 pressed do 
		(
		if tar_obj14 != undefined then num_targets -= 1
		tar_obj14 = undefined
		t_label_14.text = "None"
		)
	on tt_14 selected i do tt_value_14 = i
	on p_15 picked obj do 
		(
		if tar_obj15 == undefined then num_targets += 1
		tar_obj15 = obj
		t_label_15.text = obj.name		
		)
	on c_15 pressed do 
		(
		if tar_obj15 != undefined then num_targets -= 1
		tar_obj15 = undefined
		t_label_15.text = "None"
		)
	on tt_15 selected i do tt_value_15 = i
	)
	
rollout wj_do_rollout "Make The Wires"
	(
	group "Options"
	(
	button clear_wires "Delete Previous Wireset" width:230 align:#center toolTip:"Delete Previous Wireset"
	button select_wires "Select Previous Wireset" width:230 align:#center toolTip:"Select Previous Wireset"
	checkbox nonrend_targ_check "Make Targets Non Renderable?" align:#center checked:true
	)
	on clear_wires pressed do 
		(
		try (for i in wj_objs do delete i)
		catch (MessageBox "This operation has failed. One of the wires may have been deleted, or you may have restarted the script since your last jumble." title:"WireJumble")
		)
	on select_wires pressed do 
		(
		disableSceneRedraw()
		try (select wj_objs)
		catch (MessageBox "This operation has failed. One of the wires may have been deleted, or you may have restarted the script since your last jumble." title:"WireJumble")
		enableSceneRedraw()
		completeRedraw()
		)
	on nonrend_targ_check changed state do 
		(
		if nonrend_targ_check.checked == true then nonrend_targ = 1 else nonrend_targ = 0
		)

	button doit "Make The Wires" width:230 align:#center toolTip:"Make The Wires"
	on doit pressed do 
		(
		if num_targets >= 2 then start_the_script()
		else (MessageBox "Please pick at least two targets" title:"WireJumble")
		)
	)

if wj_floater != undefined then CloseRolloutFloater wj_floater
wj_floater = newRolloutFloater "WireJumble v1.44" 310 649
addRollout wj_rollout wj_floater
addRollout wj_tar1_rollout wj_floater
addRollout wj_tar2_rollout wj_floater rolledUp:true
addRollout wj_do_rollout wj_floater
)
-------------------------------------------------------------------------------