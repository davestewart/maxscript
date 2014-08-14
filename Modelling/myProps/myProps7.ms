

rollout roSel "Selection" width:312 height:496
(
	GroupBox grpObject "Object" pos:[8,8] width:80 height:72
	pickbutton btnPick "Pick Object" pos:[16,24] width:64 height:32
	button btnClear "Clear Object" pos:[16,56] width:64 height:16

	pickbutton btn19 "Find all copies" pos:[95,16] width:208 height:16
)

rollout roStack "Stack" width:312 height:496
(
----------------------------------------
-- interface
----------------------------------------
	listbox ddlMods "Element" pos:[8,8] width:144 height:15
	listbox ddlAttribs "Attribute" pos:[160,8] width:144 height:15

	
	GroupBox grpAttribs "Element Info" pos:[8,232] width:296 height:72
	label lblAttrib "Attrib:" pos:[16,248] width:280 height:16
	label lblAttribVal "Value:" pos:[16,264] width:280 height:16
	label lblAttribClass "Class:" pos:[16,280] width:280 height:16

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






----------------------------------------
-- handlers (ACTION)
----------------------------------------





	on ddlMods selected value do
	(
	getAttribs()
	
	)
	on ddlAttribs selected value do
	(
	getTargetAttrib()
	updateInterface()
	)
)






rollout roFloatProps "Attribute properties (float) :" width:312 height:496
(
	GroupBox grpFloatParam "Float: (-500 - 500)" pos:[8,8] width:144 height:104
	spinner spnFloatVal "Init: " pos:[24,40] width:58 height:16 range:[-999,999,30] type:#float
	spinner spnFloatVar "+/-" pos:[94,40] width:52 height:16 range:[-999,999,10] type:#float
	checkbutton ckbFloatStart "Start" pos:[16,72] width:128 height:16
	button btnFloatReset "Decline" pos:[16,88] width:64 height:16
	button btnFloatOK "Accept" pos:[80,88] width:64 height:16

)
rollout roBooleanProps "Attribute Properties (boolean) :" width:312 height:496
(
	GroupBox grpBoolParam "Boolean: (T:50% / F:50%)" pos:[8,8] width:144 height:104
	slider sldBoolVal "" pos:[16,32] width:128 height:25 range:[0,100,50] type:#integer orient:#horizontal ticks:5
	checkbutton ckbBoolStart "Start" pos:[16,72] width:128 height:16
	button btnBoolReset "Decline" pos:[16,88] width:64 height:16
	button btnBoolOK "Accept" pos:[80,88] width:64 height:16
)

rollout roSelInfo "Selection Attribute Info" width:312 height:496
(
----------------------------------------
-- interface
----------------------------------------
	listbox lbx1 "Object" pos:[8,8] width:144 height:15 items:#("1", "2", "3", "4", "5", "6", "7", "8", "9", "10")
	listbox lbx2 "Old value" pos:[152,8] width:80 height:15 items:#("1", "2", "3", "4", "5", "6", "7", "8", "9", "10")
	listbox lbx3 "New Value" pos:[232,8] width:80 height:15 items:#("1", "2", "3", "4", "5", "6", "7", "8", "9", "10")

	on lbx1 selected sel do
		(lbx2.selection = sel; lbx3.selection = sel)
	on lbx2 selected sel do
		(lbx1.selection = sel; lbx3.selection = sel)
	on lbx3 selected sel do
		(lbx1.selection = sel; lbx2.selection = sel)

)

---------------------------------------------------------------------------------------------------
-- Create Floater
---------------------------------------------------------------------------------------------------

	if ObjAttribs != undefined then closeRolloutFloater ObjAttribs 
	ObjAttribs = newRolloutFloater "Multi-Object Attribute Changer" 344 874 80 60


	addRollout roSel ObjAttribs
	addRollout roStack ObjAttribs
	addRollout roFloatProps ObjAttribs
	addRollout roSelInfo ObjAttribs
	global currentRollout = floatProps