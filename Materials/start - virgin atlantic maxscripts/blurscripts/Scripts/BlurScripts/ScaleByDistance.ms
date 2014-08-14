-------------------------------------------------------------------------------
-- ScaleByDistance.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 11/09/01
-- Modified On: 11/09/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Scales a series of objects based on the distance between two mouseclicks.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Instructions:
-- Choose your scaling axis and amounts, then hit go, click once, that's the 
-- start, click twice, that's the distance. Objects at the center (near the first
-- click) will be scaled based on your high value, objects beyond your maximum 
-- distance (second click) are scaled based on the low value, and a smooth
-- interpolation in between.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global sbd_point_a = [0,0,0]
global sbd_point_b = [0,0,0]

global sbd_get_dist
global sbd_do_scale
global sbd_start

global sbd_rollout
global sbd_floater

-- Variables

sbd_do_x = false
sbd_x_low = 0.5
sbd_x_high = 1.0
sbd_do_y = false
sbd_y_low = 0.5
sbd_y_high = 1.0
sbd_do_z = false
sbd_z_low = 0.5
sbd_z_high = 1.0

-- The Script

tool sbd_get_dist
	(
	on mousePoint clickno do 
		(
		if clickno == 2 then sbd_point_a = worldPoint
		else if clickno == 3 then
			(
			sbd_point_b = worldPoint
			#stop
			)
		)
	)

fn sbd_do_scale = 
	(
	sbd_dist = distance sbd_point_a sbd_point_b
	for i in selection do
		(
		my_dist = distance i.pos sbd_point_a
		if sbd_do_x == true then
			(
			print sbd_x_low
			if my_dist >= sbd_dist then i.scale.x *= sbd_x_low
			else 
				(
				my_ratio = 1 - (my_dist / sbd_dist)
				i.scale.x *= (my_ratio * (sbd_x_high - sbd_x_low)) + sbd_x_low
				)
			)
		if sbd_do_y == true then
			(
			if my_dist >= sbd_dist then i.scale.y *= sbd_y_low
			else 
				(
				my_ratio = 1 - (my_dist / sbd_dist)
				i.scale.y *= (my_ratio * (sbd_y_high - sbd_y_low)) + sbd_y_low
				)
			)
		if sbd_do_z == true then
			(
			if my_dist >= sbd_dist then i.scale.z *= sbd_z_low
			else 
				(
				my_ratio = 1 - (my_dist / sbd_dist)
				i.scale.z *= (my_ratio * (sbd_z_high - sbd_z_low)) + sbd_z_low
				)
			)
		)
	)

fn sbd_start = 
	(
	startTool sbd_get_dist
	sbd_do_scale()
	)

-- Rollouts

rollout sbd_rollout "ScaleByDistance"
	(
	dropdownlist method "" items:#("Spherical") selection:1

	checkbox do_x "X:" checked:sbd_do_x across:3
	spinner x_low "Low:" fieldWidth:50 range:[0.0,999999,50] type:#float offset:[-10,0] enabled:sbd_do_x
	spinner x_high "High:" fieldWidth:50 range:[0.0,999999,100] type:#float enabled:sbd_do_x
	
	on do_x changed state do 
		(
		sbd_do_x = state
		x_low.enabled = state
		x_high.enabled = state
		)	
	on x_low changed val do sbd_x_low = (val * 0.01)
	on x_high changed val do sbd_x_high = (val * 0.01)
	
	checkbox do_y "Y:" checked:sbd_do_y across:3
	spinner y_low "Low:" fieldWidth:50 range:[0.0,999999,50] type:#float offset:[-10,0] enabled:sbd_do_y
	spinner y_high "High:" fieldWidth:50 range:[0.0,999999,100] type:#float enabled:sbd_do_y
	
	on do_y changed state do 
		(
		sbd_do_y = state
		y_low.enabled = state
		y_high.enabled = state
		)	
	on y_low changed val do sbd_y_low = (val * 0.01)
	on y_high changed val do sbd_y_high = (val * 0.01)
	
	checkbox do_z "Z:" checked:sbd_do_z across:3
	spinner z_low "Low:" fieldWidth:50 range:[0.0,999999,50] type:#float offset:[-10,0] enabled:sbd_do_z
	spinner z_high "High:" fieldWidth:50 range:[0.0,999999,100] type:#float enabled:sbd_do_z
	
	on do_z changed state do 
		(
		sbd_do_z = state
		z_low.enabled = state
		z_high.enabled = state
		)	
	on z_low changed val do sbd_z_low = (val * 0.01)
	on z_high changed val do sbd_z_high = (val * 0.01)
	
	button doit "Perform Scale on Selected Objects" width:250 align:#center toolTip:"Perform Scale on Selected Objects"
	on doit pressed do 
		(
		print sbd_x_low
		sbd_start()
		)
	)

if sbd_floater != undefined then CloseRolloutFloater sbd_floater
sbd_floater = newRolloutFloater "ScaleByDistance v1.00" 300 185
addRollout sbd_rollout sbd_floater
)
-------------------------------------------------------------------------------