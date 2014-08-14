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

	Group "Axis"
		(

		label lbl2 "Axis : " across:2 align:#left
		radioButtons rdo1 "" labels:#("X", "Y", "Z") default:3 columns:3 align:#right
		)

	Group "Offset (Expression)"
		(
		editText edtExpr "" width:136 height:60 text:"90" offset:[-4,0]
		button btnCheck "Check Script Syntax" width:134 height:16
		checkbox chkInsertAsScript "Insert as actual script"
		)

	Group "OK: Let's do it!"
		(
		pickbutton pkbNode "Pick Lookat Object..." width:144 height:16
		)


	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn makeScript lookAtObj thisObj=
		(

		str = edtExpr.text
		
		if chkInsertAsScript.checked then offset = str
		else offset = (execute (str as string)) as string

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
			try	(
				for thisObj in objArray do
					(
					axis = rdo1.state
					thisObj.rotation.controller = Euler_XYZ()
					thisObj.rotation.controller[axis].controller = float_script()
					thisObj.rotation.controller[axis].controller.script = (makeScript lookAtObj thisObj)
					)
				)
			catch()
			)
		)
	
	fn checkScript =
		(
		lookAtObj = Targetcamera()
		thisObj = box()
		format"%\n" (makeScript lookAtObj thisObj)
		delete #(lookAtObj,thisObj)
		)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on pkbNode picked lookAtObj do
		(
		pkbNode.text = lookAtObj.name
		if (selection.count > 0) then assignControllers lookAtObj (getCurrentSelection())
		else displayTempPrompt "No selection" 2000
		pkbNode.text = "Pick Lookat Object..."
		)
	on btnCheck pressed do checkScript()
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



