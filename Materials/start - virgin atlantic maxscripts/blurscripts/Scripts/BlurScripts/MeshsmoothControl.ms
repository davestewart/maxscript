-------------------------------------------------------------------------------
-- MeshsmoothControl.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.31
-- Created On: 11/23/99
-- Modified On: 11/14/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Will change various meshsmooth values globally for all selected objects. Any 
-- selected objects will have their modifier stacks checked, and any instance
-- of the meshsmooth modifier will have it's values changed to reflect the
-- global settings you've choosen in the script, even if the modifiers are not
-- instances of the same modifier. You can also copy the display settings to 
-- render settings, and vice versa.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Will change various meshsmooth values globally for all selected 
-- objects. Any selected objects will have their modifier stacks checked, and 
-- any instance of the meshsmooth modifier will have it's values changed to 
-- reflect the global settings you've choosen in the script, even if the 
-- modifiers are not instances of the same modifier.
--
-- v 1.10 Added more meshsmooth parameters that the script can now affect. Also
-- added the ability to update just part of the meshsmooth information as well
-- as everything.
--
-- v 1.20 Added the ability to copy the display values of each object to the
-- render values fields, and vice versa.
--
-- v 1.21 Added version number to titlebar.
--
-- v 1.30 Now compatible with R4.0.
--
-- v 1.31 Fixed a slight bug in check_for_the_meshsmooth_modifier function.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global check_for_the_meshsmooth_modifier
global change_m_settings

global msc_floater
global msc_rollout
global msc_copyvalues

-- Variables

displayiterationsvalue = 1
displaysmoothnessvalue = 1
render_iterations_enable_value = false
renderiterationsvalue = 1
render_smoothness_enable_value = false
rendersmoothnessvalue = 1
meshsmooth_type_value = 3
what_to_change = 4

-- Functions

fn change_m_settings changewhere what = 
	(
	if what == 1 then
		(
		changewhere.subdivMethod = (meshsmooth_type_value - 1)
		)
	if what == 2 then	
		(
		changewhere.iterations = displayiterationsvalue
		changewhere.smoothness = displaysmoothnessvalue
		)
	if what == 3 then
		(
		changewhere.useRenderIterations = render_iterations_enable_value
		changewhere.renderIterations = renderiterationsvalue
		changewhere.useRenderSmoothness = render_smoothness_enable_value
		changewhere.renderSmoothness = rendersmoothnessvalue
		)
	if what == 4 then
		(
		changewhere.subdivMethod = (meshsmooth_type_value - 1)
		changewhere.iterations = displayiterationsvalue
		changewhere.smoothness = displaysmoothnessvalue
		changewhere.useRenderIterations = render_iterations_enable_value
		changewhere.renderIterations = renderiterationsvalue
		changewhere.useRenderSmoothness = render_smoothness_enable_value
		changewhere.renderSmoothness = rendersmoothnessvalue
		)
	if what == 5 then
		(
		changewhere.iterations = changewhere.Render_Iterations
		changewhere.smoothness = changewhere.Render_Smoothness
		)
	if what == 6 then
		(
		changewhere.renderIterations = changewhere.iterations
		changewhere.renderSmoothness = changewhere.Smoothness_Filter
		)
	)

fn check_for_the_meshsmooth_modifier what_to_change = 
	(
	undo "MeshsmoothControl" on
		(
		if $ == undefined then (MessageBox "Please select at least one object" title:"MeshsmoothControl")
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
							change_m_settings i.modifiers[j] what_to_change
							)
						else continue
						)
					)
				)
			)
		)
	)

-- The Script

rollout msc_rollout "MeshsmoothControl"
	(
	group "Meshsmooth Type:"
	(
	dropdownlist meshsmooth_type "" items:#("Classic", "Quad Output", "NURMS") selection:3
	)
	on meshsmooth_type selected i do meshsmooth_type_value = i

	group "Display Values:"
	(
	spinner displayiterations "Iterations: " range:[0,10,1] fieldWidth:50 type:#integer
	spinner displaysmoothness "Smoothness: " range:[0,1,1] fieldWidth:50
	)

	on displayiterations changed val do displayiterationsvalue = val
	on displaysmoothness changed val do displaysmoothnessvalue = val

	group "Render Values:"
	(
	checkbox render_iterations_enable "" across:2
	spinner renderiterations "Iterations: " range:[0,10,1] fieldWidth:50 type:#integer
	checkbox render_smoothness_enable "" across:2
	spinner rendersmoothness "Smoothness: " range:[0,1,1] fieldWidth:50
	)

	on render_iterations_enable changed state do render_iterations_enable_value = state
	on renderiterations changed val do renderiterationsvalue = val
	on render_smoothness_enable changed state do render_smoothness_enable_value = state
	on rendersmoothness changed val do rendersmoothnessvalue = val

	button update1 "Update MeshSmooth Type" width:150 align:#center toolTip:"Update MeshSmooth Type"
	on update1 pressed do check_for_the_meshsmooth_modifier 1

	button update2 "Update Display Values" width:150 align:#center toolTip:"Update Display Values"
	on update2 pressed do check_for_the_meshsmooth_modifier 2

	button update3 "Update Render Values" width:150 align:#center toolTip:"Update Render Values"
	on update3 pressed do check_for_the_meshsmooth_modifier 3

	button update4 "--- Update Everything ---" width:150 align:#center toolTip:"--- Update Everything ---"
	on update4 pressed do check_for_the_meshsmooth_modifier 4
	)

rollout msc_copyvalues "Copy Values"
	(
	button update5 "Render to Display" width:150 align:#center toolTip:"Copy Render Values to Display Values"
	button update6 "Display to Render" width:150 align:#center toolTip:"Copy Display Values to Render Values"
	on update5 pressed do check_for_the_meshsmooth_modifier 5
	on update6 pressed do check_for_the_meshsmooth_modifier 6
	)

if msc_floater != undefined then CloseRolloutFloater msc_floater
msc_floater = newRolloutFloater "MeshsmoothControl v1.31" 205 383
addRollout msc_rollout msc_floater
addRollout msc_copyvalues msc_floater rolledUp:true 
)
-------------------------------------------------------------------------------