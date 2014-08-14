



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
