---------------------------------------------------------------------------------------------------
-- Dynamic Interfaces (rollouts) Info
---------------------------------------------------------------------------------------------------
--
-- Created:  		18th August 2001
-- Last Updated:	18th August 2001
--
-- Author : 		Dave Stewart - 3dsmax@davestewart.co.uk
-- Version:  		3ds max 4
--
--
-- Utility to easily update interface display according to context...
-- Useful for LARGE interfaces with many exclusive options
-- Saves having loads of unnecessary rollouts floating around
--
-- Just strip out the "Rollout Options Rollout", adjust, and hey presto...
--
-- Make sure to declare all rollouts in "utilName_rollouts" array
--
-- Use "Category:<num>" to order rollouts if necessary
--
-- If anyone can do this better, please modify and post!!!
--
---------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------
-- Example Rollouts
---------------------------------------------------------------------------------------------------

	rollout ro1 "Rollout 1" width:160 height:104
	(
		groupBox grp1 "Rollout 1 Options" pos:[8,8] width:144 height:88 category:2
		radioButtons rdo1 "" pos:[16,32] width:126 height:32 labels:#("Option 1", "Option 2", "Option 3", "Option 4") columns:2
		button btn1 "Button" pos:[16,70] width:128 height:16
	)
	
	rollout ro2 "Rollout 2" width:160 height:184
	(
		GroupBox grp1 "Rollout 2 Options" pos:[8,8] width:144 height:168 category:2
		edittext edt1 "" pos:[16,32] width:128 height:112
		button btn1 "Button" pos:[16,152] width:128 height:16
	)
	
	rollout ro3 "Rollout 3" width:160 height:144 category:1
	(
		GroupBox grp1 "Rollout 3 Options" pos:[8,8] width:144 height:128
		checkbox chk1 "Checkbox 1" pos:[16,24] width:128 height:16
		checkbox chk2 "Checkbox 2" pos:[16,40] width:128 height:16
		checkbox chk3 "Checkbox 3" pos:[16,56] width:128 height:16
		checkbox chk4 "Checkbox 4" pos:[16,72] width:128 height:16
		checkbox chk5 "Checkbox 5" pos:[16,88] width:128 height:16
		button btn1 "Button" pos:[16,112] width:128 height:16
	)




---------------------------------------------------------------------------------------------------
-- Rollout Options Rollout
-- Place this at the end of your code, after all other rollouts
---------------------------------------------------------------------------------------------------

	rollout roOptions "Interface Options" width:160 height:88
	(
		---------------------------------------------------------------------------------------------------
		-- Interface
		---------------------------------------------------------------------------------------------------
		GroupBox grp "Display Rollouts" pos:[8,8] width:144 height:72
		radiobuttons rdo1 "" pos:[16,24] width:102 height:48 labels:#("Display Rollout 1", "Display Rollout 2", "Display Rollout 3")
	

		---------------------------------------------------------------------------------------------------
		-- Declare globals
		---------------------------------------------------------------------------------------------------

		--IMPORTANT
			-- Make sure you adjust all names correctly to reflect your Floater!!!
			-- That means all instances of "dynRO_" should be replaced...

		-- REQUIRED GLOBALS
				global dynRO_current, dynRO_old
	
		-- USER GLOBALS
			-- This should be your floater name
				global dynROFloater
		
			-- This array should include the names of all your rollouts
				global dynRO_rollouts = #(ro1, ro2, ro3)


		---------------------------------------------------------------------------------------------------
		-- Functions
		---------------------------------------------------------------------------------------------------

		fn updateInterface state = 
			(
			-- set target rollout...
				dynRO_current = execute("ro" + state as String)

			-- feedback (optional - use for debugging)...
				print ("Removing " + dynRO_old as String + " and creating " + dynRO_current as String)
				
			-- add and remove the rollouts...
				removeRollout dynRO_old dynROFloater
				addRollout dynRO_current dynROFloater
				dynRO_old = dynRO_current
			)


		---------------------------------------------------------------------------------------------------
		-- Handlers
		---------------------------------------------------------------------------------------------------
	
		-- update interface...
			on rdo1 changed state do updateInterface state
	
		-- set-up on first run...
			on roOptions open do dynRO_old = ro1
	)



---------------------------------------------------------------------------------------------------
-- Create Floater
---------------------------------------------------------------------------------------------------

	if dynROFloater != undefined then closerolloutfloater dynROFloater

	dynROFloater = newRolloutFloater "Dynamic ui (Rollout)" 188 349

	addRollout roOptions dynROFloater
	addRollout ro1 dynROFloater


	