utility onOff "Dynamic interface example" width:480 height:336

---------------------------------------------------------------------------------------------------
-- Dynamic Interfaces (interfcae elements) Info
---------------------------------------------------------------------------------------------------
--
-- Author: Dave Stewart
--
-- Utility to easily update interface display according to context...
-- Useful for LARGE interfaces with many exclusive options
-- Saves writing big lists of "x.enabled=true, y.enabled=false, z.enabled=false"
--
-- Make sure to declare all interface items in "utilName_ui<num>" arrays
-- then include all "utilName_ui<num>" arrays in "utilName_uiAll"
--
-- Finally declare all arrays as globals at the start of the script
--
-- If anyone can do this better, please modify and post!!!
-- One suggestion would be to figure out how to stop posting the ui<num> arrays as
-- globals EVERY time the groups are updated. For some reason, I can't set these
-- as globals at the start of the script... hmm...
--
---------------------------------------------------------------------------------------------------

(
	---------------------------------------------------------------------------------------------------
	-- declare globals
	---------------------------------------------------------------------------------------------------

	global onOff_ui1, onOff_ui2, onOff_ui3 -- your interface groups / selections go here
	global onOff_uiAll=	#(onOff_ui1, onOff_ui2, onOff_ui3)

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

		for i = 1 to onOff_uiAll.count do
		(
			group = execute("onOff_ui" + i as String)
			group.enabled = false
		)
			group = execute("onOff_ui" + state as String)
			group.enabled = true
			
	)

)

