---------------------------------------------------------------------------------------------------
-- Scripted Lookat Controller
--
-- Author:		Dave Stewart http://www.davestewart.co.uk
-- Idea by:		Eric Chadwick
-- Date:		19th February 2002
-- Version:		1.01
-- MAX:			4.x
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
-- History:
-- 1.0			Finished script to production level.
-- 1.01			Improved effeciency of and debugged dependsOn in assigned scripts. Rotation
--				now updates correctly when assigned objects move. Added tooltips.
--
---------------------------------------------------------------------------------------------------

rollout billboard_ro1 "Options" width:162 height:311
(
	---------------------------------------------------------------------------------------------------
	-- local declarations
	---------------------------------------------------------------------------------------------------

	local lookAtObj, thisObj, objArray, str

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------

	Group "Rotation Parameters"
	(
		spinner spnOffset "Offset : " type:#integer range:[-180,180,0] align:#left
		label lbl1 "Axis : " across:2 align:#left
		radioButtons rdo1 "" labels:#("X", "Y", "Z") default:3 columns:3 align:#right
	)

	Group "Look-At Parameters"
	(
		pickbutton pkbNode "Pick Target..." width:144 height:16 tooltip:"Pick Look-At Target from scene"
		button btnAssign "Select / Assign to..." width:144 height:16 enabled:false tooltip:"Assign scripted rotation controller (on chosen axis) to selection"
	)
	Group "Delete Controller(s)"
	(
		button btnDelete "Select / Delete" width:82 height:16 across:2 align:#right offset:[10,0] tooltip:"Delete scripted rotation controller (from chosen axis) to selection"
		checkButton chkReset "Reset to 0" align:#left width:62 height:16 offset:[10,0] checked:true tooltip:"Uncheck this to leave objects looking in the same direction after deleting controller"
	)


	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------
	fn makeScript lookAtObj thisObj=
	(
		offset = spnOffset.value as string

str= "
lookAtObj=$" + lookAtObj.name + "
if (lookAtObj != undefined) then (
thisObj=$" + thisObj.name + "
dependsOn lookAtObj.pos.controller thisObj.pos.controller
x=thisObj.pos.x - lookAtObj.pos.x
y=thisObj.pos.y - lookAtObj.pos.y
a=atan(y/x)

if x < 0 then degToRad((a+90)+" + offset + ")
else degToRad((a-90)+" + offset + ")
) else 0"
	)

	fn assignControllers lookAtObj objArray=
	(
		undo "Assign Scripted LookAt" on
		(
			axis = rdo1.state
			for thisObj in objArray do
			(
				if thisObj != lookAtObj then
				(
					try(
						thisObj.rotation.controller = Euler_XYZ()
						thisObj.rotation.controller[axis].controller = float_script()
						thisObj.rotation.controller[axis].controller.script = (makeScript lookAtObj thisObj)
					)
					catch(print thisObj)
				)
			)
		)
	)

	fn deleteControllers objArray=
	(
		undo "Delete Scripted LookAt" on
		(
			axis = rdo1.state
			for thisObj in objArray do
			(
				if thisObj != lookAtObj then
				(
					try(
						thisObj.rotation.controller[axis].controller = Bezier_Float()
						if chkReset.checked then
						(
							thisObj.rotation.controller[axis].controller.value = 0
						)
					)
					catch(print thisObj)
				)
			)
		)
	)
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------
	on pkbNode picked obj do
	(
		lookAtObj = obj
		deselect lookAtObj
		pkbNode.text = "Target: " + lookAtObj.name
		btnAssign.enabled = true
	)

	on btnAssign pressed do
	(
		if (selection.count > 0) then assignControllers lookAtObj (getCurrentSelection())
		else 
		(
			objArray = (selectByName title:"Select objects to assign Scripted Lookat Controller to:")
			if objArray != undefined then assignControllers lookAtObj objArray
		)

		objArray = #()
	)

	on btnDelete pressed do
	(
		if (selection.count > 0) then deleteControllers (getCurrentSelection())
		else 
		(
			objArray = (selectByName title:"Select objects to delete Scripted Lookat Controller from:")
			if objArray != undefined then deleteControllers objArray
		)
		objArray = #()
	)
)

if billboardFloater != undefined then closerolloutfloater billboardFloater
	billboardFloater = newRolloutFloater "Scripted Lookat Ctrl" 188 245
addRollout billboard_ro1 billboardFloater


