-------------------------------------------------------------------------------
-- LightUtilities_Cleaner.ms
-- v 2.91
-- Required File For LightUtilities.ms and LightControl.ms
-------------------------------------------------------------------------------
(
-- Functions

fn luc_cone_on_off =
(
	for s in lu_operation_on_what() do
	(
		if classof s == targetSpot or classof s == freeSpot or classof s == TargetDirectionallight or classof s == Directionallight then 
		(
			if luc_conevalue == 1 then s.showCone = true
			if luc_conevalue == 2 then s.showCone = false
		)
	)
)
	
fn luc_attnn_on_off =
(
	for s in lu_operation_on_what() do
	(
		if luc_attnnvalue == 1 then s.showNearAtten = true
		if luc_attnnvalue == 2 then s.showNearAtten = false
	)
)

fn luc_attnf_on_off =
(
	for s in lu_operation_on_what() do
	(
		if luc_attnfvalue == 1 then s.showFarAtten = true
		if luc_attnfvalue == 2 then s.showFarAtten = false
	)
)
	
-- Rollouts

rollout luc_rollout "LightCleaner"
(
	group "What To Do"
	(
		label conelab "Cone" across:2 align:#left
		radiobuttons radcone labels:#("On", "Off", "--") columns:3 align:#right default:3
		label attn1lab "Near Atten" across:2 align:#left
		radiobuttons radattenn labels:#("On", "Off", "--") columns:3 align:#right default:3
		label attn2lab "Far Atten" across:2 align:#left
		radiobuttons radattenf labels:#("On", "Off", "--") columns:3 align:#right default:3
	)

	button button_apply "Apply" width:200 align:#center tooltip:"Apply changes to lights"

	on radcone changed chg do luc_conevalue = chg
	on radattenn changed chg do luc_attnnvalue = chg
	on radattenf changed chg do luc_attnfvalue = chg
	on button_apply pressed do
	(
		if has_scene_changed() == false then 
		(
	    		undo "LightUtilities" on
			(
				if luc_conevalue == 1 or luc_conevalue == 2 then luc_cone_on_off ()
				if luc_attnnvalue == 1 or luc_attnnvalue == 2 then luc_attnn_on_off ()
				if luc_attnfvalue == 1 or luc_attnfvalue == 2 then luc_attnf_on_off ()
			)
		)
	)
)
)
-------------------------------------------------------------------------------