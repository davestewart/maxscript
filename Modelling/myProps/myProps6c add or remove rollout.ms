rollout objectAttribs "Object / Element" width:312 height:496
(
----------------------------------------
-- interface
----------------------------------------
	listbox ddlMods "Element" pos:[8,8] width:144 height:20

	listbox ddlAttribs "Attribute" pos:[160,8] width:144 height:20

	GroupBox grpObject "Object" pos:[8,304] width:80 height:72
	pickbutton btnPick "Pick Object" pos:[16,320] width:64 height:32
	button btnClear "Clear Object" pos:[16,352] width:64 height:16
	
	GroupBox grpAttribs "Element Info" pos:[96,304] width:208 height:72
	label lblAttrib "Attrib:" pos:[104,320] width:192 height:16
	label lblAttribVal "Value:" pos:[104,336] width:192 height:16
	label lblAttribClass "Class:" pos:[104,352] width:192 height:16

	GroupBox grpFloatParam "Float: (-500 - 500)" pos:[8,384] width:144 height:104
	spinner spnFloatVal "Init: " pos:[24,416] width:58 height:16 range:[-999,999,30] type:#float
	spinner spnFloatVar "+/-" pos:[94,416] width:52 height:16 range:[-999,999,10] type:#float
	checkbutton ckbFloatStart "Start" pos:[16,448] width:128 height:16
	button btnFloatReset "Decline" pos:[16,464] width:64 height:16
	button btnFloatOK "Accept" pos:[80,464] width:64 height:16


	GroupBox grpBoolParam "Boolean: (T:50% / F:50%)" pos:[160,384] width:144 height:104
	slider sldBoolVal "" pos:[168,408] width:128 height:25 range:[0,100,50] type:#integer orient:#horizontal ticks:5
	checkbutton ckbBoolStart "Start" pos:[168,448] width:128 height:16
	button btnBoolReset "Decline" pos:[168,464] width:64 height:16
	button btnBoolOK "Accept" pos:[232,464] width:64 height:16




--------------------------------------
-- variables
----------------------------------------

local printState = true
global myObj
global myMods= #()
global myAttribs= #()
global myTargetAttrib
global myTargetAttribCurVal
global myModSelected = true
global origVal = 0.0

global myPropsInterfaceFloat = #("grpFloatParam", "spnFloatVal", "spnFloatVar", "ckbFloatStart", "btnFloatReset", "btnFloatOK")
global myPropsInterfaceBoolean = #("grpBoolParam", "sldBoolVal", "ckbBoolStart", "btnBoolReset", "btnBoolOK")

global floatParams
global booleanParams

--------------------------------------
-- functions
----------------------------------------

fn changeAttribs newVal=
	(
	execute("myObj." + myTargetAttrib + "=" + (origVal + spnFloatVal.value) as String)
	)


fn updateInterface =
	(
	lblAttrib.text = "Attrib: " + myTargetAttrib as String
	lblAttribVal.text = "Value: " + myTargetAttribCurVal as String
	lblAttribClass.text = "Class: " + (classof myTargetAttribCurVal) as String

	origVal = myTargetAttribCurVal
	spnFloatVal.value = 0

	case classof myTargetAttribCurVal of
		(
		Float:
			(
		-- execute ("removeRollout " + currentRollout as String + " ObjAttribs")
		removeRollout currentRollout 
		addRollout floatParams ObjAttribs
		currentRollout = floatParams
			)
		Integer:
			(
			print "Show only Integer as Floats"
			)
		BooleanClass:
			(
		-- execute ("removeRollout " + currentRollout as String + " ObjAttribs")
		removeRollout currentRollout 
		addRollout booleanParams ObjAttribs
		currentRollout = booleanParams
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
		--result = (val + (multiplier * var)) as Float

		changeAttribs val
		)

)

rollout floatProps "Float properties" width:312 height:496
(

)
rollout booleanProps "Boolean Properties" width:312 height:496
(

)



ObjAttribs = newRolloutFloater "Test List Rollout" 344 612

addRollout objectAttribs ObjAttribs
addRollout floatProps ObjAttribs
global currentRollout = floatProps

