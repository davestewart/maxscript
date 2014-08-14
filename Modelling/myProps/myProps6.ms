utility myPropsUtility "myProps" width:160 height:416
(

local printState = false
global myObj
global myMods= #()
global myAttribs= #()
global myTargetAttrib
global myTargetAttribCurVal
global myModSelected = true

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

	GroupBox grpFloatParam "Float: (-500 - 500)" pos:[8,232] width:144 height:72
	spinner spnFloatVal "Base: " pos:[26,256] width:58 height:16 range:[-999,999,30] type:#float
	spinner spnFloatVar "+/- " pos:[96,256] width:52 height:16 range:[-999,999,10] type:#integer
	button btnFloatReset "Decline" pos:[16,280] width:64 height:16
	button btnFloatOK "Accept" pos:[80,280] width:64 height:16


	GroupBox grpBoolParam "Boolean: (T:50% / F:50%)" pos:[8,312] width:144 height:96
	slider sldBoolVal "True / False" pos:[16,328] width:128 height:44 range:[0,100,50] type:#integer orient:#horizontal
	button btnBoolReset "Decline" pos:[16,384] width:64 height:16
	button btnBoolOK "Accept" pos:[80,384] width:64 height:16





--------------------------------------
-- functions
----------------------------------------

fn changeAttribs =
	(
	print "Lets do it baby!"
	print edtNewAttribVal.text as String
	if edtNewAttribVal != undefined do
		(
		--execute("myObj." + ddlMods.selected as String + "." + ddlAttribs.selected as String)
		--myObj.myTargetAttrib = edtNewAttribVal.text as (classof myTargetAttribCurVal)
		execute("myObj." + myTargetAttrib + "=" + edtNewAttribVal.text as String)
		)
	)


fn updateInterface =
	(
	lblAttrib.text = "Attrib: " + myTargetAttrib as String
	lblAttribVal.text = "Value: " + myTargetAttribCurVal as String
	lblAttribClass.text = "Class: " + (classof myTargetAttribCurVal) as String

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
-- handlers
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
	on btnAttribDoIt pressed do changeAttribs()



)
