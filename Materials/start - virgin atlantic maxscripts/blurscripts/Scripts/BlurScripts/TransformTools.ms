-------------------------------------------------------------------------------
-- TransformTools.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.33
-- Created On: 09/20/99
-- Modified On: 06/02/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Lots of little useful tools to help transform things quickly.
--
-- SimpleRotation: allows you to quickly rotate an object about a specified 
-- coordinate system using various popular degree increments. The R buttons
-- stand for Random. The negative / positive radiobuttons lets you choose the 
-- direction of the rotation. The axis preset buttons are some preset axis
-- around which the rotation could occur, but the rotation will always follow
-- the currently selected UI coordinate system.
--
-- More...More...: The C I R buttons lets you quickly make a copy, instance, 
-- or reference of your object.
--
-- Clear: Clears the position, rotation, or scale info so the objects 
-- defaults back to no rotation, at 0,0,0 with 100% scale factors in all 
-- directions.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Lots of little useful tools to help transform things quickly. Includes 
-- the functionality of PositionCopy, SimpleRotation, and VertexdPositionCopy, 
-- + extra stuff.
--
-- PositionCopy: A helper to copy position info from one object to another. 
-- Select the object you want to copy from, hit the copy button. Then select 
-- the object you want to copy to, and hit either the x, y, z, or xyz button 
-- to paste that particular position information.
--
-- SimpleRotation: allows you to quickly rotate an object about a specified 
-- coordinate system using various popular degree increments. The R buttons
-- stand for Random. The negative / positive radiobuttons lets you choose the 
-- direction of the rotation. The C I R buttons lets you quickly make a copy, 
-- instance, or reference of your object. The axis radio buttons is the axis 
-- around which the rotation occurs (sorry, limitations of maxscript means I 
-- can't have it respect the currently chosen UI coordinate system and 
-- center).
--
-- Clear: Clears the position, rotation, or scale info so the objects 
-- defaults back to no rotation, at 0,0,0 with 100% scale factors in all 
-- directions.
--
-- v 1.10 Some code cleanup and added the VertexPositionCopy script 
-- functionality, so now if you select a vertex instead of an object in 
-- positioncopy, it will copy and paste vertex information. Only works 
-- currently with editable mesh objects with no higherlevel modifiers.
--
-- v 1.11 The rotation stuff now uses the currently selected UI coordinate 
-- system, and made the axis selection options presets. Special thanks to 
-- Larry Minton for providing me with his script extension pack #4 that let
-- me accomplish this task.
--
-- v 1.12 Some code cleanup and added the basics for a new feature called
-- random scale that does just that, randomly scales an object. This feature
-- will become more useful in my next revision as I add more functionality.
--
-- v 1.13 Cleaned up the interface, added a high and low value for the random 
-- scale function, added a button to see the currently copied x y z value.
--
-- v 1.14 The button to view the currently copied xyz values is now editable.
--
-- v 1.15 Now it works fine with even when you have several objects selected
-- at the same time.
--
-- v 1.16 Now gives warning messages when you try and copy or paste the vertex
-- position of a non editable mesh object, or an object with any modifiers
--
-- v 1.17 Fixes a bug that stopped rotation clearing if you only had one 
-- object selected.
--
-- v 1.18 Added version number to Titlebar.
--
-- v 1.19 Copied Position Floater now uses worldunits instead of regular units.
--
-- v 1.20 RandomScale has been removed and now is it's own seperate script.
--
-- v 1.30 Compatible with R4.0 Removed Positioncopy because the align tool
-- does all that.
-- 
-- v 1.31 Removed AxisRotate function to BSLib.
--
-- v 1.32 BSLib is now accessed using an include instead of getting loaded
-- at max startup.
--
-- v 1.33 copy_selected, instance_selected, and reference_selected have been
-- combined into one function. Removed all code pertaining to selection
-- sets, it uses arrays of scene objects now instead.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global axisRotate
global dorotation
global cir_selected
global clear_pos_selected
global clear_rot_selected
global clear_scale_selected

global simplerotation_rollout
global moremore_rollout
global clearrollout_rollout
global tft_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

negpos = 1

-- Functions

fn dorotation rotang rotax =
(
	undo "TransformTools" on
	(
		if selection.count == 0 then (MessageBox "Please Pick an Object" title:"TransformTools")
		else axisRotate $ (angleaxis rotang rotax)
	)
)
	
fn cir_selected operation =
(
	undo "TransformTools" on
	(
		objs = #()
		new_objs = #()
		for i in selection do append objs i
		for i in objs do
		(
			if operation == 1 then mo = copy i
			else if operation == 2 then mo = instance i
			else if operation == 3 then mo = reference i
			
			append new_objs mo
		)
		if new_objs.count != 0 then select new_objs
	)
)

fn clear_pos_selected =
(
	undo "TransformTools" on
	(
		if selection.count == 0 then (MessageBox "Please Pick an Object" title:"TransformTools")
		else
		(	
			$.pos.x = 0
			$.pos.y = 0
			$.pos.z = 0
		)
	)
)
	
fn clear_rot_selected =
(
	undo "TransformTools" on
	(
		if selection.count == 0 then (MessageBox "Please Pick an Object" title:"TransformTools")
		else
		(
			for i in selection do
			(
				a = i.pos.x
				b = i.pos.y
				c = i.pos.z
				i.rotation.x = 0
				i.rotation.y = 0
				i.rotation.z = 0
				i.pos.x = a
				i.pos.y = b
				i.pos.z = c
			)
		)
	)
)
	
fn clear_scale_selected =
(
	undo "TransformTools" on
	(
		if selection.count == 0 then (MessageBox "Please Pick an Object" title:"TransformTools")
		else
		(	
			$.scale.x = 1
			$.scale.y = 1
			$.scale.z = 1
		)
	)
)

-- Script

rollout simplerotation_rollout "SimpleRotation"
(
	label axislabelx "X" align:#center across:3
	label axislabely "Y" align:#center 
	label axislabelz "Z" align:#center 

	button xaxis90 "90" width:25 align:#center across:3 	on xaxis90 pressed do dorotation (negpos*90) [1,0,0]
	button yaxis90 "90" width:25 align:#center 		on yaxis90 pressed do dorotation (negpos*90) [0,1,0]
	button zaxis90 "90" width:25 align:#center 		on zaxis90 pressed do dorotation (negpos*90) [0,0,1]

	button xaxis45 "45" width:25 align:#center across:3 	on xaxis45 pressed do dorotation (negpos*45) [1,0,0]
	button yaxis45 "45" width:25 align:#center 		on yaxis45 pressed do dorotation (negpos*45) [0,1,0]
	button zaxis45 "45" width:25 align:#center 		on zaxis45 pressed do dorotation (negpos*45) [0,0,1]

	button xaxis30 "30" width:25 align:#center across:3 	on xaxis30 pressed do dorotation (negpos*30) [1,0,0]
	button yaxis30 "30" width:25 align:#center 		on yaxis30 pressed do dorotation (negpos*30) [0,1,0]
	button zaxis30 "30" width:25 align:#center 		on zaxis30 pressed do dorotation (negpos*30) [0,0,1]

	button xaxis10 "10" width:25 align:#center across:3 	on xaxis10 pressed do dorotation (negpos*10) [1,0,0]
	button yaxis10 "10" width:25 align:#center 		on yaxis10 pressed do dorotation (negpos*10) [0,1,0]
	button zaxis10 "10" width:25 align:#center 		on zaxis10 pressed do dorotation (negpos*10) [0,0,1]

	button xaxis5 "05" width:25 align:#center across:3 	on xaxis5 pressed do dorotation (negpos*5) [1,0,0]
	button yaxis5 "05" width:25 align:#center 		on yaxis5 pressed do dorotation (negpos*5) [0,1,0]
	button zaxis5 "05" width:25 align:#center 		on zaxis5 pressed do dorotation (negpos*5) [0,0,1]

	button xaxis1 "01" width:25 align:#center across:3 	on xaxis1 pressed do dorotation (negpos*1) [1,0,0]
	button yaxis1 "01" width:25 align:#center 		on yaxis1 pressed do dorotation (negpos*1) [0,1,0]
	button zaxis1 "01" width:25 align:#center 		on zaxis1 pressed do dorotation (negpos*1) [0,0,1]

	button xaxisr "R" width:25 toolTip:"Random" align:#center across:3 	on xaxisr pressed do dorotation (negpos*(random 0 360)) [1,0,0]
	button yaxisr "R" width:25 toolTip:"Random" align:#center 		on yaxisr pressed do dorotation (negpos*(random 0 360)) [0,1,0]
	button zaxisr "R" width:25 toolTip:"Random" align:#center 		on zaxisr pressed do dorotation (negpos*(random 0 360)) [0,0,1]

	radiobuttons negpositive labels:#("Positive", "Negative")
	on negpositive changed state do 
	(
		if negpositive.state == 1 then negpos = 1
		else negpos = -1
	)

	button axischoicepreset1 "Local" width:80 align:#center toolTip:"Local"
	on axischoicepreset1 pressed do 
	(
		setRefCoordSys #local
		setCoordCenter #local
	)

	button axischoicepreset2 "World" width:80 align:#center toolTip:"World"
	on axischoicepreset2 pressed do 
	(
		setRefCoordSys #world
		setCoordCenter #system
	)

	button axischoicepreset3 "Local Center" width:80 align:#center toolTip:"Local Center"
	on axischoicepreset3 pressed do 
	(
		setRefCoordSys #local
		setCoordCenter #selection
	)
)

rollout moremore_rollout "More...More..."
(
	button copyobject_but "C" width:25 across:3 align:#center toolTip:"Copy Object"
	on copyobject_but pressed do cir_selected 1

	button instanceobject_but "I" width:25 align:#center toolTip:"Instance Object"
	on instanceobject_but pressed do cir_selected 2

	button referenceobject_but "R" width:25 align:#center toolTip:"Reference Object"
	on referenceobject_but pressed do cir_selected 3
)

rollout clearrollout_rollout "Clear"
(
	button clearposition_but "P" width:25 across:3 align:#center toolTip:"Clear Position"
	on clearposition_but pressed do clear_pos_selected()

	button clearrotation_but "R" width:25 align:#center toolTip:"Clear Rotation"
	on clearrotation_but pressed do clear_rot_selected()

	button clearscale_but "S" width:25 align:#center toolTip:"Clear Scale"
	on clearscale_but pressed do clear_scale_selected()
)

if tft_floater != undefined then CloseRolloutFloater tft_floater
tft_floater = newRolloutFloater "TransformTools v1.33" 135 497
addRollout simplerotation_rollout tft_floater
addRollout moremore_rollout tft_floater
addRollout clearrollout_rollout tft_floater
)
-------------------------------------------------------------------------------