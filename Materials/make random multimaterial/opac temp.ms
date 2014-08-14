

	---------------------------------------------------------------------------------------------------
	-- functions OPACITY
	---------------------------------------------------------------------------------------------------
	-- initialize variables
		local spnOpacVarTemp = 10				-- remembered value for when instance / copy is changed
		local opacCtrl = bezier_float()		-- setup instanced controller, for when needed


	fn updateOpac =
	(

		-- set variables
			opacBas = spnOpacVal.value
			opacVar = spnOpacVar.value
		
		-- interpret opacity ranges	
			global opacMin = (opacBas - (opacVar/2)) as Integer
			global opacMax = (opacBas + (opacVar/2)) as Integer
				if opacMin < 0 then opacMin = 0
				if opacMax > 100 then opacMax = 100

		-- update interface display
			grpOpacParam.text = "Opacity: (" + opacMin as String + " - " + opacMax as String + ")"

		-- update instanced controller, if needed
			opacCtrl.value = opacBas

	)


	fn updateOpacDisplay =
	(
		case ckbOpacValInst.state of
		(
			true:
			(
				-- instance
				spnOpacVarTemp = spnOpacVar.value
				spnOpacVar.value = 0
				spnOpacVar.enabled = false
				updateOpac()
			)
			false:
			(
				-- copy
				spnOpacVar.value = spnOpacVarTemp
				spnOpacVar.enabled = true
				updateOpac()
			)
		)
	)


	fn setOpacMapBtnDisplay =
	(
		if btnOpacMap.map != undefined then
		(
			name =  btnOpacMap.map.name as string
			type = classof btnOpacMap.map as String
			btnOpacMap.text= name + " (" + type + ")"
			chkOpacAffectMap.enabled = true
		)
		else
		(
			btnOpacMap.text= "None"
			chkOpacAffectMap.enabled = false
		)
	)

	fn updateOpacMapCtrl =
	(
		case ckbOpacMapCtrlInst.state of
		(
			true:
			(
				opacMapInst = btnOpacMap.map
				print "Instance"
			)
			false:
			(
				print "Copy only"
			)
		)
	)

	fn updateStatus =
	(
		chkOpacStatus.text = "Disabled"
		matOpac.open = false
		components.chkOpac.checked = false
	)

	---------------------------------------------------------------------------------------------------
	-- handlers OPACITY
	---------------------------------------------------------------------------------------------------
	on matOpac open do
		updateOpac()
	on spnOpacVal changed value do
		updateOpac()
	on spnOpacVar changed value do
		updateOpac()
	on ckbOpacValInst changed state do
		updateOpacDisplay()
	on btnOpacMap picked texmap do
		setOpacMapBtnDisplay()
	on ckbOpacMapCtrlInst changed state do
		updateOpacMapCtrl()
	on chkOpacStatus changed state do
		updateStatus()
