rollout ro1 "ALT Pressed Checkboxes" width:160 height:64
(
	checkbox chk1 "Checkbox" pos:[8,8] width:144 height:16
	checkbox chk2 "Checkbox" pos:[8,24] width:144 height:16
	checkbox chk3 "Checkbox" pos:[8,40] width:144 height:16
	
	function check n state=
	(
		format "% %\n" (state as string) (n as string)
		local checkboxes=#(chk1,chk2,chk3)
		
		if keyboard.altpressed then
		(
			for i = 1 to checkboxes.count do
			(
				if i==n then checkboxes[i].state=NOT state
				else checkboxes[i].state=state
			)
		)

	)

	on chk1 changed state do check 1 state
	on chk2 changed state do check 2 state
	on chk3 changed state do check 3 state
	
)
createdialog ro1
