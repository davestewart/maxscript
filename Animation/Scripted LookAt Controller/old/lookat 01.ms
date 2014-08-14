---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------

rollout ro1 "Options" width:162 height:311
(
	---------------------------------------------------------------------------------------------------
	-- local declarations
	---------------------------------------------------------------------------------------------------

	local obj, i

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------

	Group "Rotation Options"
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
	fn makeScript obj i=
	(
		str= "
			lookAtObj = $" + obj.name + "
			thisObj = $" + i.name + "
			dependsOn $" + obj.name + "
			x = thisObj.pos.x - lookAtObj.pos.x
			y = thisObj.pos.y - lookAtObj.pos.y
			a = atan(y/x)
			degToRad(a + 90)"

		return str
	)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on pkbNode picked obj do
(
	pkbNode.text = obj.name
	if (selection.count > 0) then
	(
		try(
			for i in selection do
			(
				i.rotation.controller = Euler_XYZ()
				i.rotation.controller[3].controller = float_script()
				i.rotation.controller[3].controller.script = (makeScript obj i)
			)
		)
		catch ()
	)
	else MessageBox "Have a selection defined before you pick the Lookat Node"
)
)

if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 188 500 
addRollout ro1 myFloater

