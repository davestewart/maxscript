rollout myPropsUtility "Object / Element" width:192 height:80
(
	spinner spn7 "" pos:[8,32] width:64 height:16 range:[-999,999,0]
	dropdownList ddl5 "" pos:[72,30] width:40 height:16 items:#(" +", "+/-", "  -") selection:2
	spinner spn8 "" pos:[112,32] width:64 height:16 range:[-999,999,0]
----------------------------------------
-- interface
----------------------------------------




)

testRollout = newRolloutFloater "Test List Rollout" 312	738

addRollout myPropsUtility testRollout

