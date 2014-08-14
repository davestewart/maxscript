	---------------------------------------------------------------------------------------------------
	-- functions HIGHLIGHTS
	---------------------------------------------------------------------------------------------------

	-- initialize variables
		local spnSpecVarTemp = 10			-- remembered value for when instance / copy is changed
		local specCtrl = bezier_float()		-- setup instanced controller, for when needed
		local spnGlosVarTemp = 10			-- remembered value for when instance / copy is changed
		local glosCtrl = bezier_float()		-- setup instanced controller, for when needed

	fn updateSpec =
	(

		-- set variables
			specBas = spnSpecVal.value
			specVar = spnSpecVar.value
			specCtrl.value = copy specBas
			print ("specCtrl value is " + specCtrl.value as String)
		
		-- interpret opacity ranges	
			global specMin = (specBas - (specVar/2)) as Integer
			global specMax = (specBas + (specVar/2)) as Integer
				if specMin < 0 then specMin = 0
				if specMax > 999 then specMax = 999

		-- update interface display
			grpSpecParam.text = "Specular Level: (" + specMin as String + " - " + specMax as String + ")"

	)

	fn updateSpecDisplay =
	(
		case ckbSpecValInst.state of
		(
			true:
			(
				-- instance
				spnSpecVarTemp = spnSpecVar.value
				spnSpecVar.value = 0
				spnSpecVar.enabled = false
				updateSpec()
			)
			false:
			(
				-- copy
				spnSpecVar.value = spnSpecVarTemp
				spnSpecVar.enabled = true
				updateSpec()
			)
		)
	)



	fn updateGlos =
	(

		-- set variables
			glosBas = spnGlosVal.value
			glosVar = spnGlosVar.value
			glosCtrl.value = copy glosBas
			print ("glosCtrl value is " + glosCtrl.value as String)
		
		-- interpret opacity ranges	
			global glosMin = (glosBas - (glosVar/2)) as Integer
			global glosMax = (glosBas + (glosVar/2)) as Integer
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
	-- handlers HIGHLIGHTS
	---------------------------------------------------------------------------------------------------

	-- Both
		on matHigh open do
		(
			updateSpec(); print "Updating Spec"
			updateGlos(); print "Updating Glos"
		)


	-- Specular Level
		on spnSpecVal changed value do
			updateSpec()
		on spnSpecVar changed value do
			updateSpec()
		on ckbSpecValInst changed state do
			updateSpecDisplay()

	-- Glossiness
		on spnGlosVal changed value do
			updateGlos()
		on spnGlosVar changed value do
			updateGlos()
		on ckbGlosValInst changed state do
			updateGlosDisplay()





