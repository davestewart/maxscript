rollout expandOptions "Expand Options" width:140 height:189
(

	local iniFile = getDir #ui + "\\cp.ini"
	
	GroupBox grp1 "Expand on open" pos:[5,5] width:130 height:115
		checkbox chkSW "Space Warps" pos:[10,20] width:120 height:15 checked:false
		checkbox chkTr "Transform" pos:[10,35] width:120 height:15 checked:true
		checkbox chkMd "Modifiers" pos:[10,50] width:120 height:15 checked:true
		checkbox chkMt "Material" pos:[10,65] width:120 height:15 checked:false
		checkbox chkGz "Gizmo/Centre" pos:[10,85] width:120 height:15 enabled:true checked:false
		checkbox chkXY "XYZ Components" pos:[10,100] width:120 height:15 checked:false

	GroupBox grp2 "Automatic Settings" pos:[5,130] width:130 height:50
		checkbox chkOv "Expand on drag-over" pos:[10,145] width:120 height:15 checked:true
		checkbox chkOu "Collapse on drag-out" pos:[10,160] width:120 height:15


--	on chkSW changed state do setINISetting iniFile "Expand" "chkSW" state



	on expandOptions open do
		for c in expandOptions.controls do
		(
			try(
				state = getINISetting iniFile "Expand" (c as string)
				--format ">>%\n" state
				--c.checked = state
				if state=="true" then c.checked=true
				else c.checked=false
				
			)
			catch(/*format "Failed to update %\n" c*/)
		)



	on expandOptions oktoclose do
		for c in expandOptions.controls do
		(
			try(
				--format "%\n" c.state
				setINISetting iniFile "Expand" (c as string) (c.state as string)
			)
			catch(/*format "failed\n"*/)
		)

)

createDialog expandOptions