rollout baseRollout "Base Rollout" width:160 height:311 rolledUp:true
(
	---------------------------------------------------------------------------------------------------
	-- Declarations
	---------------------------------------------------------------------------------------------------

		local createRO, roName, roTitle, roCode, looper, str=""

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	Group "Instructions"
	(
		label lbl1 "How to us this plugin. \nWell, the thing you have to understand is that..." align:#left height:200 width:160
	)

	
	fn looper j=
	(
		myStr = ""
		local btnX, btnY, btnPos, btnW, btnH, btnSize
		for i = 1 to 10 do
		(
			btnW = 32
			btnH = 32
			
			btnX = 4
			btnY = (((i-1)*btnH)+8)
			
			btnPos = (" [" + (btnX as string) + "," + (btnY as string) + "] ") as string
			btnSize = (" width:" + (btnW as string) + " height:" + (btnH as string) + " ") as string

			myStr += "button btn" + (i as string) + (btnPos as string) + (btnSize as string) + " "
		)
		-- myStr += " button btn1" + " button btn2 width:20"
		return myStr
		
	)
	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn createRO roName roTitle =
	(
		clearListener()

		roCode = "rollout " +roName as String+ " \"" +roTitle as String+ "\" width:160 height:200 rolledUp:false"
		roCode += "	("

		
		roCode += (looper 10)

		roCode += "	)"

		try(execute roCode);catch()
		execute ("addRollout " +roName+ " dynROFloater")

	)
	
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------


	on edtROName changed val do
	(
		if val != "" then btnROCreate.enabled = true
		else btnROCreate.enabled = false
	)

	on baseRollout open do createRO "two" "two"
)

if dynROFloater != undefined then closerolloutfloater dynROFloater
	dynROFloater = newRolloutFloater "Dynamic Rollouts" 188 500 
addRollout baseRollout dynROFloater 
