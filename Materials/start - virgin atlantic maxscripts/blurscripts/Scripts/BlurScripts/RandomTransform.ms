-------------------------------------------------------------------------------
-- RandomTransform.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.22
-- Created On: 02/01/01
-- Modified On: 06/30/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Lets you move, rotate and scale an object by a random amount.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Lets you move, rotate and scale an object by a random amount.
--
-- v 1.01 BSLib is now accessed using an include instead of getting loaded
-- at max startup.
--
-- v 1.10 Added a relative and absolute mode. Changed the move default.
--
-- v 1.20 Added code which allows groups to be randomly transformed as either
-- a single object or as a collection of individual objects.
--
-- v 1.21 Cleaned up code a bit in the random_scale_function Function.
--
-- v 1.22 Moved the options group to a new rollout
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global random_move_function
global random_rotate_function
global random_scale_function

global rt_floater
global rt_rollout
global rt_options_rollout

-- Includes

include "$scripts/BlurScripts/BSLib.ms"

-- Variables

av = 5
what_transform_value = 1
rt_type = 2

move_low_value = -50
move_high_value = 50
rotate_low_value = -45
rotate_high_value = 45
scale_low_value = 25
scale_high_value = 200

rt_groups_value = true

-- Functions

fn random_move_function =
	(
	undo "RandomTransform" on
		(
		for i in selection do
			(
			if isgroupmember i == true and rt_groups_value == true then continue
			else
				(
				if rt_type == 1 then
					(
					currentx = 0
					currenty = 0
					currentz = 0
					)
				else
					(
					currentx = i.pos.x
					currenty = i.pos.y
					currentz = i.pos.z
					)
	
				if av == 1 then i.pos.x = currentx + (random move_low_value move_high_value)
				if av == 2 then i.pos.y = currenty + (random move_low_value move_high_value)
				if av == 3 then i.pos.z = currentz + (random move_low_value move_high_value)
				if av == 4 then i.pos = [currentx + (random move_low_value move_high_value), currenty + (random move_low_value move_high_value), currentz + (random move_low_value move_high_value)]
				if av == 5 then 
					(
					cr = (random move_low_value move_high_value)
					i.pos = [currentx + cr, currenty + cr, currentz + cr]
					)
				)
			)
		)
	)

fn random_rotate_function =
	(
	undo "RandomTransform" on
		(
		for i in selection do
			(
			if isgroupmember i == true and rt_groups_value == true then continue
			else
				(
				if rt_type == 2 then
					(
					x = 0
					y = 0
					z = 0
					if av == 1 then x = (angleaxis (random rotate_low_value rotate_high_value) [1,0,0])
					if av == 2 then y = (angleaxis (random rotate_low_value rotate_high_value) [0,1,0])
					if av == 3 then z = (angleaxis (random rotate_low_value rotate_high_value) [0,0,1])
					if av == 4 then 
						(
						x = (angleaxis (random rotate_low_value rotate_high_value) [1,0,0])
						y = (angleaxis (random rotate_low_value rotate_high_value) [0,1,0])
						z = (angleaxis (random rotate_low_value rotate_high_value) [0,0,1])
						)
					if av == 5 then	
						(
						ran = (random rotate_low_value rotate_high_value)
						x = (angleaxis ran [1,0,0])
						y = (angleaxis ran [0,1,0])
						z = (angleaxis ran [0,0,1])
						)
					if x != 0 then axisRotate i x
					if y != 0 then axisRotate i y
					if z != 0 then axisRotate i z
					)
				else
					(
					a = i.pos.x
					b = i.pos.y
					c = i.pos.z
					x = 0
					y = 0
					z = 0
					if av == 1 then 
						(
						i.rotation.x = 0
						x = (angleaxis (random rotate_low_value rotate_high_value) [1,0,0])
						)
					if av == 2 then 
						(
						i.rotation.y = 0
						y = (angleaxis (random rotate_low_value rotate_high_value) [0,1,0])
						)
					if av == 3 then 
						(
						i.rotation.z = 0
						z = (angleaxis (random rotate_low_value rotate_high_value) [0,0,1])
						)
					if av == 4 then 
						(
						i.rotation.x = 0
						i.rotation.y = 0
						i.rotation.z = 0					
						x = (angleaxis (random rotate_low_value rotate_high_value) [1,0,0])
						y = (angleaxis (random rotate_low_value rotate_high_value) [0,1,0])
						z = (angleaxis (random rotate_low_value rotate_high_value) [0,0,1])
						)
					if av == 5 then 
						(
						i.rotation.x = 0
						i.rotation.y = 0
						i.rotation.z = 0
						ran = (random rotate_low_value rotate_high_value)
						x = (angleaxis ran [1,0,0])
						y = (angleaxis ran [0,1,0])
						z = (angleaxis ran [0,0,1])
						)
					if x != 0 then axisRotate i x
					if y != 0 then axisRotate i y
					if z != 0 then axisRotate i z
					i.pos.x = a
					i.pos.y = b
					i.pos.z = c
					)
				)
			)
		)
	)

fn random_scale_function =
	(
	undo "RandomTransform" on
		(
		reallowvalue = scale_low_value*0.01
		realhighvalue = scale_high_value*0.01
		for i in selection do
			(
			if isgroupmember i == true and rt_groups_value == true then continue
			else
				(
				if av == 1 then i.scale.x *= random reallowvalue realhighvalue
				if av == 2 then i.scale.y *= random reallowvalue realhighvalue
				if av == 3 then i.scale.z *= random reallowvalue realhighvalue
				if av == 4 then i.scale *= [(random reallowvalue realhighvalue), (random reallowvalue realhighvalue), (random reallowvalue realhighvalue)]
				if av == 5 then 
					(
					cr = random reallowvalue realhighvalue
					i.scale *= [cr, cr, cr]
					)
				)
			)
		)
	)

fn randomly_transform = 
	(
	if what_transform_value == 1 then random_move_function()
	else if what_transform_value == 2 then random_rotate_function()
	else random_scale_function()
	)

-- Rollouts

rollout rt_rollout "RandomTransform"
	(
	dropdownlist the_axis "" items:#("RX", "RY", "RZ", "RXRYRZ", "RXYZ") selection:5
	dropdownlist what_transform "" items:#("Move", "Rotate", "Scale") selection:1
	dropdownlist rtmode "" items:#("Absolute", "Relative") selection:2

	Group "Move"
	(
	spinner move_low "Low:" fieldWidth:50 range:[-99999999,99999999,-50] type:#worldunits
	spinner move_high "High:" fieldWidth:50 range:[-99999999,99999999,50] type:#worldunits
	)
	
	Group "Rotate"
	(
	spinner rotate_low "Low Angle:" fieldWidth:50 range:[-360,360,-45] type:#float enabled:false
	spinner rotate_high "High Angle:" fieldWidth:50 range:[-360,360,45] type:#float enabled:false
	)
	
	Group "Scale"
	(
	spinner scale_low "Low %" range:[1,10000,25] fieldWidth:50 type:#float enabled:false
	spinner scale_high "High %" range:[1,10000,200] fieldWidth:50 type:#float enabled:false
	)
	
	on the_axis selected i do av = i
	on what_transform selected i do
		(
		if i == 1 then 
			(
			what_transform_value = 1
			move_low.enabled = true
			move_high.enabled = true
			rotate_low.enabled = false
			rotate_high.enabled = false
			scale_low.enabled = false
			scale_high.enabled = false
			rtmode.enabled = true
			)
		else if i == 2 then 
			(
			what_transform_value = 2
			move_low.enabled = false
			move_high.enabled = false
			rotate_low.enabled = true
			rotate_high.enabled = true
			scale_low.enabled = false
			scale_high.enabled = false
			rtmode.enabled = true
			)
		else if i == 3 then 
			(
			what_transform_value = 3
			move_low.enabled = false
			move_high.enabled = false
			rotate_low.enabled = false
			rotate_high.enabled = false
			scale_low.enabled = true
			scale_high.enabled = true
			
			rtmode.selection = 2
			rt_type = 2
			rtmode.enabled = false
			)
		)
	on rtmode selected i do rt_type = i
	
	on move_low changed val do move_low_value = val
	on move_high changed val do move_high_value = val
	on rotate_low changed val do rotate_low_value = val
	on rotate_high changed val do rotate_high_value = val
	on scale_low changed val do scale_low_value = val
	on scale_high changed val do scale_high_value = val
	
	button thetransform "Transform" width:130 align:#center toolTip:"Transform"
	on thetransform pressed do randomly_transform()
	)

rollout rt_options_rollout "Options"
	(
	checkbox treat_groups "Treat Group as Single Obj" checked:true
	on treat_groups changed state do 
		(
		if treat_groups.checked == true then rt_groups_value = true
		else rt_groups_value = false
		)
	)

if rt_floater != undefined then CloseRolloutFloater rt_floater
rt_floater = newRolloutFloater "RandomTransform v1.22" 195 400
addRollout rt_rollout rt_floater
addRollout rt_options_rollout rt_floater rolledup:true
)
-------------------------------------------------------------------------------