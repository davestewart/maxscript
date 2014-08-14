---------------------------------------------------------------------------------------------------
-- Dynamic Interfaces (ui elements) Info
---------------------------------------------------------------------------------------------------
--
-- Created:  		18th August 2001
-- Last Updated:	18th August 2001
--
-- Author : 		Dave Stewart - 3dsmax@davestewart.co.uk
-- Version:  		3ds max 4
-- 
--
-- code to easily update interface display according to context...
-- Useful for LARGE interfaces with many exclusive options
-- Saves writing big lists of "x.enabled=true, y.enabled=false, z.enabled=false"
--
-- Just strip out the bits you need, adjust, and hey presto...
--
-- Make sure to declare all interface items in "utilName_ui<num>" arrays
-- then include all "utilName_ui<num>" arrays in "utilName_uiAll"
-- Finally declare all arrays as globals in the "Declare globals" section
--
-- Suggested naming of arrays includes the util name at the start, to save
-- clashing globals  ie. if two utils both use "ui1, ui2, ui3", this could
-- lead to problems!
--
-- If anyone can do this better, please modify and post!!!
--
---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
-- Start Rollouts
---------------------------------------------------------------------------------------------------

rollout ro1 "Interface Options" width:160 height:532
(
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------

	GroupBox grp "GroupBox" pos:[8,8] width:144 height:72
	radiobuttons rdo1 "" pos:[16,24] width:98 height:48 labels:#("Display Group 1", "Display Group 2", "Display Group 3")


	GroupBox grp1 "Group One" pos:[8,88] width:144 height:80
	radiobuttons rdo2 "" pos:[16,104] width:126 height:32 labels:#("Option 1", "Option 2", "Option 3", "Option 4") columns:2
	button btn1 "Button" pos:[16,144] width:128 height:16

	GroupBox grp2 "Group Two" pos:[8,175] width:144 height:160
	edittext edt1 "" pos:[16,191] width:128 height:112
	button btn2 "Button" pos:[16,311] width:128 height:16

	GroupBox grp3 "Group Three" pos:[8,344] width:144 height:128
	checkbox chk1 "Checkbox 1" pos:[16,360] width:128 height:16
	checkbox chk2 "Checkbox 2" pos:[16,376] width:128 height:16
	checkbox chk3 "Checkbox 3" pos:[16,392] width:128 height:16
	checkbox chk4 "Checkbox 4" pos:[16,408] width:128 height:16
	checkbox chk5 "Checkbox 5" pos:[16,424] width:128 height:16
	button btn4 "Button" pos:[16,448] width:128 height:16


	---------------------------------------------------------------------------------------------------
	-- Declare globals
	---------------------------------------------------------------------------------------------------

	-- IMPORTANT!
		-- Make sure you adjust the names correctly to reflect your Floater!!!
		-- That means all instances of "onOff_" should be replaced...


	-- REQUIRED GLOBALS
			global onOff_uiAll = undefined

	-- USER GLOBALS
		-- This array should include the names of all your interface selection arrays...
			global onOff_ui1, onOff_ui2, onOff_ui3


	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn updateInterface state =
		(
	-- update globals arrays ONLY on first run...
		if onOff_uiAll== undefined then
			(
		-- your interface selections go here...
			global onOff_ui1= 	#(grp1, btn1, rdo2) 						-- ui selection 1
			global onOff_ui2= 	#(grp2, edt1, btn2) 						-- ui selection 2
			global onOff_ui3= 	#(grp3, chk1, chk2, chk3, chk4, chk5, btn4) -- ui selection 3

			global onOff_uiAll=	#(onOff_ui1, onOff_ui2, onOff_ui3) 			-- all ui selections
			)

	-- update interface...
		for i = 1 to onOff_uiAll.count do
			(
			group = execute("onOff_ui" + i as String)
			group.enabled = false
			)
			group = execute("onOff_ui" + state as String)
			group.enabled = true
		)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	-- update interface...
		on rdo1 changed state do updateInterface state

	-- set-up on first run...
		on ro1 open do updateInterface 1

)

---------------------------------------------------------------------------------------------------
-- Create Floater
---------------------------------------------------------------------------------------------------

	if onOffFloater != undefined then closerolloutfloater onOffFloater
	onOffFloater = newRolloutFloater "Dynamic ui (groups)" 188 538

	addRollout ro1 onOffFloater
