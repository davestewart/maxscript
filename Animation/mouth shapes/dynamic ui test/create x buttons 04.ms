rollout baseRollout "Base Rollout" width:160 height:311 rolledUp:true
(
	---------------------------------------------------------------------------------------------------
	-- Declarations
	---------------------------------------------------------------------------------------------------

		local roName, roTitle, roCode
		local btnX, btnY, btnPos, btnW, btnH, btnSize
		local lblX, lblY, lblPos, lblW, lblH, lblSize

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
			btnW = 32
			btnH = 32
			
			btnX = 4
			btnY = (((i-1)*btnH)+8)
			
			
			lblX = btnW + 4
			lblY = ((i-1)*btnH)+(btnH/2)
			
			btnPos = " [" +btnX as string+ "," +btnY as string+ "]" as string
			btnSize = " width:" +btnW as string+ " height:" +btnH as string
			btnImg = " "

			lblPos = " [" +lblX as string+ "," +lblY as string+ "]" as string
			lblSize = " width:" +lblW as string+ " height:" +lblH as string			

			str += "button btn" + i as string + btnPos + btnSize + btnImg + " align:#right across:2\n"
			str += "label lbl" + i as string + lblPos + lblSize + " \" " + (random 1 100) as string + " >\" align:#left\n"
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

		roCode += looper 10

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
