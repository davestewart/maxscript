-------------------------------------------------------------------------------
-- SubdivisionControl.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 11/14/01
-- Modified On: 11/14/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Will change various meshsmooth values globally for all selected objects. You 
-- can also copy the display settings to render settings, and vice versa. Can
-- work on meshsmooth modifiers or polyobjects, or both.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global sdc_find_meshsmooth
global sdc_find_poly
global sdc_change_meshsmooth
global sdc_change_poly
global sdc_start

global sdc_floater
global sdc_rollout

-- Variables

do_disp_value = false
disp_iter_value = 1
disp_smooth_value = 1

do_rend_value = false
rend_iter_enable_value = false
rend_iter_value = 1
rend_smooth_enable_value = false
rend_smooth_value = 1

affect_meshsmooth_value = true
affect_poly_value = true

sdc_do_what = 0

-- Functions

fn sdc_find_meshsmooth = 
	(
	if $ == undefined then (MessageBox "Please select at least one object" title:"SubdivisionControl")
	else
		(
		for i in selection do
			(
			if i.modifiers.count == 0 then continue
			else
				(
				for j = 1 to i.modifiers.count do
					(
					if classof i.modifiers[j] == MeshSmooth then
						(
						sdc_change_meshsmooth i.modifiers[j]
						)
					else continue
					)
				)
			)
		)
	)
	
fn sdc_find_poly = 
	(
	if $ == undefined then (MessageBox "Please select at least one object" title:"SubdivisionControl")
	else
		(
		for i in selection do
			(
			if classof i.baseobject == Editable_Poly then 
				(
				sdc_change_poly i
				)
			)
		)
	)

fn sdc_change_meshsmooth changewhere = 
	(
	if sdc_do_what == 1 then
		(
		if do_disp_value == true then
			(
			changewhere.iterations = disp_iter_value
			changewhere.smoothness = disp_smooth_value
			)
		if do_rend_value == true then
			(
			changewhere.useRenderIterations = rend_iter_enable_value
			changewhere.renderIterations = rend_iter_value
			changewhere.useRenderSmoothness = rend_smooth_enable_value
			changewhere.renderSmoothness = rend_smooth_value
			)
		)
	if sdc_do_what == 2 then
		(
		changewhere.iterations = changewhere.Render_Iterations
		changewhere.smoothness = changewhere.Render_Smoothness
		)
	if sdc_do_what == 3 then
		(
		changewhere.renderIterations = changewhere.iterations
		changewhere.renderSmoothness = changewhere.Smoothness_Filter
		)
	)
	
fn sdc_change_poly what = 
	(
	if sdc_do_what == 1 then
		(
		if do_disp_value == true then
			(
			what.iterations = disp_iter_value
			what.surfaceSmoothness = disp_smooth_value
			)
		if do_rend_value == true then
			(
			what.useRenderIterations = rend_iter_enable_value
			what.renderIterations = rend_iter_value
			what.useRenderSmoothness = rend_smooth_enable_value
			what.renderSmoothness = rend_smooth_value
			)
		)
	if sdc_do_what == 2 then
		(
		what.iterations = what.renderIterations
		what.surfaceSmoothness = what.renderSmoothness
		)
	if sdc_do_what == 3 then
		(
		what.renderIterations = what.iterations
		what.renderSmoothness = what.surfaceSmoothness
		)
	)
	
fn sdc_start = 
	(
	if affect_meshsmooth_value == true then
		(
		sdc_find_meshsmooth()
		)
	if affect_poly_value == true then
		(
		sdc_find_poly()
		)	
	)

-- The Script

rollout sdc_rollout "SubdivisionControl"
	(
	group "Display Values:"
	(
	checkbox do_disp "" checked:do_disp_value
	spinner disp_iter "Iterations: " range:[0,10,1] fieldWidth:50 type:#integer enabled:do_disp_value
	spinner disp_smooth "Smoothness: " range:[0,1,1] fieldWidth:50 enabled:do_disp_value
	)

	on do_disp changed state do 
		(
		disp_iter.enabled = disp_smooth.enabled = do_disp_value = state
		)
	on disp_iter changed val do disp_iter_value = val
	on disp_smooth changed val do disp_smooth_value = val

	group "Render Values:"
	(
	checkbox do_rend "" checked:do_rend_value
	checkbox rend_iter_enable "" across:2 enabled:do_rend_value
	spinner rend_iter "Iterations: " range:[0,10,1] fieldWidth:50 type:#integer enabled:do_rend_value
	checkbox rend_smooth_enable "" across:2 enabled:do_rend_value
	spinner rend_smooth "Smoothness: " range:[0,1,1] fieldWidth:50 enabled:do_rend_value
	)

	on do_rend changed state do 
		(
		rend_iter.enabled = rend_iter_enable.enabled = rend_smooth.enabled = rend_smooth_enable.enabled = do_rend_value = state
		)	
	on rend_iter_enable changed state do rend_iter_enable_value = state
	on rend_iter changed val do rend_iter_value = val
	on rend_smooth_enable changed state do rend_smooth_enable_value = state
	on rend_smooth changed val do rend_smooth_value = val

	group "Affect:"
	(
	checkbox affect_meshsmooth "Meshsmooth Modifiers" checked:affect_meshsmooth_value
	checkbox affect_poly "Polyobject Subdivision" checked:affect_poly_value
	)

	on affect_meshsmooth changed state do affect_meshsmooth_value = state
	on affect_poly changed state do affect_poly_value = state

	group "Action:"
	(
	button do1 "Update Values" width:160 align:#center toolTip:"Update Values"
	button do2 "Copy Render to Display" width:160 align:#center toolTip:"Copy Render Values to Display Values"
	button do3 "Copy Display to Render" width:160 align:#center toolTip:"Copy Display Values to Render Values"
	)

	on do1 pressed do 
		(
		sdc_do_what = 1
		sdc_start()
		)
	on do2 pressed do 
		(
		sdc_do_what = 2
		sdc_start()
		)
	on do3 pressed do 
		(
		sdc_do_what = 3
		sdc_start()
		)
	)

if sdc_floater != undefined then CloseRolloutFloater sdc_floater
sdc_floater = newRolloutFloater "SubdivisionControl v1.00" 205 411
addRollout sdc_rollout sdc_floater
)
-------------------------------------------------------------------------------