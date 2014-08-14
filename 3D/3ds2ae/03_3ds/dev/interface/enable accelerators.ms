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
nf = newRolloutFloater "" 100 100 
addRollout rAccelState nf 

--on ax StatusTextChange txt do enableAccelerators = false 
