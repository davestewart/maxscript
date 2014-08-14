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

	Group "Rotation: Axis Options"
		(
		spinner spnOffset "Offset : " type:#integer range:[-360,360,90] align:#left
		label lbl1 "Axis : " across:2 align:#left
		radioButtons rdo1 "" labels:#("X", "Y", "Z") default:3 columns:3 align:#right
		)

	Group "OK: Let's do it!"
		(
		pickbutton pkbNode "Pick Lookat Object..." width:144 height:16
		)


	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------
	fn allExceptLookat =
		(
		)

	fn makeScript obj i=
		(
		offset = spnOffset.value as string

		str= "
lookAtObj = $" + obj.name + "
thisObj = $" + i.name + "
dependsOn $" + obj.name + "
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
)

if billboardFloater != undefined then closerolloutfloater billboardFloater
	billboardFloater = newRolloutFloater "My Floater" 188 180 
addRollout billboard_ro1 billboardFloater


