-------------------------------------------------------------------------------
-- AnimatedAlign.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 10/12/01
-- Modified On: 10/14/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Align one object to another object at each requested frame range. Does
-- one key per frame. Will add rotational aligning in next version.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global start_anima

global anima_rollout
global anima_floater

-- Variables

sta = 0
sto = 100

obj1 = undefined
obj2 = undefined

x_pos_value = true
y_pos_value = true
z_pos_value = true
x_or_value = false
y_or_value = false
z_or_value = false

-- Functions

fn start_anima = 
	(
	if isdeleted obj1 == true or isdeleted obj2 == true then (MessageBox "At least one of your objects has been deleted. Please pick new objects." title:"AnimatedAlign")
	else
		(
		for i = sta to sto do
			(
			animate on at time i 
				(
--				if x_or_value == true then obj1.rotation.x = obj2.rotation.x
--				if y_or_value == true then obj1.rotation.y = obj2.rotation.y
--				if z_or_value == true then obj1.rotation.z = obj2.rotation.z
				if x_pos_value == true then obj1.pos.x = obj2.pos.x
				if y_pos_value == true then obj1.pos.y = obj2.pos.y
				if z_pos_value == true then obj1.pos.z = obj2.pos.z
				)
			)
		)
	)
	
-- Script
	
rollout anima_rollout "AnimatedAlign"
	(
	group "Objects"
	(
	label what_obj1 "None" align:#center
	pickbutton PickObj1 "Pick Object To Align" width:180 align:#center toolTip:"Pick Object To Align" filter:geometry_filter
	label what_obj2 "None" align:#center
	pickbutton PickObj2 "Pick Object To Align To" width:180 align:#center toolTip:"Pick Object To Align To" filter:geometry_filter
	)
	
	on PickObj1 picked obj do 
		(
		obj1 = obj
		what_obj1.text = obj.name
		)
		
	on PickObj2 picked obj do 
		(
		obj2 = obj
		what_obj2.text = obj.name
		)
	
	group "Time"
	(
	spinner start_time "Start: " range:[-9999999,9999999,0] type:#integer fieldWidth:45 align:#center across:2
	spinner end_time " End: " range:[-9999999,9999999,100] type:#integer fieldWidth:45 align:#center
	)
	on start_time changed val do sta = val
	on end_time changed val do sto = val
	
	group "Parameters"
	(
	label label1 "Position:" align:#center
	checkbox x_pos "X" across:3 align:#center checked:x_pos_value
	checkbox y_pos "Y" align:#center checked:y_pos_value
	checkbox z_pos "Z" align:#center checked:z_pos_value
	
	label label2 "Orientation:" align:#center enabled:false
	checkbox x_or "X" across:3 align:#center checked:x_or_value enabled:false
	checkbox y_or "Y" align:#center checked:y_or_value enabled:false
	checkbox z_or "Z" align:#center checked:z_or_value enabled:false
	)
	on x_pos changed state do x_pos_value = state
	on y_pos changed state do y_pos_value = state
	on z_pos changed state do z_pos_value = state
	
	on x_or changed state do x_or_value = state
	on y_or changed state do y_or_value = state
	on z_or changed state do z_or_value = state
	
	button doit "Start Aligning" width:180 align:#center toolTip:"Start Aligning"
	on doit pressed do start_anima()
	)

if anima_floater != undefined then CloseRolloutFloater anima_floater
anima_floater = newRolloutFloater "AnimatedAlign v1.00" 230 355
addRollout anima_rollout anima_floater
)
-------------------------------------------------------------------------------