utility myPropsUtility "myProps" width:160 height:416
(

local printState = false
global myObj
global myMods= #()
global myAttribs= #()
global myTargetAttrib
global myTargetAttribCurVal
global myModSelected = true

global myPropsInterfaceFloat = #("grpFloatParam", "spnFloatVal", "spnFloatVar", "ckbFloatStart", "btnFloatReset", "btnFloatOK")
global myPropsInterfaceBoolean = #("grpBoolParam", "sldBoolVal", "ckbBoolStart", "btnBoolReset", "btnBoolOK")



----------------------------------------
-- interface
----------------------------------------

		GroupBox grpObject "Object" pos:[8,8] width:144 height:40
		pickbutton btnPick "Pick Object" pos:[16,24] width:64 height:16
		button btnClear "Clear Object" pos:[80,24] width:64 height:16
	
		GroupBox grpAttribs "Stack" pos:[8,56] width:144 height:168
		dropdownList ddlMods "Element" pos:[16,72] width:128 height:40 enabled:false
		dropdownList ddlAttribs "Attributes" pos:[16,120] width:128 height:40 enabled:false
	
		label lblAttrib "Attrib:" pos:[19,168] width:125 height:16
		label lblAttribVal "Value:" pos:[16,184] width:128 height:16
		label lblAttribClass "Class:" pos:[18,200] width:126 height:16

	GroupBox grpFloatParam "Float: (-500 - 500)" pos:[8,232] width:144 height:96
	spinner spnFloatVal "Init: " pos:[22,256] width:58 height:16 range:[-999,999,30] type:#float
	spinner spnFloatVar "+/- " pos:[92,256] width:52 height:16 range:[-999,999,10] type:#float
	checkbutton ckbFloatStart "Start" pos:[16,288] width:128 height:16
	button btnFloatReset "Decline" pos:[16,304] width:64 height:16
	button btnFloatOK "Accept" pos:[80,304] width:64 height:16


		GroupBox grpBoolParam "Boolean: (T:50% / F:50%)" pos:[8,336] width:144 height:104
		slider sldBoolVal "" pos:[16,360] width:128 height:25 range:[0,100,50] type:#integer orient:#horizontal ticks:5
		checkbutton ckbBoolStart "Start" pos:[16,400] width:128 height:16
		button btnBoolReset "Decline" pos:[16,416] width:64 height:16
		button btnBoolOK "Accept" pos:[80,416] width:64 height:16





--------------------------------------
-- functions
----------------------------------------

fn changeAttribs val=
	(
	execute("myObj." + myTargetAttrib + "=" + val)
	)


fn updateInterface =
	(
	lblAttrib.text = "Attrib: " + myTargetAttrib as String
	lblAttribVal.text = "Value: " + myTargetAttribCurVal as String
	lblAttribClass.text = "Class: " + (classof myTargetAttribCurVal) as String

	case classof myTargetAttribCurVal of
		(
		Float:
			(
			print "Show only Floats"
			grpFloatParam.enabled = true
			grpFloatParam.enabled = true
			spnFloatVal.enabled = true
			spnFloatVar.enabled = true
			ckbFloatStart.enabled = true
			btnFloatReset.enabled = true
			btnFloatOK.enabled = true

			grpBoolParam.enabled = false
			sldBoolVal.enabled = false
			ckbBoolStart.enabled = false
			btnBoolReset.enabled = false
			btnBoolOK.enabled = false

/*
			-- this is how I'd LIKE to do it... but it bruk
			for i = 1 to myPropsInterfaceFloat.count do
				execute(myPropsInterfaceFloat[i] + ".enabled = false")
*/
			)
		Integer:
			(
			print "Show only Integer as Floats"
			)
		BooleanClass:
			(
			print "Show only Floats"
			grpFloatParam.enabled = false
			grpFloatParam.enabled = false
			spnFloatVal.enabled = false
			spnFloatVar.enabled = false
			ckbFloatStart.enabled = false
			btnFloatReset.enabled = false
			btnFloatOK.enabled = false

			grpBoolParam.enabled = true
			sldBoolVal.enabled = true
			ckbBoolStart.enabled = true
			btnBoolReset.enabled = true
			btnBoolOK.enabled = true
			)
		default:
			(
			print "Show Nothing"
			)
		)

	)


fn getTargetAttrib =
	(

	if myModSelected then
		(
		myTargetAttrib = ddlMods.selected as String + "." + ddlAttribs.selected as String
		myTargetAttribCurVal = execute ("myObj." + ddlMods.selected as String + "." + ddlAttribs.selected as String )
		)
	else
		(
		myTargetAttrib = ddlAttribs.selected as String
		myTargetAttribCurVal = execute ("myObj.baseobject" + "." + ddlAttribs.selected as String )
		)
	)


fn getAttribs =
	(
	myAttribs = #()
	
	-- modifier selected? if not, must be base object...
		if ddlMods.selected != myMods[myMods.count] then myModSelected = true
		else myModSelected = false

	if myModSelected then
		myAttribs = execute("getPropNames myObj." + ddlMods.selected)
	else
		myAttribs = getPropNames myObj.baseobject

	if printState then print myAttribs
	
	-- populate dropdown list
		ddlAttribs.items = myAttribs

	getTargetAttrib()
	updateInterface()

	)


fn getMods =
	(
	print "Getting Mods..."
	myMods = #()
	for i = 1 to myObj.modifiers.count do
		(
		append myMods myObj.modifiers[i].name
		)
	append myMods (myObj.baseObject as String)
	if printState then print myMods

	-- populate dropdown list
		ddlMods.items = myMods

	updateInterface()
	)


fn tcb = updateInterface()

fn start =
	(
	getMods()
	ddlMods.enabled = true
	ddlMods.selection = myMods.count -- Go to base object on start

	getAttribs()
	ddlAttribs.enabled = true
	)


----------------------------------------
-- handlers (SETUP)
----------------------------------------

	on myPropsUtility open do
		(
		local curSel = getCurrentSelection()
		if curSel.count == 1 do
			(
			global myObj = curSel[1]
			if printState then print myObj
			start()
			)
		registerTimeCallback tcb
		)

	on myPropsUtility close do unRegisterTimeCallback tcb

	on btnPick picked obj do
		(
			myObj = obj
			start()
		)

	on ddlMods selected value do
		(
		getAttribs()
		)

	on ddlAttribs selected value do
		(
		getTargetAttrib()
		updateInterface()
		)

----------------------------------------
-- handlers (ACTION)
----------------------------------------

on ckbFloatStart changed state do
	case state of
		(
		true:
			(
			print "true"
			myTargetAttribCurVal
			-- set random multiplier
			global multiplier = random 0.0 1.0
			print multiplier
			)
		false:
			(
			print "false"
			)
		)


	on spnFloatVal changed value do
		(
		val = spnFloatVal.value
		var = spnFloatVar.value
		result = val + (multiplier * var)

		changeAttribs (result as String)
		)

	on spnFloatVar changed value do
		(
		val = spnFloatVal.value
		var = spnFloatVar.value
		result = val + (multiplier * var)

		changeAttribs (result as String)
		)

)
multiplier