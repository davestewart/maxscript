	---------------------------------------------------------------------------------------------------
	-- functions GLOSSINESS
	---------------------------------------------------------------------------------------------------

	-- initialize variables
		local spnGlosVarTemp = 10			-- remembered value for when instance / copy is changed
		local glosCtrl = bezier_float()		-- setup instanced controller, for when needed

	fn updateGlos =
		(

		-- set variables
			glosBas = spnGlosVal.value
			glosVar = spnGlosVar.value
			glosCtrl.value = copy glosBas
			print ("glosCtrl value is " + glosCtrl.value as String)
		
		-- interpret opacity ranges	
			global glosMin = (glosBas - (glosGar/2)) as Integer
			global glosMax = (glosBas + (glosGar/2)) as Integer
				if glosMin < 0 then glosMin = 0
				if glosMax > 100 then glosMax = 100

		-- update interface display
			grpGlosParam.text = "Glossiness: (" + glosMin as String + " - " + glosMax as String + ")"

		)

	fn updateGlosDisplay =
		(
		case ckbGlosValInst.state of
			(
			true:
				(
				-- instance
				spnGlosVarTemp = spnGlosVar.value
				spnGlosVar.value = 0
				spnGlosVar.enabled = false
				updateGlos()
				)
			false:
				(
				-- copy
				spnGlosVar.value = spnGlosVarTemp
				spnGlosVar.enabled = true
				updateGlos()
				)
			)
		)



	---------------------------------------------------------------------------------------------------
	-- handlers GLOSSINESS
	---------------------------------------------------------------------------------------------------

	-- Glossiness
		on matHigh open do
			(updateGlos(); print "Updating Glos")
		on spnGlosVal changed value do
			updateGlos()
		on spnGlosVar changed value do
			updateGlos()
		on ckbGlosValInst changed state do
			updateGlosDisplay()

