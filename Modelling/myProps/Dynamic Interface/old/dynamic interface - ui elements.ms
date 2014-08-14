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
-- Finally declare all arrays as globals at the start of the script
--
-- Suggested naming of arrays includes the util name at the start, to save
-- clashing globals  ie. if two utils both use "ui1, ui2, ui3", this could
-- lead to problems!
--
-- If anyone can do this better, please modify and post!!!
--
---------------------------------------------------------------------------------------------------


	---------------------------------------------------------------------------------------------------
	-- Declare globals - IMPORTANT!
	---------------------------------------------------------------------------------------------------

	-- REQUIRED GLOBALS
	-- Make sure you adjust the names correctly to reflect your Floater!!!

		global onOff_uiAll = undefined


	-- USER GLOBALS
	-- Make sure you adjust the names correctly to reflect your Floater!!!

		global onOff_ui1, onOff_ui2, onOff_ui3

	---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
-- Start Rollouts
---------------------------------------------------------------------------------------------------

rollout ro1 "Interface Options" width:160 height:88
(
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------

	groupBox grp "GroupBox" pos:[8,8] width:144 height:72
	radioButtons rdo1 "" pos:[16,24] width:29 height:48 labels:#("Display Group 1", "Display Group 2", "Display Group 3")


	groupBox grp1 "Group One" pos:[8,88] width:144 height:72
	button btn1 "Button 1" pos:[16,104] width:128 height:48

	groupBox grp2 "Group Two" pos:[8,168] width:144 height:72 enabled:false
	button btn2 "Button 2" pos:[16,184] width:128 height:48 enabled:false

	groupBox grp3 "Group Three" pos:[8,248] width:144 height:72 enabled:false
	button btn3 "Button 3" pos:[16,264] width:128 height:48 enabled:false

	---------------------------------------------------------------------------------------------------
	-- Handler
	---------------------------------------------------------------------------------------------------

	on rdo1 changed state do
	(
	-- update globals arrays ONLY on first run...
		if onOff_uiAll== undefined then
		(
		-- your interface selections go here...
			global onOff_ui1= 	#(grp1, btn1) -- ui selection 1
			global onOff_ui2= 	#(grp2, btn2) -- ui selection 2
			global onOff_ui3= 	#(grp3, btn3) -- ui selection 3

			global onOff_uiAll=	#(onOff_ui1, onOff_ui2, onOff_ui3) -- all ui selections
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

)

---------------------------------------------------------------------------------------------------
-- Create Floater
---------------------------------------------------------------------------------------------------

	if onOffFloater != undefined then closerolloutfloater onOffFloater
	onOffFloater = newRolloutFloater "Dynamic Rollouts" 188 500

	addRollout ro1 onOffFloater
