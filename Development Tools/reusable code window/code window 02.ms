rollout ro1 "Options" width:392 height:184
(
	edittext edt1 "" pos:[0,32] width:384 height:144  --text:"pos+= (random -40 40)" 
	button btn1 "Execute" pos:[304,8] width:80 height:16
	radioButtons rdo1 "" pos:[8,8] width:133 height:16 labels:#("Selection", "Pick") columns:2

	---------------------------------------------------------------------------------------------------
	-- declare globals
	---------------------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------



	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------
	--
	--	THIS CODE WORKS! USE IT AS A TEMPLATE
	--
	--	obj = $Sphere01.name
	--	cmd="pos+=20"
	--	execute("$" + obj + "." + cmd)


fn doCode=
	(
	for obj in selection do (
		try	(
			tempObj = obj.name
			cmd=edt1.text
			execute("$" + tempObj + "." + cmd)
			)
		catch (
		--displayTempPrompt <string> <milliseconds_integer> 
			)
		)
	)
	
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------


	on btn1 pressed do
		doCode()
)

if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 415 240
addRollout ro1 myFloater