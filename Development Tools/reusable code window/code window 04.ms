rollout ro1 "Apply this code to the selected objects..." width:392 height:184
(
	---------------------------------------------------------------------------------------------------
	-- declarations
	---------------------------------------------------------------------------------------------------
	local varsText = "r = (random -10.0 10.0)
c = color (random 0.0 255.0) (random 0.0 255.0) (random 0.0 255.0)"

local codeText = "$.pos.x += r
$.pos.y += r
$.pos.z += (random -10.0 10.0)
$.wirecolor = c"

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	button btnGetText "Get Listener text" pos:[192,8] width:88 height:16

	radiobuttons rdo1 "" pos:[8,8] width:133 height:16 labels:#("Selection", "Pick") columns:2
	button btnDoCode "Execute >" pos:[288,8] width:56 height:16
	label lblStatus "-" pos:[352,8] width:32 height:16 enabled:true

	label lblVars "Constant Variables" align:#left offset:[-8,0] across:2
	button btnInsertToVars "<" width:16 height:16 alighn:#right
	edittext edtVars "" width:384 height:144 offset:[-12,0] text:varsText

	label lblCode "Per Object Code" align:#left offset:[-8,0]
	edittext edtCode "" width:384 height:144 offset:[-12,0] text:codeText 

	label lblFinal "Final Code" align:#left offset:[-8,0]
	edittext edtFinal "" width:384 height:144 offset:[-12,0]

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------
	--
	--	THIS CODE WORKS! USE IT AS A TEMPLATE
	--
	--	obj = $Sphere01.name
	--	cmd="pos+=20"
	--	execute("$" + obj + "." + cmd)


	fn replaceAll strAll strOut strIn =
	(
		while ((i=findstring strAll strOut) != undefined) do
		(
			strAll = replace strAll i strOut.count strIn
		)
		return strAll
	)
	
	fn doCode2=
	(
		cmd=edt1.text
		for obj in selection do (
			try(
				execute cmd
				lblStatus.text = "OK"
			)
			catch (
				lblStatus.text = "Error!"
			)
		)
	)
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on btnGetText pressed do
	(
		edtCode.text += getListenerSelText()
	)

	on btnDoCode pressed do
	(
		objCode = replaceAll edtCode.text "$" "obj"

		cmd = edtVars.text + "
		
for obj in selection do (
	try(
		" + objCode + "
)
	catch()
	)"

		edtFinal.text = cmd

		execute cmd
	)

	on btnInsertToVars pressed do ro1.title = "ARSE"


)

if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 415 440
addRollout ro1 myFloater

/*
if ro1 != undefined then destroyDialog ro1
myDialog = CreateDialog ro1 width:390 height:440 style:#(#style_minimizebox,#style_titlebar,#style_sysmenu)
*/


