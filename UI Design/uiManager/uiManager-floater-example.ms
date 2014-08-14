-------------------------------------------------------------------------------------------------------------------------------
-- 
-- UI Manager Example: Floater functionality
--
-- 1. Open only 2 rollouts to start with
-- 2. Automatically resize the floater when rollouts are toggled
-- 
-------------------------------------------------------------------------------------------------------------------------------

-- load UI Manager
	filein "uiManager0.51.ms"
	
-- rollout definitions
	rollout ro1 "Rollout 1" width:160 height:90 (
		groupBox grp1 "GroupBox" pos:[8,8] width:144 height:100; 
		on ro1 rolledup state do uiManager.autoSizeFloater rf;
		)
		
	
	rollout ro2 "Rollout 2" width:160 height:64 (
		groupBox grp1 "GroupBox" pos:[8,8] width:144 height:28; 
		on ro2 rolledup state do uiManager.autoSizeFloater rf;
		)
		
	
	rollout ro3 "Rollout 3" width:160 height:64 (
		groupBox grp1 "GroupBox" pos:[8,8] width:144 height:48; 
		on ro3 rolledup state do uiManager.autoSizeFloater rf;
		)
		
	
	rollout ro4 "Rollout 4" width:160 height:64 (
		groupBox grp1 "GroupBox" pos:[8,8] width:144 height:48; 
		on ro4 rolledup state do uiManager.autoSizeFloater rf;
		)
		
	rollout ro5 "Rollout 5" width:160 height:64 (
		groupBox grp1 "GroupBox" pos:[8,8] width:144 height:48; 
		on ro5 rolledup state do uiManager.autoSizeFloater rf;
		)
		
-- create the floater and add the rollouts
	rf = newRolloutFloater "Multi-Floater" 180 500
	
	addRollout ro1 rf
	addRollout ro2 rf
	addRollout ro3 rf
	addRollout ro4 rf
	addRollout ro5 rf
	
-- open only the first 2 rollouts
	toggleFloaterRollout rf #(1,2)
	


