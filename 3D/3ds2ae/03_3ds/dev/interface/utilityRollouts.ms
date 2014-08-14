rollout rAccelState "State" 
( 
	checkButton accelState "Test" 
	on rAccelState open do 
	( 
		accelState.text = if (enableAccelerators) then "Enabled" else "Disabled" 
		accelState.checked = enableAccelerators 
	) 
	on accelState changed state do 
	( 
		enableAccelerators = state 
		accelState.text = if (enableAccelerators) then "Enabled" else "Disabled" 
	) 
) 

rollout roColor "Color Picker" width:100 height:100
(
	colorPicker cp1 "" width:90 height:90 pos:[4,4]

	on cp1 changed col do
	(
		curItem.value = (color col.b col.g col.r)
	)
	on roColor open do
	(
		messagebox "opened"
		local col =(color 255 0 0)
		cp1.changed col
	)
)