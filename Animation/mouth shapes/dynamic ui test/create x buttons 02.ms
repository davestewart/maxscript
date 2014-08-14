rollout baseRollout "Base Rollout" width:160 height:311 rolledUp:true
(
	---------------------------------------------------------------------------------------------------
	-- Declarations
	---------------------------------------------------------------------------------------------------

		local roName, roTitle, roCode, str

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	Group "Instructions"
	(
		label lbl1 "How to us this plugin. \nWell, the thing you have to understand is that..." align:#left height:200 width:160
	)

	
	fn looper j=
	(
		for i = 1 to j do
		(
			str += "Number" + i as string
			return roCode
		)
	)
	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn createRO =
	(
		clearListener()

		roCode = "rollout ro1 \"Rollout 1\" width:160 height:200 rolledUp:false"
		roCode += "	("
		roCode += "label lbl1 \"start\" "


		--roCode += (looper 10)

		roCode += "label lbl1 \"finish\" "
		roCode += "	)"

		try(execute roCode);catch()
		addRollout ro1 dynROFloater

	)
	
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on baseRollout open do createRO()
)

if dynROFloater != undefined then closerolloutfloater dynROFloater
	dynROFloater = newRolloutFloater "Dynamic Rollouts" 188 500 
addRollout baseRollout dynROFloater 
