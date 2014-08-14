-------------------------------------------------------------------------------
-- SplineControl.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 06/28/02
-- Modified On: 06/28/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Allows you to change various parameters on splines.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global splc_do

global splc_rollout
global splc_floater

-- Variables

do_rend_thick_value = false
do_rend_sides_value = false
do_rend_angle_value = false
do_renderable_value = false
do_mapping_value = false
do_disprendermesh_value = false
do_useviewport_value = false
do_steps_value = false
do_optimize_value = false
do_adaptive_value = false

rend_thick_value = 1
rend_sides_value = 12
rend_angle_value = 0
renderable_checkbox_value = false
mapping_checkbox_value = false
disprendermesh_checkbox_value = false
useviewport_checkbox_value = false
steps_value = 6
optimize_checkbox_value = true
adaptive_checkbox_value = false

-- Functions

fn splc_do = 
	(
	for i in selection do
		(
		if superclassof i == shape then
			(
			if do_rend_thick_value == true then 
				(
				i.thickness = rend_thick_value
				)
			if do_rend_sides_value == true then 
				(
				i.sides = rend_sides_value
				)
			if do_rend_angle_value == true then 
				(
				i.angle = rend_angle_value
				)
			if do_renderable_value == true then 
				(
				i.baseobject.renderable = renderable_checkbox_value
				)
			if do_mapping_value == true then 
				(
				i.mapCoords = mapping_checkbox_value
				)
			if do_disprendermesh_value == true then 
				(
				i.DisplayRenderMesh = disprendermesh_checkbox_value
				)
			if do_useviewport_value == true then 
				(
				i.UseViewportSettings = useviewport_checkbox_value
				)
			if do_steps_value == true then 
				(
				i.steps = steps_value
				)
			if do_optimize_value == true then 
				(
				i.optimize = optimize_checkbox_value
				)
			if do_adaptive_value == true then 
				(
				i.adaptive = adaptive_checkbox_value
				)
			)
		)
	)

-- Script

rollout splc_rollout "SplineControl"
	(
	group "Rendering Parameters:"
	(
	checkbox do_rend_thick "" across:2
	spinner rend_thick "Render Thickness: " range:[-9999999,9999999,1] fieldWidth:45 enabled:false type:#float
	checkbox do_rend_sides "" across:2
	spinner rend_sides "Render Sides: " range:[3,100,12] fieldWidth:45 enabled:false type:#integer
	checkbox do_rend_angle "" across:2
	spinner rend_angle "Render Angle: " range:[-9999999,9999999,0] fieldWidth:45 enabled:false type:#float
	
	checkbox do_renderable "" across:2
	checkbox renderable_checkbox "Renderable" enabled:false checked:false align:#right
	checkbox do_mapping "" across:2
	checkbox mapping_checkbox "Generate Mapping Coords." enabled:false checked:false align:#right
	checkbox do_disprendermesh "" across:2
	checkbox disprendermesh_checkbox "Display Render Mesh" enabled:false checked:false align:#right
	checkbox do_useviewport "" across:2
	checkbox useviewport_checkbox "Use Viewport Settings" enabled:false checked:false align:#right
	)
	
	group "Interpolation Parameters:"
	(
	checkbox do_steps "" across:2
	spinner steps "Steps: " range:[0,100,6] fieldWidth:45 enabled:false type:#float
	checkbox do_optimize "" across:2
	checkbox optimize_checkbox "Optimize" enabled:false checked:true align:#right
	checkbox do_adaptive "" across:2
	checkbox adaptive_checkbox "Adaptive" enabled:false checked:false align:#right
	)
	
	on do_rend_thick changed state do 
		(
		rend_thick.enabled = state
		do_rend_thick_value = state
		)
	on rend_thick changed val do rend_thick_value = val
	on do_rend_sides changed state do 
		(
		rend_sides.enabled = state
		do_rend_sides_value = state
		)
	on rend_sides changed val do rend_sides_value = val
	on do_rend_angle changed state do 
		(
		rend_angle.enabled = state
		do_rend_angle_value = state
		)
	on rend_angle changed val do rend_angle_value = val
	
	on do_renderable changed state do 
		(
		renderable_checkbox.enabled = state
		do_renderable_value = state
		)
	on renderable_checkbox changed state do renderable_checkbox_value = state
	on do_mapping changed state do 
		(
		mapping_checkbox.enabled = state
		do_mapping_value = state
		)
	on mapping_checkbox changed state do mapping_checkbox_value = state
	on do_disprendermesh changed state do 
		(
		disprendermesh_checkbox.enabled = state
		do_disprendermesh_value = state
		)
	on disprendermesh_checkbox changed state do disprendermesh_checkbox_value = state
	on do_useviewport changed state do 
		(
		useviewport_checkbox.enabled = state
		do_useviewport_value = state
		)
	on useviewport_checkbox changed state do useviewport_checkbox_value = state
	
	on do_steps changed state do 
		(
		steps.enabled = state
		do_steps_value = state
		)
	on steps changed val do steps_value = val
	on do_optimize changed state do 
		(
		optimize_checkbox.enabled = state
		do_optimize_value = state
		)
	on optimize_checkbox changed state do optimize_checkbox_value = state
	on do_adaptive changed state do 
		(
		adaptive_checkbox.enabled = state
		do_adaptive_value = state
		)
	on adaptive_checkbox changed state do adaptive_checkbox_value = state
		
	button splc_button "Update Parameters" width:192 align:#center toolTip:"Update Parameters"
	on splc_button pressed do splc_do()
	)

if splc_floater != undefined then CloseRolloutFloater splc_floater
splc_floater = newRolloutFloater "SplineControl v1.00" 230 349
addRollout splc_rollout splc_floater
)
-------------------------------------------------------------------------------