---------------------------------------------------------------------------------------------------
-- Dynamic Interfaces (rollouts) Info
---------------------------------------------------------------------------------------------------
--
-- Created:  		18th August 2001
-- Last Updated:	18th August 2001
--
-- Author : 		Dave Stewart
-- Version:  		3ds max 4
--
--
-- Utility to easily update interface display according to context...
-- Useful for LARGE interfaces with many exclusive options
-- Saves having loads of unnecessary rollouts floating around
--
-- Make sure to declare all rollouts in "utilName_rollouts" array
--
-- If anyone can do this better, please modify and post!!!
--
---------------------------------------------------------------------------------------------------


	---------------------------------------------------------------------------------------------------
	-- Declare globals - IMPORTANT!
	---------------------------------------------------------------------------------------------------

	-- REQUIRED GLOBALS
	-- Make sure you adjust the names correctly to reflect your Floater!!!
	
		global dynROFloater, dynRO_current, dynRO_old


	-- USER GLOBALS
	-- Make sure you adjust the name correctly to reflect your Floater!!!
	
		global dynRO_rollouts = #(ro1, ro2, ro3)

	---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
-- Rollout Options Rollout
---------------------------------------------------------------------------------------------------

	rollout roOptions "Interface Options" width:160 height:88
	(
		---------------------------------------------------------------------------------------------------
		-- Interface
		---------------------------------------------------------------------------------------------------
		GroupBox grp "Display Rollouts" pos:[8,8] width:144 height:72
		radiobuttons rdo1 "" pos:[16,24] width:102 height:48 labels:#("Display Rollout 1", "Display Rollout 2", "Display Rollout 3")
	
		---------------------------------------------------------------------------------------------------
		-- Handlers
		---------------------------------------------------------------------------------------------------
	
		on rdo1 changed state do
			(
/*
			-- declare globals
				if dynRO_rollouts == undefined then
					dynRO_rollouts = #(ro1, ro2, ro3)
*/
	
			-- feedback (optional - use for debugging)
				dynRO_current = execute("ro" + state as String)
				print ("Removing " + dynRO_old as String + " and creating " + dynRO_current as String)
				
			-- add and remove the rollouts
				removeRollout dynRO_old dynROFloater
				addRollout dynRO_current dynROFloater
				dynRO_old = dynRO_current
			)

		on roOptions open do
			(
			dynRO_old = ro1
			)
	)

---------------------------------------------------------------------------------------------------
-- Other Rollouts
---------------------------------------------------------------------------------------------------

	rollout ro1 "Rollout 1" width:160 height:104
	(
		groupBox grp1 "Rollout 1 Options" pos:[8,8] width:144 height:88
		button btn1 "Button" pos:[16,32] width:128 height:16
		radioButtons rdo1 "" pos:[16,56] width:126 height:32 labels:#("Option 1", "Option 2", "Option 3", "Option 4") columns:2
	)
	
	rollout ro2 "Rollout 2" width:160 height:184
	(
		GroupBox grp1 "Rollout 2 Options" pos:[8,8] width:144 height:168
		edittext edt1 "" pos:[16,32] width:128 height:112
		button btn4 "Button" pos:[16,152] width:128 height:16
	)
	
	rollout ro3 "Rollout 3" width:160 height:144
	(
		GroupBox grp1 "Rollout 3 Options" pos:[8,8] width:144 height:128
		checkbox chk1 "Checkbox 1" pos:[16,24] width:128 height:16
		checkbox chk2 "Checkbox 2" pos:[16,40] width:128 height:16
		checkbox chk3 "Checkbox 3" pos:[16,56] width:128 height:16
		button btn6 "Button" pos:[16,112] width:128 height:16
		checkbox chk4 "Checkbox 4" pos:[16,72] width:128 height:16
		checkbox chk5 "Checkbox 5" pos:[16,88] width:128 height:16
	)


---------------------------------------------------------------------------------------------------
-- Create Floater
---------------------------------------------------------------------------------------------------

	if dynROFloater != undefined then closerolloutfloater dynROFloater

	dynROFloater = newRolloutFloater "Dynamic Rollouts" 188 500 

	addRollout roOptions dynROFloater
	addRollout ro1 dynROFloater


	