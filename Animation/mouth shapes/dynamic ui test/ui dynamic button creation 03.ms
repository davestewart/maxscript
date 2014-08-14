---------------------------------------------------------------------------------------------------
-- declare variables
---------------------------------------------------------------------------------------------------


rollout ro1 "Options" width:160 height:311
	( 
	---------------------------------------------------------------------------------------------------
	-- Variables
	---------------------------------------------------------------------------------------------------

	local roMouth, createRO

	fn createRO =
		(
		clearListener()

		local str = "checkbutton ckb1 width:32 height:32 offset:[0,-5] across:2"

		roCode = "rollout roMouth \"New Rollout\" width:160 height:200"
		roCode += "	("
		roCode += " label lbl2 \"ARSE...\" align:#left"
		roCode += "	)"

		try(execute roCode);catch()
		addRollout roMouth myFloater
		

		)
	
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	
		Group "Mouth Shapes" 
			(
			label lbl1 "Making buttons..." align:#left
			button btn1 "Add rollout"
			)







	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

			
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------
	--on ro1 open do createRO()
	on btn1 pressed do createRO()
	)

if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 188 500 
addRollout ro1 myFloater

