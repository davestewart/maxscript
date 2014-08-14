rollout ro1 "Apply this code to the selected objects..." width:392 height:184
(
	edittext edt1 "" pos:[0,32] width:384 height:144  --text:"pos+= (random -40 40)" 
	button btn1 "Execute >" pos:[288,8] width:56 height:16
	radiobuttons rdo1 "" pos:[8,8] width:133 height:16 labels:#("Selection", "Pick") columns:2
	label lblStatus "" pos:[352,8] width:32 height:16 enabled:true

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
	cmd=edt1.text
	for obj in selection do (
		try	(
			tempObj = obj.name
			execute("$" + tempObj + "." + cmd)
			--lblStatus.text = "OK"
			)
		catch (
			--lblStatus.text = "Error!"
			)
		)
	)
	
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------


	button btn2 "Get Listener text" pos:[192,8] width:88 height:16
	on btn1 pressed do
		doCode()
	on btn2 pressed do edt1.text += getListenerSelText() 

)

if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 415 240
addRollout ro1 myFloater