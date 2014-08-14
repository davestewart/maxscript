rollout baseRollout "Base Rollout" width:160 height:311 rolledUp:true
(
	---------------------------------------------------------------------------------------------------
	-- Declarations
	---------------------------------------------------------------------------------------------------

		local roName, roTitle, roCode

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	Group "Instructions"
		(
		label lbl1 "How to us this plugin. \nWell, the thing you have to understand is that..." align:#left height:200 width:160
		)

	
	fn looper j=
		(
		local str = ""
		for i = 1 to 10 do
			(
			btnX = 8 as string
			btnY= (((i-1)*32)+8) as string
			lblX= ""
			lblY= ""
			str += "button btn" + i as string + " width:32 height:32 pos:[" +btnX+ "," +btnY+ "] align:#right across:2\n"
			str += "label lbl" + i as string + " \" " + (random 1 100) as string + " >\" width:120 align:#left\n"
			print str
			)
			return str
		)
	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn createRO roName roTitle =
		(
		clearListener()

		roCode = "rollout " +roName as String+ " \"" +roTitle as String+ "\" width:160 height:200 rolledUp:false"
		roCode += "	("
		roCode += "label lblStart \"Start\" "


		roCode += looper 10

		roCode += "label lblEnd \"End\" "
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
	on btnROCreate pressed do
		(
		roIndex+=1
		
		roName = "scriptMngrRO_" + (removeSpacesFromStr (edtROName.text as String))
		roTitle = edtROName.text as String
		
		createRO roName roTitle
		
		edtROName.text = "Test Rollout " + roIndex as String
		)
	
	on baseRollout open do createRO "two" "two"
)

if dynROFloater != undefined then closerolloutfloater dynROFloater
	dynROFloater = newRolloutFloater "Dynamic Rollouts" 188 500 
addRollout baseRollout dynROFloater 
