global autoSizeFloater, rf

function autoSizeFloater floater =
(
	local height = 0
	for ro in floater.rollouts do height += if ro.open == false then 22 else ro.height + 25
	floater.size = [floater.size[1],height + 1]
)

function toggleFloaterRollout floater r rollouts: =
(
	if rollouts == unsupplied do rollouts = floater.rollouts
	if classof r == Integer then for i = 1 to rollouts.count do rollouts[i].open = i == r
	else if classof r == Array then for i = 1 to rollouts.count do rollouts[i].open = finditem r i > 0
	else if classof r == RolloutClass then for i = 1 to rollouts.count do rollouts[i].open = rollouts[i] == r
)

toggleFloaterRollout rf ro3
--autoSizeFloater rf

rollout ro1 "Rollout 1" width:160 height:90 (
	groupBox grp1 "GroupBox" pos:[8,8] width:144 height:100; 
	on ro1 rolledup state do autoSizeFloater rf;
)
	

rollout ro2 "Rollout 2" width:160 height:64 (
	groupBox grp1 "GroupBox" pos:[8,8] width:144 height:28; 
	on ro2 rolledup state do autoSizeFloater rf;
)
	

rollout ro3 "Rollout 3" width:160 height:64 (
	groupBox grp1 "GroupBox" pos:[8,8] width:144 height:48; 
	on ro3 rolledup state do autoSizeFloater rf;
)
	

rollout ro4 "Rollout 4" width:160 height:64 (
	groupBox grp1 "GroupBox" pos:[8,8] width:144 height:48; 
	on ro4 rolledup state do autoSizeFloater rf;
)
	
rollout ro5 "Rollout 5" width:160 height:64 (
	groupBox grp1 "GroupBox" pos:[8,8] width:144 height:48; 
	on ro5 rolledup state do autoSizeFloater rf;
)
	

rf = newRolloutFloater "Multi-Floater" 180 500

addRollout ro1 rf
addRollout ro2 rf
addRollout ro3 rf
addRollout ro4 rf
addRollout ro5 rf

autoSizeFloater rf


