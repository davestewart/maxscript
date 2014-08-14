-------------------------------------------------------------------------------
-- LightUtilities_Order.ms
-- v 2.91
-- Required File For LightUtilities.ms and LightControl.ms
-------------------------------------------------------------------------------
(
-- Functions

fn luo_start = 
(
	luo_cur_light = 1
	luo_update()
)

fn luo_up lelight = 
(
	if lelight != 1 then
	(
		local temp = luo_array[lelight]
		luo_array[lelight] = luo_array[lelight-1]
		luo_array[lelight-1] = temp
		luo_cur_light -= 1
	)
	luo_update()
)
	
fn luo_down lelight = 
(
	if lelight != luo_array.count then
	(
		local temp = luo_array[lelight]
		luo_array[lelight] = luo_array[lelight+1]
		luo_array[lelight+1] = temp
		luo_cur_light += 1
	)
	luo_update()
)

fn luo_func = 
(
	luos="Rollout luo_rollout \"LightOrder\"\n"
	luos+="(\n"

	luos+="Button luo_up_button \"Up\" width:80 height:23 align:#center tooltip:\"Move Light Up\" across:2\n"
	luos+="Button luo_down_button \"Down\" width:80 height:23 align:#center tooltip:\"Move Light Down\"\n"

	luos+="on luo_up_button pressed do luo_up luo_cur_light\n"
	luos+="on luo_down_button pressed do luo_down luo_cur_light\n"
	
	luos_light_labels = #()

	if luo_array.count != 0 then
	(
		for i in luo_array do
		(
			append luos_light_labels (i.name as string)
		)
		luos+="radiobuttons which_light labels:luos_light_labels default:luo_cur_light columns:1\n"
		luos+="on which_light changed state do luo_cur_light = which_light.state\n"
	)

	luos+="button luo_done_button \"Done\" width:80 height:23 align:#center across:2 tooltip:\"Done\"\n"
	luos+="button luo_cancel_button \"Cancel\" width:80 height:23 align:#center toolTip:\"Do the Conversion\"\n"
	
	luos+="on luo_done_button pressed do (destroydialog luo_rollout\n"
	luos+="luo_rollout = undefined\n"
	luos+="luv_cumulative())\n"	
	luos+="on luo_cancel_button pressed do (destroydialog luo_rollout\n"
	luos+="luo_rollout = undefined)\n"

	luos+=")\n"
	execute luos
)
	
fn luo_update = 
(
	if luo_rollout == undefined then lu_dialog_pos = [400,400] else lu_dialog_pos = GetDialogPos luo_rollout
	luo_dialog_height = 67 + (15*luo_array.count)
	if luo_rollout != undefined then destroydialog luo_rollout

	luo_func()
	
	createDialog luo_rollout width:220 height:luo_dialog_height pos:lu_dialog_pos modal:true
)
)
-------------------------------------------------------------------------------