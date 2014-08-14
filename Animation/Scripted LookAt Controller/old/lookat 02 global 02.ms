---------------------------------------------------------------------------------------------------
-- Scripted Lookat Controller
--
-- Author:		Dave Stewart http://www.davestewart.co.uk
-- Idea by:		Eric Chadwick
-- Date:		19th February 2002
-- Version:		0.5
--
-- Usage:		Multi-assign a scripted single-axis (billboard style) lookat controller
--				to selected objects.
--
-- Benefits:	Due to the fact that you cannot script the target in MAX's built-in Lookat
--				controller, it is currently very time-consuming to assign the controller to
--				more than a few objects.
--
--				This utility assigns a simple customised trigonometric script to each object
--				in the selection, enabling each one to look at the specified target.
--
--				Try it on multiple axis for most fun!
--				
---------------------------------------------------------------------------------------------------

rollout billboard_ro1 "Options" width:162 height:311
(
	---------------------------------------------------------------------------------------------------
	-- local declarations
	---------------------------------------------------------------------------------------------------

	local lookAtObj, thisObj, objArray

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------

	Group "Rotation"
	(
		spinner spnOffset "Offset : " type:#integer range:[-360,360,90] align:#left
		label lbl1 "Axis : " across:2 align:#left
		radioButtons rdoAxis "" labels:#("X", "Y", "Z") default:3 columns:3 align:#right
	)

	Group "Objects and Target"
	(
		pickbutton pkbNode "Pick Lookat Target..." width:144 height:16
		button btnAssign "Assign to selected..." width:144 height:16 enabled:false
	)

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn makeScript lookAtObj thisObj=
	(

		str = spnOffset.value
		
str= "
lookAtObj = scriptedLookAtNode
thisObj = $" + thisObj.name + "
dependsOn $" + lookAtObj.name + " $" + thisObj.name + "
x = thisObj.pos.x - lookAtObj.pos.x
y = thisObj.pos.y - lookAtObj.pos.y
a = atan(y/x)
degToRad(a + " + offset + ")"

		return str
	)


	fn assignControllers lookAtObj objArray=
	(
		undo "Assign Scripted LookAt" on
		(
			persistent global scriptedLookAtNode = lookAtObj
			format "\nGlobal variable 'scriptedLookAtNode' set to % " lookAtObj.name
			try(
				for thisObj in objArray do
				(
					axis = rdoAxis.state
					thisObj.rotation.controller = Euler_XYZ()
					thisObj.rotation.controller[axis].controller = float_script()
					thisObj.rotation.controller[axis].controller.script = (makeScript lookAtObj thisObj)
				)
			)
			catch()
		)
	)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on pkbNode picked obj do
	(
		lookAtObj = obj
		pkbNode.text = lookAtObj.name
		btnAssign.enabled = true

	)
	on btnAssign pressed do
	(
		if (selection.count > 0) then assignControllers lookAtObj (getCurrentSelection())
		pkbNode.text = "Pick Lookat Object..."
	)
)

rollout billboard_ro2 "Instructions" rolledUp:true
(
	label lbl1 "The Offset field provides an extra way to get control over each object being rotated." align:#left width:154 height:45 offset:[-8,0]
	label lbl2 "Use 'thisObj' and 'lookAtObj' as variables referring to the objects evaluated by the script. ie..." align:#left width:154 height:40 offset:[-8,0]
	label lbl3 "'thisObj.height * random -45.0 45.0'" align:#left width:134 height:30
	label lbl4 "...would randomly rotate the object, but according to it's own height property." width:154 height:50 align:#left offset:[-10,0]
	label lbl5 "Check the 'Insert as script' box to have each controller re-\evaluate your script on every frame, otherwise only the value result will be used at creation time." width:154 height:85 align:#left offset:[-10,0]
	label lbl6 "Use the 'Check Script Syntax' button to print a test script to the Listener.\nNB. Error checking is not handled very well!" width:154 height:80 align:#left offset:[-10,0]
)

if billboardFloater != undefined then closerolloutfloater billboardFloater
	billboardFloater = newRolloutFloater "Scripted Lookat Utility" 188 308
addRollout billboard_ro1 billboardFloater
addRollout billboard_ro2 billboardFloater



