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

persistent global globalScriptedLookAtNode

rollout billboard_ro1 "Options" width:162 height:311
(
	---------------------------------------------------------------------------------------------------
	-- local declarations
	---------------------------------------------------------------------------------------------------

	local lookAtObj, thisObj, objArray, str

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------

	Group "Rotation"
		(
		spinner spnOffset "Offset : " type:#integer range:[-360,360,90] align:#left
		label lbl1 "Axis : " across:2 align:#left
		radioButtons rdo1 "" labels:#("X", "Y", "Z") default:3 columns:3 align:#right
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
		offset = spnOffset.value as string

str= "
lookAtObj = globalScriptedLookAtNode
thisObj = $" + thisObj.name + "
dependsOn globalScriptedLookAtNode $" + thisObj.name + "
x = thisObj.pos.x - lookAtObj.pos.x
y = thisObj.pos.y - lookAtObj.pos.y
a = atan(y/x)
degToRad(a + " + offset + ")"
		)

	fn assignControllers lookAtObj objArray=
		(
		undo "Assign Scripted LookAt" on
			(
			print objArray
			axis = rdo1.state
			for thisObj in objArray do
				(
				thisObj.rotation.controller = Euler_XYZ()
				thisObj.rotation.controller[axis].controller = float_script()
				thisObj.rotation.controller[axis].controller.script = (makeScript lookAtObj thisObj)
/*
				if thisObj != lookAtObj then
					(
					try	(
						)
					catch()
					)
*/
				)
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
		globalScriptedLookAtNode = undefined
		globalScriptedLookAtNode = lookAtObj
		)

	on btnAssign pressed do
		(
		if (selection.count > 0) then assignControllers lookAtObj (getCurrentSelection())
		else 
			(
			objArray = selectByName()
			assignControllers lookAtObj objArray
			)

		pkbNode.text = "Pick Lookat Object..."
		btnAssign.enabled = false
		objArray = #()
		)
)

if billboardFloater != undefined then closerolloutfloater billboardFloater
	billboardFloater = newRolloutFloater "Scripted Lookat Ctrl" 188 200
addRollout billboard_ro1 billboardFloater


